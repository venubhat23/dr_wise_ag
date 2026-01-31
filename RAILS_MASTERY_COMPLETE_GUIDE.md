# 🚀 Complete Rails Mastery Guide - From Zero to Production Expert

## Table of Contents
1. [Ruby Fundamentals](#ruby-fundamentals)
2. [Rails Architecture & MVC](#rails-architecture)
3. [ActiveRecord Deep Dive](#activerecord)
4. [Controllers & Routing](#controllers-routing)
5. [Views & Frontend](#views-frontend)
6. [Authentication & Authorization](#auth)
7. [API Development](#api)
8. [Testing Strategies](#testing)
9. [Performance Optimization](#performance)
10. [Security Best Practices](#security)
11. [Deployment & DevOps](#deployment)
12. [Advanced Topics](#advanced)
13. [Interview Questions](#interview)

---

## 1. Ruby Fundamentals {#ruby-fundamentals}

### Core Concepts to Master

#### 1.1 Object-Oriented Programming
```ruby
# Real Production Example: Service Object Pattern for Insurance Processing
class InsurancePolicyProcessor
  attr_reader :policy, :customer, :errors

  def initialize(policy, customer)
    @policy = policy
    @customer = customer
    @errors = []
  end

  def process
    ActiveRecord::Base.transaction do
      validate_policy!
      calculate_premiums
      apply_discounts
      generate_commission_structure
      create_policy_record
      notify_stakeholders
    rescue StandardError => e
      @errors << e.message
      handle_processing_failure(e)
      raise ActiveRecord::Rollback
    end
  end

  private

  def validate_policy!
    raise PolicyError, "Customer age exceeds limit" if customer.age > policy.max_age
    raise PolicyError, "Invalid coverage amount" unless policy.valid_coverage?
  end

  def calculate_premiums
    @base_premium = PremiumCalculator.new(policy, customer).calculate
    @tax_amount = @base_premium * 0.18 # GST
    @total_premium = @base_premium + @tax_amount
  end

  def generate_commission_structure
    CommissionDistributor.new(policy).distribute({
      main_agent: 0.20,
      sub_agent: 0.05,
      company: 0.10
    })
  end
end
```

**Common Production Mistakes & Solutions:**
```ruby
# MISTAKE: Class variables shared across inheritance
class BasePolicy
  @@commission_rate = 0.10 # Don't do this!
end

# SOLUTION: Use class instance variables
class BasePolicy
  class << self
    attr_accessor :commission_rate
  end
  self.commission_rate = 0.10
end

# MISTAKE: Not handling nil properly
def calculate_total
  items.sum(&:price) # Fails if items is nil
end

# SOLUTION: Safe navigation
def calculate_total
  items&.sum(&:price) || 0
end
```

#### 1.2 Metaprogramming in Production
```ruby
# Real-world: Dynamic API client generation
class DynamicApiClient
  API_ENDPOINTS = {
    users: '/api/v1/users',
    orders: '/api/v1/orders',
    products: '/api/v1/products'
  }.freeze

  API_ENDPOINTS.each do |resource, endpoint|
    # Dynamically create finder methods
    define_singleton_method("find_#{resource.to_s.singularize}") do |id|
      get("#{endpoint}/#{id}")
    end

    # Create listing methods
    define_singleton_method("list_#{resource}") do |params = {}|
      get(endpoint, params)
    end

    # Create creation methods
    define_singleton_method("create_#{resource.to_s.singularize}") do |attributes|
      post(endpoint, attributes)
    end
  end

  def self.method_missing(method_name, *args, &block)
    if method_name.to_s =~ /^find_(.+)_by_(.+)$/
      resource = $1.pluralize
      attribute = $2
      return get("/api/v1/#{resource}", { attribute => args.first })
    end
    super
  end

  def self.respond_to_missing?(method_name, include_private = false)
    method_name.to_s =~ /^find_(.+)_by_(.+)$/ || super
  end
end
```

#### 1.3 Blocks, Procs, and Lambdas - Production Use Cases
```ruby
# Production Pattern: Configurable retry logic with blocks
class RobustApiClient
  def self.with_retry(max_attempts: 3, backoff: :exponential, &block)
    attempt = 0
    last_exception = nil

    while attempt < max_attempts
      attempt += 1

      begin
        return yield(attempt)
      rescue StandardError => e
        last_exception = e
        Rails.logger.warn "Attempt #{attempt}/#{max_attempts} failed: #{e.message}"

        if attempt < max_attempts
          sleep_time = calculate_backoff(attempt, backoff)
          sleep(sleep_time)
        end
      end
    end

    raise last_exception || StandardError.new("All attempts failed")
  end

  private

  def self.calculate_backoff(attempt, strategy)
    case strategy
    when :exponential
      2 ** (attempt - 1)
    when :linear
      attempt
    when Proc
      strategy.call(attempt)
    else
      1
    end
  end
end

# Usage in production
RobustApiClient.with_retry(max_attempts: 5, backoff: ->(n) { n * 0.5 }) do |attempt|
  Rails.logger.info "Making API call, attempt #{attempt}"
  external_payment_gateway.process_payment(order)
end
```

### Practice Exercises
1. **Build a DSL for Form Validation**
```ruby
class FormValidator
  include ValidationDSL

  validate :email do
    presence true
    format /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    uniqueness scope: :company_id
  end

  validate :age do
    presence true
    numericality greater_than: 18, less_than: 100
  end
end
```

2. **Implement Method Chaining Pattern**
```ruby
class QueryBuilder
  def initialize(model)
    @model = model
    @conditions = []
  end

  def where(conditions)
    @conditions << conditions
    self
  end

  def order(column)
    @order = column
    self
  end

  def limit(num)
    @limit = num
    self
  end

  def execute
    query = @model
    @conditions.each { |c| query = query.where(c) }
    query = query.order(@order) if @order
    query = query.limit(@limit) if @limit
    query
  end
end
```

---

## 2. Rails Architecture & MVC {#rails-architecture}

### Deep MVC Understanding with Production Patterns

#### 2.1 Model Layer - Beyond Basic ActiveRecord
```ruby
# Production Pattern: Domain modeling with value objects
class Money
  attr_reader :amount, :currency

  def initialize(amount, currency = 'USD')
    @amount = BigDecimal(amount.to_s)
    @currency = currency
  end

  def +(other)
    raise ArgumentError unless same_currency?(other)
    Money.new(@amount + other.amount, @currency)
  end

  def to_s
    "#{currency_symbol}#{formatted_amount}"
  end

  private

  def same_currency?(other)
    @currency == other.currency
  end

  def currency_symbol
    { 'USD' => '$', 'EUR' => '€', 'INR' => '₹' }[@currency]
  end

  def formatted_amount
    @amount.to_s('F').reverse.scan(/\d{1,3}/).join(',').reverse
  end
end

# Using in models
class Insurance < ApplicationRecord
  def premium
    Money.new(read_attribute(:premium_amount), premium_currency)
  end

  def premium=(money)
    self.premium_amount = money.amount
    self.premium_currency = money.currency
  end
end
```

#### 2.2 Controller Patterns - Production Ready
```ruby
# Production Pattern: Layered controller with operations
class Admin::InsurancePoliciesController < ApplicationController
  include ErrorHandling
  include ActivityTracking

  before_action :authenticate_admin!
  before_action :load_policy, only: [:show, :edit, :update, :destroy]
  around_action :track_activity

  def create
    operation = InsuranceOperations::Create.new(policy_params, current_user)

    if operation.execute
      respond_with_success(operation.result)
    else
      respond_with_errors(operation.errors)
    end
  end

  private

  def respond_with_success(policy)
    respond_to do |format|
      format.html { redirect_to policy, notice: 'Policy created successfully' }
      format.json { render json: PolicySerializer.new(policy) }
      format.turbo_stream { render turbo_stream: turbo_stream.append('policies', policy) }
    end
  end

  def track_activity
    activity = Activity.create!(
      user: current_user,
      action: action_name,
      resource: controller_name,
      started_at: Time.current
    )

    yield

    activity.update!(
      completed_at: Time.current,
      status: 'success',
      response_code: response.status
    )
  rescue => e
    activity&.update!(status: 'failed', error_message: e.message)
    raise
  end
end
```

### Production Challenge: Solving N+1 Queries at Scale
```ruby
# Problem in production: Dashboard loading 500+ records with associations
class DashboardController < ApplicationController
  def index
    # BAD: Causes N+1 queries, page loads in 15+ seconds
    @policies = current_user.insurance_policies.active
    # Each policy access: customer, agent, payments, documents = 4N queries!
  end
end

# SOLUTION 1: Strategic Eager Loading
class DashboardController < ApplicationController
  def index
    @policies = current_user
      .insurance_policies
      .active
      .includes(
        :customer,
        :agent,
        payments: :payment_method,
        documents: { attachment_attachment: :blob }
      )
      .references(:customers) # Needed when using WHERE with joined tables
      .where('customers.verified = ?', true)
  end
end

# SOLUTION 2: Custom SQL for Complex Aggregations
class PolicyDashboardQuery
  def self.execute(user_id)
    sql = <<-SQL
      SELECT
        p.id,
        p.policy_number,
        p.status,
        c.name as customer_name,
        COUNT(DISTINCT pay.id) as payment_count,
        SUM(pay.amount) as total_paid,
        COUNT(DISTINCT d.id) as document_count,
        MAX(pay.created_at) as last_payment_date
      FROM insurance_policies p
      LEFT JOIN customers c ON c.id = p.customer_id
      LEFT JOIN payments pay ON pay.policy_id = p.id
      LEFT JOIN documents d ON d.policy_id = p.id
      WHERE p.user_id = ?
        AND p.active = true
      GROUP BY p.id, c.name
      ORDER BY p.created_at DESC
    SQL

    ActiveRecord::Base.connection.select_all(
      ActiveRecord::Base.sanitize_sql([sql, user_id])
    ).to_a
  end
end

# SOLUTION 3: Materialized Views for Real-time Dashboards
class CreatePolicyDashboardView < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE MATERIALIZED VIEW policy_dashboard_stats AS
      SELECT
        user_id,
        COUNT(*) as total_policies,
        SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_policies,
        SUM(premium_amount) as total_premium,
        AVG(EXTRACT(EPOCH FROM (policy_end_date - policy_start_date))/86400) as avg_duration_days
      FROM insurance_policies
      GROUP BY user_id;

      CREATE UNIQUE INDEX ON policy_dashboard_stats (user_id);
    SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS policy_dashboard_stats"
  end
end

# Refresh materialized view periodically
class RefreshDashboardStatsJob < ApplicationJob
  def perform
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY policy_dashboard_stats")
  end
end
```

---

## 3. ActiveRecord Deep Dive {#activerecord}

### 3.1 Advanced Query Optimization
```ruby
# Production Scenario: Complex reporting with millions of records
class AdvancedReportingService
  # Use SELECT only needed columns
  def lightweight_report
    Order
      .select(:id, :order_number, :total, :created_at)
      .where(created_at: 30.days.ago..Time.current)
      .pluck_in_batches(:id, :total, batch_size: 1000) do |batch|
        process_batch(batch)
      end
  end

  # Use database functions instead of Ruby
  def statistical_report
    Order
      .select(
        "DATE(created_at) as order_date",
        "COUNT(*) as order_count",
        "SUM(total) as revenue",
        "AVG(total) as avg_order_value",
        "STDDEV(total) as stddev_order_value",
        "PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total) as median_order_value"
      )
      .where(status: 'completed')
      .group("DATE(created_at)")
      .having("SUM(total) > ?", 1000)
  end

  # Optimize with CTEs (Common Table Expressions)
  def complex_hierarchical_report
    sql = <<-SQL
      WITH RECURSIVE category_tree AS (
        SELECT id, name, parent_id, 0 as level
        FROM categories
        WHERE parent_id IS NULL

        UNION ALL

        SELECT c.id, c.name, c.parent_id, ct.level + 1
        FROM categories c
        JOIN category_tree ct ON c.parent_id = ct.id
      ),
      category_sales AS (
        SELECT
          c.id,
          SUM(oi.quantity * oi.price) as total_sales,
          COUNT(DISTINCT o.id) as order_count
        FROM category_tree c
        JOIN products p ON p.category_id = c.id
        JOIN order_items oi ON oi.product_id = p.id
        JOIN orders o ON o.id = oi.order_id
        WHERE o.created_at >= ?
        GROUP BY c.id
      )
      SELECT
        ct.*,
        COALESCE(cs.total_sales, 0) as sales,
        COALESCE(cs.order_count, 0) as orders
      FROM category_tree ct
      LEFT JOIN category_sales cs ON cs.id = ct.id
      ORDER BY ct.level, cs.total_sales DESC
    SQL

    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.sanitize_sql([sql, 30.days.ago])
    )
  end
end
```

### 3.2 Database Transactions - Production Patterns
```ruby
# Production Pattern: Distributed transactions with saga pattern
class PaymentSaga
  def execute(order)
    saga_state = SagaState.create!(
      saga_type: 'payment',
      status: 'started',
      data: { order_id: order.id }
    )

    begin
      # Step 1: Reserve inventory
      inventory_transaction = reserve_inventory(order)
      saga_state.add_step('inventory_reserved', inventory_transaction.id)

      # Step 2: Charge payment
      payment_transaction = charge_payment(order)
      saga_state.add_step('payment_charged', payment_transaction.id)

      # Step 3: Create shipment
      shipment = create_shipment(order)
      saga_state.add_step('shipment_created', shipment.id)

      # Step 4: Send notifications
      send_notifications(order)
      saga_state.add_step('notifications_sent', true)

      saga_state.complete!
    rescue => e
      Rails.logger.error "Saga failed: #{e.message}"
      rollback_saga(saga_state)
      raise
    end
  end

  private

  def rollback_saga(saga_state)
    saga_state.completed_steps.reverse.each do |step|
      case step.name
      when 'inventory_reserved'
        release_inventory(step.transaction_id)
      when 'payment_charged'
        refund_payment(step.transaction_id)
      when 'shipment_created'
        cancel_shipment(step.resource_id)
      end
    end
    saga_state.mark_as_rolled_back!
  end
end

# Production Pattern: Optimistic locking with retry
class OptimisticUpdateService
  MAX_RETRIES = 3

  def update_with_retry(record, attributes)
    retries = 0

    begin
      record.with_lock do
        record.update!(attributes)
      end
    rescue ActiveRecord::StaleObjectError => e
      retries += 1
      if retries < MAX_RETRIES
        Rails.logger.warn "Optimistic lock failed, retry #{retries}/#{MAX_RETRIES}"
        record.reload
        retry
      else
        raise ConcurrentUpdateError, "Failed after #{MAX_RETRIES} retries"
      end
    end
  end
end
```

### 3.3 Callbacks - Production Anti-patterns and Solutions
```ruby
# ANTI-PATTERN: Callback hell
class Order < ApplicationRecord
  after_create :send_confirmation_email
  after_create :update_inventory
  after_create :calculate_commission
  after_create :sync_with_accounting
  after_create :track_analytics
  after_update :notify_status_change
  after_update :update_search_index
  # Leads to: Slow saves, hard to test, hidden dependencies
end

# SOLUTION: Event-driven architecture
class Order < ApplicationRecord
  # Only data integrity callbacks
  before_save :normalize_data
  after_create_commit :publish_created_event
  after_update_commit :publish_updated_event

  private

  def publish_created_event
    EventBus.publish('order.created', order_event_payload)
  end

  def publish_updated_event
    if saved_change_to_status?
      EventBus.publish('order.status_changed', status_change_payload)
    end
  end
end

# Separate handlers for each concern
class OrderCreatedHandler
  def handle(event)
    order = Order.find(event.data[:order_id])

    OrderConfirmationJob.perform_later(order)
    InventoryUpdateJob.perform_later(order)
    CommissionCalculationJob.perform_later(order)
    AccountingSyncJob.perform_later(order)
    AnalyticsTrackingJob.perform_later(order)
  end
end
```

### 3.4 Migrations - Zero Downtime Strategies
```ruby
# Production Safe Migration Pattern
class AddIndexWithoutDowntime < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    # Step 1: Add column without NOT NULL (safe)
    unless column_exists?(:users, :account_status)
      add_column :users, :account_status, :string
    end

    # Step 2: Backfill in batches (prevents locking)
    User.in_batches(of: 10_000) do |batch|
      batch.update_all(account_status: 'active')
      sleep(0.1) # Give replication time to catch up

      # Log progress for monitoring
      Rails.logger.info "Migrated #{batch.maximum(:id)} users"
    end

    # Step 3: Add constraints after data is populated
    change_column_null :users, :account_status, false
    change_column_default :users, :account_status, 'pending'

    # Step 4: Add index concurrently (non-blocking)
    add_index :users, :account_status,
              algorithm: :concurrently,
              if_not_exists: true
  end

  def down
    remove_index :users, :account_status, if_exists: true
    remove_column :users, :account_status, if_exists: true
  end
end

# Strong migrations gem pattern
class SafelyRenameColumn < ActiveRecord::Migration[7.0]
  def up
    # Step 1: Add new column
    add_column :users, :email_address, :string

    # Step 2: Dual write (handled in model)
    # class User < ApplicationRecord
    #   before_save :sync_email_columns
    #   def sync_email_columns
    #     self.email_address = email if email_changed?
    #   end
    # end

    # Step 3: Backfill
    User.in_batches.update_all('email_address = email')

    # Step 4: Switch reads to new column (deploy app changes)
    # Step 5: Remove old column (in next migration)
  end
end
```

---

## 4. Controllers & Routing {#controllers-routing}

### 4.1 Advanced Routing Patterns
```ruby
# config/routes.rb - Production routing with all patterns
Rails.application.routes.draw do
  # Health checks and monitoring
  get '/health', to: proc { [200, {}, ['OK']] }
  get '/metrics', to: 'monitoring#metrics'

  # API versioning with module approach
  namespace :api do
    namespace :v1 do
      resources :policies do
        member do
          post :approve
          post :reject
          get :audit_log
        end

        collection do
          get :pending_approval
          post :bulk_update
        end

        resources :payments, shallow: true do
          post :refund, on: :member
        end
      end
    end

    # Version 2 with breaking changes
    namespace :v2 do
      resources :policies, only: [:index, :show] do
        resources :transactions, controller: 'policy_transactions'
      end
    end
  end

  # Subdomain routing for multi-tenant apps
  constraints subdomain: /^(?!www|api)(\w+)/ do
    scope module: 'tenant' do
      root 'dashboard#show'
      resources :settings
    end
  end

  # Admin panel with IP restrictions
  constraints IpWhitelist do
    namespace :admin do
      root 'dashboard#index'
      resources :users do
        post :impersonate, on: :member
      end
    end
  end

  # Dynamic route based on feature flags
  constraints FeatureFlag.new(:new_checkout) do
    post '/checkout', to: 'checkout_v2#create'
  end

  # Catch-all for client-side routing (React/Vue)
  get '*path', to: 'application#index', constraints: ->(req) {
    !req.xhr? && req.format.html?
  }
end

# Custom constraint classes
class IpWhitelist
  ALLOWED_IPS = ENV.fetch('ADMIN_IPS', '').split(',')

  def self.matches?(request)
    return true if Rails.env.development?
    ALLOWED_IPS.include?(request.remote_ip)
  end
end

class FeatureFlag
  def initialize(flag_name)
    @flag_name = flag_name
  end

  def matches?(request)
    Flipper.enabled?(@flag_name, current_user(request))
  end

  private

  def current_user(request)
    User.find_by(id: request.session[:user_id])
  end
end
```

### 4.2 Controller Composition Patterns
```ruby
# Production pattern: Controller concerns for cross-cutting features
module ApiController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_key!
    before_action :track_api_usage
    after_action :set_rate_limit_headers

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from StandardError, with: :internal_error if Rails.env.production?
  end

  private

  def authenticate_api_key!
    api_key = request.headers['X-API-Key']
    @api_client = ApiClient.find_by(key: api_key)

    unless @api_client&.active?
      render json: { error: 'Invalid API key' }, status: :unauthorized
    end
  end

  def track_api_usage
    ApiUsageTracker.track(@api_client, request) if @api_client
  end

  def set_rate_limit_headers
    response.headers['X-RateLimit-Limit'] = @api_client.rate_limit.to_s
    response.headers['X-RateLimit-Remaining'] = @api_client.remaining_requests.to_s
    response.headers['X-RateLimit-Reset'] = @api_client.reset_time.to_i.to_s
  end

  def not_found(exception)
    render json: {
      error: 'Resource not found',
      details: exception.message
    }, status: :not_found
  end
end

# Production Controller with all best practices
class Api::V1::InsurancePoliciesController < ApplicationController
  include ApiController
  include Pagination

  # Declarative parameter filtering
  before_action :validate_parameters!, only: [:create, :update]
  before_action :load_policy, only: [:show, :update, :destroy]
  before_action :authorize_policy!, only: [:update, :destroy]

  def index
    policies = PolicySearchService
      .new(current_user)
      .search(search_params)
      .includes(:customer, :agent, last_payment: :payment_method)
      .page(params[:page])

    render json: PolicyBlueprint.render(
      policies,
      root: :policies,
      meta: pagination_meta(policies),
      include: params[:include]&.split(',')
    )
  end

  def create
    result = Policies::CreateOperation.call(
      user: current_user,
      params: policy_params
    )

    if result.success?
      render json: PolicyBlueprint.render(result.policy), status: :created
    else
      render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def policy_params
    params.require(:policy).permit(
      :type, :customer_id, :coverage_amount,
      details: [:start_date, :end_date, :premium],
      riders: []
    )
  end

  def search_params
    params.permit(:q, :status, :type, :date_from, :date_to, :sort, :order)
  end

  def validate_parameters!
    validator = PolicyParameterValidator.new(params)
    unless validator.valid?
      render json: { errors: validator.errors }, status: :bad_request
    end
  end
end
```

---

## 5. Views & Frontend Integration {#views-frontend}

### 5.1 Modern View Patterns with Hotwire
```ruby
# ViewComponent for reusable UI
class PolicyCardComponent < ViewComponent::Base
  with_collection_parameter :policy

  def initialize(policy:, show_actions: true, compact: false)
    @policy = policy
    @show_actions = show_actions
    @compact = compact
  end

  def status_badge
    tag.span(
      @policy.status.humanize,
      class: "badge badge-#{status_color}",
      data: { turbo_frame: dom_id(@policy, :status) }
    )
  end

  private

  def status_color
    case @policy.status
    when 'active' then 'success'
    when 'pending' then 'warning'
    when 'expired' then 'danger'
    else 'secondary'
    end
  end

  def render?
    @policy.visible_to?(Current.user)
  end
end
```

### 5.2 Stimulus Controllers for Interactivity
```javascript
// app/javascript/controllers/auto_complete_controller.js
import { Controller } from "@hotwired/stimulus"
import debounce from "lodash/debounce"

export default class extends Controller {
  static targets = ["input", "results", "hidden"]
  static values = {
    url: String,
    minChars: { type: Number, default: 2 },
    delay: { type: Number, default: 300 }
  }

  connect() {
    this.search = debounce(this.search.bind(this), this.delayValue)
    this.selectedIndex = -1
  }

  onInput() {
    const query = this.inputTarget.value

    if (query.length < this.minCharsValue) {
      this.hideResults()
      return
    }

    this.search(query)
  }

  async search(query) {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`, {
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": this.csrfToken
      }
    })

    if (response.ok) {
      const data = await response.json()
      this.showResults(data)
    }
  }

  showResults(items) {
    this.resultsTarget.innerHTML = items.map((item, index) => `
      <div class="autocomplete-item"
           data-action="click->auto-complete#select"
           data-index="${index}"
           data-value="${item.id}"
           data-label="${item.name}">
        ${this.highlightMatch(item.name, this.inputTarget.value)}
      </div>
    `).join('')

    this.resultsTarget.classList.remove('hidden')
  }

  select(event) {
    const item = event.currentTarget
    this.inputTarget.value = item.dataset.label
    this.hiddenTarget.value = item.dataset.value
    this.hideResults()

    // Dispatch custom event
    this.dispatch("selected", {
      detail: {
        value: item.dataset.value,
        label: item.dataset.label
      }
    })
  }

  hideResults() {
    this.resultsTarget.classList.add('hidden')
    this.selectedIndex = -1
  }

  // Keyboard navigation
  onKeydown(event) {
    const items = this.resultsTarget.querySelectorAll('.autocomplete-item')

    switch(event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.selectedIndex = Math.min(this.selectedIndex + 1, items.length - 1)
        this.highlightItem(items)
        break
      case 'ArrowUp':
        event.preventDefault()
        this.selectedIndex = Math.max(this.selectedIndex - 1, -1)
        this.highlightItem(items)
        break
      case 'Enter':
        event.preventDefault()
        if (this.selectedIndex >= 0) {
          items[this.selectedIndex].click()
        }
        break
      case 'Escape':
        this.hideResults()
        break
    }
  }

  highlightItem(items) {
    items.forEach((item, index) => {
      item.classList.toggle('highlighted', index === this.selectedIndex)
    })
  }

  highlightMatch(text, query) {
    const regex = new RegExp(`(${query})`, 'gi')
    return text.replace(regex, '<strong>$1</strong>')
  }

  get csrfToken() {
    return document.querySelector('[name="csrf-token"]').content
  }
}
```

### 5.3 Turbo Streams for Real-time Updates
```erb
<!-- app/views/policies/update.turbo_stream.erb -->
<%= turbo_stream.replace @policy do %>
  <%= render PolicyCardComponent.new(policy: @policy) %>
<% end %>

<%= turbo_stream.prepend "notifications" do %>
  <div class="alert alert-success" data-controller="alert">
    Policy <%= @policy.policy_number %> updated successfully
  </div>
<% end %>

<%= turbo_stream.update "policy_stats" do %>
  <%= render StatisticsComponent.new(user: current_user) %>
<% end %>
```

---

## 6. Authentication & Authorization {#auth}

### 6.1 Multi-Factor Authentication Implementation
```ruby
# Complete MFA implementation
class MfaService
  def initialize(user)
    @user = user
  end

  def enable_totp!
    secret = ROTP::Base32.random

    @user.create_mfa_setting!(
      totp_secret: encrypt(secret),
      backup_codes: generate_backup_codes,
      enabled_at: Time.current
    )

    generate_qr_code(secret)
  end

  def verify_totp(code)
    return false unless @user.mfa_enabled?

    totp = ROTP::TOTP.new(decrypt(@user.mfa_setting.totp_secret))

    # Allow drift for clock skew
    if totp.verify(code, drift_behind: 30, drift_ahead: 30)
      @user.mfa_setting.update!(
        last_used_at: Time.current,
        consecutive_failures: 0
      )
      true
    else
      handle_failed_attempt
      false
    end
  end

  def verify_backup_code(code)
    return false unless @user.mfa_enabled?

    hashed = Digest::SHA256.hexdigest(code)
    codes = @user.mfa_setting.backup_codes

    if codes.include?(hashed)
      codes.delete(hashed)
      @user.mfa_setting.update!(backup_codes: codes)

      # Alert user when backup codes are running low
      MfaMailer.backup_codes_low(@user).deliver_later if codes.size <= 2

      true
    else
      false
    end
  end

  private

  def generate_backup_codes
    10.times.map do
      code = SecureRandom.hex(4).scan(/.{4}/).join('-').upcase
      Digest::SHA256.hexdigest(code)
    end
  end

  def encrypt(text)
    Rails.application.message_verifier('mfa').generate(text)
  end

  def decrypt(encrypted_text)
    Rails.application.message_verifier('mfa').verify(encrypted_text)
  end

  def handle_failed_attempt
    setting = @user.mfa_setting
    setting.increment!(:consecutive_failures)

    if setting.consecutive_failures >= 5
      @user.lock_access!
      SecurityMailer.account_locked(@user).deliver_later
    end
  end
end
```

### 6.2 OAuth2 Provider Implementation
```ruby
# OAuth2 provider using Doorkeeper
class OAuth2Provider
  def self.configure
    Doorkeeper.configure do
      resource_owner_authenticator do
        current_user || redirect_to(new_user_session_path)
      end

      admin_authenticator do
        current_user&.admin? || redirect_to(new_user_session_path)
      end

      access_token_expires_in 2.hours
      use_refresh_token

      grant_flows %w[authorization_code client_credentials password]

      # Scopes
      default_scopes :read
      optional_scopes :write, :admin

      # Custom token response
      custom_access_token_response do |token|
        {
          access_token: token.token,
          token_type: 'Bearer',
          expires_in: token.expires_in,
          refresh_token: token.refresh_token,
          scope: token.scopes.to_s,
          created_at: token.created_at.to_i,
          user: UserSerializer.new(token.resource_owner).to_h
        }
      end

      # Token revocation
      revoke_token do |token|
        token.revoke
        TokenRevocationJob.perform_later(token)
      end
    end
  end
end
```

### 6.3 Advanced Authorization with Pundit
```ruby
# Policy classes for complex authorization
class PolicyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.agent?
        scope.where(agent_id: user.id)
          .or(scope.where(sub_agent_id: user.id))
      else
        scope.where(customer_id: user.customer.id)
      end
    end
  end

  def show?
    admin? || owner? || assigned_agent? || customer?
  end

  def update?
    return false if record.locked?
    admin? || (assigned_agent? && record.pending?)
  end

  def approve?
    admin? || (manager? && record.pending_approval?)
  end

  def cancel?
    return false if record.cancelled?
    admin? || (owner? && record.created_at > 24.hours.ago)
  end

  def view_sensitive_data?
    admin? || (assigned_agent? && user.has_permission?(:view_sensitive))
  end

  private

  def admin?
    user.role == 'admin'
  end

  def manager?
    user.role == 'manager'
  end

  def owner?
    record.user_id == user.id
  end

  def assigned_agent?
    record.agent_id == user.id || record.sub_agent_id == user.id
  end

  def customer?
    record.customer_id == user.customer&.id
  end
end
```

---

## 7. API Development {#api}

### 7.1 GraphQL with Advanced Features
```ruby
# app/graphql/types/policy_type.rb
module Types
  class PolicyType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false
    field :policy_number, String, null: false
    field :status, String, null: false
    field :premium, Types::MoneyType, null: false
    field :customer, Types::CustomerType, null: false
    field :payments, Types::PaymentType.connection_type, null: false

    # Custom resolver with dataloader
    field :total_paid, Types::MoneyType, null: false
    def total_paid
      BatchLoader::GraphQL.for(object.id).batch do |policy_ids, loader|
        payments = Payment.where(policy_id: policy_ids)
                         .group(:policy_id)
                         .sum(:amount)

        policy_ids.each do |id|
          loader.call(id, Money.new(payments[id] || 0))
        end
      end
    end

    # Field with authorization
    field :commission_details, Types::CommissionType, null: true
    def commission_details
      return nil unless context[:current_user].can?(:view_commissions, object)
      object.commission
    end

    # Subscription support
    field :status_changed, subscription: Subscriptions::PolicyStatusChanged
  end
end

# app/graphql/mutations/create_policy.rb
module Mutations
  class CreatePolicy < BaseMutation
    argument :input, Types::PolicyInput, required: true

    field :policy, Types::PolicyType, null: true
    field :errors, [Types::ErrorType], null: false

    def resolve(input:)
      authorize_user!

      result = Policies::CreateService.call(
        user: context[:current_user],
        attributes: input.to_h
      )

      if result.success?
        # Trigger subscription
        PolicySchema.subscriptions.trigger(
          'policyCreated',
          {},
          result.policy
        )

        { policy: result.policy, errors: [] }
      else
        { policy: nil, errors: format_errors(result.errors) }
      end
    end

    private

    def authorize_user!
      unless context[:current_user].can_create_policy?
        raise GraphQL::ExecutionError, "Unauthorized"
      end
    end
  end
end
```

### 7.2 RESTful API with JSON:API Spec
```ruby
# Using jsonapi-serializer
class PolicySerializer
  include JSONAPI::Serializer

  set_type :policy
  set_id :id

  attributes :policy_number, :status, :premium_amount, :start_date, :end_date

  attribute :premium do |policy|
    {
      amount: policy.premium_amount,
      currency: policy.premium_currency,
      formatted: policy.formatted_premium
    }
  end

  belongs_to :customer
  belongs_to :agent, serializer: UserSerializer
  has_many :payments
  has_many :documents

  # Conditional includes
  attribute :sensitive_info, if: Proc.new { |record, params|
    params[:current_user]&.can?(:view_sensitive, record)
  } do |policy|
    {
      ssn: policy.customer.ssn,
      income: policy.customer.annual_income
    }
  end

  # Links
  link :self do |policy|
    "/api/v1/policies/#{policy.id}"
  end

  link :approve, if: Proc.new { |policy| policy.pending? } do |policy|
    "/api/v1/policies/#{policy.id}/approve"
  end

  # Meta information
  meta do |policy|
    {
      created_at: policy.created_at,
      updated_at: policy.updated_at,
      version: policy.version_number
    }
  end
end
```

### 7.3 WebSocket API with ActionCable
```ruby
# Real-time notifications and updates
class PolicyChannel < ApplicationCable::Channel
  def subscribed
    if params[:policy_id].present?
      policy = Policy.find(params[:policy_id])

      if current_user.can?(:view, policy)
        stream_for policy
        transmit_current_state(policy)
      else
        reject
      end
    else
      # Stream all policies user has access to
      stream_from "policies:#{current_user.id}"
    end
  end

  def update_status(data)
    policy = Policy.find(data['policy_id'])

    if current_user.can?(:update, policy)
      result = Policies::UpdateStatusService.call(
        policy: policy,
        status: data['status'],
        user: current_user
      )

      if result.success?
        broadcast_update(policy)
      else
        transmit_error(result.errors)
      end
    else
      transmit_error(['Unauthorized'])
    end
  end

  private

  def transmit_current_state(policy)
    transmit({
      type: 'current_state',
      data: PolicySerializer.new(policy).to_h
    })
  end

  def broadcast_update(policy)
    PolicyChannel.broadcast_to(policy, {
      type: 'status_update',
      data: {
        id: policy.id,
        status: policy.status,
        updated_by: current_user.name,
        updated_at: policy.updated_at
      }
    })
  end
end
```

---

## 8. Testing Strategies {#testing}

### 8.1 Advanced RSpec Patterns
```ruby
# spec/support/shared_examples/api_endpoint.rb
RSpec.shared_examples "api endpoint" do |method, path|
  context "authentication" do
    it "returns 401 without auth token" do
      send(method, path)
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with invalid token" do
      headers = { 'Authorization': 'Bearer invalid' }
      send(method, path, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "rate limiting" do
    it "enforces rate limits" do
      100.times { send(method, path, headers: auth_headers) }
      send(method, path, headers: auth_headers)

      expect(response).to have_http_status(:too_many_requests)
      expect(response.headers['X-RateLimit-Remaining']).to eq('0')
    end
  end
end

# spec/services/policy_creation_service_spec.rb
RSpec.describe PolicyCreationService do
  let(:service) { described_class.new(user: user, params: params) }

  describe '#call' do
    subject(:result) { service.call }

    context 'with valid params' do
      let(:params) { attributes_for(:policy) }

      it 'creates policy' do
        expect { result }.to change(Policy, :count).by(1)
      end

      it 'returns success result' do
        expect(result).to be_success
        expect(result.policy).to be_persisted
      end

      it 'publishes creation event' do
        expect(EventBus).to receive(:publish)
          .with('policy.created', anything)

        result
      end

      it 'creates audit log' do
        expect { result }.to change(AuditLog, :count).by(1)
      end
    end

    context 'when external service fails' do
      before do
        allow(PremiumCalculator).to receive(:calculate)
          .and_raise(ExternalServiceError)
      end

      it 'retries 3 times' do
        expect(PremiumCalculator).to receive(:calculate)
          .exactly(3).times

        expect { result }.to raise_error(ExternalServiceError)
      end

      it 'logs failure' do
        expect(Rails.logger).to receive(:error)
          .with(/Premium calculation failed/)

        expect { result }.to raise_error(ExternalServiceError)
      end
    end
  end
end
```

### 8.2 Integration Testing
```ruby
# spec/integration/policy_workflow_spec.rb
RSpec.describe "Policy Workflow", type: :integration do
  fixtures :all

  describe "complete policy lifecycle" do
    let(:customer) { customers(:john_doe) }
    let(:agent) { users(:agent) }

    it "processes policy from creation to payment" do
      # Create policy
      policy = nil

      expect {
        policy = PolicyCreationService.call(
          user: agent,
          customer: customer,
          params: policy_params
        ).policy
      }.to change(Policy, :count).by(1)
       .and change(AuditLog, :count).by(1)

      expect(policy.status).to eq('pending')

      # Approve policy
      expect {
        PolicyApprovalService.call(
          policy: policy,
          approver: users(:manager)
        )
      }.to change { policy.reload.status }.to('approved')
       .and have_enqueued_job(PolicyApprovedNotificationJob)

      # Process payment
      payment = nil

      expect {
        payment = PaymentService.call(
          policy: policy,
          amount: policy.premium_amount,
          payment_method: payment_methods(:credit_card)
        ).payment
      }.to change(Payment, :count).by(1)

      expect(payment.status).to eq('completed')
      expect(policy.reload.status).to eq('active')

      # Verify commission distribution
      expect(Commission.where(policy: policy)).to exist
      expect(Commission.where(policy: policy).sum(:amount))
        .to eq(policy.total_commission)
    end
  end
end
```

### 8.3 Performance Testing
```ruby
# spec/performance/api_performance_spec.rb
RSpec.describe "API Performance", type: :performance do
  include RSpec::Benchmark::Matchers

  describe "GET /api/v1/policies" do
    before do
      create_list(:policy, 1000)
    end

    it "performs under 100ms" do
      expect {
        get "/api/v1/policies", headers: auth_headers
      }.to perform_under(100).ms
    end

    it "scales linearly" do
      expect {
        get "/api/v1/policies?limit=10", headers: auth_headers
      }.to perform_linear.in_range(10, 100, 1000)
    end

    it "doesn't increase memory significantly" do
      expect {
        get "/api/v1/policies", headers: auth_headers
      }.to perform_allocation(10_000).objects
    end
  end
end
```

---

## 9. Performance Optimization {#performance}

### 9.1 Database Query Optimization
```ruby
# Query optimization service
class QueryOptimizer
  # Use EXPLAIN to analyze queries
  def self.analyze(relation)
    sql = relation.to_sql
    result = ActiveRecord::Base.connection.execute("EXPLAIN ANALYZE #{sql}")

    parse_explain_output(result)
  end

  # Automatic index suggestions
  def self.suggest_indexes(model)
    suggestions = []

    # Foreign keys without indexes
    model.reflect_on_all_associations.each do |assoc|
      if assoc.macro == :belongs_to
        column = assoc.foreign_key
        unless index_exists?(model.table_name, column)
          suggestions << "add_index :#{model.table_name}, :#{column}"
        end
      end
    end

    # Frequently queried columns (from query logs)
    frequent_columns = analyze_query_logs(model.table_name)
    frequent_columns.each do |column|
      unless index_exists?(model.table_name, column)
        suggestions << "add_index :#{model.table_name}, :#{column}"
      end
    end

    suggestions
  end

  # Query result caching
  def self.cached_query(key, expires_in: 1.hour, &block)
    Rails.cache.fetch(key, expires_in: expires_in) do
      ActiveSupport::Notifications.instrument('cached_query.active_record', key: key) do
        block.call.to_a # Convert relation to array for caching
      end
    end
  end
end

# Usage in production
class PolicyReportService
  def monthly_summary(month)
    key = "policy_summary:#{month.strftime('%Y-%m')}"

    QueryOptimizer.cached_query(key, expires_in: 6.hours) do
      Policy
        .select(
          "DATE(created_at) as date",
          "COUNT(*) as count",
          "SUM(premium_amount) as total_premium",
          "AVG(coverage_amount) as avg_coverage"
        )
        .where(created_at: month.beginning_of_month..month.end_of_month)
        .group("DATE(created_at)")
    end
  end
end
```

### 9.2 Application-Level Caching
```ruby
# Multi-layer caching strategy
class CachingStrategy
  # Method-level caching with automatic invalidation
  module CacheableMethod
    def cache_method(method_name, expires_in: 1.hour)
      original_method = instance_method(method_name)

      define_method(method_name) do |*args|
        cache_key = "#{self.class.name}:#{id}:#{method_name}:#{args.hash}"

        Rails.cache.fetch(cache_key, expires_in: expires_in) do
          original_method.bind(self).call(*args)
        end
      end
    end
  end

  # Fragment caching with Russian Doll
  class SmartCacheKey
    def self.for(object, includes: [])
      base_key = object.cache_key_with_version

      includes.each do |association|
        assoc_records = object.send(association)
        if assoc_records.respond_to?(:maximum)
          timestamp = assoc_records.maximum(:updated_at)
          base_key += "-#{association}:#{timestamp.to_i}"
        end
      end

      base_key
    end
  end

  # Distributed caching with Redis
  class DistributedCache
    def self.fetch(key, options = {}, &block)
      value = Redis.current.get(key)

      if value.nil?
        value = block.call
        Redis.current.setex(
          key,
          options[:expires_in] || 3600,
          Marshal.dump(value)
        )
      else
        value = Marshal.load(value)
      end

      value
    end
  end
end
```

### 9.3 Background Job Optimization
```ruby
# Optimized background job processing
class OptimizedJob < ApplicationJob
  # Batch processing
  def perform_batch(ids)
    records = Model.where(id: ids).includes(:association)

    records.find_in_batches(batch_size: 100) do |batch|
      process_batch(batch)

      # Update progress
      progress = (processed_count.to_f / total_count * 100).round
      JobProgressTracker.update(job_id, progress)

      # Prevent memory bloat
      GC.start if processed_count % 1000 == 0
    end
  end

  # Parallel processing with thread pool
  def perform_parallel(items)
    pool = Concurrent::FixedThreadPool.new(4)

    items.each do |item|
      pool.post { process_item(item) }
    end

    pool.shutdown
    pool.wait_for_termination
  end

  # Memory-efficient CSV processing
  def process_large_csv(file_path)
    CSV.foreach(file_path, headers: true).lazy.each_slice(1000) do |rows|
      ActiveRecord::Base.transaction do
        records = rows.map { |row| build_record(row) }
        Model.import(records, validate: false)
      end

      # Allow other jobs to run
      sleep(0.1)
    end
  end
end
```

---

## 10. Security Best Practices {#security}

### 10.1 Input Validation and Sanitization
```ruby
# Comprehensive input validation
class SecurityValidator
  # SQL Injection Prevention
  def self.sanitize_sql_input(input)
    # Never use string interpolation
    # BAD: where("name = '#{input}'")
    # GOOD:
    ActiveRecord::Base.sanitize_sql_array(["name = ?", input])
  end

  # XSS Prevention
  def self.sanitize_html(html)
    ActionController::Base.helpers.sanitize(
      html,
      tags: %w[p br strong em a],
      attributes: %w[href title]
    )
  end

  # Command Injection Prevention
  def self.safe_system_call(command, *args)
    # Never use backticks or system() with string
    # BAD: `#{command} #{args.join(' ')}`
    # GOOD:
    Open3.capture3(command, *args)
  end

  # File Upload Validation
  def self.validate_file_upload(file)
    errors = []

    # Check file size
    if file.size > 10.megabytes
      errors << "File too large"
    end

    # Check file type (don't trust Content-Type)
    mime = Marcel::MimeType.for(file, name: file.original_filename)
    unless %w[image/jpeg image/png application/pdf].include?(mime)
      errors << "Invalid file type"
    end

    # Check for malicious content
    if contains_malicious_content?(file)
      errors << "File contains malicious content"
    end

    errors
  end

  private

  def self.contains_malicious_content?(file)
    # Scan with antivirus
    scanner = ClamScan::Client.new
    result = scanner.scan_file(file.path)
    result.infected?
  end
end
```

### 10.2 Authentication Security
```ruby
# Secure authentication implementation
class SecureAuthenticationService
  # Password requirements
  PASSWORD_REQUIREMENTS = {
    min_length: 12,
    require_uppercase: true,
    require_lowercase: true,
    require_numbers: true,
    require_special: true,
    check_common_passwords: true
  }.freeze

  def self.validate_password(password)
    errors = []

    errors << "Too short" if password.length < PASSWORD_REQUIREMENTS[:min_length]
    errors << "Must contain uppercase" unless password =~ /[A-Z]/
    errors << "Must contain lowercase" unless password =~ /[a-z]/
    errors << "Must contain numbers" unless password =~ /\d/
    errors << "Must contain special characters" unless password =~ /[!@#$%^&*]/

    if common_password?(password)
      errors << "Password is too common"
    end

    errors
  end

  # Secure session management
  def self.create_secure_session(user)
    session_id = SecureRandom.hex(32)

    # Store session with additional security info
    SessionStore.create!(
      session_id: Digest::SHA256.hexdigest(session_id),
      user_id: user.id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      created_at: Time.current,
      expires_at: 24.hours.from_now
    )

    # Set secure cookie
    {
      value: session_id,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict,
      expires: 24.hours.from_now
    }
  end

  # Rate limiting for authentication
  def self.check_rate_limit(identifier)
    key = "auth_attempts:#{identifier}"
    attempts = Redis.current.get(key).to_i

    if attempts >= 5
      lockout_time = Redis.current.ttl(key)
      raise TooManyAttemptsError, "Locked for #{lockout_time} seconds"
    end

    Redis.current.multi do |r|
      r.incr(key)
      r.expire(key, 15.minutes)
    end

    true
  end
end
```

### 10.3 API Security
```ruby
# API Security implementation
class ApiSecurity
  # API Key Management
  class ApiKeyManager
    def self.generate_key
      prefix = Rails.env.production? ? 'pk' : 'tk'
      key = SecureRandom.hex(32)

      # Store hashed version
      ApiKey.create!(
        key_id: "#{prefix}_#{SecureRandom.hex(8)}",
        hashed_key: Digest::SHA256.hexdigest(key),
        expires_at: 1.year.from_now
      )

      "#{prefix}_#{key}" # Return unhashed key only once
    end

    def self.validate_key(key)
      return false unless key =~ /^[pt]k_[a-f0-9]{64}$/

      hashed = Digest::SHA256.hexdigest(key.split('_', 2).last)
      api_key = ApiKey.find_by(hashed_key: hashed)

      return false unless api_key
      return false if api_key.expired?
      return false if api_key.revoked?

      api_key.update!(last_used_at: Time.current)
      true
    end
  end

  # Request signing for webhooks
  class WebhookSigner
    def self.sign_request(payload, secret)
      signature = OpenSSL::HMAC.hexdigest(
        'sha256',
        secret,
        payload
      )

      "sha256=#{signature}"
    end

    def self.verify_signature(payload, signature, secret)
      expected = sign_request(payload, secret)

      # Constant-time comparison to prevent timing attacks
      ActiveSupport::SecurityUtils.secure_compare(signature, expected)
    end
  end
end
```

---

## 11. Deployment & DevOps {#deployment}

### 11.1 Container Orchestration with Kubernetes
```yaml
# kubernetes/rails-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app
  labels:
    app: rails
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rails
  template:
    metadata:
      labels:
        app: rails
    spec:
      containers:
      - name: rails
        image: myapp:latest
        ports:
        - containerPort: 3000
        env:
        - name: RAILS_ENV
          value: production
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: rails-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: rails-secrets
              key: redis-url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
      - name: sidekiq
        image: myapp:latest
        command: ["bundle", "exec", "sidekiq"]
        env:
        - name: RAILS_ENV
          value: production
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
---
apiVersion: v1
kind: Service
metadata:
  name: rails-service
spec:
  selector:
    app: rails
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: LoadBalancer
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rails-hpa
spec:
  scalarRef:
    apiVersion: apps/v1
    kind: Deployment
    name: rails-app
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### 11.2 Infrastructure as Code with Terraform
```hcl
# terraform/rails_infrastructure.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "rails-vpc"
    Environment = var.environment
  }
}

# RDS Database
resource "aws_db_instance" "postgres" {
  identifier     = "rails-${var.environment}-db"
  engine         = "postgres"
  engine_version = "14.6"
  instance_class = var.db_instance_class

  allocated_storage     = 100
  storage_encrypted     = true
  storage_type          = "gp3"

  db_name  = "rails_production"
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Environment = var.environment
  }
}

# ElastiCache Redis
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "rails-${var.environment}-cache"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379

  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]

  tags = {
    Environment = var.environment
  }
}

# ECS Fargate Service
resource "aws_ecs_service" "rails" {
  name            = "rails-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.rails.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.rails.arn
    container_name   = "rails"
    container_port   = 3000
  }
}
```

### 11.3 CI/CD Pipeline
```yaml
# .github/workflows/production_deployment.yml
name: Production Deployment

on:
  push:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s

    steps:
      - uses: actions/checkout@v3

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true

      - name: Run tests
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost/test
        run: |
          bundle exec rails db:test:prepare
          bundle exec rspec --format documentation

      - name: Run security audit
        run: |
          bundle exec brakeman -q --no-pager
          bundle exec bundler-audit check --update

  build:
    needs: test
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v3

      - name: Log in to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          cache-from: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache
          cache-to: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Deploy to Kubernetes
        uses: azure/k8s-deploy@v4
        with:
          manifests: |
            kubernetes/deployment.yaml
            kubernetes/service.yaml
          images: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}

      - name: Run migrations
        run: |
          kubectl exec -it deployment/rails-app -- bundle exec rails db:migrate

      - name: Clear cache
        run: |
          kubectl exec -it deployment/rails-app -- bundle exec rails cache:clear

      - name: Health check
        run: |
          for i in {1..30}; do
            if curl -f https://api.example.com/health; then
              echo "Deployment successful"
              exit 0
            fi
            sleep 10
          done
          echo "Health check failed"
          exit 1
```

---

## 12. Advanced Topics {#advanced}

### 12.1 Event-Driven Architecture
```ruby
# Event sourcing implementation
module EventSourcing
  class Event < ApplicationRecord
    belongs_to :aggregate, polymorphic: true

    validates :event_type, presence: true
    validates :event_data, presence: true
    validates :event_version, presence: true

    before_create :set_event_id
    after_create :publish_event

    private

    def set_event_id
      self.event_id = SecureRandom.uuid
    end

    def publish_event
      EventBus.publish(self)
    end
  end

  class EventStore
    def self.store(aggregate, event_type, data)
      Event.create!(
        aggregate: aggregate,
        event_type: event_type,
        event_data: data,
        event_version: next_version(aggregate),
        occurred_at: Time.current
      )
    end

    def self.replay(aggregate_type, aggregate_id, until_version = nil)
      events = Event
        .where(aggregate_type: aggregate_type, aggregate_id: aggregate_id)
        .order(:event_version)

      events = events.where('event_version <= ?', until_version) if until_version

      aggregate = aggregate_type.constantize.new
      events.each { |event| aggregate.apply_event(event) }
      aggregate
    end

    private

    def self.next_version(aggregate)
      Event.where(aggregate: aggregate).maximum(:event_version).to_i + 1
    end
  end

  module Aggregate
    extend ActiveSupport::Concern

    included do
      attr_accessor :version, :uncommitted_events
    end

    def initialize
      @version = 0
      @uncommitted_events = []
    end

    def apply_event(event)
      method_name = "apply_#{event.event_type.underscore}"
      send(method_name, event.event_data) if respond_to?(method_name, true)
      @version = event.event_version
    end

    def record_event(event_type, data)
      event = EventStore.store(self, event_type, data)
      @uncommitted_events << event
      apply_event(event)
    end

    def commit!
      @uncommitted_events = []
    end
  end
end

# Usage example
class Order
  include EventSourcing::Aggregate

  attr_reader :id, :status, :items, :total

  def place(customer_id, items)
    record_event('OrderPlaced', {
      customer_id: customer_id,
      items: items,
      total: calculate_total(items)
    })
  end

  def ship(tracking_number)
    raise "Cannot ship #{status} order" unless status == 'placed'

    record_event('OrderShipped', {
      tracking_number: tracking_number,
      shipped_at: Time.current
    })
  end

  private

  def apply_order_placed(data)
    @id = SecureRandom.uuid
    @status = 'placed'
    @items = data['items']
    @total = data['total']
  end

  def apply_order_shipped(data)
    @status = 'shipped'
    @tracking_number = data['tracking_number']
    @shipped_at = data['shipped_at']
  end
end
```

### 12.2 CQRS Implementation
```ruby
# Command Query Responsibility Segregation
module CQRS
  # Command side
  module Commands
    class CreatePolicyCommand
      include ActiveModel::Model

      attr_accessor :customer_id, :coverage_amount, :premium, :start_date

      validates :customer_id, :coverage_amount, :premium, presence: true
      validate :future_start_date

      def execute
        return Result.failure(errors) unless valid?

        ActiveRecord::Base.transaction do
          policy = Policy.create!(attributes)

          # Publish event for read model update
          EventPublisher.publish('policy.created', policy.attributes)

          Result.success(policy)
        end
      rescue => e
        Result.failure(e.message)
      end

      private

      def future_start_date
        errors.add(:start_date, 'must be in future') if start_date < Date.current
      end
    end
  end

  # Query side with read models
  module Queries
    class PolicyReadModel < ApplicationRecord
      self.table_name = 'policy_read_models'

      # Denormalized for fast reads
      # customer_name, agent_name, total_paid, last_payment_date, etc.

      def self.rebuild_from_events
        Event.where(aggregate_type: 'Policy').find_each do |event|
          case event.event_type
          when 'PolicyCreated'
            create_read_model(event)
          when 'PolicyUpdated'
            update_read_model(event)
          when 'PaymentReceived'
            update_payment_info(event)
          end
        end
      end
    end

    class PolicyListQuery
      def self.execute(filters = {})
        query = PolicyReadModel.all

        query = query.where('customer_name LIKE ?', "%#{filters[:search]}%") if filters[:search]
        query = query.where(status: filters[:status]) if filters[:status]
        query = query.where('created_at >= ?', filters[:from_date]) if filters[:from_date]

        query.select(:id, :policy_number, :customer_name, :status, :premium, :total_paid)
              .order(created_at: :desc)
      end
    end
  end

  class Result
    attr_reader :value, :errors

    def self.success(value)
      new(true, value, nil)
    end

    def self.failure(errors)
      new(false, nil, errors)
    end

    def initialize(success, value, errors)
      @success = success
      @value = value
      @errors = errors
    end

    def success?
      @success
    end

    def failure?
      !@success
    end
  end
end
```

---

## 13. Top 100 Interview Questions with Detailed Answers {#interview}

### Basic Level (1-20)

**1. What is Rails and why use it?**
Rails is a full-stack MVC framework for building web applications. Benefits:
- Convention over configuration
- Built-in security features
- Active community
- Rapid development
- Rich ecosystem

**2. Explain MVC architecture**
```ruby
# Model - Business logic and data
class User < ApplicationRecord
  validates :email, presence: true
end

# View - Presentation layer
# app/views/users/show.html.erb
<h1><%= @user.name %></h1>

# Controller - Request handling
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
end
```

**3. What's the difference between `render` and `redirect_to`?**
- `render`: Shows a view template without new HTTP request
- `redirect_to`: Sends HTTP redirect (302), creates new request
- Instance variables persist with render, lost with redirect

**4. What are Strong Parameters?**
Protection against mass assignment:
```ruby
def user_params
  params.require(:user).permit(:name, :email, roles: [])
end
```

**5. Explain Rails callbacks**
Hooks into object lifecycle:
```ruby
before_save :normalize_email
after_create :send_welcome_email
around_update :log_changes
```

### Intermediate Level (21-50)

**21. How do you handle N+1 queries?**
```ruby
# Problem
User.all.each { |u| puts u.posts.count } # N+1

# Solutions
User.includes(:posts) # Eager loading
User.joins(:posts).group('users.id').count('posts.id') # SQL aggregation
User.counter_cache: true # Counter cache
```

**22. Explain database transactions**
```ruby
ActiveRecord::Base.transaction do
  user.save!
  account.save!
  # Both succeed or both rollback
end
```

**23. What's the difference between `includes`, `joins`, and `preload`?**
- `includes`: LEFT OUTER JOIN or separate queries
- `joins`: INNER JOIN, for filtering
- `preload`: Always separate queries
- `eager_load`: Always LEFT OUTER JOIN

**24. How do you implement caching?**
```ruby
# Fragment caching
<% cache @product do %>
  <%= render @product %>
<% end %>

# Query caching
Rails.cache.fetch("products", expires_in: 1.hour) do
  Product.expensive_query
end

# Method caching
def expensive_calculation
  @result ||= perform_calculation
end
```

### Advanced Level (51-100)

**75. How do you implement zero-downtime deployments?**
1. Use rolling deployments
2. Database migrations without locking
3. Feature flags for gradual rollout
4. Backwards compatible changes
5. Health checks and rollback strategy

**76. Explain optimistic vs pessimistic locking**
```ruby
# Optimistic - version column
product = Product.find(1)
product.stock -= 1
product.save! # Raises StaleObjectError if changed

# Pessimistic - database lock
Product.transaction do
  product = Product.lock.find(1)
  product.stock -= 1
  product.save!
end
```

**77. How do you debug performance issues?**
1. Use APM tools (New Relic, Scout)
2. Database query analysis (EXPLAIN)
3. Memory profiling
4. Bullet gem for N+1
5. rack-mini-profiler

**78. Implement rate limiting**
```ruby
class RateLimiter
  def self.allow?(key, limit: 100, period: 1.hour)
    count = Redis.current.incr(key)
    Redis.current.expire(key, period) if count == 1
    count <= limit
  end
end
```

**90. Design a multi-tenant application**
```ruby
# Schema-based
class ApplicationController < ActionController::Base
  before_action :set_tenant

  def set_tenant
    Apartment::Tenant.switch!(request.subdomain)
  end
end

# Row-based
class ApplicationRecord < ActiveRecord::Base
  belongs_to :tenant
  default_scope { where(tenant: Current.tenant) }
end
```

**100. What makes a Rails developer senior?**
- Understanding of Rails internals
- Performance optimization skills
- Security best practices
- System design capabilities
- Mentoring and code review skills
- Production debugging experience
- Knowledge of deployment and DevOps
- Ability to make architectural decisions

---

## Final Tips for Mastery

1. **Build Real Projects**: Theory without practice is useless
2. **Read Source Code**: Study Rails and popular gems
3. **Contribute to Open Source**: Best way to learn from experts
4. **Performance First**: Always think about scale
5. **Security Always**: Never compromise on security
6. **Test Everything**: TDD/BDD is not optional
7. **Stay Updated**: Rails evolves rapidly
8. **Join Communities**: RubyConf, RailsConf, local meetups
9. **Mentor Others**: Teaching solidifies learning
10. **Production Experience**: Real mastery comes from production issues

---

## Resources for Continuous Learning

### Must-Read Books
1. "The Rails 7 Way" - Obie Fernandez
2. "Agile Web Development with Rails 7" - Sam Ruby
3. "Rails AntiPatterns" - Chad Pytel
4. "Metaprogramming Ruby" - Paolo Perrotta
5. "Practical Object-Oriented Design" - Sandi Metz

### Online Resources
- [Rails Guides](https://guides.rubyonrails.org/) - Official documentation
- [RailsCasts](http://railscasts.com/) - Video tutorials (archive)
- [GoRails](https://gorails.com/) - Modern Rails tutorials
- [Drifting Ruby](https://www.driftingruby.com/) - Weekly screencasts
- [Ruby Weekly](https://rubyweekly.com/) - Newsletter

### Practice Platforms
- [Exercism](https://exercism.io/tracks/ruby) - Coding exercises
- [CodeWars](https://www.codewars.com/) - Challenges
- [RubyKoans](http://rubykoans.com/) - Learn by testing

### Communities
- [Reddit r/rails](https://reddit.com/r/rails)
- [Ruby on Rails Discord](https://discord.gg/rails)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/ruby-on-rails)
- [Ruby Forum](https://discuss.rubyonrails.org/)

---

*Remember: Mastery is a journey, not a destination. Keep learning, keep building, and keep pushing boundaries!*

**Last Updated**: January 2025
**Version**: 1.0.0

---

*This guide is a living document. Contribute improvements at [github.com/rails-mastery-guide]()*