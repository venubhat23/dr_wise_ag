# InsureBook Admin - Complete End-to-End Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Database Schema & Models](#database-schema--models)
3. [Authentication & Authorization](#authentication--authorization)
4. [Controllers & Business Logic](#controllers--business-logic)
5. [Frontend & JavaScript](#frontend--javascript)
6. [API Documentation](#api-documentation)
7. [Services & Background Jobs](#services--background-jobs)
8. [Feature-by-Feature Walkthrough](#feature-by-feature-walkthrough)
9. [Deployment & Configuration](#deployment--configuration)

---

## 1. Architecture Overview

### Technology Stack
- **Framework**: Ruby on Rails 8.0.4
- **Ruby Version**: 3.2.0
- **Database**: PostgreSQL
- **Server**: Puma
- **Frontend**: Hotwire (Turbo + Stimulus), Bootstrap 5.3
- **Authentication**: Devise + JWT
- **Authorization**: CanCanCan
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **File Storage**: Active Storage

### Directory Structure
```
insurebook_admin/
├── app/
│   ├── assets/          # Stylesheets, images
│   ├── controllers/     # Request handlers
│   │   ├── admin/      # Admin panel controllers
│   │   └── api/        # Mobile API controllers
│   ├── helpers/        # View helpers
│   ├── javascript/     # JavaScript modules
│   ├── jobs/           # Background jobs
│   ├── mailers/        # Email handlers
│   ├── models/         # Business models
│   ├── services/       # Service objects
│   └── views/          # HTML templates
├── config/             # Application configuration
├── db/                 # Database migrations & schema
├── lib/                # Custom libraries
├── public/             # Static files
├── spec/               # Test files
└── vendor/             # Third-party code
```

---

## 2. Database Schema & Models

### Core User Models

#### User Model (`app/models/user.rb`)
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # User Types
  enum user_type: {
    admin: 'admin',
    agent: 'agent',
    sub_agent: 'sub_agent',
    customer: 'customer',
    ambassador: 'ambassador'
  }

  # Associations
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :health_insurances
  has_many :life_insurances
  has_many :motor_insurances
  has_many :leads
  has_many :payouts
  has_many :commission_payouts

  # Validations
  validates :name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :pan, uniqueness: { allow_blank: true }

  # Authentication Methods
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:email)

    # Multi-modal login support
    where(conditions).where([
      "lower(email) = :value OR mobile = :value OR pan = :value",
      { value: login.downcase }
    ]).first
  end

  # Permission Methods
  def has_permission?(module_name, action = 'read')
    return true if email == 'admin@drwise.com' # Super admin

    permissions.exists?(
      module_name: module_name,
      action_type: action,
      status: 'enabled'
    )
  end

  # Dashboard Access
  def dashboard_path
    case user_type
    when 'admin'
      '/admin/dashboard'
    when 'agent', 'sub_agent'
      '/agent/dashboard'
    when 'customer'
      '/customer/dashboard'
    else
      '/'
    end
  end
end
```

#### Customer Model (`app/models/customer.rb`)
```ruby
class Customer < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  belongs_to :sub_agent, optional: true
  has_many :health_insurances
  has_many :life_insurances
  has_many :motor_insurances
  has_many :other_insurances
  has_many :family_members
  has_many :customer_documents
  has_many :leads

  # Validations
  validates :display_name, presence: true
  validates :mobile, presence: true, uniqueness: true
  validates :pan, uniqueness: { allow_blank: true }
  validates :email, uniqueness: { allow_blank: true }

  # Enums
  enum customer_type: {
    individual: 'individual',
    corporate: 'corporate'
  }

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  # Search
  include PgSearch::Model
  pg_search_scope :search_by_details,
    against: [:display_name, :mobile, :email, :pan],
    using: {
      tsearch: { prefix: true }
    }

  # Methods
  def full_address
    [address_line_1, address_line_2, city, state, pincode].compact.join(', ')
  end

  def total_policies
    health_insurances.count + life_insurances.count +
    motor_insurances.count + other_insurances.count
  end

  def active_policies
    health_insurances.active + life_insurances.active +
    motor_insurances.active + other_insurances.active
  end
end
```

### Insurance Policy Models

#### HealthInsurance Model (`app/models/health_insurance.rb`)
```ruby
class HealthInsurance < ApplicationRecord
  # Core Associations
  belongs_to :customer
  belongs_to :user, optional: true
  belongs_to :sub_agent, optional: true
  belongs_to :distributor, optional: true
  has_many :health_insurance_members, dependent: :destroy
  has_many :commission_payouts, as: :policy
  has_one :payout, as: :policy
  has_one :lead

  # Validations
  validates :policy_number, presence: true, uniqueness: true
  validates :policy_holder, presence: true
  validates :insurance_company_name, presence: true
  validates :policy_type, presence: true
  validates :insurance_type, presence: true
  validates :sum_insured, presence: true, numericality: { greater_than: 0 }
  validates :net_premium, presence: true, numericality: { greater_than: 0 }
  validates :total_premium, presence: true, numericality: { greater_than: 0 }

  # Enums
  enum policy_type: {
    new: 'New',
    renewal: 'Renewal',
    portability: 'Portability'
  }

  enum insurance_type: {
    individual: 'Individual',
    family_floater: 'Family Floater',
    group: 'Group'
  }

  enum payment_mode: {
    yearly: 'Yearly',
    half_yearly: 'Half Yearly',
    quarterly: 'Quarterly',
    monthly: 'Monthly'
  }

  # Scopes
  scope :active, -> { where('policy_end_date >= ?', Date.current) }
  scope :expired, -> { where('policy_end_date < ?', Date.current) }
  scope :expiring_soon, -> { where(
    'policy_end_date BETWEEN ? AND ?',
    Date.current,
    60.days.from_now
  )}

  # Callbacks
  after_create :generate_lead
  after_create :calculate_commissions
  after_create :create_payout

  # Renewal Methods
  def can_be_renewed?
    return false if policy_type == 'renewal'
    return false if has_been_renewed?
    policy_end_date.present? && policy_end_date <= 60.days.from_now
  end

  def has_been_renewed?
    HealthInsurance.exists?(
      customer_id: customer_id,
      policy_type: 'renewal',
      policy_start_date: policy_end_date + 1.day
    )
  end

  def renewal_status_text
    return 'Already Renewed' if has_been_renewed?
    return 'Renewal Policy' if is_renewal?

    days_to_expiry = (policy_end_date - Date.current).to_i
    if days_to_expiry <= 0
      'Expired'
    elsif days_to_expiry <= 30
      "Expires in #{days_to_expiry} days"
    elsif days_to_expiry <= 60
      "Renewal Available"
    else
      'Active'
    end
  end

  private

  def generate_lead
    LeadGeneratorService.new(self).generate
  end

  def calculate_commissions
    CommissionCalculatorService.new(self).calculate
  end

  def create_payout
    StructuredPayoutService.new(self).create_payout
  end
end
```

#### LifeInsurance Model (`app/models/life_insurance.rb`)
```ruby
class LifeInsurance < ApplicationRecord
  belongs_to :customer
  belongs_to :user, optional: true
  belongs_to :sub_agent, optional: true
  has_many :commission_payouts, as: :policy
  has_one :payout, as: :policy

  # Life Insurance Specific Fields
  validates :policy_term, presence: true
  validates :premium_paying_term, presence: true
  validates :nominee_name, presence: true
  validates :nominee_relation, presence: true
  validates :nominee_dob, presence: true

  enum policy_type: {
    term: 'Term',
    whole_life: 'Whole Life',
    endowment: 'Endowment',
    ulip: 'ULIP',
    money_back: 'Money Back'
  }

  enum premium_mode: {
    annual: 'Annual',
    semi_annual: 'Semi-Annual',
    quarterly: 'Quarterly',
    monthly: 'Monthly',
    single: 'Single'
  }

  # Methods
  def maturity_date
    policy_start_date + policy_term.years if policy_start_date && policy_term
  end

  def next_premium_date
    return nil if premium_mode == 'single'

    case premium_mode
    when 'annual'
      last_premium_date + 1.year
    when 'semi_annual'
      last_premium_date + 6.months
    when 'quarterly'
      last_premium_date + 3.months
    when 'monthly'
      last_premium_date + 1.month
    end
  end
end
```

### Lead Management Models

#### Lead Model (`app/models/lead.rb`)
```ruby
class Lead < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :customer, foreign_key: :converted_customer_id, optional: true
  belongs_to :affiliate, class_name: 'SubAgent', optional: true
  has_many :branch_out_leads

  # Lead Stages
  enum current_stage: {
    lead_generated: 'lead_generated',
    consultation_scheduled: 'consultation_scheduled',
    one_on_one: 'one_on_one',
    follow_up: 'follow_up',
    policy_created: 'policy_created',
    converted: 'converted',
    closed: 'closed'
  }

  # Product Categories
  enum product_category: {
    insurance: 'insurance',
    loan: 'loan',
    investment: 'investment'
  }

  # Validations
  validates :lead_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :contact_number, presence: true
  validates :current_stage, presence: true

  # Scopes
  scope :open_leads, -> { where.not(current_stage: ['converted', 'closed']) }
  scope :converted_leads, -> { where(current_stage: 'converted') }
  scope :recent, -> { order(created_at: :desc) }

  # State Machine Methods
  def advance_stage!
    case current_stage
    when 'lead_generated'
      consultation_scheduled!
    when 'consultation_scheduled'
      one_on_one!
    when 'one_on_one'
      follow_up!
    when 'follow_up'
      policy_created!
    when 'policy_created'
      converted!
    end
    update(stage_updated_at: Time.current)
  end

  def can_branch_out?
    ['lead_generated', 'consultation_scheduled'].include?(current_stage)
  end

  def branch_out!(sub_agent)
    return false unless can_branch_out?

    BranchOutLead.create!(
      lead: self,
      sub_agent: sub_agent,
      branched_at: Time.current,
      status: 'active'
    )
  end

  # Lead ID Generation
  def self.generate_lead_id
    prefix = "LD"
    timestamp = Time.current.strftime("%Y%m%d%H%M%S")
    random = SecureRandom.hex(3).upcase
    "#{prefix}#{timestamp}#{random}"
  end
end
```

### Commission & Payout Models

#### CommissionPayout Model (`app/models/commission_payout.rb`)
```ruby
class CommissionPayout < ApplicationRecord
  belongs_to :policy, polymorphic: true
  belongs_to :user, optional: true
  belongs_to :sub_agent, optional: true

  # Payout Types
  enum payout_to: {
    main_agent: 'main_agent',
    sub_agent: 'sub_agent',
    ambassador: 'ambassador',
    investor: 'investor',
    company: 'company'
  }

  # Status
  enum status: {
    pending: 'pending',
    approved: 'approved',
    paid: 'paid',
    cancelled: 'cancelled'
  }

  # Validations
  validates :payout_amount, presence: true, numericality: { greater_than: 0 }
  validates :commission_percentage, presence: true
  validates :policy_type, presence: true

  # Scopes
  scope :pending_payouts, -> { where(status: 'pending') }
  scope :approved_payouts, -> { where(status: 'approved') }
  scope :by_month, ->(date) {
    where(created_at: date.beginning_of_month..date.end_of_month)
  }

  # Methods
  def approve!
    update(
      status: 'approved',
      approved_at: Time.current,
      approved_by: Current.user&.id
    )
  end

  def mark_as_paid!
    update(
      status: 'paid',
      paid_at: Time.current,
      payment_reference: generate_payment_reference
    )
  end

  private

  def generate_payment_reference
    "PAY#{Time.current.strftime('%Y%m%d')}#{id.to_s.rjust(6, '0')}"
  end
end
```

---

## 3. Authentication & Authorization

### Authentication System

#### Devise Configuration (`config/initializers/devise.rb`)
```ruby
Devise.setup do |config|
  # Authentication Configuration
  config.mailer_sender = 'admin@insurebook.com'
  config.case_insensitive_keys = [:email, :mobile, :pan]
  config.strip_whitespace_keys = [:email, :mobile, :pan]

  # Custom authentication
  config.authentication_keys = [:email]
  config.reset_password_keys = [:email]
  config.confirmation_keys = [:email]

  # Session timeout
  config.timeout_in = 30.minutes

  # Password requirements
  config.password_length = 6..128

  # Login tracking
  config.sign_in_count = true
  config.last_sign_in_at = true
  config.current_sign_in_at = true
  config.last_sign_in_ip = true
  config.current_sign_in_ip = true
end
```

#### Multi-Modal Login Implementation
```ruby
# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def create
    # Find user by email, mobile, or PAN
    user = find_user_for_authentication

    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      redirect_to after_sign_in_path_for(user)
    else
      flash[:alert] = 'Invalid login credentials'
      redirect_to new_user_session_path
    end
  end

  private

  def find_user_for_authentication
    login_value = params[:user][:email]

    # Clean mobile number if provided
    if login_value =~ /^\+?[\d\s-]+$/
      login_value = login_value.gsub(/[\s-]/, '').gsub(/^\+91/, '')
    end

    # Try to find user
    user = User.find_by(email: login_value.downcase) ||
           User.find_by(mobile: login_value) ||
           User.find_by(pan: login_value.upcase)

    # Check customer table if not found in users
    if user.nil?
      customer = Customer.find_by(mobile: login_value) ||
                 Customer.find_by(email: login_value.downcase) ||
                 Customer.find_by(pan: login_value.upcase)

      user = customer.user if customer
    end

    user
  end
end
```

### Authorization System

#### CanCanCan Ability Definition (`app/models/ability.rb`)
```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    # Super Admin - Full Access
    if user.email == 'admin@drwise.com'
      can :manage, :all
      return
    end

    # Define abilities based on user type
    case user.user_type
    when 'admin'
      admin_abilities(user)
    when 'agent'
      agent_abilities(user)
    when 'sub_agent'
      sub_agent_abilities(user)
    when 'customer'
      customer_abilities(user)
    when 'ambassador'
      ambassador_abilities(user)
    end
  end

  private

  def admin_abilities(user)
    # Dashboard access
    can :read, :dashboard

    # Customer management
    if user.has_permission?('customers', 'manage')
      can :manage, Customer
    elsif user.has_permission?('customers', 'read')
      can :read, Customer
    end

    # Policy management
    %w[health_insurance life_insurance motor_insurance].each do |policy_type|
      if user.has_permission?(policy_type, 'manage')
        can :manage, policy_type.classify.constantize
      elsif user.has_permission?(policy_type, 'create')
        can :create, policy_type.classify.constantize
      elsif user.has_permission?(policy_type, 'read')
        can :read, policy_type.classify.constantize
      end
    end

    # Lead management
    if user.has_permission?('leads', 'manage')
      can :manage, Lead
    elsif user.has_permission?('leads', 'read')
      can :read, Lead
    end

    # Reports
    can :read, :reports if user.has_permission?('reports', 'read')
    can :export, :reports if user.has_permission?('reports', 'export')

    # Payouts
    if user.has_permission?('payouts', 'manage')
      can :manage, CommissionPayout
      can :approve, CommissionPayout
    elsif user.has_permission?('payouts', 'read')
      can :read, CommissionPayout
    end
  end

  def agent_abilities(user)
    # Own customers
    can :manage, Customer, sub_agent_id: user.sub_agent&.id

    # Own policies
    can :manage, HealthInsurance, user_id: user.id
    can :manage, LifeInsurance, user_id: user.id
    can :manage, MotorInsurance, user_id: user.id

    # Own leads
    can :manage, Lead, user_id: user.id

    # View own payouts
    can :read, CommissionPayout, user_id: user.id
  end

  def sub_agent_abilities(user)
    # Limited customer access
    can :read, Customer, sub_agent_id: user.sub_agent&.id
    can :create, Customer

    # Create policies
    can :create, HealthInsurance
    can :create, LifeInsurance
    can :create, MotorInsurance

    # Own leads
    can :manage, Lead, affiliate_id: user.sub_agent&.id

    # View own commissions
    can :read, CommissionPayout, sub_agent_id: user.sub_agent&.id
  end

  def customer_abilities(user)
    # Own profile
    can :read, Customer, user_id: user.id
    can :update, Customer, user_id: user.id

    # Own policies
    can :read, HealthInsurance, customer_id: user.customer&.id
    can :read, LifeInsurance, customer_id: user.customer&.id
    can :read, MotorInsurance, customer_id: user.customer&.id

    # Family members
    can :manage, FamilyMember, customer_id: user.customer&.id

    # Documents
    can :manage, CustomerDocument, customer_id: user.customer&.id
  end

  def ambassador_abilities(user)
    # View referred customers
    can :read, Customer, ambassador_id: user.id

    # View commission
    can :read, CommissionPayout, payout_to: 'ambassador'
  end
end
```

#### Permission Model (`app/models/permission.rb`)
```ruby
class Permission < ApplicationRecord
  belongs_to :user

  # Permission Modules
  MODULES = %w[
    dashboard customers health_insurance life_insurance
    motor_insurance leads payouts reports analytics
    settings sub_agents distributors
  ].freeze

  # Action Types
  ACTION_TYPES = %w[
    create read update delete export manage approve
  ].freeze

  # Validations
  validates :module_name, presence: true, inclusion: { in: MODULES }
  validates :action_type, presence: true, inclusion: { in: ACTION_TYPES }
  validates :status, presence: true, inclusion: { in: %w[enabled disabled] }

  # Scopes
  scope :enabled, -> { where(status: 'enabled') }
  scope :for_module, ->(module_name) { where(module_name: module_name) }

  # Class Methods
  def self.grant_all_to(user)
    MODULES.each do |mod|
      ACTION_TYPES.each do |action|
        find_or_create_by(
          user: user,
          module_name: mod,
          action_type: action
        ).update(status: 'enabled')
      end
    end
  end

  def self.grant_module_to(user, module_name, actions = ACTION_TYPES)
    actions.each do |action|
      find_or_create_by(
        user: user,
        module_name: module_name,
        action_type: action
      ).update(status: 'enabled')
    end
  end
end
```

---

## 4. Controllers & Business Logic

### Admin Controllers

#### Admin::DashboardController (`app/controllers/admin/dashboard_controller.rb`)
```ruby
class Admin::DashboardController < Admin::BaseController
  before_action :authenticate_user!
  before_action :authorize_dashboard_access

  def index
    @dashboard_data = fetch_dashboard_data
    @charts_data = prepare_charts_data
    @recent_activities = fetch_recent_activities
  end

  def analytics
    @analytics = AnalyticsService.new(current_user).generate
    @session_analytics = SessionAnalytics.new.generate
    @commission_analytics = CommissionAnalytics.new(date_range).generate
  end

  private

  def fetch_dashboard_data
    {
      total_customers: Customer.count,
      active_policies: active_policies_count,
      pending_renewals: pending_renewals_count,
      monthly_premium: calculate_monthly_premium,
      pending_payouts: CommissionPayout.pending_payouts.sum(:payout_amount),
      open_leads: Lead.open_leads.count,
      conversion_rate: calculate_conversion_rate,
      monthly_new_business: calculate_monthly_new_business
    }
  end

  def active_policies_count
    HealthInsurance.active.count +
    LifeInsurance.active.count +
    MotorInsurance.active.count
  end

  def pending_renewals_count
    HealthInsurance.expiring_soon.count +
    MotorInsurance.expiring_soon.count
  end

  def calculate_monthly_premium
    current_month = Date.current.beginning_of_month..Date.current.end_of_month

    HealthInsurance.where(created_at: current_month).sum(:total_premium) +
    LifeInsurance.where(created_at: current_month).sum(:premium_amount) +
    MotorInsurance.where(created_at: current_month).sum(:total_premium)
  end

  def calculate_conversion_rate
    total_leads = Lead.count
    converted_leads = Lead.converted_leads.count

    return 0 if total_leads.zero?
    ((converted_leads.to_f / total_leads) * 100).round(2)
  end

  def prepare_charts_data
    {
      policy_distribution: policy_distribution_data,
      monthly_premium_trend: monthly_premium_trend,
      lead_conversion_funnel: lead_funnel_data,
      commission_distribution: commission_distribution_data
    }
  end

  def policy_distribution_data
    {
      'Health Insurance' => HealthInsurance.count,
      'Life Insurance' => LifeInsurance.count,
      'Motor Insurance' => MotorInsurance.count,
      'Other Insurance' => OtherInsurance.count
    }
  end

  def monthly_premium_trend
    (0..11).map do |months_ago|
      date = months_ago.months.ago
      month_name = date.strftime("%B %Y")
      month_range = date.beginning_of_month..date.end_of_month

      total = HealthInsurance.where(created_at: month_range).sum(:total_premium) +
              LifeInsurance.where(created_at: month_range).sum(:premium_amount) +
              MotorInsurance.where(created_at: month_range).sum(:total_premium)

      [month_name, total]
    end.reverse.to_h
  end

  def fetch_recent_activities
    Activity.recent.limit(10).includes(:user, :trackable)
  end

  def authorize_dashboard_access
    authorize! :read, :dashboard
  end
end
```

#### Admin::HealthInsurancesController (`app/controllers/admin/health_insurances_controller.rb`)
```ruby
class Admin::HealthInsurancesController < Admin::BaseController
  before_action :set_health_insurance, only: [:show, :edit, :update, :destroy, :renew]
  before_action :load_form_data, only: [:new, :edit, :create, :update, :renew]

  def index
    @health_insurances = HealthInsurance
      .includes(:customer, :sub_agent, :health_insurance_members)
      .page(params[:page])

    apply_filters if params[:filter].present?
    apply_search if params[:search].present?
    apply_sorting

    @stats = calculate_statistics
  end

  def new
    @health_insurance = HealthInsurance.new
    @health_insurance.health_insurance_members.build
  end

  def create
    @health_insurance = HealthInsurance.new(health_insurance_params)

    ActiveRecord::Base.transaction do
      if @health_insurance.save
        handle_members if params[:members].present?
        create_lead_and_commissions

        redirect_to admin_health_insurances_path,
                    notice: 'Health Insurance created successfully'
      else
        render :new
      end
    end
  rescue => e
    flash[:alert] = "Error: #{e.message}"
    render :new
  end

  def renew
    @renewal = @health_insurance.dup
    @renewal.policy_type = 'renewal'
    @renewal.policy_number = nil
    @renewal.policy_start_date = @health_insurance.policy_end_date + 1.day
    @renewal.policy_end_date = calculate_renewal_end_date
    @renewal.policy_booking_date = Date.current

    # Copy members
    @health_insurance.health_insurance_members.each do |member|
      @renewal.health_insurance_members.build(member.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  def create_renewal
    @health_insurance = HealthInsurance.new(renewal_params)
    @health_insurance.policy_type = 'renewal'

    if @health_insurance.save
      redirect_to admin_health_insurances_path,
                  notice: 'Renewal created successfully'
    else
      render :renew
    end
  end

  private

  def set_health_insurance
    @health_insurance = HealthInsurance.find(params[:id])
  end

  def load_form_data
    @customers = Customer.active.order(:display_name)
    @sub_agents = SubAgent.active.order(:full_name)
    @distributors = Distributor.active.order(:name)
    @insurance_companies = insurance_companies_list
  end

  def health_insurance_params
    params.require(:health_insurance).permit(
      :customer_id, :policy_holder, :insurance_company_name,
      :policy_type, :insurance_type, :policy_number,
      :policy_booking_date, :policy_start_date, :policy_end_date,
      :payment_mode, :sum_insured, :net_premium, :gst_percentage,
      :total_premium, :sub_agent_id, :distributor_id,
      :main_agent_commission_percentage, :sub_agent_commission_percentage,
      :ambassador_commission_percentage, :investor_commission_percentage,
      :company_expenses_percentage, :notes,
      health_insurance_members_attributes: [
        :id, :member_name, :relation, :dob, :age, :_destroy
      ]
    )
  end

  def handle_members
    params[:members].each do |member_params|
      next if member_params[:member_name].blank?

      @health_insurance.health_insurance_members.create!(
        member_name: member_params[:member_name],
        relation: member_params[:relation],
        dob: member_params[:dob],
        age: calculate_age(member_params[:dob])
      )
    end
  end

  def create_lead_and_commissions
    # Generate Lead
    LeadGeneratorService.new(@health_insurance).generate

    # Calculate Commissions
    CommissionCalculatorService.new(@health_insurance).calculate

    # Create Payout
    StructuredPayoutService.new(@health_insurance).create_payout
  end

  def apply_filters
    case params[:filter]
    when 'active'
      @health_insurances = @health_insurances.active
    when 'expired'
      @health_insurances = @health_insurances.expired
    when 'expiring_soon'
      @health_insurances = @health_insurances.expiring_soon
    when 'renewal'
      @health_insurances = @health_insurances.where(policy_type: 'renewal')
    end
  end

  def apply_search
    @health_insurances = @health_insurances.joins(:customer)
      .where(
        "customers.display_name ILIKE :search OR
         health_insurances.policy_number ILIKE :search OR
         health_insurances.insurance_company_name ILIKE :search",
        search: "%#{params[:search]}%"
      )
  end

  def apply_sorting
    sort_column = params[:sort] || 'created_at'
    sort_direction = params[:direction] || 'desc'

    @health_insurances = @health_insurances.order("#{sort_column} #{sort_direction}")
  end

  def calculate_statistics
    {
      total_policies: @health_insurances.count,
      total_premium: @health_insurances.sum(:total_premium),
      total_sum_insured: @health_insurances.sum(:sum_insured),
      active_policies: @health_insurances.active.count,
      expired_policies: @health_insurances.expired.count,
      renewal_due: @health_insurances.expiring_soon.count
    }
  end

  def calculate_renewal_end_date
    case @health_insurance.payment_mode
    when 'yearly'
      @health_insurance.policy_end_date + 1.year
    when 'half_yearly'
      @health_insurance.policy_end_date + 6.months
    when 'quarterly'
      @health_insurance.policy_end_date + 3.months
    when 'monthly'
      @health_insurance.policy_end_date + 1.month
    else
      @health_insurance.policy_end_date + 1.year
    end
  end

  def insurance_companies_list
    [
      'ICICI Lombard', 'HDFC ERGO', 'Bajaj Allianz', 'Star Health',
      'Care Health', 'Max Bupa', 'Aditya Birla Health', 'Reliance General',
      'National Insurance', 'United India Insurance', 'Oriental Insurance',
      'New India Assurance', 'SBI General', 'Tata AIG', 'Cholamandalam MS'
    ]
  end
end
```

### API Controllers

#### Api::BaseController (`app/controllers/api/base_controller.rb`)
```ruby
class Api::BaseController < ActionController::API
  before_action :authenticate_api_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from JWT::DecodeError, with: :unauthorized

  private

  def authenticate_api_user!
    @current_user = AuthorizeApiRequest.new(request.headers).call
    render_unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def render_success(data = {}, message = 'Success', status = :ok)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  def render_error(message = 'Error', status = :unprocessable_entity, errors = {})
    render json: {
      success: false,
      message: message,
      errors: errors
    }, status: status
  end

  def not_found
    render_error('Record not found', :not_found)
  end

  def unprocessable_entity(exception)
    render_error('Validation failed', :unprocessable_entity, exception.record.errors)
  end

  def unauthorized
    render_error('Unauthorized', :unauthorized)
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
```

#### Api::AuthController (`app/controllers/api/auth_controller.rb`)
```ruby
class Api::AuthController < Api::BaseController
  skip_before_action :authenticate_api_user!, only: [:login, :register]

  def login
    user = find_user_by_credentials

    if user && user.valid_password?(login_params[:password])
      token = JwtService.encode(user_id: user.id)

      render_success(
        {
          token: token,
          user: user_data(user)
        },
        'Login successful'
      )
    else
      render_error('Invalid credentials', :unauthorized)
    end
  end

  def register
    user = User.new(registration_params)

    if user.save
      # Create associated records
      create_customer_if_needed(user)
      create_sub_agent_if_needed(user)

      token = JwtService.encode(user_id: user.id)

      render_success(
        {
          token: token,
          user: user_data(user)
        },
        'Registration successful',
        :created
      )
    else
      render_error('Registration failed', :unprocessable_entity, user.errors)
    end
  end

  def logout
    # Invalidate token (add to blacklist if using token blacklisting)
    render_success({}, 'Logout successful')
  end

  def profile
    render_success(
      {
        user: user_data(current_user),
        permissions: user_permissions(current_user)
      }
    )
  end

  def update_profile
    if current_user.update(profile_params)
      render_success(
        { user: user_data(current_user) },
        'Profile updated successfully'
      )
    else
      render_error('Update failed', :unprocessable_entity, current_user.errors)
    end
  end

  private

  def find_user_by_credentials
    login = login_params[:email_or_mobile_or_pan]

    # Clean mobile number
    if login =~ /^\+?[\d\s-]+$/
      login = login.gsub(/[\s-]/, '').gsub(/^\+91/, '')
    end

    User.find_by(email: login) ||
    User.find_by(mobile: login) ||
    User.find_by(pan: login&.upcase)
  end

  def login_params
    params.require(:auth).permit(:email_or_mobile_or_pan, :password)
  end

  def registration_params
    params.require(:user).permit(
      :name, :email, :mobile, :password, :password_confirmation,
      :pan, :aadhaar, :user_type, :date_of_birth
    )
  end

  def profile_params
    params.require(:user).permit(
      :name, :mobile, :date_of_birth,
      :address_line_1, :address_line_2, :city, :state, :pincode
    )
  end

  def user_data(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      mobile: user.mobile,
      user_type: user.user_type,
      pan: user.pan,
      profile_complete: user.profile_complete?,
      created_at: user.created_at
    }
  end

  def user_permissions(user)
    user.permissions.enabled.group_by(&:module_name).transform_values do |perms|
      perms.map(&:action_type)
    end
  end

  def create_customer_if_needed(user)
    return unless user.customer?

    Customer.create!(
      user: user,
      display_name: user.name,
      email: user.email,
      mobile: user.mobile,
      pan: user.pan,
      customer_type: 'individual',
      status: 'active'
    )
  end

  def create_sub_agent_if_needed(user)
    return unless user.sub_agent?

    SubAgent.create!(
      user: user,
      full_name: user.name,
      email: user.email,
      mobile: user.mobile,
      pan: user.pan,
      status: 'active',
      commission_percentage: 3.0
    )
  end
end
```

---

## 5. Frontend & JavaScript

### Application Layout (`app/views/layouts/application.html.erb`)
```erb
<!DOCTYPE html>
<html>
  <head>
    <title>InsureBook Admin</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <!-- Custom CSS -->
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>

    <!-- JavaScript -->
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <% if user_signed_in? %>
      <div class="d-flex">
        <!-- Sidebar -->
        <%= render 'shared/sidebar' %>

        <!-- Main Content -->
        <div class="flex-grow-1">
          <!-- Navbar -->
          <%= render 'shared/navbar' %>

          <!-- Page Content -->
          <main class="container-fluid py-4">
            <%= render 'shared/flash_messages' %>
            <%= yield %>
          </main>
        </div>
      </div>
    <% else %>
      <%= yield %>
    <% end %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
```

### Sidebar Component (`app/views/shared/_sidebar.html.erb`)
```erb
<nav class="sidebar" id="sidebar">
  <div class="sidebar-header">
    <h3><i class="bi bi-shield-check"></i> InsureBook</h3>
  </div>

  <ul class="sidebar-nav">
    <!-- Dashboard -->
    <li class="nav-item">
      <%= link_to admin_dashboard_path, class: "nav-link #{active_class('admin/dashboard')}" do %>
        <i class="bi bi-speedometer2"></i>
        <span>Dashboard</span>
      <% end %>
    </li>

    <!-- Customers -->
    <% if can?(:read, Customer) %>
      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#customersMenu">
          <i class="bi bi-people"></i>
          <span>Customers</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="customersMenu" class="nav-content collapse">
          <li>
            <%= link_to 'All Customers', admin_customers_path, class: "nav-link" %>
          </li>
          <% if can?(:create, Customer) %>
            <li>
              <%= link_to 'Add Customer', new_admin_customer_path, class: "nav-link" %>
            </li>
          <% end %>
          <li>
            <%= link_to 'Import Customers', import_admin_customers_path, class: "nav-link" %>
          </li>
        </ul>
      </li>
    <% end %>

    <!-- Insurance Policies -->
    <li class="nav-item">
      <a class="nav-link collapsed" data-bs-toggle="collapse" href="#insuranceMenu">
        <i class="bi bi-file-earmark-medical"></i>
        <span>Insurance</span>
        <i class="bi bi-chevron-down ms-auto"></i>
      </a>
      <ul id="insuranceMenu" class="nav-content collapse">
        <% if can?(:read, HealthInsurance) %>
          <li>
            <%= link_to 'Health Insurance', admin_health_insurances_path, class: "nav-link" %>
          </li>
        <% end %>
        <% if can?(:read, LifeInsurance) %>
          <li>
            <%= link_to 'Life Insurance', admin_life_insurances_path, class: "nav-link" %>
          </li>
        <% end %>
        <% if can?(:read, MotorInsurance) %>
          <li>
            <%= link_to 'Motor Insurance', admin_motor_insurances_path, class: "nav-link" %>
          </li>
        <% end %>
      </ul>
    </li>

    <!-- Leads -->
    <% if can?(:read, Lead) %>
      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#leadsMenu">
          <i class="bi bi-funnel"></i>
          <span>Leads</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="leadsMenu" class="nav-content collapse">
          <li>
            <%= link_to 'All Leads', admin_leads_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Lead Pipeline', pipeline_admin_leads_path, class: "nav-link" %>
          </li>
          <% if can?(:create, Lead) %>
            <li>
              <%= link_to 'Add Lead', new_admin_lead_path, class: "nav-link" %>
            </li>
          <% end %>
        </ul>
      </li>
    <% end %>

    <!-- Payouts -->
    <% if can?(:read, CommissionPayout) %>
      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#payoutsMenu">
          <i class="bi bi-cash-stack"></i>
          <span>Payouts</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="payoutsMenu" class="nav-content collapse">
          <li>
            <%= link_to 'All Payouts', admin_commission_payouts_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Pending Approvals', pending_admin_commission_payouts_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Payout Reports', reports_admin_commission_payouts_path, class: "nav-link" %>
          </li>
        </ul>
      </li>
    <% end %>

    <!-- Reports -->
    <% if can?(:read, :reports) %>
      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#reportsMenu">
          <i class="bi bi-graph-up"></i>
          <span>Reports</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="reportsMenu" class="nav-content collapse">
          <li>
            <%= link_to 'Policy Reports', policy_reports_admin_reports_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Commission Reports', commission_reports_admin_reports_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Expiry Reports', expiry_reports_admin_reports_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Analytics Dashboard', analytics_admin_dashboard_path, class: "nav-link" %>
          </li>
        </ul>
      </li>
    <% end %>

    <!-- Settings -->
    <% if current_user.admin? %>
      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-toggle="collapse" href="#settingsMenu">
          <i class="bi bi-gear"></i>
          <span>Settings</span>
          <i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="settingsMenu" class="nav-content collapse">
          <li>
            <%= link_to 'Users', admin_users_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Roles & Permissions', admin_roles_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'Sub Agents', admin_sub_agents_path, class: "nav-link" %>
          </li>
          <li>
            <%= link_to 'System Settings', admin_settings_path, class: "nav-link" %>
          </li>
        </ul>
      </li>
    <% end %>
  </ul>

  <!-- User Info -->
  <div class="sidebar-footer">
    <div class="user-info">
      <i class="bi bi-person-circle"></i>
      <span><%= current_user.name %></span>
      <small class="d-block text-muted"><%= current_user.user_type.humanize %></small>
    </div>
    <%= link_to destroy_user_session_path, method: :delete, class: "btn btn-sm btn-outline-danger" do %>
      <i class="bi bi-box-arrow-right"></i> Logout
    <% end %>
  </div>
</nav>
```

### JavaScript Application (`app/javascript/application.js`)
```javascript
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// Initialize Bootstrap tooltips and popovers
document.addEventListener("turbo:load", () => {
  // Tooltips
  const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  tooltips.forEach(tooltip => {
    new bootstrap.Tooltip(tooltip)
  })

  // Popovers
  const popovers = document.querySelectorAll('[data-bs-toggle="popover"]')
  popovers.forEach(popover => {
    new bootstrap.Popover(popover)
  })

  // Sidebar toggle
  initializeSidebar()

  // Search functionality
  initializeSearch()

  // Dynamic forms
  initializeDynamicForms()

  // Charts
  initializeCharts()

  // Notifications
  initializeNotifications()
})

// Sidebar Management
function initializeSidebar() {
  const sidebarToggle = document.getElementById('sidebarToggle')
  const sidebar = document.getElementById('sidebar')
  const mainContent = document.getElementById('mainContent')

  if (sidebarToggle && sidebar) {
    // Load saved state
    const sidebarState = localStorage.getItem('sidebarState')
    if (sidebarState === 'collapsed') {
      sidebar.classList.add('collapsed')
      mainContent?.classList.add('expanded')
    }

    // Toggle sidebar
    sidebarToggle.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed')
      mainContent?.classList.toggle('expanded')

      // Save state
      const isCollapsed = sidebar.classList.contains('collapsed')
      localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded')
    })
  }

  // Handle submenu active states
  const currentPath = window.location.pathname
  const navLinks = document.querySelectorAll('.sidebar .nav-link')

  navLinks.forEach(link => {
    if (link.getAttribute('href') === currentPath) {
      link.classList.add('active')

      // Expand parent menu
      const parentCollapse = link.closest('.collapse')
      if (parentCollapse) {
        parentCollapse.classList.add('show')
        const parentToggle = document.querySelector(`[href="#${parentCollapse.id}"]`)
        parentToggle?.classList.remove('collapsed')
      }
    }
  })
}

// Search Functionality
function initializeSearch() {
  const searchInput = document.getElementById('globalSearch')
  const searchResults = document.getElementById('searchResults')

  if (searchInput && searchResults) {
    let searchTimeout

    searchInput.addEventListener('input', (e) => {
      clearTimeout(searchTimeout)
      const query = e.target.value.trim()

      if (query.length < 2) {
        searchResults.innerHTML = ''
        searchResults.classList.add('d-none')
        return
      }

      searchTimeout = setTimeout(() => {
        performSearch(query)
      }, 300)
    })

    // Hide results on click outside
    document.addEventListener('click', (e) => {
      if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
        searchResults.classList.add('d-none')
      }
    })
  }

  async function performSearch(query) {
    try {
      const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      const data = await response.json()
      displaySearchResults(data)
    } catch (error) {
      console.error('Search error:', error)
    }
  }

  function displaySearchResults(data) {
    if (!data || data.length === 0) {
      searchResults.innerHTML = '<div class="p-3 text-muted">No results found</div>'
    } else {
      let html = '<div class="list-group">'

      data.forEach(item => {
        html += `
          <a href="${item.url}" class="list-group-item list-group-item-action">
            <div class="d-flex justify-content-between">
              <div>
                <h6 class="mb-1">${item.title}</h6>
                <small class="text-muted">${item.type}</small>
              </div>
              <small class="text-muted">${item.subtitle || ''}</small>
            </div>
          </a>
        `
      })

      html += '</div>'
      searchResults.innerHTML = html
    }

    searchResults.classList.remove('d-none')
  }
}

// Dynamic Forms
function initializeDynamicForms() {
  // Add/Remove form fields
  document.addEventListener('click', (e) => {
    if (e.target.matches('.add-fields')) {
      e.preventDefault()
      addFields(e.target)
    }

    if (e.target.matches('.remove-fields')) {
      e.preventDefault()
      removeFields(e.target)
    }
  })

  function addFields(button) {
    const container = document.querySelector(button.dataset.container)
    const template = document.querySelector(button.dataset.template)

    if (container && template) {
      const newFields = template.content.cloneNode(true)
      const timestamp = new Date().getTime()

      // Replace placeholder with unique ID
      newFields.querySelectorAll('[name], [id], [for]').forEach(element => {
        if (element.name) element.name = element.name.replace(/NEW_RECORD/g, timestamp)
        if (element.id) element.id = element.id.replace(/NEW_RECORD/g, timestamp)
        if (element.getAttribute('for')) {
          element.setAttribute('for', element.getAttribute('for').replace(/NEW_RECORD/g, timestamp))
        }
      })

      container.appendChild(newFields)
    }
  }

  function removeFields(button) {
    const fieldset = button.closest('.nested-fields')

    if (fieldset) {
      const destroyInput = fieldset.querySelector('[name*="_destroy"]')

      if (destroyInput) {
        destroyInput.value = '1'
        fieldset.style.display = 'none'
      } else {
        fieldset.remove()
      }
    }
  }

  // Auto-calculate fields
  initializeCalculations()
}

// Auto Calculations
function initializeCalculations() {
  // Premium Calculations for Insurance Forms
  const premiumCalculators = document.querySelectorAll('[data-calculate-premium]')

  premiumCalculators.forEach(form => {
    const netPremium = form.querySelector('[name*="net_premium"]')
    const gstPercentage = form.querySelector('[name*="gst_percentage"]')
    const totalPremium = form.querySelector('[name*="total_premium"]')

    if (netPremium && gstPercentage && totalPremium) {
      const calculatePremium = () => {
        const net = parseFloat(netPremium.value) || 0
        const gst = parseFloat(gstPercentage.value) || 0
        const gstAmount = (net * gst) / 100
        const total = net + gstAmount

        totalPremium.value = total.toFixed(2)

        // Update display
        const gstDisplay = form.querySelector('[data-gst-amount]')
        if (gstDisplay) {
          gstDisplay.textContent = `₹${gstAmount.toFixed(2)}`
        }
      }

      netPremium.addEventListener('input', calculatePremium)
      gstPercentage.addEventListener('input', calculatePremium)
    }
  })

  // Commission Calculations
  const commissionCalculators = document.querySelectorAll('[data-calculate-commission]')

  commissionCalculators.forEach(form => {
    const totalPremium = form.querySelector('[name*="total_premium"]')
    const commissionInputs = form.querySelectorAll('[name*="_commission_percentage"]')

    if (totalPremium && commissionInputs.length > 0) {
      const calculateCommissions = () => {
        const premium = parseFloat(totalPremium.value) || 0
        let totalCommission = 0

        commissionInputs.forEach(input => {
          const percentage = parseFloat(input.value) || 0
          const amount = (premium * percentage) / 100
          totalCommission += amount

          // Update display
          const amountDisplay = form.querySelector(
            `[data-commission-amount="${input.name.match(/(\w+)_commission/)[1]}"]`
          )
          if (amountDisplay) {
            amountDisplay.textContent = `₹${amount.toFixed(2)}`
          }
        })

        // Update total commission display
        const totalDisplay = form.querySelector('[data-total-commission]')
        if (totalDisplay) {
          totalDisplay.textContent = `₹${totalCommission.toFixed(2)}`
        }
      }

      totalPremium.addEventListener('input', calculateCommissions)
      commissionInputs.forEach(input => {
        input.addEventListener('input', calculateCommissions)
      })
    }
  })
}

// Charts Initialization
function initializeCharts() {
  const chartContainers = document.querySelectorAll('[data-chart]')

  chartContainers.forEach(container => {
    const chartType = container.dataset.chartType
    const chartData = JSON.parse(container.dataset.chartData || '{}')
    const chartOptions = JSON.parse(container.dataset.chartOptions || '{}')

    // Using ChartKick
    if (window.Chartkick) {
      switch (chartType) {
        case 'line':
          new Chartkick.LineChart(container, chartData, chartOptions)
          break
        case 'pie':
          new Chartkick.PieChart(container, chartData, chartOptions)
          break
        case 'column':
          new Chartkick.ColumnChart(container, chartData, chartOptions)
          break
        case 'bar':
          new Chartkick.BarChart(container, chartData, chartOptions)
          break
        case 'area':
          new Chartkick.AreaChart(container, chartData, chartOptions)
          break
      }
    }
  })
}

// Notifications
function initializeNotifications() {
  // Check for new notifications periodically
  if (window.notificationInterval) {
    clearInterval(window.notificationInterval)
  }

  window.notificationInterval = setInterval(checkNotifications, 60000) // Every minute

  async function checkNotifications() {
    try {
      const response = await fetch('/api/notifications/unread', {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      const data = await response.json()
      updateNotificationBadge(data.count)

      if (data.notifications && data.notifications.length > 0) {
        showNotificationToast(data.notifications[0])
      }
    } catch (error) {
      console.error('Notification check error:', error)
    }
  }

  function updateNotificationBadge(count) {
    const badge = document.querySelector('.notification-badge')
    if (badge) {
      if (count > 0) {
        badge.textContent = count > 99 ? '99+' : count
        badge.classList.remove('d-none')
      } else {
        badge.classList.add('d-none')
      }
    }
  }

  function showNotificationToast(notification) {
    const toastHTML = `
      <div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
          <i class="bi bi-bell-fill text-primary me-2"></i>
          <strong class="me-auto">${notification.title}</strong>
          <small>${notification.time}</small>
          <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body">
          ${notification.message}
        </div>
      </div>
    `

    const toastContainer = document.querySelector('.toast-container') || createToastContainer()
    toastContainer.insertAdjacentHTML('beforeend', toastHTML)

    const toastElement = toastContainer.lastElementChild
    const toast = new bootstrap.Toast(toastElement)
    toast.show()

    // Remove after hidden
    toastElement.addEventListener('hidden.bs.toast', () => {
      toastElement.remove()
    })
  }

  function createToastContainer() {
    const container = document.createElement('div')
    container.className = 'toast-container position-fixed top-0 end-0 p-3'
    container.style.zIndex = '9999'
    document.body.appendChild(container)
    return container
  }
}

// Form Validation
document.addEventListener('turbo:load', () => {
  const forms = document.querySelectorAll('.needs-validation')

  forms.forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault()
        event.stopPropagation()
      }

      form.classList.add('was-validated')
    })
  })
})

// Date Picker Initialization
document.addEventListener('turbo:load', () => {
  const dateInputs = document.querySelectorAll('input[type="date"]')

  dateInputs.forEach(input => {
    // Set min/max dates based on data attributes
    if (input.dataset.minDate) {
      input.min = input.dataset.minDate
    }

    if (input.dataset.maxDate) {
      input.max = input.dataset.maxDate
    }

    // Auto-calculate age for DOB fields
    if (input.name.includes('dob') || input.name.includes('date_of_birth')) {
      input.addEventListener('change', (e) => {
        const ageField = document.querySelector(
          `[name="${input.name.replace('dob', 'age').replace('date_of_birth', 'age')}"]`
        )

        if (ageField) {
          const dob = new Date(e.target.value)
          const today = new Date()
          let age = today.getFullYear() - dob.getFullYear()
          const monthDiff = today.getMonth() - dob.getMonth()

          if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
            age--
          }

          ageField.value = age
        }
      })
    }
  })
})

