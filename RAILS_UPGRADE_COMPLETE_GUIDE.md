# 🚀 Complete Rails Upgrade Guide - From 5.x to 7.2

## Table of Contents
1. [Overview & Strategy](#overview)
2. [Sample Application Setup](#sample-app)
3. [Rails 5.2 to 6.0 Upgrade](#rails-5-to-6)
4. [Rails 6.0 to 6.1 Upgrade](#rails-6-to-6-1)
5. [Rails 6.1 to 7.0 Upgrade](#rails-6-1-to-7)
6. [Rails 7.0 to 7.1 Upgrade](#rails-7-to-7-1)
7. [Rails 7.1 to 7.2 Upgrade](#rails-7-1-to-7-2)
8. [Version Features Deep Dive](#version-features)
9. [Troubleshooting Guide](#troubleshooting)
10. [Production Upgrade Checklist](#production-checklist)

---

## 1. Overview & Strategy {#overview}

### Why Upgrade Rails?

#### Security Benefits
- Critical security patches
- Vulnerability fixes
- Updated dependencies

#### Performance Improvements
- Better query performance
- Memory optimizations
- Faster boot times

#### New Features
- Modern JavaScript integration
- Better developer experience
- Enhanced testing tools

### Upgrade Strategy

#### 1. Incremental Approach
```bash
# DON'T: Jump from 5.2 directly to 7.2
# Rails 5.2 → 7.2 (❌ High risk)

# DO: Incremental upgrades
# Rails 5.2 → 6.0 → 6.1 → 7.0 → 7.1 → 7.2 (✅ Safe)
```

#### 2. Preparation Checklist
- [ ] Comprehensive test suite (90%+ coverage)
- [ ] Documentation of custom patches
- [ ] Gem compatibility audit
- [ ] Performance baseline metrics
- [ ] Staging environment setup
- [ ] Rollback plan

#### 3. Risk Assessment Matrix
```ruby
# High Risk Changes
- Major version jumps (5.x → 7.x)
- Custom engine modifications
- Heavy gem dependencies
- Complex asset pipeline setups

# Medium Risk Changes
- Minor version upgrades
- Standard gem updates
- Configuration changes

# Low Risk Changes
- Patch version updates
- Security fixes
- Documentation updates
```

---

## 2. Sample Application Setup {#sample-app}

Let's create a sample Rails 5.2 application that we'll upgrade through all versions.

### Creating the Sample App (Rails 5.2)

```bash
# Install specific Rails version
gem install rails -v 5.2.8.1

# Create sample application
rails _5.2.8.1_ new insurance_app --database=postgresql
cd insurance_app
```

### Sample Application Structure

```ruby
# Gemfile (Rails 5.2)
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 5.2.8'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'image_processing', '~> 1.2'

# Business logic gems
gem 'devise', '~> 4.7'
gem 'pundit', '~> 2.1'
gem 'kaminari', '~> 1.2'
gem 'ransack', '~> 2.3'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0'
  gem 'factory_bot_rails', '~> 6.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
```

### Sample Models and Controllers

```ruby
# app/models/policy.rb (Rails 5.2 style)
class Policy < ApplicationRecord
  belongs_to :customer
  belongs_to :agent, class_name: 'User'

  has_many :payments, dependent: :destroy
  has_many :claims, dependent: :destroy

  validates :policy_number, presence: true, uniqueness: true
  validates :premium_amount, presence: true, numericality: { greater_than: 0 }

  enum status: { draft: 0, active: 1, expired: 2, cancelled: 3 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_agent, ->(agent_id) { where(agent_id: agent_id) }

  # Rails 5.2 style callbacks
  before_save :calculate_commission
  after_create :send_notification

  private

  def calculate_commission
    self.commission_amount = premium_amount * 0.10
  end

  def send_notification
    PolicyMailer.policy_created(self).deliver_now
  end
end
```

```ruby
# app/controllers/policies_controller.rb (Rails 5.2 style)
class PoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  def index
    @q = Policy.ransack(params[:q])
    @policies = @q.result(distinct: true)
                  .includes(:customer, :agent)
                  .page(params[:page])
                  .per(10)
  end

  def create
    @policy = current_user.policies.build(policy_params)

    if @policy.save
      redirect_to @policy, notice: 'Policy was successfully created.'
    else
      render :new
    end
  end

  private

  def set_policy
    @policy = Policy.find(params[:id])
  end

  def policy_params
    params.require(:policy).permit(:policy_number, :customer_id, :premium_amount, :status)
  end
end
```

```ruby
# config/application.rb (Rails 5.2)
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 5.2

    # Custom configuration
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :utc

    # Asset pipeline configuration
    config.assets.precompile += %w( admin.js admin.css )
  end
end
```

---

## 3. Rails 5.2 to 6.0 Upgrade {#rails-5-to-6}

### Step 1: Update Ruby Version

```bash
# Update Ruby from 2.7 to 3.0 (minimum for Rails 6)
echo "3.0.0" > .ruby-version
rbenv install 3.0.0
rbenv local 3.0.0
```

### Step 2: Update Gemfile

```ruby
# Gemfile updates for Rails 6.0
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.0.6'  # Updated
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'     # Updated
gem 'sass-rails', '>= 6' # Updated
gem 'webpacker', '~> 4.0' # NEW - replaces uglifier/coffee-rails
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

# Remove these (replaced by Webpacker)
# gem 'uglifier'
# gem 'coffee-rails'

# Updated gem versions
gem 'devise', '~> 4.8'
gem 'pundit', '~> 2.2'
gem 'kaminari', '~> 1.2'
gem 'ransack', '~> 2.4'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0'
  gem 'factory_bot_rails', '~> 6.2'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
```

### Step 3: Run Rails Update Commands

```bash
# Update Rails
bundle update rails

# Run Rails update generator
rails app:update

# This will prompt you to review and update:
# - config/application.rb
# - config/environments/*.rb
# - config/initializers/*.rb
# - config/locales/en.yml
```

### Step 4: Update Configuration Files

```ruby
# config/application.rb (Rails 6.0)
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 6.0  # Updated

    # Configuration for the application
    config.time_zone = 'Eastern Time (US & Canada)'

    # Rails 6 new configurations
    config.autoloader = :zeitwerk  # NEW: Zeitwerk autoloader
  end
end
```

```ruby
# config/environments/development.rb (Rails 6.0 additions)
Rails.application.configure do
  # Existing configurations...

  # NEW Rails 6 configurations
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Webpacker configurations
  config.webpacker.check_yarn_integrity = false
end
```

### Step 5: Webpacker Setup

```bash
# Install Webpacker
rails webpacker:install

# This creates:
# - app/javascript/ directory
# - config/webpack/ directory
# - config/webpacker.yml
# - yarn.lock and package.json
```

```javascript
// app/javascript/packs/application.js (NEW)
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Custom JavaScript
import "../stylesheets/application"
import "../scripts/policies"
```

### Step 6: Update Models for Rails 6

```ruby
# app/models/policy.rb (Rails 6 updates)
class Policy < ApplicationRecord
  belongs_to :customer
  belongs_to :agent, class_name: 'User'

  has_many :payments, dependent: :destroy
  has_many :claims, dependent: :destroy

  validates :policy_number, presence: true, uniqueness: true
  validates :premium_amount, presence: true, numericality: { greater_than: 0 }

  enum status: { draft: 0, active: 1, expired: 2, cancelled: 3 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_agent, ->(agent_id) { where(agent_id: agent_id) }

  # Rails 6: Use after_create_commit for better performance
  after_create_commit :send_notification
  before_save :calculate_commission

  private

  def calculate_commission
    self.commission_amount = premium_amount * 0.10
  end

  def send_notification
    # Rails 6: Use deliver_later by default
    PolicyMailer.policy_created(self).deliver_later
  end
end
```

### Step 7: Update Views for Webpacker

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>Insurance App</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <!-- Rails 6: Webpacker tags -->
    <%= stylesheet_link_tag 'application', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

### Step 8: Database Migration and Testing

```bash
# Run existing migrations
rails db:migrate

# Run tests to ensure everything works
bundle exec rspec

# Check deprecation warnings
RAILS_DISABLE_DEPRECATED_TO_S_CONVERSION=true rails server
```

### Rails 6.0 New Features Implemented

#### 1. Action Mailbox (for incoming emails)
```ruby
# Generate mailbox
rails generate mailbox policy_updates

# app/mailboxes/policy_updates_mailbox.rb
class PolicyUpdatesMailbox < ApplicationMailbox
  before_processing :ensure_from_insurance_company

  def process
    policy = Policy.find_by(policy_number: extract_policy_number)

    if policy
      policy.update_from_email(mail)
    end
  end

  private

  def ensure_from_insurance_company
    unless mail.from.include?("@insurancecompany.com")
      bounce_with PolicyUpdateMailer.invalid_sender(inbound_email)
    end
  end
end
```

#### 2. Action Text (Rich Text Content)
```ruby
# Add Action Text to Policy model
rails action_text:install
rails generate migration AddActionTextToPolicy

# app/models/policy.rb
class Policy < ApplicationRecord
  has_rich_text :description  # NEW Rails 6 feature
  has_rich_text :notes
end
```

#### 3. Parallel Testing
```ruby
# test/test_helper.rb
class ActiveSupport::TestCase
  # Rails 6: Enable parallel testing
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do |worker|
    SimpleCov.result
  end
end
```

---

## 4. Rails 6.0 to 6.1 Upgrade {#rails-6-to-6-1}

### Step 1: Update Gemfile for Rails 6.1

```ruby
# Gemfile for Rails 6.1
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 6.1.7'  # Updated to 6.1
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'      # Updated
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0' # Updated
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false

# Rails 6.1 specific gems
gem 'image_processing', '~> 1.2'

gem 'devise', '~> 4.8'
gem 'pundit', '~> 2.2'
```

### Step 2: Run Rails Update for 6.1

```bash
bundle update rails
rails app:update
```

### Step 3: Update Configuration for Rails 6.1

```ruby
# config/application.rb (Rails 6.1)
require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 6.1  # Updated to 6.1

    # Rails 6.1 new configuration options
    config.autoloader = :zeitwerk

    # Active Storage configurations
    config.active_storage.variant_processor = :mini_magick
  end
end
```

### Step 4: Implement Rails 6.1 New Features

#### 1. Horizontal Sharding Support
```ruby
# config/database.yml (Rails 6.1 - Multiple databases)
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  primary:
    <<: *default
    database: insurance_app_development

  # Rails 6.1: Database sharding
  shard_one:
    <<: *default
    database: insurance_app_shard_1_development

  shard_two:
    <<: *default
    database: insurance_app_shard_2_development
```

```ruby
# app/models/application_record.rb (Rails 6.1 sharding)
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Rails 6.1: Connect to specific shards
  connects_to shards: {
    default: { writing: :primary, reading: :primary },
    shard_one: { writing: :shard_one, reading: :shard_one },
    shard_two: { writing: :shard_two, reading: :shard_two }
  }
end

# Usage in models
class Policy < ApplicationRecord
  # Policies for customers 1-1000 go to shard_one
  # Policies for customers 1001-2000 go to shard_two

  def self.find_by_customer(customer_id)
    if customer_id <= 1000
      connected_to(shard: :shard_one) { find_by(customer_id: customer_id) }
    else
      connected_to(shard: :shard_two) { find_by(customer_id: customer_id) }
    end
  end
end
```

#### 2. Delegated Types (Alternative to STI)
```ruby
# Rails 6.1: Delegated types for policy types
class Policy < ApplicationRecord
  delegated_type :policy_type, types: %w[ HealthInsurance LifeInsurance AutoInsurance ]

  delegate :premium_calculation, to: :policy_type
end

class HealthInsurance < ApplicationRecord
  include PolicyType

  validates :medical_history, presence: true

  def premium_calculation
    base_amount * health_risk_factor
  end
end

class LifeInsurance < ApplicationRecord
  include PolicyType

  validates :beneficiary, presence: true

  def premium_calculation
    base_amount * age_factor * lifestyle_factor
  end
end

# Migration for delegated types
class CreatePolicyTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :health_insurances do |t|
      t.belongs_to :policy, null: false, foreign_key: true
      t.text :medical_history
      t.decimal :health_risk_factor, default: 1.0
      t.timestamps
    end

    create_table :life_insurances do |t|
      t.belongs_to :policy, null: false, foreign_key: true
      t.string :beneficiary
      t.decimal :age_factor, default: 1.0
      t.decimal :lifestyle_factor, default: 1.0
      t.timestamps
    end
  end
end
```

#### 3. Strict Loading to Prevent N+1
```ruby
# app/models/policy.rb (Rails 6.1)
class Policy < ApplicationRecord
  belongs_to :customer
  belongs_to :agent, class_name: 'User'

  # Rails 6.1: Strict loading to catch N+1 queries
  def self.with_strict_loading
    strict_loading.includes(:customer, :agent, :payments)
  end
end

# Usage
policies = Policy.with_strict_loading
policies.each do |policy|
  puts policy.customer.name    # OK - preloaded
  puts policy.claims.count     # Raises ActiveRecord::StrictLoadingViolationError
end
```

#### 4. Destroy Associations in Background
```ruby
# app/models/customer.rb (Rails 6.1)
class Customer < ApplicationRecord
  has_many :policies, dependent: :destroy_async  # Rails 6.1 feature

  # When customer is deleted, policies are destroyed in background job
end
```

#### 5. Where.not with Multiple Attributes
```ruby
# Rails 6.1: Enhanced where.not
# Find policies that are not (draft and created today)
Policy.where.not(status: 'draft', created_at: Date.current.all_day)

# Find policies not belonging to specific agents
Policy.where.not(agent_id: [1, 2, 3])
```

---

## 5. Rails 6.1 to 7.0 Upgrade {#rails-6-1-to-7}

### Step 1: Update Ruby to 3.1

```bash
echo "3.1.0" > .ruby-version
rbenv install 3.1.0
rbenv local 3.1.0
```

### Step 2: Update Gemfile for Rails 7.0

```ruby
# Gemfile for Rails 7.0
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 7.0.8'  # Major upgrade to 7.0
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'

# Rails 7: Remove webpacker, add importmap + turbo
gem 'importmap-rails'     # NEW: Replace Webpacker
gem 'turbo-rails'         # NEW: Hotwire Turbo
gem 'stimulus-rails'      # NEW: Hotwire Stimulus
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'sprockets-rails'     # NEW: Required for Rails 7

gem 'image_processing', '~> 1.2'

# Updated gems
gem 'devise', '~> 4.9'
gem 'pundit', '~> 2.3'
```

### Step 3: Install Hotwire (Turbo + Stimulus)

```bash
# Remove Webpacker
yarn remove @rails/webpacker
rm -rf app/javascript
rm -rf config/webpack
rm package.json yarn.lock

# Install new Rails 7 JavaScript approach
rails importmap:install
rails turbo:install
rails stimulus:install
```

### Step 4: Update Configuration for Rails 7.0

```ruby
# config/application.rb (Rails 7.0)
require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 7.0  # Updated to 7.0

    # Rails 7 configurations
    config.autoloader = :zeitwerk
    config.active_storage.variant_processor = :mini_magick

    # Rails 7: New configurations
    config.active_support.cache_format_version = 7.0
    config.action_dispatch.cookies_serializer = :json
  end
end
```

### Step 5: Convert JavaScript to Hotwire

```javascript
// app/javascript/application.js (Rails 7)
import "@hotwired/turbo-rails"
import "./controllers"

// Import custom modules
import "./policies"
import "./customers"
```

```javascript
// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.debug = false
window.Stimulus = application

export { application }
```

```javascript
// app/javascript/controllers/policy_controller.js (Stimulus)
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "premium"]
  static values = {
    policyId: Number,
    agentCommission: Number
  }

  connect() {
    console.log("Policy controller connected", this.policyIdValue)
  }

  updateStatus(event) {
    const newStatus = event.target.value
    this.statusTarget.textContent = newStatus

    // Use Rails 7 Turbo for AJAX
    fetch(`/policies/${this.policyIdValue}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ policy: { status: newStatus } })
    })
  }

  calculatePremium() {
    const baseAmount = parseFloat(this.premiumTarget.value)
    const commission = baseAmount * (this.agentCommissionValue / 100)

    // Update UI with Turbo Stream
    this.dispatch("premium-calculated", {
      detail: { premium: baseAmount, commission: commission }
    })
  }
}
```

### Step 6: Update Views for Turbo

```erb
<!-- app/views/layouts/application.html.erb (Rails 7) -->
<!DOCTYPE html>
<html>
  <head>
    <title>Insurance App</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <!-- Rails 7: Importmap instead of Webpacker -->
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

```erb
<!-- app/views/policies/index.html.erb (Rails 7 with Turbo) -->
<div id="policies" data-controller="policy-list">
  <h1>Policies</h1>

  <!-- Turbo Frame for dynamic updates -->
  <%= turbo_frame_tag "policy_search" do %>
    <%= form_with url: policies_path, method: :get, local: false, data: { turbo_frame: "policies" } do |form| %>
      <%= form.text_field :search, placeholder: "Search policies...",
                         data: { action: "input->policy-list#search" } %>
    <% end %>
  <% end %>

  <%= turbo_frame_tag "policies" do %>
    <% @policies.each do |policy| %>
      <div class="policy-card"
           data-controller="policy"
           data-policy-policy-id-value="<%= policy.id %>"
           data-policy-agent-commission-value="<%= policy.agent_commission_percentage %>">

        <h3><%= link_to policy.policy_number, policy %></h3>
        <p>Status: <span data-policy-target="status"><%= policy.status %></span></p>
        <p>Premium: $<span data-policy-target="premium"><%= policy.premium_amount %></span></p>

        <!-- Inline editing with Turbo -->
        <%= button_to "Quick Edit", edit_policy_path(policy),
                     method: :get,
                     form: { data: { turbo_frame: "policy_#{policy.id}_edit" } } %>
      </div>
    <% end %>
  <% end %>
</div>
```

### Step 7: Update Models for Rails 7

```ruby
# app/models/policy.rb (Rails 7)
class Policy < ApplicationRecord
  belongs_to :customer
  belongs_to :agent, class_name: 'User'

  has_many :payments, dependent: :destroy
  has_many :claims, dependent: :destroy

  # Rails 7: Enhanced enums with prefix/suffix
  enum status: {
    draft: 0,
    active: 1,
    expired: 2,
    cancelled: 3
  }, _prefix: :status

  enum policy_type: {
    health: 0,
    life: 1,
    auto: 2
  }, _suffix: :insurance

  # Rails 7: New validation helpers
  validates :policy_number, presence: true, uniqueness: true
  validates :premium_amount,
    presence: true,
    numericality: { greater_than: 0, less_than: 1_000_000 },
    comparison: { greater_than: :minimum_premium }

  validates :start_date,
    presence: true,
    comparison: { greater_than: Date.current }

  # Rails 7: Query improvements
  scope :recent, -> { order(created_at: :desc) }
  scope :by_agent, ->(agent_id) { where(agent_id: agent_id) }
  scope :expiring_soon, -> { where(end_date: ..30.days.from_now) }
  scope :high_value, -> { where(premium_amount: 50_000..) }

  # Rails 7: Broadcast updates with Turbo
  after_create_commit -> { broadcast_prepend_to "policies", partial: "policies/policy" }
  after_update_commit -> { broadcast_replace_to "policies" }
  after_destroy_commit -> { broadcast_remove_to "policies" }

  private

  def minimum_premium
    case policy_type
    when 'health' then 1_000
    when 'life' then 5_000
    when 'auto' then 800
    else 500
    end
  end
end
```

### Step 8: Update Controllers for Rails 7

```ruby
# app/controllers/policies_controller.rb (Rails 7)
class PoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  # Rails 7: In place of format.js, use Turbo Stream
  def index
    @q = Policy.ransack(params[:q])
    @policies = @q.result(distinct: true)
                  .includes(:customer, :agent)
                  .page(params[:page])
  end

  def create
    @policy = current_user.policies.build(policy_params)

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy created successfully.' }
        format.turbo_stream { flash.now[:notice] = 'Policy created!' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('policy_form', partial: 'form', locals: { policy: @policy }) }
      end
    end
  end

  def update
    respond_to do |format|
      if @policy.update(policy_params)
        format.html { redirect_to @policy, notice: 'Policy updated successfully.' }
        format.turbo_stream { flash.now[:notice] = 'Policy updated!' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('policy_form', partial: 'form', locals: { policy: @policy }) }
      end
    end
  end

  private

  def set_policy
    @policy = Policy.find(params[:id])
  end

  def policy_params
    params.require(:policy).permit(:policy_number, :customer_id, :premium_amount, :status, :policy_type)
  end
end
```

### Rails 7.0 Major New Features Implemented

#### 1. ActionController::Live for Real-time Updates
```ruby
# app/controllers/policy_updates_controller.rb
class PolicyUpdatesController < ApplicationController
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/plain'

    Policy.find(params[:policy_id]).tap do |policy|
      loop do
        response.stream.write "Policy #{policy.policy_number} status: #{policy.reload.status}\n"
        sleep 5
      end
    end
  ensure
    response.stream.close
  end
end
```

#### 2. Encrypted Attributes
```ruby
# app/models/customer.rb (Rails 7)
class Customer < ApplicationRecord
  # Rails 7: Encrypted attributes
  encrypts :ssn
  encrypts :bank_account, deterministic: true  # For searching
  encrypts :medical_records, ignore_case: true

  has_many :policies, dependent: :destroy_async

  validates :email, presence: true, uniqueness: true
end
```

---

## 6. Rails 7.0 to 7.1 Upgrade {#rails-7-to-7-1}

### Step 1: Update Gemfile for Rails 7.1

```ruby
# Gemfile for Rails 7.1
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'  # Updated Ruby version

gem 'rails', '~> 7.1.3'  # Updated to 7.1
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'sprockets-rails'
gem 'bootsnap', require: false

# Rails 7.1 compatible gems
gem 'image_processing', '~> 1.2'
gem 'redis', '>= 4.0.1'

gem 'devise', '~> 4.9'
gem 'pundit', '~> 2.3'
```

### Step 2: Run Rails Update for 7.1

```bash
bundle update rails
rails app:update
```

### Step 3: Update Configuration for Rails 7.1

```ruby
# config/application.rb (Rails 7.1)
require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 7.1  # Updated to 7.1

    # Rails 7.1: New configuration options
    config.active_job.use_big_decimal_serializer = true
    config.action_controller.raise_on_open_redirects = true
    config.active_record.run_commit_callbacks_on_first_saved_instances_in_transaction = false
  end
end
```

### Rails 7.1 New Features Implementation

#### 1. Composite Primary Keys
```ruby
# Rails 7.1: Composite primary keys
class PolicyCoverage < ApplicationRecord
  # Migration for composite primary key
  # create_table :policy_coverages, primary_key: [:policy_id, :coverage_type] do |t|
  #   t.integer :policy_id
  #   t.string :coverage_type
  #   t.decimal :coverage_amount
  # end

  self.primary_key = [:policy_id, :coverage_type]

  belongs_to :policy
end

# Usage
coverage = PolicyCoverage.find([123, 'health'])
```

#### 2. Generated Columns
```ruby
# Rails 7.1: Database generated columns
class CreatePoliciesWithGeneratedColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :policies do |t|
      t.string :policy_number
      t.decimal :base_premium, precision: 10, scale: 2
      t.decimal :tax_rate, precision: 5, scale: 4, default: 0.18

      # Generated column for total premium
      t.virtual :total_premium,
        type: :decimal,
        as: 'base_premium * (1 + tax_rate)',
        stored: true

      t.timestamps
    end

    add_index :policies, :total_premium
  end
end
```

#### 3. Async Queries
```ruby
# Rails 7.1: Asynchronous queries
class PoliciesController < ApplicationController
  def dashboard
    # Start async queries
    @policies_count = Policy.async_count
    @total_premium = Policy.async_sum(:premium_amount)
    @recent_policies = Policy.recent.limit(10).load_async

    # These will execute in parallel
    @active_policies_count = Policy.status_active.async_count
    @expiring_soon = Policy.expiring_soon.load_async

    # Results are available when accessed in view
  end
end
```

#### 4. Normalizes Declaration
```ruby
# Rails 7.1: Attribute normalization
class Customer < ApplicationRecord
  # Automatically normalize phone numbers
  normalizes :phone, with: -> phone {
    phone.gsub(/\D/, '').gsub(/\A1/, '') if phone
  }

  # Normalize email to lowercase
  normalizes :email, with: -> email { email.strip.downcase }

  # Normalize names
  normalizes :first_name, :last_name, with: -> name {
    name.strip.titleize if name
  }
end
```

#### 5. Exclude Clause Support
```ruby
# Rails 7.1: EXCLUDE clause for constraints
class CreateExclusiveTimeSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :agent_schedules do |t|
      t.references :agent, null: false
      t.tsrange :time_slot
      t.timestamps
    end

    # PostgreSQL EXCLUDE constraint
    execute <<-SQL
      ALTER TABLE agent_schedules
      ADD CONSTRAINT no_overlapping_schedules
      EXCLUDE USING gist (agent_id WITH =, time_slot WITH &&)
    SQL
  end
end
```

#### 6. ActiveRecord::Base.normalizes
```ruby
# app/models/policy.rb (Rails 7.1)
class Policy < ApplicationRecord
  # Rails 7.1: Built-in normalization
  normalizes :policy_number, with: -> value { value.upcase.strip }
  normalizes :status, with: -> value { value.downcase }

  # Conditional normalization
  normalizes :notes, with: -> value {
    ActionController::Base.helpers.strip_tags(value) if value
  }

  validates :policy_number, presence: true, format: { with: /\A[A-Z0-9-]+\z/ }
end
```

---

## 7. Rails 7.1 to 7.2 Upgrade {#rails-7-1-to-7-2}

### Step 1: Update Ruby to 3.3

```bash
echo "3.3.0" > .ruby-version
rbenv install 3.3.0
rbenv local 3.3.0
```

### Step 2: Update Gemfile for Rails 7.2

```ruby
# Gemfile for Rails 7.2
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

gem 'rails', '~> 7.2.1'  # Latest Rails 7.2
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'sprockets-rails'
gem 'bootsnap', require: false
gem 'kamal', require: false  # NEW: Rails 7.2 deployment tool

# Rails 7.2 optimizations
gem 'image_processing', '~> 1.2'
gem 'redis', '>= 4.0.1'

gem 'devise', '~> 4.9'
gem 'pundit', '~> 2.3'
```

### Step 3: Rails 7.2 Configuration Updates

```ruby
# config/application.rb (Rails 7.2)
require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module InsuranceApp
  class Application < Rails::Application
    config.load_defaults 7.2  # Rails 7.2

    # Rails 7.2: Dev container support
    config.assume_ssl = true if Rails.env.production?

    # Rails 7.2: Enhanced security defaults
    config.force_ssl = true if Rails.env.production?
  end
end
```

### Rails 7.2 New Features Implementation

#### 1. Development Containers Support
```yaml
# .devcontainer/devcontainer.json (Rails 7.2)
{
  "name": "Rails Insurance App",
  "dockerComposeFile": "docker-compose.yml",
  "service": "web",
  "workspaceFolder": "/workspace",
  "features": {
    "ghcr.io/devcontainers/features/ruby:1": {
      "version": "3.3"
    },
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    }
  },
  "postCreateCommand": "bundle install",
  "customizations": {
    "vscode": {
      "extensions": [
        "rebornix.ruby",
        "ms-vscode.vscode-json"
      ]
    }
  }
}
```

#### 2. Progressive Web App (PWA) Support
```ruby
# Rails 7.2: Built-in PWA generator
rails generate pwa

# This creates:
# app/views/pwa/manifest.json.erb
# app/views/pwa/service-worker.js
# config/routes.rb additions
```

```erb
<!-- app/views/pwa/manifest.json.erb -->
{
  "name": "Insurance App",
  "short_name": "InsuranceApp",
  "description": "Manage your insurance policies",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#000000",
  "icons": [
    {
      "src": "<%= asset_path 'icon-192.png' %>",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "<%= asset_path 'icon-512.png' %>",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

#### 3. Enhanced Database Features
```ruby
# Rails 7.2: Improved database features
class Policy < ApplicationRecord
  # Rails 7.2: Better enum handling
  enum :status, %w[draft active expired cancelled].index_by(&:to_sym), validate: true
  enum :priority, { low: 1, medium: 2, high: 3, critical: 4 }, validate: { allow_nil: true }

  # Rails 7.2: Enhanced query methods
  scope :high_priority_active, -> { active.where(priority: :high..) }

  # Rails 7.2: Better batch processing
  def self.process_renewals_in_batches
    in_batches(of: 1000, order: :asc) do |batch|
      batch.where(status: :active, end_date: ..30.days.from_now).each(&:process_renewal)
    end
  end
end
```

#### 4. Kamal Deployment Configuration
```yaml
# config/deploy.yml (Rails 7.2 - Kamal)
service: insurance-app

image: insurance-app

servers:
  web:
    hosts:
      - 192.168.1.1
      - 192.168.1.2
    labels:
      traefik.http.routers.insurance-app.rule: Host(`insurance.example.com`)
      traefik.http.routers.insurance-app.tls.certresolver: letsencrypt

  job:
    hosts:
      - 192.168.1.3
    cmd: bundle exec sidekiq

registry:
  server: registry.digitalocean.com
  username:
    - DOCKER_REGISTRY_TOKEN

env:
  clear:
    PORT: 3000
  secret:
    - RAILS_MASTER_KEY

volumes:
  - "storage_volume:/rails/storage"

accessories:
  db:
    image: postgres:15
    host: 192.168.1.4
    env:
      secret:
        - POSTGRES_PASSWORD
    volumes:
      - /var/lib/postgresql/data:/var/lib/postgresql/data

  redis:
    image: redis:7.0
    host: 192.168.1.5
    volumes:
      - /var/lib/redis:/data
```

#### 5. Enhanced Performance Monitoring
```ruby
# Rails 7.2: Built-in performance monitoring
class ApplicationController < ActionController::Base
  # Rails 7.2: Enhanced instrumentation
  around_action :track_performance, if: -> { Rails.env.production? }

  private

  def track_performance
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    yield

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    duration = ((end_time - start_time) * 1000).round(2)

    Rails.logger.info "#{controller_name}##{action_name} completed in #{duration}ms"

    # Rails 7.2: Enhanced metrics
    ActiveSupport::Notifications.instrument('controller.performance') do |payload|
      payload[:controller] = controller_name
      payload[:action] = action_name
      payload[:duration] = duration
    end
  end
end
```

---

## 8. Version Features Deep Dive {#version-features}

### Rails 5.2 Key Features

#### Active Storage
```ruby
# File uploads without external gems
class Policy < ApplicationRecord
  has_one_attached :document
  has_many_attached :supporting_documents

  validate :document_type_validation

  private

  def document_type_validation
    return unless document.attached?

    unless document.blob.content_type.in?(%w[application/pdf image/jpeg image/png])
      errors.add(:document, 'Must be a PDF or image file')
    end
  end
end
```

#### Redis Cache Store
```ruby
# config/environments/production.rb
Rails.application.configure do
  config.cache_store = :redis_cache_store, {
    url: ENV['REDIS_URL'],
    connect_timeout: 30,
    read_timeout: 0.2,
    write_timeout: 0.2,
    reconnect_attempts: 1,
  }
end
```

### Rails 6.0 Revolutionary Features

#### Zeitwerk Autoloader
```ruby
# Zeitwerk follows file naming conventions strictly
# app/models/insurance_policy.rb → InsurancePolicy
# app/services/policy_calculation_service.rb → PolicyCalculationService

# Custom inflections
# config/initializers/zeitwerk.rb
Rails.autoloaders.main.inflector.inflect(
  "html_parser" => "HTMLParser",
  "json_api" => "JSONAPI"
)
```

#### Multiple Databases
```ruby
# config/database.yml
production:
  primary:
    <<: *default
    database: insurance_primary

  analytics:
    <<: *default
    database: insurance_analytics

# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :primary, reading: :primary }
end

class AnalyticsRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :analytics, reading: :analytics }
end
```

### Rails 6.1 Database Enhancements

#### Horizontal Sharding
```ruby
# Multi-shard setup
class Policy < ApplicationRecord
  def self.shard_for_customer(customer_id)
    customer_id % 3 == 0 ? :shard_1 :
    customer_id % 3 == 1 ? :shard_2 : :shard_3
  end

  def self.find_by_customer_distributed(customer_id)
    shard = shard_for_customer(customer_id)
    connected_to(shard: shard) do
      find_by(customer_id: customer_id)
    end
  end
end
```

### Rails 7.0 Modern Frontend

#### Hotwire Turbo Streams
```ruby
# Real-time updates without JavaScript
class Policy < ApplicationRecord
  after_create_commit -> {
    broadcast_prepend_to("policies", partial: "policies/policy")
  }

  after_update_commit -> {
    broadcast_replace_to("policies")
  }

  after_destroy_commit -> {
    broadcast_remove_to("policies")
  }
end
```

#### Import Maps
```ruby
# config/importmap.rb
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin external libraries
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"
```

### Rails 7.1 Performance Features

#### Background Queries
```ruby
# Parallel query execution
def dashboard_data
  # These execute concurrently
  active_policies = Policy.active.load_async
  pending_claims = Claim.pending.load_async
  monthly_revenue = Payment.current_month.async_sum(:amount)

  {
    active_policies: active_policies,
    pending_claims: pending_claims,
    monthly_revenue: monthly_revenue
  }
end
```

### Rails 7.2 Production Features

#### Built-in Authentication
```ruby
# Rails 7.2 simplified authentication
class User < ApplicationRecord
  has_secure_password

  generates_token_for :password_reset, expires_in: 15.minutes
  generates_token_for :email_confirmation, expires_in: 24.hours
end

# Usage
class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    token = user.generate_token_for(:password_reset)

    # Send token via email
    PasswordResetMailer.reset_link(user, token).deliver_later
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:token])

    if @user
      # Show reset form
    else
      redirect_to login_path, alert: 'Invalid or expired token'
    end
  end
end
```

---

## 9. Troubleshooting Guide {#troubleshooting}

### Common Upgrade Issues

#### Issue 1: Zeitwerk Loading Errors
```bash
# Error: uninitialized constant PolicyCalculation
# Solution: Fix file naming
mv app/services/policy_calculation.rb app/services/policy_calculation_service.rb

# Update class name to match
class PolicyCalculationService  # was PolicyCalculation
end
```

#### Issue 2: Webpacker to Importmap Issues
```bash
# Error: Can't find JavaScript files
# Solution: Migrate JavaScript properly

# 1. Create new JavaScript structure
mkdir -p app/javascript/controllers

# 2. Convert modules
# OLD: app/javascript/packs/policies.js
# NEW: app/javascript/policies.js

# 3. Update import statements
# OLD: import Rails from "@rails/ujs"
# NEW: import "@hotwired/turbo-rails"
```

#### Issue 3: Database Migration Issues
```ruby
# Error: PG::DuplicateColumn in migration
# Solution: Check for existing columns

class SafeAddColumn < ActiveRecord::Migration[7.0]
  def up
    unless column_exists?(:policies, :lead_id)
      add_column :policies, :lead_id, :string
    end
  end

  def down
    if column_exists?(:policies, :lead_id)
      remove_column :policies, :lead_id
    end
  end
end
```

#### Issue 4: Gem Compatibility Problems
```ruby
# Create compatibility checker
# script/gem_compatibility_check.rb

require 'net/http'
require 'json'

def check_gem_compatibility(gem_name, rails_version)
  uri = URI("https://rubygems.org/api/v1/gems/#{gem_name}.json")
  response = Net::HTTP.get_response(uri)

  if response.code == '200'
    gem_info = JSON.parse(response.body)
    puts "#{gem_name}: #{gem_info['version']} (#{gem_info['info']})"
  else
    puts "#{gem_name}: Could not fetch information"
  end
rescue => e
  puts "#{gem_name}: Error checking compatibility - #{e.message}"
end

# Check all gems
File.readlines('Gemfile').each do |line|
  if line =~ /gem\s+['"]([^'"]+)['"]/
    gem_name = $1
    check_gem_compatibility(gem_name, '7.2')
  end
end
```

### Performance Issues After Upgrade

#### Issue 1: Slower Query Performance
```ruby
# Diagnosis tool
class QueryPerformanceAnalyzer
  def self.analyze_slow_queries
    ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT
        query,
        mean_time,
        calls,
        total_time,
        mean_time/calls as avg_per_call
      FROM pg_stat_statements
      WHERE mean_time > 100  -- queries taking more than 100ms
      ORDER BY mean_time DESC
      LIMIT 10
    SQL
  end

  def self.suggest_indexes
    # Analyze WHERE clauses and suggest missing indexes
    missing_indexes = []

    ActiveRecord::Base.descendants.each do |model|
      model.reflections.each do |name, reflection|
        if reflection.foreign_key && !index_exists?(model.table_name, reflection.foreign_key)
          missing_indexes << "add_index :#{model.table_name}, :#{reflection.foreign_key}"
        end
      end
    end

    missing_indexes
  end
end
```

#### Issue 2: Memory Bloat
```ruby
# Memory monitoring
class MemoryMonitor
  def self.track_memory_usage
    before = memory_usage

    yield

    after = memory_usage
    difference = after - before

    Rails.logger.info "Memory usage increased by #{difference}MB"

    if difference > 100 # More than 100MB increase
      Rails.logger.warn "Large memory increase detected!"
      GC.start # Force garbage collection
    end
  end

  private

  def self.memory_usage
    `ps -o rss= -p #{Process.pid}`.to_i / 1024.0 # Convert to MB
  end
end

# Usage in controllers
around_action :track_memory, only: [:index, :show]

def track_memory
  MemoryMonitor.track_memory_usage { yield }
end
```

### Asset Pipeline Issues

#### Issue 1: Missing Assets After Upgrade
```bash
# Clear old assets
rails assets:clobber

# Precompile with debugging
RAILS_ENV=production rails assets:precompile --trace

# Check for missing files
rails assets:precompile 2>&1 | grep -i error
```

#### Issue 2: JavaScript Module Loading Issues
```javascript
// Debug import map issues
// In browser console:
console.log(document.querySelector('[data-turbo-track="reload"]'));

// Check if importmap is loaded
console.log(window.importShim);

// Test individual imports
import('./controllers/application').then(module => console.log(module));
```

### Testing Issues After Upgrade

#### Issue 1: Test Failures Due to New Defaults
```ruby
# Fix test configuration
# spec/rails_helper.rb

RSpec.configure do |config|
  # Rails 7+ specific configurations
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false

  # Handle new strong parameters
  config.before(:each, type: :controller) do
    allow(controller).to receive(:verify_authenticity_token)
  end

  # Update for new error handling
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end
```

#### Issue 2: Feature Test Failures with Hotwire
```ruby
# Update system tests for Turbo
# spec/system/policies_spec.rb

RSpec.describe "Policy management", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "creates a new policy with Turbo" do
    visit new_policy_path

    fill_in "Policy number", with: "POL-001"
    fill_in "Premium amount", with: "1000"

    # Wait for Turbo to complete
    click_button "Create Policy"
    expect(page).to have_content("Policy was successfully created")

    # Check for Turbo frame updates
    within("#policies") do
      expect(page).to have_content("POL-001")
    end
  end
end
```

---

## 10. Production Upgrade Checklist {#production-checklist}

### Pre-Upgrade Phase

#### 1. Assessment (2-4 weeks before)
- [ ] **Code Audit**
  ```bash
  # Check for deprecated methods
  rails app:update --dry-run

  # Scan for compatibility issues
  bundle exec ruby-audit check

  # Review custom patches
  grep -r "monkey_patch\|alias_method_chain" app/
  ```

- [ ] **Dependency Analysis**
  ```bash
  # Check gem compatibility
  bundle outdated --only-explicit

  # Verify third-party service compatibility
  curl -I https://api.payment-gateway.com/v2/health
  ```

- [ ] **Performance Baseline**
  ```ruby
  # Benchmark critical paths
  class PerformanceBaseline
    def self.measure_critical_paths
      {
        policy_creation: benchmark_policy_creation,
        policy_search: benchmark_policy_search,
        dashboard_load: benchmark_dashboard
      }
    end

    def self.benchmark_policy_creation
      Benchmark.measure do
        1000.times { create(:policy) }
      end
    end
  end
  ```

#### 2. Environment Preparation (1-2 weeks before)
- [ ] **Staging Environment Setup**
  ```bash
  # Create identical staging environment
  heroku create insurance-app-staging

  # Copy production data (anonymized)
  pg_dump --no-owner production_db | pg_restore staging_db

  # Anonymize sensitive data
  rails db:sanitize_staging_data
  ```

- [ ] **Backup Strategy**
  ```bash
  # Full database backup
  pg_dump -Fc -h localhost -U postgres insurance_production > backup_$(date +%Y%m%d_%H%M%S).sql

  # Code backup
  git tag v-pre-rails-upgrade-$(date +%Y%m%d)
  git push origin --tags

  # Asset backup
  aws s3 sync s3://app-assets/ s3://app-assets-backup-$(date +%Y%m%d)/
  ```

### Upgrade Phase

#### 1. Dependencies Update (Day 1)
```bash
#!/bin/bash
# upgrade_script.sh

set -e

echo "Starting Rails upgrade..."

# 1. Update Ruby
echo "Updating Ruby..."
rbenv install 3.3.0
rbenv local 3.3.0

# 2. Update Gemfile
echo "Updating Gemfile..."
sed -i "s/rails', '~> 7.1/rails', '~> 7.2/" Gemfile

# 3. Bundle update
echo "Running bundle update..."
bundle update rails

# 4. Run Rails updater
echo "Running rails app:update..."
THOR_MERGE=code rails app:update

# 5. Fix common issues
echo "Fixing common upgrade issues..."
rails zeitwerk:check

echo "Upgrade completed. Please review changes and run tests."
```

#### 2. Configuration Updates (Day 1-2)
```ruby
# config/environments/production.rb updates tracker
class UpgradeConfigurationTracker
  RAILS_7_2_CONFIGS = {
    'config.load_defaults' => '7.2',
    'config.active_job.use_big_decimal_serializer' => true,
    'config.action_controller.raise_on_open_redirects' => true,
    'config.assume_ssl' => true,
    'config.force_ssl' => true
  }.freeze

  def self.verify_configuration
    config_file = File.read(Rails.root.join('config/environments/production.rb'))

    missing_configs = RAILS_7_2_CONFIGS.reject do |config_name, expected_value|
      config_file.include?(config_name)
    end

    if missing_configs.any?
      puts "Missing Rails 7.2 configurations:"
      missing_configs.each { |config, value| puts "  #{config} = #{value}" }
    else
      puts "All Rails 7.2 configurations present ✅"
    end
  end
end
```

#### 3. Database Migrations (Day 2)
```ruby
# Safe migration strategy
class ProductionMigrationRunner
  def self.run_safe_migrations
    migrations_to_run = ActiveRecord::Base.connection.migration_context.migrations_status
                                          .select { |status, version, name| status == "down" }

    puts "Found #{migrations_to_run.length} pending migrations"

    migrations_to_run.each do |status, version, name|
      puts "Running migration: #{name}"

      # Run with timeout
      Timeout.timeout(300) do  # 5 minute timeout
        ActiveRecord::Migrator.run(:up, ActiveRecord::Base.connection.migration_context.migrations, version.to_i)
      end

      # Verify migration success
      unless ActiveRecord::Base.connection.migration_context.current_version == version.to_i
        raise "Migration #{version} failed to apply"
      end

      puts "✅ Migration #{name} completed successfully"

      # Brief pause between migrations
      sleep 1
    end
  end
end
```

### Post-Upgrade Phase

#### 1. Verification (Day 3)
```ruby
# Comprehensive health check
class PostUpgradeHealthCheck
  def self.run_all_checks
    checks = [
      :check_database_connectivity,
      :check_redis_connectivity,
      :check_external_services,
      :check_background_jobs,
      :check_file_uploads,
      :check_email_delivery,
      :verify_authentication,
      :test_critical_user_flows
    ]

    results = {}

    checks.each do |check|
      puts "Running #{check}..."
      start_time = Time.current

      begin
        send(check)
        results[check] = { status: :passed, duration: Time.current - start_time }
        puts "✅ #{check} passed"
      rescue => e
        results[check] = { status: :failed, error: e.message, duration: Time.current - start_time }
        puts "❌ #{check} failed: #{e.message}"
      end
    end

    generate_health_report(results)
  end

  def self.check_database_connectivity
    Policy.count
    Customer.count
    Payment.count
  end

  def self.test_critical_user_flows
    # Simulate user creating a policy
    user = User.first
    customer = Customer.first

    policy = Policy.create!(
      customer: customer,
      agent: user,
      policy_number: "TEST-#{SecureRandom.hex(4)}",
      premium_amount: 1000,
      status: 'draft'
    )

    policy.update!(status: 'active')
    policy.destroy
  end
end
```

#### 2. Performance Monitoring (Day 3-7)
```ruby
# Performance monitoring post-upgrade
class UpgradePerformanceMonitor
  def self.monitor_upgrade_impact
    monitoring_period = 7.days

    metrics = {
      response_times: monitor_response_times,
      memory_usage: monitor_memory_usage,
      database_performance: monitor_database_performance,
      error_rates: monitor_error_rates
    }

    generate_performance_report(metrics)
  end

  def self.monitor_response_times
    # Use APM tool or custom monitoring
    NewRelic::Agent.record_custom_metric('Upgrade/ResponseTime', average_response_time)
  end

  def self.compare_with_baseline
    current_metrics = collect_current_metrics
    baseline_metrics = load_baseline_metrics

    improvements = []
    regressions = []

    current_metrics.each do |metric, value|
      baseline_value = baseline_metrics[metric]
      next unless baseline_value

      change_percent = ((value - baseline_value) / baseline_value * 100).round(2)

      if change_percent < -5  # 5% improvement
        improvements << { metric: metric, improvement: change_percent.abs }
      elsif change_percent > 10  # 10% regression
        regressions << { metric: metric, regression: change_percent }
      end
    end

    {
      improvements: improvements,
      regressions: regressions
    }
  end
end
```

#### 3. User Acceptance Testing (Day 4-7)
```ruby
# Automated user acceptance tests
class UserAcceptanceTestSuite
  def self.run_production_smoke_tests
    test_results = {}

    # Test user login
    test_results[:user_login] = test_user_login

    # Test policy creation workflow
    test_results[:policy_creation] = test_policy_creation_workflow

    # Test payment processing
    test_results[:payment_processing] = test_payment_processing

    # Test reports generation
    test_results[:reports] = test_reports_generation

    # Test mobile responsiveness
    test_results[:mobile] = test_mobile_compatibility

    generate_uat_report(test_results)
  end

  def self.test_policy_creation_workflow
    # Using real browser automation
    driver = Selenium::WebDriver.for(:chrome, options: chrome_options)

    begin
      driver.navigate.to "#{Rails.application.config.app_url}/login"

      # Login
      driver.find_element(:id, "email").send_keys(test_user_email)
      driver.find_element(:id, "password").send_keys(test_user_password)
      driver.find_element(:css, "button[type='submit']").click

      # Create policy
      driver.navigate.to "#{Rails.application.config.app_url}/policies/new"
      driver.find_element(:id, "policy_customer_id").send_keys("1")
      driver.find_element(:id, "policy_premium_amount").send_keys("1000")
      driver.find_element(:css, "button[type='submit']").click

      # Verify success
      success_message = driver.find_element(:css, ".alert-success").text
      success_message.include?("Policy was successfully created")

    rescue => e
      false
    ensure
      driver&.quit
    end
  end
end
```

### Rollback Plan

#### Emergency Rollback Procedure
```bash
#!/bin/bash
# rollback_script.sh

echo "EMERGENCY ROLLBACK INITIATED"

# 1. Switch to previous version
git checkout v-pre-rails-upgrade-$(date +%Y%m%d)

# 2. Restore database backup
pg_restore --clean --if-exists -d insurance_production backup_$(date +%Y%m%d)_*.sql

# 3. Restore assets
aws s3 sync s3://app-assets-backup-$(date +%Y%m%d)/ s3://app-assets/

# 4. Restart application
sudo systemctl restart puma
sudo systemctl restart sidekiq

# 5. Verify rollback
curl -f http://localhost/health || echo "ROLLBACK VERIFICATION FAILED"

echo "Rollback completed. Please verify application functionality."
```

### Final Production Checklist

- [ ] **All tests passing** ✅
- [ ] **Performance within acceptable range** ✅
- [ ] **No critical errors in logs** ✅
- [ ] **External integrations working** ✅
- [ ] **Background jobs processing** ✅
- [ ] **User acceptance tests passed** ✅
- [ ] **Monitoring alerts configured** ✅
- [ ] **Documentation updated** ✅
- [ ] **Team trained on new features** ✅
- [ ] **Rollback plan tested and ready** ✅

---

## Conclusion

Rails upgrades are complex but manageable with proper planning, testing, and incremental approach. The key to successful upgrades is:

1. **Never skip versions** - Always upgrade incrementally
2. **Test extensively** - Comprehensive test suite is crucial
3. **Plan for rollback** - Always have an escape route
4. **Monitor closely** - Watch performance and errors post-upgrade
5. **Document everything** - Keep detailed logs of changes

Remember: **A successful Rails upgrade improves security, performance, and developer productivity while maintaining system stability.**

---

*Last Updated: January 2025*
*Rails Version Coverage: 5.2 → 7.2*
*This guide will be updated as new Rails versions are released*

---

**Need help with your Rails upgrade?**
- Join the [Rails community discussions](https://discuss.rubyonrails.org/)
- Check [Rails upgrade guides](https://edgeguides.rubyonrails.org/)
- Consider hiring Rails upgrade specialists for critical production systems