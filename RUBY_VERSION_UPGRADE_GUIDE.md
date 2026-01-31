# Ruby Version Upgrade Guide - Complete Tutorial

## Table of Contents
1. [Pre-Upgrade Checklist](#pre-upgrade-checklist)
2. [Ruby Version Management Tools](#ruby-version-management-tools)
3. [Upgrade Process Step-by-Step](#upgrade-process-step-by-step)
4. [Real Project Upgrade: 2.4 to 3.0](#real-project-upgrade-24-to-30)
5. [Real Project Upgrade: 3.0 to 3.2](#real-project-upgrade-30-to-32)
6. [Common Issues and Solutions](#common-issues-and-solutions)
7. [Rollback Strategy](#rollback-strategy)
8. [Performance Testing](#performance-testing)

---

## Pre-Upgrade Checklist

### 1. Assess Current State
```bash
# Check current Ruby version
ruby --version

# Check Rails version (if applicable)
rails --version

# Check gem versions
bundle outdated

# Generate dependency report
bundle exec gem dependency > dependencies_report.txt

# Check for deprecated warnings
ruby -w -c **/*.rb 2>&1 | grep -i deprecat
```

### 2. Backup Everything
```bash
# Backup your project
git checkout -b backup/pre-ruby-upgrade
git push origin backup/pre-ruby-upgrade

# Backup database (if applicable)
pg_dump production_db > backup_$(date +%Y%m%d).sql

# Document current gem versions
bundle list > gems_backup.txt
cp Gemfile.lock Gemfile.lock.backup
```

### 3. Check Compatibility
```bash
# Install ready4rails gem for Rails projects
gem install ready4rails

# Check gem compatibility
bundle exec bundle outdated --strict

# Use bundler-audit for security check
gem install bundler-audit
bundle audit check
```

---

## Ruby Version Management Tools

### Using RVM
```bash
# Install RVM
\curl -sSL https://get.rvm.io | bash -s stable

# Install new Ruby version
rvm install 3.2.0
rvm install 3.2.0 --with-openssl-dir=$(brew --prefix openssl) # macOS with Homebrew

# List installed versions
rvm list

# Switch versions
rvm use 3.2.0
rvm use 3.2.0 --default

# Create gemset for isolation
rvm gemset create myapp_ruby32
rvm use 3.2.0@myapp_ruby32
```

### Using rbenv
```bash
# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby version
rbenv install 3.2.0
rbenv install --list  # See available versions

# Set version
rbenv global 3.2.0     # System-wide
rbenv local 3.2.0      # Project-specific
rbenv shell 3.2.0      # Current shell only

# Verify
rbenv version
rbenv versions
```

### Using asdf
```bash
# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Add Ruby plugin
asdf plugin add ruby

# Install Ruby version
asdf install ruby 3.2.0
asdf list all ruby     # List available versions

# Set version
asdf global ruby 3.2.0
asdf local ruby 3.2.0

# Create .tool-versions file
echo "ruby 3.2.0" > .tool-versions
```

---

## Upgrade Process Step-by-Step

### Step 1: Install Target Ruby Version
```bash
# Using RVM
rvm install 3.2.0
rvm use 3.2.0
rvm gemset create project_name
rvm use 3.2.0@project_name

# Create .ruby-version file
echo "3.2.0" > .ruby-version
echo "project_name" > .ruby-gemset
```

### Step 2: Update Gemfile
```ruby
# Gemfile
# Before
ruby '2.4.0'

# After
ruby '3.2.0'

# Also update gem versions if needed
gem 'rails', '~> 7.0.0'  # For Ruby 3.2
gem 'pg', '~> 1.4'
gem 'puma', '~> 6.0'
```

### Step 3: Update Bundler
```bash
# Check bundler version
bundle --version

# Update bundler
gem install bundler

# Or install specific version
gem install bundler -v '2.4.0'

# Update bundle
bundle update --bundler
```

### Step 4: Update Dependencies
```bash
# Remove old lock file
rm Gemfile.lock

# Install fresh dependencies
bundle install

# Or update specific gems first
bundle update rails pg puma

# Then full bundle
bundle install
```

### Step 5: Run Tests
```bash
# Run test suite
bundle exec rspec
bundle exec rails test

# Run rubocop for style issues
bundle exec rubocop --auto-gen-config
bundle exec rubocop -a  # Auto-fix

# Check for deprecations
RUBYOPT='-W:deprecated' bundle exec rspec
```

---

## Real Project Upgrade: 2.4 to 3.0

### Project: E-commerce Rails Application

#### Initial Setup (Ruby 2.4.0, Rails 5.2)
```ruby
# Original Gemfile
source 'https://rubygems.org'
ruby '2.4.0'

gem 'rails', '~> 5.2.0'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'carrierwave', '~> 1.0'
gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'pry-rails'
end
```

#### Step 1: Prepare for Upgrade
```bash
# Create upgrade branch
git checkout -b upgrade/ruby-2.4-to-3.0

# Document current state
ruby --version > upgrade_log.txt
bundle list >> upgrade_log.txt

# Run existing tests to ensure they pass
bundle exec rspec
# All tests should pass before proceeding
```

#### Step 2: Install Ruby 3.0
```bash
# Install Ruby 3.0
rvm install 3.0.6
rvm use 3.0.6
rvm gemset create ecommerce_ruby30
rvm use 3.0.6@ecommerce_ruby30

# Verify
ruby --version
# => ruby 3.0.6p216
```

#### Step 3: Fix Ruby 3.0 Breaking Changes

##### Issue 1: Keyword Arguments
```ruby
# Ruby 2.4 (old way - will break in 3.0)
def process_order(user, items, **options)
  discount = options[:discount] || 0
  shipping = options[:shipping] || 'standard'
  # ...
end

# Called with positional hash (breaks in Ruby 3.0)
process_order(user, items, { discount: 10, shipping: 'express' })

# Fix for Ruby 3.0
process_order(user, items, discount: 10, shipping: 'express')
# Or explicitly convert
process_order(user, items, **{ discount: 10, shipping: 'express' })
```

##### Issue 2: Webrick Removed from Standard Library
```ruby
# Add to Gemfile
gem 'webrick', '~> 1.7'  # Required for Ruby 3.0+
```

##### Issue 3: URI.escape Deprecated
```ruby
# Old (Ruby 2.4)
URI.escape(string)
URI.unescape(string)

# New (Ruby 3.0)
require 'cgi'
CGI.escape(string)
CGI.unescape(string)

# Or use URI::Parser
URI::Parser.new.escape(string)
```

#### Step 4: Update Gemfile for Ruby 3.0
```ruby
# Updated Gemfile
source 'https://rubygems.org'
ruby '3.0.6'

gem 'rails', '~> 6.1.7'  # Rails 6.1 supports Ruby 3.0
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.6'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'  # Replace asset pipeline
gem 'turbo-rails', '~> 1.0'  # Replace turbolinks
gem 'stimulus-rails', '~> 1.0'
gem 'jbuilder', '~> 2.11'
gem 'redis', '~> 4.5'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.9.0', require: false
gem 'image_processing', '~> 1.12'  # Replace carrierwave
gem 'webrick', '~> 1.7'  # Required for Ruby 3.0

group :development, :test do
  gem 'rspec-rails', '~> 5.0'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pry-rails'
end
```

#### Step 5: Fix Application Code

##### Update Models
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Ruby 2.4 - hash syntax
  scope :active, -> { where(status: 'active') }

  # Ruby 3.0 - ensure keyword arguments
  def self.create_with_profile(email:, name:, **attributes)
    transaction do
      user = create!(email: email, name: name, **attributes)
      user.create_profile!(name: name)
      user
    end
  end

  # Fix deprecated File.exists?
  def avatar_exists?
    # Old: File.exists?(avatar_path)
    File.exist?(avatar_path)  # Ruby 3.0
  end
end
```

##### Update Controllers
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Fix keyword argument warnings

  # Before (Ruby 2.4)
  def redirect_with_message(path, options = {})
    flash[options[:type] || :notice] = options[:message]
    redirect_to path, options.except(:type, :message)
  end

  # After (Ruby 3.0)
  def redirect_with_message(path, type: :notice, message: nil, **redirect_options)
    flash[type] = message if message
    redirect_to path, **redirect_options
  end
end
```

##### Update Service Objects
```ruby
# app/services/order_service.rb
class OrderService
  # Ruby 2.4 - positional + keyword args mixed
  def initialize(user, items, discount: 0, shipping_method: 'standard')
    @user = user
    @items = items
    @discount = discount
    @shipping_method = shipping_method
  end

  # Ruby 3.0 - fix delegated keyword arguments
  def process_payment(**payment_args)
    # Before: PaymentGateway.charge(payment_args)
    PaymentGateway.charge(**payment_args)  # Explicit delegation
  end

  # Fix pattern matching (new in Ruby 2.7+)
  def calculate_total
    case @shipping_method
    in 'express'
      subtotal + 20
    in 'standard'
      subtotal + 10
    else
      subtotal
    end
  end

  private

  def subtotal
    @items.sum { |item| item[:price] * item[:quantity] }
  end
end
```

#### Step 6: Update Tests
```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Fix keyword argument expectations

  # Before (Ruby 2.4)
  it 'creates user with profile' do
    user = User.create_with_profile(
      { email: 'test@example.com', name: 'Test User' }
    )
  end

  # After (Ruby 3.0)
  it 'creates user with profile' do
    user = User.create_with_profile(
      email: 'test@example.com',
      name: 'Test User'
    )

    expect(user).to be_persisted
    expect(user.profile).to be_present
  end

  # Use new Ruby 3.0 features
  it 'uses pattern matching' do
    result = case user.status
    in 'active'
      :can_purchase
    in 'suspended'
      :cannot_purchase
    else
      :unknown
    end

    expect(result).to eq(:can_purchase)
  end
end
```

#### Step 7: Database and Migration Updates
```ruby
# Fix Rails 6.1 migration syntax
class UpdateUsersTable < ActiveRecord::Migration[6.1]
  def change
    # Ruby 3.0 + Rails 6.1 improvements
    change_table :users, bulk: true do |t|
      t.string :status, default: 'pending', null: false
      t.index :email, unique: true, where: "deleted_at IS NULL"
      t.check_constraint "age >= 18", name: "users_age_check"
    end
  end
end
```

#### Step 8: Run Full Test Suite
```bash
# Clear cache
bundle exec rails tmp:clear
bundle exec rails assets:clobber

# Run migrations
bundle exec rails db:migrate

# Run all tests
bundle exec rspec

# Check for deprecations
RUBYOPT='-W:deprecated' bundle exec rspec

# Run in production mode locally
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails server
```

---

## Real Project Upgrade: 3.0 to 3.2

### Project: API Microservice

#### Initial Setup (Ruby 3.0.6, Rails 7.0)
```ruby
# Original Gemfile (Ruby 3.0)
source 'https://rubygems.org'
ruby '3.0.6'

gem 'rails', '~> 7.0.0'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.6'
gem 'redis', '~> 4.5'
gem 'sidekiq', '~> 6.5'
gem 'jwt', '~> 2.5'
gem 'rack-cors', '~> 1.1'
gem 'jsonapi-serializer', '~> 2.2'
gem 'kaminari', '~> 1.2'
gem 'bootsnap', require: false

group :development, :test do
  gem 'rspec-rails', '~> 5.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.19'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'database_cleaner-active_record', '~> 2.0'
end
```

#### Step 1: Install Ruby 3.2
```bash
# Install Ruby 3.2
rvm install 3.2.3
rvm use 3.2.3
rvm gemset create api_ruby32
rvm use 3.2.3@api_ruby32

# Update .ruby-version
echo "3.2.3" > .ruby-version
echo "api_ruby32" > .ruby-gemset
```

#### Step 2: Leverage Ruby 3.2 Features

##### Data Class (New in Ruby 3.2)
```ruby
# app/models/api_response.rb
# Before (Ruby 3.0)
class ApiResponse
  attr_reader :status, :data, :errors, :meta

  def initialize(status:, data: nil, errors: nil, meta: nil)
    @status = status
    @data = data
    @errors = errors
    @meta = meta
  end

  def success?
    status == :ok
  end

  def to_h
    {
      status: status,
      data: data,
      errors: errors,
      meta: meta
    }.compact
  end
end

# After (Ruby 3.2) - Using Data class
ApiResponse = Data.define(:status, :data, :errors, :meta) do
  def success?
    status == :ok
  end

  def to_h
    {
      status: status,
      data: data,
      errors: errors,
      meta: meta
    }.compact
  end
end

# Usage
response = ApiResponse.new(
  status: :ok,
  data: { user: { id: 1, name: 'John' } },
  errors: nil,
  meta: { page: 1 }
)
```

##### Pattern Matching Improvements
```ruby
# app/services/request_parser.rb
class RequestParser
  # Ruby 3.2 - Improved pattern matching
  def parse_request(params)
    case params
    in { action: 'create', resource: 'user', data: { email:, name:, age: } }
      create_user(email:, name:, age:)

    in { action: 'update', resource: 'user', id:, data: }
      update_user(id, **data)

    in { action: 'delete', resource: String => resource, id: Integer => id }
      delete_resource(resource, id)

    # Ruby 3.2 - Pattern matching with pinning
    in { action: ^@allowed_action, **rest }
      process_allowed_action(@allowed_action, rest)

    else
      { error: 'Invalid request format' }
    end
  end

  # Ruby 3.2 - Find pattern in arrays
  def extract_errors(results)
    case results
    in [*, { status: :error, message: }, *]
      "Found error: #{message}"
    else
      "No errors found"
    end
  end
end
```

##### Anonymous Block Arguments
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Ruby 3.0
  scope :with_recent_activity, -> {
    joins(:activities).where(activities: { created_at: 1.week.ago.. })
  }

  # Ruby 3.2 - Anonymous block arguments
  scope :active_in_period, -> {
    where(last_active_at: _1.._2)  # _1 and _2 are anonymous arguments
  }

  # Usage
  User.active_in_period(1.week.ago, Time.current)

  # Ruby 3.2 - it as default block parameter
  def self.process_batch
    find_in_batches do
      # 'it' is the default block parameter in Ruby 3.2+
      it.each(&:process!)
    end
  end
end
```

##### Refinements Improvements
```ruby
# lib/core_extensions/string_refinements.rb
module StringRefinements
  refine String do
    # Ruby 3.2 - Better refinement support
    def to_slug
      downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '-')
    end

    def truncate_words(max_words)
      words = split
      return self if words.length <= max_words

      words.first(max_words).join(' ') + '...'
    end
  end
end

# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  using StringRefinements  # Ruby 3.2 - refinements work better

  def generate_cache_key(resource, title)
    "#{resource}/#{title.to_slug}"
  end
end
```

#### Step 3: Update Gemfile for Ruby 3.2
```ruby
# Updated Gemfile
source 'https://rubygems.org'
ruby '3.2.3'

gem 'rails', '~> 7.1.0'  # Rails 7.1 optimized for Ruby 3.2
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'redis', '~> 5.0'
gem 'sidekiq', '~> 7.2'
gem 'jwt', '~> 2.7'
gem 'rack-cors', '~> 2.0'
gem 'jsonapi-serializer', '~> 2.2'
gem 'kaminari', '~> 1.2'
gem 'bootsnap', require: false

# Ruby 3.2 specific performance gems
gem 'yjit', require: false  # Just-in-time compiler

group :development, :test do
  gem 'rspec-rails', '~> 6.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.2'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'debug', '~> 1.9'  # Ruby 3.2 native debugger
end
```

#### Step 4: Performance Optimizations with Ruby 3.2

##### Enable YJIT (Ruby 3.2's JIT Compiler)
```ruby
# config/application.rb
module ApiApp
  class Application < Rails::Application
    config.load_defaults 7.1

    # Enable YJIT for Ruby 3.2
    if defined?(RubyVM::YJIT) && RubyVM::YJIT.enabled?
      config.before_initialize do
        Rails.logger.info "YJIT is enabled"
      end
    end
  end
end

# config/puma.rb
# Enable YJIT in production
if ENV['RAILS_ENV'] == 'production'
  ENV['RUBYOPT'] = '--yjit'
end

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
```

##### Memory and Performance Improvements
```ruby
# app/services/batch_processor.rb
class BatchProcessor
  # Ruby 3.2 - Better memory management with WeakRef
  require 'weakref'

  def initialize
    @processed_items = {}  # Regular hash
    @cache = {}  # Will use WeakRef
  end

  def process_with_cache(items)
    items.map do |item|
      # Ruby 3.2 - Improved WeakRef handling
      cached = @cache[item.id]

      if cached&.weakref_alive?
        cached.__getobj__
      else
        result = expensive_process(item)
        @cache[item.id] = WeakRef.new(result)
        result
      end
    end
  end

  private

  def expensive_process(item)
    # Simulate expensive operation
    sleep(0.1)
    { id: item.id, processed_at: Time.current }
  end
end
```

#### Step 5: Update Tests for Ruby 3.2
```ruby
# spec/services/api_service_spec.rb
require 'rails_helper'

RSpec.describe ApiService do
  # Ruby 3.2 - Using Data classes in tests
  let(:request_data) do
    RequestData = Data.define(:method, :endpoint, :params, :headers)
    RequestData.new(
      method: :get,
      endpoint: '/api/users',
      params: { page: 1 },
      headers: { 'Authorization' => 'Bearer token' }
    )
  end

  describe '#process_request' do
    it 'uses pattern matching for request routing' do
      service = described_class.new

      # Ruby 3.2 pattern matching
      result = case request_data
      in RequestData[method: :get, endpoint: %r{/api/users}, **]
        service.fetch_users(request_data.params)
      in RequestData[method: :post, endpoint: %r{/api/users}, **]
        service.create_user(request_data.params)
      else
        { error: 'Unknown endpoint' }
      end

      expect(result).to have_key(:data)
    end

    # Ruby 3.2 - Test with anonymous block arguments
    it 'processes batch efficiently' do
      items = create_list(:item, 10)

      # Using numbered parameters
      processed = items.map { { id: _1.id, status: 'processed' } }

      expect(processed).to all(include(:id, :status))
    end
  end
end
```

#### Step 6: Benchmark Ruby 3.2 Improvements
```ruby
# benchmarks/ruby32_performance.rb
require 'benchmark/ips'
require_relative '../config/environment'

# Test YJIT performance
def fibonacci(n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

Benchmark.ips do |x|
  x.report("Fibonacci(30)") { fibonacci(30) }
  x.report("Data.define") do
    Point = Data.define(:x, :y)
    1000.times { Point.new(x: rand(100), y: rand(100)) }
  end

  x.report("Pattern matching") do
    data = { type: 'user', attributes: { name: 'John', age: 30 } }
    case data
    in { type: 'user', attributes: { name:, age: } }
      "#{name} is #{age}"
    end
  end

  x.compare!
end

# Run with YJIT
# RUBYOPT='--yjit' ruby benchmarks/ruby32_performance.rb
```

---

## Common Issues and Solutions

### Issue 1: Keyword Argument Separation
```ruby
# Problem: Ruby 3.0+ separates positional and keyword arguments

# Breaks in Ruby 3.0+
def method(arg, **kwargs)
  # ...
end
method(arg, { key: 'value' })  # Error!

# Solution 1: Use double splat
method(arg, **{ key: 'value' })

# Solution 2: Pass as keywords
method(arg, key: 'value')

# Solution 3: For delegation
def delegate_method(*args, **kwargs, &block)
  other_method(*args, **kwargs, &block)
end
```

### Issue 2: Removed or Moved Standard Libraries
```ruby
# Libraries removed from standard library in Ruby 3.0+
# Add these to Gemfile if needed:

gem 'rexml'      # XML parser
gem 'rss'        # RSS library
gem 'webrick'    # Web server
gem 'net-pop'    # POP3 client
gem 'net-smtp'   # SMTP client
gem 'net-imap'   # IMAP client
gem 'matrix'     # Matrix library
gem 'prime'      # Prime numbers
gem 'debug'      # Debugger (replaces byebug)
```

### Issue 3: File and Dir Method Changes
```ruby
# Deprecated methods
File.exists?('file.txt')   # Deprecated
Dir.exists?('directory')   # Deprecated

# Use instead
File.exist?('file.txt')    # Correct
Dir.exist?('directory')    # Correct

# Encoding changes
# Ruby 2.x default external encoding might differ
# Ruby 3.x has better UTF-8 handling

# Explicitly set encoding if needed
File.read('file.txt', encoding: 'UTF-8')
```

### Issue 4: Frozen String Literals
```ruby
# Ruby 3.0+ moves toward frozen strings by default

# Add to top of files or use magic comment
# frozen_string_literal: true

# Fix string mutation errors
str = "hello"
str << " world"  # Error if frozen

# Solution
str = +"hello"  # Explicitly mutable
str << " world"  # Works

# Or
str = "hello".dup
str << " world"
```

### Issue 5: Gem Compatibility
```bash
# Check gem compatibility before upgrade
gem install bundler-leak
bundle leak check

# Update gems gradually
bundle update --conservative gem_name

# Use version constraints wisely
gem 'some_gem', '~> 2.0'  # Pessimistic constraint

# Test gem compatibility
bundle exec rspec
bundle exec rubocop
```

---

## Rollback Strategy

### Prepare Rollback Plan
```bash
# 1. Tag current version before upgrade
git tag -a pre-ruby-upgrade -m "Before Ruby upgrade"
git push origin pre-ruby-upgrade

# 2. Document rollback steps
cat > ROLLBACK.md << EOF
# Rollback Instructions

1. Switch Ruby version:
   rvm use 2.4.0@project_name

2. Checkout previous code:
   git checkout pre-ruby-upgrade

3. Restore Gemfile.lock:
   cp Gemfile.lock.backup Gemfile.lock
   bundle install

4. Restore database if needed:
   psql database_name < backup_20240101.sql

5. Clear caches:
   bundle exec rails tmp:clear
   bundle exec rails assets:clobber
   bundle exec rails assets:precompile

6. Restart services:
   sudo systemctl restart puma
   sudo systemctl restart sidekiq
EOF
```

### Quick Rollback Script
```bash
#!/bin/bash
# rollback.sh

echo "Starting rollback..."

# Switch Ruby version
rvm use 2.4.0@project_name

# Restore code
git checkout pre-ruby-upgrade

# Restore dependencies
cp Gemfile.lock.backup Gemfile.lock
bundle install

# Clear caches
bundle exec rails tmp:clear
bundle exec rails assets:clobber

# Run tests
bundle exec rspec

if [ $? -eq 0 ]; then
  echo "Rollback successful!"
else
  echo "Rollback tests failed!"
  exit 1
fi
```

---

## Performance Testing

### Before and After Benchmarks
```ruby
# benchmarks/performance_test.rb
require 'benchmark'
require 'memory_profiler'
require_relative '../config/environment'

def benchmark_operations
  results = {}

  # Database operations
  results[:db_read] = Benchmark.measure do
    1000.times { User.find(rand(1..100)) }
  end

  # API endpoint
  results[:api_call] = Benchmark.measure do
    100.times do
      app = ActionDispatch::Integration::Session.new(Rails.application)
      app.get '/api/v1/users'
    end
  end

  # Memory usage
  report = MemoryProfiler.report do
    100.times { User.all.map(&:to_json) }
  end

  results[:memory] = {
    total_allocated: report.total_allocated,
    total_retained: report.total_retained
  }

  results
end

# Run before upgrade
before_results = benchmark_operations
File.write('before_upgrade.json', before_results.to_json)

# Run after upgrade
after_results = benchmark_operations
File.write('after_upgrade.json', after_results.to_json)

# Compare results
require 'json'
before = JSON.parse(File.read('before_upgrade.json'))
after = JSON.parse(File.read('after_upgrade.json'))

puts "Performance Comparison:"
puts "DB Read: #{((before['db_read']['real'] - after['db_read']['real']) / before['db_read']['real'] * 100).round(2)}% improvement"
puts "API Call: #{((before['api_call']['real'] - after['api_call']['real']) / before['api_call']['real'] * 100).round(2)}% improvement"
puts "Memory: #{((before['memory']['total_allocated'] - after['memory']['total_allocated']) / before['memory']['total_allocated'] * 100).round(2)}% reduction"
```

### Load Testing
```bash
# Install wrk for load testing
brew install wrk  # macOS
apt-get install wrk  # Ubuntu

# Test before upgrade
wrk -t12 -c400 -d30s --latency http://localhost:3000/api/v1/users > before_load.txt

# Test after upgrade
wrk -t12 -c400 -d30s --latency http://localhost:3000/api/v1/users > after_load.txt

# Compare results
diff before_load.txt after_load.txt
```

---

## Deployment Strategy

### Staged Deployment
```yaml
# .github/workflows/ruby_upgrade.yml
name: Ruby Upgrade Deployment

on:
  push:
    branches: [ ruby-upgrade ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby-version: ['3.0.6', '3.2.3']

    steps:
    - uses: actions/checkout@v3
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: ${{ matrix.ruby-version }}
        bundler-cache: true

    - name: Run tests
      run: |
        bundle exec rails db:create db:schema:load
        bundle exec rspec

    - name: Performance test
      run: |
        bundle exec ruby benchmarks/performance_test.rb

  deploy_staging:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to staging
      run: |
        # Deploy to staging environment
        cap staging deploy

  deploy_production:
    needs: deploy_staging
    runs-on: ubuntu-latest
    environment: production
    steps:
    - name: Deploy to production
      run: |
        # Deploy to production with canary
        cap production deploy:canary
```

### Monitoring After Upgrade
```ruby
# config/initializers/monitoring.rb
if defined?(NewRelic)
  NewRelic::Agent.after_fork(:force_reconnect => true) do
    # Record Ruby version
    NewRelic::Agent.set_custom_attribute('ruby_version', RUBY_VERSION)
    NewRelic::Agent.set_custom_attribute('rails_version', Rails.version)

    # Monitor specific metrics
    if defined?(RubyVM::YJIT) && RubyVM::YJIT.enabled?
      NewRelic::Agent.set_custom_attribute('yjit_enabled', true)
      NewRelic::Agent.set_custom_attribute('yjit_stats', RubyVM::YJIT.runtime_stats)
    end
  end
end

# Log performance metrics
Rails.application.config.after_initialize do
  Rails.logger.info "Ruby #{RUBY_VERSION} initialized"
  Rails.logger.info "GC stats: #{GC.stat}"

  if defined?(RubyVM::YJIT)
    Rails.logger.info "YJIT enabled: #{RubyVM::YJIT.enabled?}"
  end
end
```

---

## Best Practices Summary

1. **Always Test Thoroughly**
   - Run full test suite before and after upgrade
   - Test in staging environment first
   - Use canary deployments for production

2. **Upgrade Incrementally**
   - Don't skip major versions
   - Update gems one at a time if issues arise
   - Fix deprecation warnings before upgrading

3. **Document Everything**
   - Keep detailed upgrade logs
   - Document workarounds and fixes
   - Create runbooks for rollback

4. **Monitor Performance**
   - Benchmark before and after
   - Monitor memory usage
   - Track error rates

5. **Use Version Managers**
   - Always use RVM, rbenv, or asdf
   - Create separate gemsets/environments
   - Document Ruby version in .ruby-version

6. **Keep Dependencies Updated**
   - Regularly run bundle audit
   - Use Dependabot or similar tools
   - Test gem updates in isolation

Remember: Ruby upgrades can bring significant performance improvements and new features, but require careful planning and testing.