// File Upload Preview
document.addEventListener('turbo:load', () => {
  const fileInputs = document.querySelectorAll('input[type="file"]')

  fileInputs.forEach(input => {
    input.addEventListener('change', (e) => {
      const preview = document.querySelector(`[data-preview-for="${input.id}"]`)

      if (preview && e.target.files.length > 0) {
        const file = e.target.files[0]

        if (file.type.startsWith('image/')) {
          const reader = new FileReader()

          reader.onload = (e) => {
            preview.innerHTML = `<img src="${e.target.result}" class="img-thumbnail" style="max-height: 200px;">`
          }

          reader.readAsDataURL(file)
        } else {
          preview.innerHTML = `
            <div class="alert alert-info">
              <i class="bi bi-file-earmark"></i> ${file.name}
              <small class="d-block">${(file.size / 1024).toFixed(2)} KB</small>
            </div>
          `
        }
      }
    })
  })
})

// Export functionality
window.exportData = function(format, url) {
  const params = new URLSearchParams(window.location.search)
  params.append('format', format)

  window.location.href = `${url}?${params.toString()}`
}

// Print functionality
window.printSection = function(sectionId) {
  const section = document.getElementById(sectionId)

  if (section) {
    const printWindow = window.open('', '_blank')
    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Print</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
          @media print {
            .no-print { display: none !important; }
          }
        </style>
      </head>
      <body>
        ${section.innerHTML}
        <script>window.onload = () => { window.print(); window.close(); }</script>
      </body>
      </html>
    `)
    printWindow.document.close()
  }
}
```

### Custom Styles (`app/assets/stylesheets/application.scss`)
```scss
// Bootstrap Configuration
@import "bootstrap";

// Variables
:root {
  --sidebar-width: 250px;
  --sidebar-collapsed-width: 60px;
  --primary-color: #4e73df;
  --secondary-color: #858796;
  --success-color: #1cc88a;
  --warning-color: #f6c23e;
  --danger-color: #e74a3b;
  --light-color: #f8f9fc;
  --dark-color: #2e3544;
}

// Base Styles
body {
  font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: var(--light-color);
}

// Sidebar Styles
.sidebar {
  width: var(--sidebar-width);
  min-height: 100vh;
  background: linear-gradient(180deg, var(--primary-color) 10%, var(--dark-color) 100%);
  transition: width 0.3s ease;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1000;
  overflow-x: hidden;
  overflow-y: auto;

  &.collapsed {
    width: var(--sidebar-collapsed-width);

    .sidebar-header h3 {
      display: none;
    }

    .nav-link span {
      display: none;
    }

    .nav-link i {
      margin-right: 0;
      font-size: 1.2rem;
    }

    .sidebar-footer .user-info span,
    .sidebar-footer .user-info small {
      display: none;
    }
  }

  .sidebar-header {
    padding: 1.5rem;
    color: white;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);

    h3 {
      margin: 0;
      font-size: 1.2rem;
      font-weight: 700;

      i {
        margin-right: 0.5rem;
      }
    }
  }

  .sidebar-nav {
    list-style: none;
    padding: 1rem 0;
    margin: 0;

    .nav-item {
      margin-bottom: 0.5rem;
    }

    .nav-link {
      color: rgba(255, 255, 255, 0.8);
      padding: 0.75rem 1.5rem;
      display: flex;
      align-items: center;
      text-decoration: none;
      transition: all 0.3s;
      position: relative;

      i {
        margin-right: 0.75rem;
        font-size: 0.9rem;
      }

      &:hover {
        color: white;
        background: rgba(255, 255, 255, 0.1);
      }

      &.active {
        color: white;
        background: rgba(255, 255, 255, 0.1);

        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 0;
          bottom: 0;
          width: 3px;
          background: white;
        }
      }
    }

    .nav-content {
      background: rgba(0, 0, 0, 0.1);
      list-style: none;
      padding: 0.5rem 0;

      .nav-link {
        padding-left: 3rem;
        font-size: 0.9rem;
      }
    }
  }

  .sidebar-footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    padding: 1rem;
    background: rgba(0, 0, 0, 0.2);
    color: white;

    .user-info {
      display: flex;
      align-items: center;
      margin-bottom: 1rem;

      i {
        font-size: 1.5rem;
        margin-right: 0.5rem;
      }
    }
  }
}

// Main Content
.main-content {
  margin-left: var(--sidebar-width);
  min-height: 100vh;
  transition: margin-left 0.3s ease;

  &.expanded {
    margin-left: var(--sidebar-collapsed-width);
  }
}

// Card Styles
.card {
  border: none;
  box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
  margin-bottom: 1.5rem;

  .card-header {
    background-color: var(--light-color);
    border-bottom: 1px solid #e3e6f0;
    font-weight: 600;
    color: var(--primary-color);
  }

  &.border-left-primary {
    border-left: 0.25rem solid var(--primary-color);
  }

  &.border-left-success {
    border-left: 0.25rem solid var(--success-color);
  }

  &.border-left-warning {
    border-left: 0.25rem solid var(--warning-color);
  }

  &.border-left-danger {
    border-left: 0.25rem solid var(--danger-color);
  }
}

// Dashboard Cards
.dashboard-card {
  padding: 1.25rem;

  .metric-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--dark-color);
  }

  .metric-label {
    color: var(--secondary-color);
    text-transform: uppercase;
    font-size: 0.8rem;
    font-weight: 700;
  }

  .metric-icon {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 2rem;
    color: rgba(0, 0, 0, 0.1);
  }
}

// Tables
.table-responsive {
  .table {
    th {
      font-weight: 600;
      color: var(--primary-color);
      border-bottom: 2px solid var(--primary-color);
      white-space: nowrap;
    }

    td {
      vertical-align: middle;
    }

    .action-buttons {
      white-space: nowrap;

      .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
        margin-right: 0.25rem;
      }
    }
  }
}

// Forms
.form-label {
  font-weight: 600;
  color: var(--dark-color);
  margin-bottom: 0.5rem;
}

.form-control,
.form-select {
  border-radius: 0.35rem;

  &:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
  }
}

.form-check-input:checked {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
}

// Buttons
.btn {
  border-radius: 0.35rem;
  font-weight: 600;

  &.btn-primary {
    background-color: var(--primary-color);
    border-color: var(--primary-color);

    &:hover {
      background-color: darken(var(--primary-color), 10%);
    }
  }
}

// Alerts
.alert {
  border-radius: 0.35rem;

  &.alert-dismissible {
    .btn-close {
      padding: 0.5rem;
    }
  }
}

// Pagination
.pagination {
  .page-link {
    color: var(--primary-color);

    &:hover {
      background-color: var(--light-color);
    }
  }

  .page-item.active .page-link {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
  }
}

// Loading Spinner
.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 200px;

  .spinner-border {
    width: 3rem;
    height: 3rem;
    border-width: 0.3rem;
  }
}

// Responsive
@media (max-width: 768px) {
  .sidebar {
    width: 100%;
    transform: translateX(-100%);

    &.show {
      transform: translateX(0);
    }
  }

  .main-content {
    margin-left: 0;
  }
}

// Print Styles
@media print {
  .sidebar,
  .navbar,
  .no-print {
    display: none !important;
  }

  .main-content {
    margin-left: 0 !important;
  }

  .card {
    box-shadow: none !important;
    border: 1px solid #dee2e6 !important;
  }
}

// Custom Animations
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.5s ease-in-out;
}

@keyframes slideInLeft {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0);
  }
}

.slide-in-left {
  animation: slideInLeft 0.3s ease-in-out;
}

// Status Badges
.badge {
  font-weight: 600;
  padding: 0.35rem 0.65rem;

  &.bg-success-light {
    background-color: rgba(28, 200, 138, 0.1);
    color: var(--success-color);
  }

  &.bg-warning-light {
    background-color: rgba(246, 194, 62, 0.1);
    color: var(--warning-color);
  }

  &.bg-danger-light {
    background-color: rgba(231, 74, 59, 0.1);
    color: var(--danger-color);
  }
}

// Search Results
.search-results {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: white;
  border: 1px solid #dee2e6;
  border-radius: 0.35rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
  max-height: 400px;
  overflow-y: auto;
  z-index: 1000;

  .list-group-item {
    border-left: none;
    border-right: none;

    &:first-child {
      border-top: none;
    }

    &:last-child {
      border-bottom: none;
    }

    &:hover {
      background-color: var(--light-color);
    }
  }
}

// Toast Notifications
.toast {
  min-width: 300px;

  .toast-header {
    background-color: var(--light-color);

    i {
      font-size: 1.2rem;
    }
  }
}

// Charts
.chart-container {
  position: relative;
  height: 300px;

  canvas {
    max-height: 100%;
  }
}

// File Upload
.file-upload-wrapper {
  position: relative;

  .file-upload-input {
    position: absolute;
    opacity: 0;
    z-index: -1;
  }

  .file-upload-label {
    display: inline-block;
    padding: 0.5rem 1rem;
    background-color: var(--light-color);
    border: 2px dashed #dee2e6;
    border-radius: 0.35rem;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
      background-color: white;
      border-color: var(--primary-color);
    }

    i {
      font-size: 2rem;
      color: var(--secondary-color);
    }
  }

  &.has-file {
    .file-upload-label {
      border-style: solid;
      border-color: var(--success-color);
    }
  }
}

// Timeline
.timeline {
  position: relative;
  padding: 1rem 0;

  &::before {
    content: '';
    position: absolute;
    left: 2rem;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #dee2e6;
  }

  .timeline-item {
    position: relative;
    padding-left: 5rem;
    padding-bottom: 2rem;

    &::before {
      content: '';
      position: absolute;
      left: 1.5rem;
      top: 0.5rem;
      width: 1rem;
      height: 1rem;
      border-radius: 50%;
      background: white;
      border: 2px solid var(--primary-color);
    }

    &.completed::before {
      background: var(--success-color);
      border-color: var(--success-color);
    }

    .timeline-date {
      font-size: 0.875rem;
      color: var(--secondary-color);
    }

    .timeline-content {
      background: white;
      padding: 1rem;
      border-radius: 0.35rem;
      box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
    }
  }
}
```

---

## 6. Services & Background Jobs

### Commission Calculator Service (`app/services/commission_calculator_service.rb`)
```ruby
class CommissionCalculatorService
  attr_reader :policy, :premium_amount

  def initialize(policy)
    @policy = policy
    @premium_amount = calculate_premium_amount
  end

  def calculate
    ActiveRecord::Base.transaction do
      create_main_agent_commission
      create_sub_agent_commission if policy.sub_agent.present?
      create_ambassador_commission if policy.customer.ambassador.present?
      create_investor_commission if investor_eligible?
      create_company_expenses
    end
  end

  private

  def calculate_premium_amount
    case policy
    when HealthInsurance, MotorInsurance
      policy.net_premium || 0
    when LifeInsurance
      policy.premium_amount || 0
    else
      0
    end
  end

  def create_main_agent_commission
    percentage = policy.main_agent_commission_percentage || default_main_agent_percentage
    amount = calculate_amount(percentage)

    CommissionPayout.create!(
      policy: policy,
      policy_type: policy.class.name.underscore,
      user: policy.user,
      payout_to: 'main_agent',
      commission_percentage: percentage,
      payout_amount: amount,
      status: 'pending',
      premium_amount: premium_amount
    )
  end

  def create_sub_agent_commission
    percentage = policy.sub_agent_commission_percentage || default_sub_agent_percentage
    amount = calculate_amount(percentage)
    tds_percentage = 5.0
    tds_amount = (amount * tds_percentage) / 100
    net_amount = amount - tds_amount

    CommissionPayout.create!(
      policy: policy,
      policy_type: policy.class.name.underscore,
      sub_agent: policy.sub_agent,
      payout_to: 'sub_agent',
      commission_percentage: percentage,
      payout_amount: amount,
      tds_percentage: tds_percentage,
      tds_amount: tds_amount,
      net_payout_amount: net_amount,
      status: 'pending',
      premium_amount: premium_amount
    )
  end

  def create_ambassador_commission
    percentage = policy.ambassador_commission_percentage || default_ambassador_percentage
    amount = calculate_amount(percentage)

    CommissionPayout.create!(
      policy: policy,
      policy_type: policy.class.name.underscore,
      user: policy.customer.ambassador,
      payout_to: 'ambassador',
      commission_percentage: percentage,
      payout_amount: amount,
      status: 'pending',
      premium_amount: premium_amount
    )
  end

  def create_investor_commission
    percentage = policy.investor_commission_percentage || default_investor_percentage
    amount = calculate_amount(percentage)

    CommissionPayout.create!(
      policy: policy,
      policy_type: policy.class.name.underscore,
      payout_to: 'investor',
      commission_percentage: percentage,
      payout_amount: amount,
      status: 'pending',
      premium_amount: premium_amount
    )
  end

  def create_company_expenses
    percentage = policy.company_expenses_percentage || default_company_expenses_percentage
    amount = calculate_amount(percentage)

    CommissionPayout.create!(
      policy: policy,
      policy_type: policy.class.name.underscore,
      payout_to: 'company',
      commission_percentage: percentage,
      payout_amount: amount,
      status: 'approved',
      premium_amount: premium_amount
    )
  end

  def calculate_amount(percentage)
    (premium_amount * percentage) / 100
  end

  def investor_eligible?
    # Investor commission only for high-value policies
    premium_amount >= 50000
  end

  def default_main_agent_percentage
    case policy
    when HealthInsurance
      15.0
    when LifeInsurance
      35.0
    when MotorInsurance
      12.5
    else
      10.0
    end
  end

  def default_sub_agent_percentage
    3.0
  end

  def default_ambassador_percentage
    2.0
  end

  def default_investor_percentage
    1.0
  end

  def default_company_expenses_percentage
    5.0
  end
end
```

### Lead Generator Service (`app/services/lead_generator_service.rb`)
```ruby
class LeadGeneratorService
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def generate
    return if lead_exists?

    Lead.create!(
      lead_id: generate_lead_id,
      name: policy.customer.display_name,
      contact_number: policy.customer.mobile,
      email: policy.customer.email,
      product_category: 'insurance',
      product_subcategory: product_subcategory,
      current_stage: 'policy_created',
      customer_type: policy.customer.customer_type,
      converted_customer_id: policy.customer_id,
      policy_created_id: policy.id,
      stage_updated_at: Time.current,
      created_date: policy.policy_booking_date || Date.current,
      notes: "Auto-generated from #{policy.class.name.humanize} creation",
      is_direct: policy.sub_agent_id.blank?,
      affiliate_id: policy.sub_agent_id,
      user: policy.user
    )
  end

  private

  def lead_exists?
    Lead.exists?(
      converted_customer_id: policy.customer_id,
      product_subcategory: product_subcategory,
      policy_created_id: policy.id
    )
  end

  def generate_lead_id
    prefix = lead_prefix
    timestamp = Time.current.strftime("%Y%m%d%H%M%S")
    random = SecureRandom.hex(3).upcase
    "#{prefix}#{timestamp}#{random}"
  end

  def lead_prefix
    case policy
    when HealthInsurance
      "HL"
    when LifeInsurance
      "LL"
    when MotorInsurance
      "ML"
    else
      "OL"
    end
  end

  def product_subcategory
    case policy
    when HealthInsurance
      'health'
    when LifeInsurance
      'life'
    when MotorInsurance
      'motor'
    else
      'other'
    end
  end
end
```

### JWT Service (`app/services/jwt_service.rb`)
```ruby
class JwtService
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM = 'HS256'
  EXPIRY_TIME = 24.hours

  def self.encode(payload, expiry = EXPIRY_TIME.from_now)
    payload[:exp] = expiry.to_i
    JWT.encode(payload, HMAC_SECRET, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, HMAC_SECRET, true, algorithm: ALGORITHM)
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError => e
    raise JWT::DecodeError, "Invalid token: #{e.message}"
  end

  def self.valid_token?(token)
    decode(token)
    true
  rescue JWT::DecodeError
    false
  end
end
```

### Analytics Service (`app/services/analytics_service.rb`)
```ruby
class AnalyticsService
  attr_reader :user, :date_range

  def initialize(user, date_range = nil)
    @user = user
    @date_range = date_range || default_date_range
  end

  def generate
    {
      overview: generate_overview,
      policies: generate_policy_analytics,
      customers: generate_customer_analytics,
      leads: generate_lead_analytics,
      commissions: generate_commission_analytics,
      trends: generate_trends
    }
  end

  private

  def default_date_range
    Date.current.beginning_of_month..Date.current.end_of_month
  end

  def generate_overview
    {
      total_premium: calculate_total_premium,
      active_policies: count_active_policies,
      new_customers: count_new_customers,
      conversion_rate: calculate_conversion_rate,
      avg_policy_value: calculate_avg_policy_value,
      renewal_rate: calculate_renewal_rate
    }
  end

  def generate_policy_analytics
    {
      by_type: policies_by_type,
      by_status: policies_by_status,
      by_payment_mode: policies_by_payment_mode,
      top_insurance_companies: top_insurance_companies,
      expiring_soon: expiring_policies,
      renewal_opportunities: renewal_opportunities
    }
  end

  def generate_customer_analytics
    {
      total: Customer.count,
      new_this_month: Customer.where(created_at: date_range).count,
      by_type: Customer.group(:customer_type).count,
      by_status: Customer.group(:status).count,
      top_customers: top_customers_by_premium,
      customer_lifetime_value: calculate_clv
    }
  end

  def generate_lead_analytics
    {
      total: Lead.count,
      by_stage: Lead.group(:current_stage).count,
      conversion_funnel: generate_conversion_funnel,
      avg_conversion_time: calculate_avg_conversion_time,
      by_source: Lead.group(:source).count,
      top_performers: top_performing_agents
    }
  end

  def generate_commission_analytics
    {
      total_payable: CommissionPayout.pending_payouts.sum(:payout_amount),
      paid_this_month: CommissionPayout.paid.where(paid_at: date_range).sum(:payout_amount),
      by_type: CommissionPayout.group(:payout_to).sum(:payout_amount),
      pending_approvals: CommissionPayout.pending_payouts.count,
      avg_commission_rate: calculate_avg_commission_rate
    }
  end

  def generate_trends
    {
      premium_trend: monthly_premium_trend,
      customer_growth: monthly_customer_growth,
      policy_growth: monthly_policy_growth,
      commission_trend: monthly_commission_trend
    }
  end

  def calculate_total_premium
    HealthInsurance.where(created_at: date_range).sum(:total_premium) +
    LifeInsurance.where(created_at: date_range).sum(:premium_amount) +
    MotorInsurance.where(created_at: date_range).sum(:total_premium)
  end

  def count_active_policies
    HealthInsurance.active.count +
    LifeInsurance.active.count +
    MotorInsurance.active.count
  end

  def count_new_customers
    Customer.where(created_at: date_range).count
  end

  def calculate_conversion_rate
    total_leads = Lead.where(created_at: date_range).count
    converted_leads = Lead.converted_leads.where(created_at: date_range).count

    return 0 if total_leads.zero?
    ((converted_leads.to_f / total_leads) * 100).round(2)
  end

  def calculate_avg_policy_value
    total_policies = HealthInsurance.count + LifeInsurance.count + MotorInsurance.count
    return 0 if total_policies.zero?

    total_premium = calculate_total_premium
    (total_premium / total_policies).round(2)
  end

  def calculate_renewal_rate
    total_renewals = HealthInsurance.where(policy_type: 'renewal').count +
                     MotorInsurance.where(policy_type: 'renewal').count

    total_eligible = HealthInsurance.where('policy_end_date < ?', Date.current).count +
                     MotorInsurance.where('policy_end_date < ?', Date.current).count

    return 0 if total_eligible.zero?
    ((total_renewals.to_f / total_eligible) * 100).round(2)
  end

  def policies_by_type
    {
      'Health Insurance' => HealthInsurance.count,
      'Life Insurance' => LifeInsurance.count,
      'Motor Insurance' => MotorInsurance.count
    }
  end

  def policies_by_status
    active = HealthInsurance.active.count + LifeInsurance.active.count + MotorInsurance.active.count
    expired = HealthInsurance.expired.count + LifeInsurance.expired.count + MotorInsurance.expired.count

    {
      'Active' => active,
      'Expired' => expired
    }
  end

  def monthly_premium_trend
    (0..11).map do |months_ago|
      date = months_ago.months.ago
      month_range = date.beginning_of_month..date.end_of_month

      premium = HealthInsurance.where(created_at: month_range).sum(:total_premium) +
                LifeInsurance.where(created_at: month_range).sum(:premium_amount) +
                MotorInsurance.where(created_at: month_range).sum(:total_premium)

      {
        month: date.strftime("%B %Y"),
        amount: premium
      }
    end.reverse
  end

  def generate_conversion_funnel
    stages = Lead.current_stages.keys
    funnel = {}

    stages.each_with_index do |stage, index|
      count = Lead.where(current_stage: stages[index..]).count
      funnel[stage] = count
    end

    funnel
  end

  def top_customers_by_premium
    Customer.joins(:health_insurances, :life_insurances, :motor_insurances)
            .group('customers.id')
            .order('SUM(health_insurances.total_premium + life_insurances.premium_amount + motor_insurances.total_premium) DESC')
            .limit(10)
  end

  def top_performing_agents
    User.joins(:commission_payouts)
        .where(user_type: ['agent', 'sub_agent'])
        .group('users.id')
        .order('SUM(commission_payouts.payout_amount) DESC')
        .limit(10)
  end
end
```

---

## 7. Feature-by-Feature Walkthrough

### 1. User Authentication & Login

**Features:**
- Multi-modal login (Email/Mobile/PAN)
- Role-based access control
- Session management with timeout
- Password reset functionality
- Remember me option

**Flow:**
1. User visits `/users/sign_in`
2. Enters credentials (email/mobile/PAN + password)
3. System validates against User and Customer tables
4. Creates session and redirects to appropriate dashboard
5. Session expires after 30 minutes of inactivity

### 2. Dashboard Analytics

**Features:**
- Real-time metrics display
- Interactive charts with ChartKick
- Period comparison
- Export to PDF/Excel
- Customizable widgets

**Key Metrics:**
- Total customers and growth rate
- Active policies by type
- Premium collection trends
- Lead conversion funnel
- Commission distribution
- Renewal pipeline

### 3. Customer Management

**Features:**
- Complete customer lifecycle management
- Family member tracking
- Document management with Active Storage
- Customer communication history
- Policy portfolio view
- Import/Export functionality

**Workflow:**
1. Create customer with KYC details
2. Add family members
3. Upload documents (PAN, Aadhaar, etc.)
4. Link to policies
5. Track interactions and communications

### 4. Policy Creation & Management

**Health Insurance Features:**
- Individual/Family Floater/Group policies
- Member management with age calculation
- Premium calculation with GST
- Renewal tracking and reminders
- Claim history
- Policy document generation

**Life Insurance Features:**
- Multiple policy types (Term, Whole Life, ULIP, etc.)
- Nominee management
- Premium payment tracking
- Maturity calculations
- Loan against policy
- Surrender value calculations

**Motor Insurance Features:**
- Comprehensive/Third Party/Own Damage
- Vehicle details management
- NCB tracking
- Add-on covers
- IDV calculation
- Claim settlement tracking

### 5. Lead Management System

**Features:**
- Multi-stage pipeline
- Lead scoring
- Automated follow-ups
- Branch-out capability
- Conversion tracking
- Source attribution

**Lead Stages:**
1. Lead Generated
2. Consultation Scheduled
3. One-on-One Meeting
4. Follow-up
5. Policy Created
6. Converted/Closed

### 6. Commission & Payout System

**Features:**
- Automated commission calculation
- Multi-level distribution
- TDS calculation
- Approval workflow
- Payment processing
- Reconciliation reports

**Commission Structure:**
- Main Agent: 10-35% (varies by product)
- Sub Agent: 2-5%
- Ambassador: 2%
- Investor: 1% (high-value policies)
- Company Expenses: 5%

### 7. Reporting & Analytics

**Available Reports:**
- Policy Reports (Active/Expired/Renewal Due)
- Commission Reports (Pending/Paid/By Agent)
- Customer Reports (New/Active/Inactive)
- Lead Reports (Conversion/Source/Performance)
- Financial Reports (Premium/Claims/Profitability)
- Compliance Reports (KYC/Documentation)

### 8. Mobile API Platform

**Features:**
- JWT-based authentication
- RESTful API design
- Real-time synchronization
- Offline capability
- Push notifications
- File upload/download

**Key Endpoints:**
- Authentication: `/api/auth/login`, `/api/auth/register`
- Customers: `/api/customers`
- Policies: `/api/policies/:type`
- Leads: `/api/leads`
- Payouts: `/api/payouts`
- Reports: `/api/reports`

### 9. Admin Panel Features

**User Management:**
- User creation and role assignment
- Permission management
- Activity tracking
- Login history
- Password policies

**System Settings:**
- Company configuration
- Commission rates
- Email templates
- SMS templates
- Notification settings

**Import/Export:**
- Bulk customer import
- Policy data import
- Report export (PDF/Excel/CSV)
- Data backup

### 10. Notification System

**Features:**
- Email notifications
- SMS notifications
- In-app notifications
- Push notifications (mobile)
- Customizable templates
- Scheduling capability

**Notification Triggers:**
- Policy expiry (30/60 days)
- Premium due dates
- Lead follow-ups
- Commission approvals
- Birthday wishes
- Document expiry

---

## 8. API Documentation

### Authentication Endpoints

#### POST /api/auth/login
```json
Request:
{
  "email_or_mobile_or_pan": "user@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "JWT_TOKEN",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "user@example.com",
      "user_type": "agent"
    }
  }
}
```

#### POST /api/auth/register
```json
Request:
{
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "password": "password123",
    "password_confirmation": "password123",
    "pan": "ABCDE1234F",
    "user_type": "customer"
  }
}

Response:
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "JWT_TOKEN",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    }
  }
}
```

### Customer Endpoints

#### GET /api/customers
```json
Headers:
{
  "Authorization": "Bearer JWT_TOKEN"
}

Response:
{
  "success": true,
  "data": {
    "customers": [...],
    "meta": {
      "current_page": 1,
      "total_pages": 10,
      "total_count": 100
    }
  }
}
```

#### POST /api/customers
```json
Request:
{
  "customer": {
    "display_name": "Jane Doe",
    "mobile": "9876543210",
    "email": "jane@example.com",
    "pan": "ABCDE1234F",
    "aadhaar": "123456789012",
    "customer_type": "individual"
  }
}

Response:
{
  "success": true,
  "message": "Customer created successfully",
  "data": {
    "customer": {...}
  }
}
```

### Policy Endpoints

#### GET /api/policies/health
```json
Response:
{
  "success": true,
  "data": {
    "policies": [...],
    "statistics": {
      "total": 100,
      "active": 85,
      "expired": 15
    }
  }
}
```

#### POST /api/policies/health
```json
Request:
{
  "health_insurance": {
    "customer_id": 1,
    "policy_holder": "Self",
    "insurance_company_name": "ICICI Lombard",
    "policy_type": "new",
    "insurance_type": "family_floater",
    "policy_number": "POL123456",
    "sum_insured": 500000,
    "net_premium": 15000,
    "total_premium": 17700
  }
}
```

---

## 9. Deployment & Configuration

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql://username:password@host:port/database

# Rails
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key_base
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

# Email
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_password

# SMS (if using)
SMS_API_KEY=your_sms_api_key
SMS_SENDER_ID=INSURE

# Storage (for Active Storage)
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret
AWS_REGION=ap-south-1
AWS_BUCKET=insurebook-storage

# Analytics
GOOGLE_ANALYTICS_ID=UA-XXXXXXXXX-X
```

### Database Setup
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Seed initial data
rails db:seed

# Create first admin user
rails console
User.create!(
  name: "Admin",
  email: "admin@insurebook.com",
  password: "admin123",
  user_type: "admin"
)
```

### Production Deployment with Kamal
```yaml
# config/deploy.yml
service: insurebook
image: insurebook/app

servers:
  web:
    - 192.168.1.1

registry:
  username: dockerhub_username
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  secret:
    - RAILS_MASTER_KEY

accessories:
  db:
    image: postgres:15
    host: 192.168.1.2
    env:
      clear:
        POSTGRES_DB: insurebook_production
      secret:
        - POSTGRES_PASSWORD

traefik:
  options:
    publish:
      - "443:443"
    volume:
      - "/letsencrypt/acme.json:/letsencrypt/acme.json"
```

### Deployment Commands
```bash
# First deployment
kamal setup

# Deploy updates
kamal deploy

# Run migrations
kamal app exec 'rails db:migrate'

# Access console
kamal app exec 'rails console'

# View logs
kamal app logs

# Rollback
kamal rollback
```

### Monitoring & Maintenance

**Health Check Endpoint:**
```ruby
# config/routes.rb
get '/health', to: proc { [200, {}, ['OK']] }
```

**Background Jobs:**
```bash
# Start Solid Queue
rails solid_queue:start
```

**Cron Jobs (whenever gem):**
```ruby
# config/schedule.rb
every 1.day, at: '9:00 am' do
  runner "RenewalReminderJob.perform_later"
end

every 1.day, at: '10:00 am' do
  runner "PremiumDueReminderJob.perform_later"
end

every :sunday, at: '11:00 pm' do
  runner "WeeklyReportJob.perform_later"
end
```

---

## 10. Security Considerations

### Authentication Security
- BCrypt for password hashing
- JWT tokens with expiration
- Session timeout after inactivity
- CSRF protection enabled
- Strong password requirements

### Authorization
- Role-based access control with CanCanCan
- Granular permissions system
- API authentication required
- Admin approval for sensitive actions

### Data Protection
- SSL/TLS encryption in transit
- Encrypted database connections
- PII data masking in logs
- Regular security audits
- GDPR compliance features

### Best Practices
- Regular dependency updates
- SQL injection prevention
- XSS protection
- Rate limiting on API
- Audit logging for all changes

---

## Conclusion

InsureBook Admin is a comprehensive insurance management platform built with modern web technologies. It provides:

1. **Complete Insurance Lifecycle Management** - From lead generation to policy renewal
2. **Multi-Product Support** - Health, Life, Motor, and other insurance products
3. **Advanced Commission System** - Automated calculations and multi-level distribution
4. **Mobile-Ready API** - Complete mobile app support with JWT authentication
5. **Robust Reporting** - Comprehensive analytics and business intelligence
6. **Scalable Architecture** - Built on Rails 8.0 with modern deployment tools

The application follows Rails best practices, implements proper security measures, and provides a user-friendly interface for managing all aspects of an insurance business.

For further customization or feature additions, the modular architecture allows easy extension while maintaining code quality and performance.