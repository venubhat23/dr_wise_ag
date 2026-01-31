# Ruby Complete Learning Guide - In-Depth with Examples & Exercises

## Table of Contents
- [Part 1: Environment Setup & Basics](#part-1-environment-setup--basics)
- [Part 2: Core Ruby Concepts](#part-2-core-ruby-concepts)
- [Part 3: Object-Oriented Programming](#part-3-object-oriented-programming)
- [Part 4: Advanced Ruby](#part-4-advanced-ruby)
- [Part 5: Real-World Applications](#part-5-real-world-applications)

---

# Part 1: Environment Setup & Basics

## 1. RVM/rbenv Setup

### What is RVM/rbenv?
**RVM (Ruby Version Manager)** and **rbenv** are tools that allow you to install and manage multiple Ruby versions on the same machine. Think of it like having different toolboxes - you can switch between them based on your project needs.

### Real-World Scenario
Imagine you're a developer working on 3 projects:
- Project A uses Ruby 2.7.0 (legacy banking app)
- Project B uses Ruby 3.0.0 (modern API)
- Project C uses Ruby 3.2.0 (new microservice)

Without RVM/rbenv, you'd have conflicts. With them, you can switch Ruby versions seamlessly.

### Installation & Setup

#### RVM Installation:
```bash
# Install GPG keys
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# Install RVM
\curl -sSL https://get.rvm.io | bash -s stable

# Load RVM into shell session
source ~/.rvm/scripts/rvm

# Verify installation
rvm --version
```

#### rbenv Installation:
```bash
# Install rbenv and ruby-build
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Verify installation
rbenv --version
```

### Practical Usage

#### RVM Commands:
```bash
# List available Ruby versions
rvm list known

# Install specific Ruby version
rvm install 3.2.0
rvm install 2.7.4

# List installed versions
rvm list

# Switch Ruby version
rvm use 3.2.0
rvm use 2.7.4 --default  # Set as default

# Create gemset (isolated gem environment)
rvm gemset create myproject
rvm use 3.2.0@myproject

# Project-specific Ruby version
echo "3.2.0" > .ruby-version
echo "myproject" > .ruby-gemset
```

#### rbenv Commands:
```bash
# List available versions
rbenv install --list

# Install Ruby version
rbenv install 3.2.0

# Set global version
rbenv global 3.2.0

# Set local version for project
cd myproject
rbenv local 2.7.4

# List installed versions
rbenv versions

# Show current version
rbenv version
```

### Practice Exercises

**Exercise 1.1:** Install both Ruby 3.0.0 and 2.7.0
```bash
# Your solution here
# Test: ruby --version should show different versions after switching
```

**Exercise 1.2:** Create a project with specific Ruby version
```bash
# Create project directory
mkdir todo_app
cd todo_app
# Set Ruby version to 3.0.0
# Create a gemset called 'todo'
# Install rails gem in this gemset only
```

**Exercise 1.3:** Troubleshoot version conflicts
```ruby
# Scenario: You get error "Your Ruby version is 2.7.0, but your Gemfile specified 3.0.0"
# How would you fix this?
```

---

## 2. IRB and Pry Console

### What are IRB and Pry?
- **IRB (Interactive Ruby)**: Ruby's built-in REPL (Read-Eval-Print Loop)
- **Pry**: Advanced REPL with debugging capabilities, syntax highlighting, and better introspection

### Real-World Usage

#### IRB Basics:
```ruby
# Start IRB
$ irb

# Basic usage
irb> name = "John"
=> "John"

irb> def greet(person)
irb>   "Hello, #{person}!"
irb> end
=> :greet

irb> greet(name)
=> "Hello, John!"

# Multi-line input
irb> class User
irb>   def initialize(name)
irb>     @name = name
irb>   end
irb> end

# Load Ruby files
irb> require './my_script.rb'
irb> load 'calculator.rb'  # Can reload changes

# Execute shell commands
irb> `ls`
irb> system('pwd')
```

#### Pry Advanced Features:
```ruby
# Install Pry
gem install pry pry-doc

# Start Pry
$ pry

# Introspection
pry> show-method Array#map
pry> ls String  # List all methods
pry> cd String  # Navigate into class
pry> show-doc String#split

# Debugging with binding.pry
# In your code:
def calculate_discount(price, percentage)
  binding.pry  # Execution stops here
  discount = price * (percentage / 100.0)
  price - discount
end

# Edit method in-session
pry> edit calculate_discount

# Command history
pry> hist
pry> hist --grep map
pry> hist --replay 5..10
```

### Practice Exercises

**Exercise 2.1:** IRB Configuration
```ruby
# Create ~/.irbrc file with:
# 1. Auto-indentation
# 2. History saving
# 3. Custom prompt
# 4. Useful requires (pp, date, etc.)

# Solution template:
# ~/.irbrc
require 'irb/completion'
require 'pp'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: "ruby> ",
  PROMPT_S: "  ... ",
  PROMPT_C: "  ... ",
  RETURN: "=> %s\n"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM
```

**Exercise 2.2:** Pry Debugging
```ruby
# Debug this code using Pry:
class ShoppingCart
  def initialize
    @items = []
  end

  def add_item(item, price, quantity)
    # Add binding.pry here
    @items << { item: item, price: price, quantity: quantity }
    calculate_total
  end

  def calculate_total
    @items.reduce(0) { |sum, item| sum + (item[:price] * item[:quantity]) }
  end
end

# Test in Pry:
# cart = ShoppingCart.new
# cart.add_item("Apple", 2.5, 3)
# Explore @items, step through calculation
```

---

## 3. Variables and Constants

### Types of Variables in Ruby

#### Local Variables
```ruby
# Start with lowercase or underscore
name = "Alice"
_temporary = 42
user_age = 25

# Scope: Limited to method, block, or class definition
def show_scope
  local_var = "I'm local"
  puts local_var  # Works
end
# puts local_var  # Error: undefined local variable
```

#### Instance Variables
```ruby
# Start with @
class BankAccount
  def initialize(balance)
    @balance = balance  # Instance variable
    @transactions = []
  end

  def deposit(amount)
    @balance += amount
    @transactions << { type: 'deposit', amount: amount, time: Time.now }
  end

  def balance
    @balance  # Accessible throughout instance
  end
end

account = BankAccount.new(1000)
account.deposit(500)
puts account.balance  # 1500
```

#### Class Variables
```ruby
# Start with @@
class Employee
  @@company = "TechCorp"  # Shared across all instances
  @@employee_count = 0

  def initialize(name)
    @name = name
    @@employee_count += 1
  end

  def self.employee_count
    @@employee_count
  end

  def self.company
    @@company
  end
end

Employee.new("John")
Employee.new("Jane")
puts Employee.employee_count  # 2
puts Employee.company  # TechCorp
```

#### Global Variables
```ruby
# Start with $
$global_config = { env: 'development', debug: true }

class Application
  def run
    puts "Running in #{$global_config[:env]} mode"
    puts "Debug: #{$global_config[:debug]}"
  end
end

# Accessible everywhere (use sparingly!)
App.new.run
```

#### Constants
```ruby
# Start with uppercase (convention: ALL_CAPS)
PI = 3.14159
MAX_USERS = 1000

class ServerConfig
  HOST = 'localhost'
  PORT = 3000
  TIMEOUTS = {
    connection: 30,
    read: 60,
    write: 60
  }.freeze  # Freeze to prevent modification

  def self.url
    "http://#{HOST}:#{PORT}"
  end
end

# Warning: Constants can be changed (with warning)
PI = 3.14  # Warning: already initialized constant PI

# To prevent any modification:
FROZEN_CONFIG = { api_key: 'secret123' }.freeze
# FROZEN_CONFIG[:api_key] = 'new'  # Error: can't modify frozen Hash
```

### Real-World Example: Configuration System
```ruby
class AppConfiguration
  # Class variable for singleton instance
  @@instance = nil

  # Constants for defaults
  DEFAULT_SETTINGS = {
    database: {
      host: 'localhost',
      port: 5432,
      pool: 5
    },
    cache: {
      ttl: 3600,
      max_size: 1000
    }
  }.freeze

  def initialize
    @settings = DEFAULT_SETTINGS.dup
    @environment = ENV['APP_ENV'] || 'development'
    load_environment_config
  end

  def self.instance
    @@instance ||= new
  end

  private

  def load_environment_config
    # Instance variables for current config
    @database_url = ENV['DATABASE_URL']
    @cache_redis_url = ENV['REDIS_URL']

    # Global variable for quick access (careful use)
    $app_debug = @environment == 'development'
  end
end

# Usage
config = AppConfiguration.instance
puts config.inspect
```

### Practice Exercises

**Exercise 3.1:** Variable Scope Challenge
```ruby
# Fix this code - identify scope issues:
class Calculator
  result = 0

  def add(a, b)
    result = a + b
  end

  def multiply(a, b)
    result = a * b
  end

  def show_result
    puts result
  end
end

# Expected behavior:
# calc = Calculator.new
# calc.add(5, 3)
# calc.show_result  # Should show 8
# calc.multiply(4, 2)
# calc.show_result  # Should show 8
```

**Exercise 3.2:** Build a Settings Manager
```ruby
# Create a SettingsManager class that:
# 1. Uses constants for default values
# 2. Uses class variables for shared settings
# 3. Uses instance variables for user-specific settings
# 4. Implements a global $debug flag

class SettingsManager
  # Your code here
end

# Test cases:
# manager1 = SettingsManager.new('user1')
# manager2 = SettingsManager.new('user2')
# manager1.set_theme('dark')
# manager2.set_theme('light')
# SettingsManager.set_global_timeout(30)
# Both should have timeout 30, different themes
```

---

## 4. Data Types Deep Dive

### Strings - Complete Guide

#### String Creation and Literals
```ruby
# Different ways to create strings
single_quote = 'Simple string'
double_quote = "String with #{interpolation}"
percent_string = %q(String with 'quotes' inside)
percent_interpolate = %Q(Interpolated #{1 + 1} string)
heredoc = <<~TEXT
  Multi-line
  string with
  proper indentation
TEXT

# String encoding
utf8_string = "Hello 世界 🌍"
puts utf8_string.encoding  # UTF-8

# Frozen strings (immutable)
frozen = "immutable".freeze
# frozen << " more"  # Error: can't modify frozen String

# Mutable strings
buffer = String.new(capacity: 100)  # Pre-allocated buffer
buffer << "Efficient "
buffer << "string building"
```

#### String Methods - Real Examples
```ruby
# Case manipulation
email = "  John.DOE@EXAMPLE.com  "
clean_email = email.strip.downcase
# => "john.doe@example.com"

# Smart capitalization
title = "the lord of the rings"
title.split.map(&:capitalize).join(' ')
# => "The Lord Of The Rings"

# Substring operations
phone = "1234567890"
formatted = "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
# => "(123) 456-7890"

# Pattern replacement
text = "The price is $100 or $200"
text.gsub(/\$(\d+)/) { |match| "€#{($1.to_i * 0.85).round}" }
# => "The price is €85 or €170"

# String scanning
log = "Error at 10:30, Warning at 10:45, Error at 11:00"
errors = log.scan(/Error at (\d+:\d+)/).flatten
# => ["10:30", "11:00"]

# Character operations
password = "Pass123!"
has_uppercase = password.chars.any? { |c| c.match?(/[A-Z]/) }
has_digit = password.match?(/\d/)
has_special = password.match?(/[!@#$%^&*]/)

# String interpolation advanced
class Product
  attr_reader :name, :price

  def initialize(name, price)
    @name, @price = name, price
  end

  def to_s
    "#{@name}: $#{'%.2f' % @price}"
  end
end

product = Product.new("Laptop", 999.99)
puts "Today's deal: #{product}"
# => "Today's deal: Laptop: $999.99"
```

### Integers and Floats - Precision Matters

```ruby
# Integer operations
population = 7_900_000_000  # Underscores for readability
bytes = 0b11111111  # Binary: 255
permissions = 0o755  # Octal: 493
color = 0xFF0000    # Hex: 16711680

# Arbitrary precision
factorial_100 = (1..100).inject(:*)
puts factorial_100.to_s.length  # 158 digits!

# Float precision issues
price = 0.1 + 0.2
puts price == 0.3  # false! (floating point arithmetic)
puts (price - 0.3).abs < 0.0001  # Better comparison

# BigDecimal for money
require 'bigdecimal'
price1 = BigDecimal("19.99")
price2 = BigDecimal("4.50")
tax_rate = BigDecimal("0.08")
total = (price1 + price2) * (1 + tax_rate)
puts total.round(2).to_s('F')  # "26.45"

# Number formatting
number = 1234567.89
formatted = number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
# => "1,234,567.89"

# Rational numbers
fraction = Rational(3, 4)  # 3/4
decimal = fraction.to_f    # 0.75
percentage = (fraction * 100).to_i  # 75
```

### Symbols - Memory Efficiency

```ruby
# Symbol vs String memory
puts "hello".object_id  # Different each time
puts "hello".object_id  # Different object ID
puts :hello.object_id   # Same each time
puts :hello.object_id   # Same object ID

# Real use case: Hash keys
# Bad - creates new string objects
user = { "name" => "John", "age" => 30, "email" => "john@example.com" }

# Good - reuses symbol objects
user = { name: "John", age: 30, email: "john@example.com" }

# Symbol to string conversion
status = :pending
puts status.to_s.capitalize  # "Pending"
puts status.to_s.upcase      # "PENDING"

# String to symbol
input = "active"
status = input.to_sym  # :active

# Dynamic symbols
method_name = "user_#{action}_handler".to_sym
# Creates: :user_create_handler, :user_update_handler, etc.

# Symbols as method names
class DynamicMethods
  [:get, :post, :put, :delete].each do |method|
    define_method("#{method}_request") do |url|
      "#{method.upcase} request to #{url}"
    end
  end
end

api = DynamicMethods.new
puts api.get_request("/users")   # "GET request to /users"
puts api.post_request("/users")  # "POST request to /users"
```

### Booleans and Nil

```ruby
# Truthy and Falsy
# Only nil and false are falsy, everything else is truthy

# Common mistake
if 0          # 0 is truthy in Ruby!
  puts "This will print"
end

if ""         # Empty string is truthy!
  puts "This will also print"
end

if nil || false
  puts "Won't print"
else
  puts "Will print"
end

# Nil checking patterns
user = nil

# Bad
if user != nil
  puts user.name
end

# Good
if user
  puts user.name
end

# Better
puts user&.name  # Safe navigation operator

# Nil coalescing
name = nil
display_name = name || "Anonymous"  # "Anonymous"

# But careful with boolean values
enabled = false
setting = enabled || true  # true (probably not what you want!)
setting = enabled.nil? ? true : enabled  # false (correct)
```

### Practice Exercises

**Exercise 4.1:** String Processor
```ruby
# Create a StringProcessor class that:
class StringProcessor
  def self.extract_urls(text)
    # Extract all URLs from text
    # Input: "Visit https://google.com or http://example.org"
    # Output: ["https://google.com", "http://example.org"]
  end

  def self.mask_credit_card(card_number)
    # Mask credit card keeping last 4 digits
    # Input: "4532-1234-5678-9876"
    # Output: "****-****-****-9876"
  end

  def self.generate_slug(title)
    # Convert title to URL-friendly slug
    # Input: "Hello World! This is Ruby"
    # Output: "hello-world-this-is-ruby"
  end

  def self.word_frequency(text)
    # Count word frequency (case-insensitive)
    # Input: "The the quick brown fox"
    # Output: {"the" => 2, "quick" => 1, "brown" => 1, "fox" => 1}
  end
end
```

**Exercise 4.2:** Number Calculator
```ruby
# Build a financial calculator:
class FinancialCalculator
  def self.compound_interest(principal, rate, time, n = 12)
    # Calculate compound interest
    # A = P(1 + r/n)^(nt)
  end

  def self.format_currency(amount, currency = "$")
    # Format number as currency with commas
    # Input: 1234567.89
    # Output: "$1,234,567.89"
  end

  def self.percentage_change(old_value, new_value)
    # Calculate percentage change
    # Return formatted string like "+25.5%" or "-10.2%"
  end
end
```

---

## 5. Arrays - Complete Mastery

### Array Creation and Initialization
```ruby
# Different ways to create arrays
empty = []
numbers = [1, 2, 3, 4, 5]
mixed = [1, "two", :three, 4.0, nil]
nested = [[1, 2], [3, 4], [5, 6]]

# Array constructor
zeros = Array.new(5, 0)  # [0, 0, 0, 0, 0]
sequence = Array.new(5) { |i| i * 2 }  # [0, 2, 4, 6, 8]

# Range to array
letters = ('a'..'z').to_a
numbers = (1..100).step(5).to_a

# %w and %i shortcuts
words = %w[apple banana cherry]  # ["apple", "banana", "cherry"]
symbols = %i[read write execute]  # [:read, :write, :execute]

# Array decomposition
first, *middle, last = [1, 2, 3, 4, 5]
# first = 1, middle = [2, 3, 4], last = 5
```

### Array Manipulation Methods
```ruby
# Adding elements
arr = [1, 2, 3]
arr.push(4)           # [1, 2, 3, 4]
arr << 5 << 6         # [1, 2, 3, 4, 5, 6]
arr.unshift(0)        # [0, 1, 2, 3, 4, 5, 6]
arr.insert(3, 2.5)    # [0, 1, 2, 2.5, 3, 4, 5, 6]

# Removing elements
arr.pop               # Returns 6, arr = [0, 1, 2, 2.5, 3, 4, 5]
arr.shift             # Returns 0, arr = [1, 2, 2.5, 3, 4, 5]
arr.delete(2.5)       # Returns 2.5, arr = [1, 2, 3, 4, 5]
arr.delete_at(2)      # Returns 3, arr = [1, 2, 4, 5]

# Array operations
a = [1, 2, 3, 4]
b = [3, 4, 5, 6]

union = a | b         # [1, 2, 3, 4, 5, 6]
intersection = a & b  # [3, 4]
difference = a - b    # [1, 2]
concatenation = a + b # [1, 2, 3, 4, 3, 4, 5, 6]

# Unique elements
duplicates = [1, 2, 2, 3, 3, 3, 4]
unique = duplicates.uniq  # [1, 2, 3, 4]
duplicates.uniq!          # Modifies in place

# Array rotation
arr = [1, 2, 3, 4, 5]
arr.rotate(2)   # [3, 4, 5, 1, 2]
arr.rotate(-1)  # [5, 1, 2, 3, 4]
```

### Advanced Array Operations
```ruby
# Multi-dimensional array operations
matrix = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

# Transpose
transposed = matrix.transpose
# [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

# Flatten
flat = matrix.flatten  # [1, 2, 3, 4, 5, 6, 7, 8, 9]
matrix.flatten(1)      # Flatten only one level

# Zip arrays together
names = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
cities = ["NYC", "LA", "Chicago"]

combined = names.zip(ages, cities)
# [["Alice", 25, "NYC"], ["Bob", 30, "LA"], ["Charlie", 35, "Chicago"]]

# Array sampling
data = (1..100).to_a
sample = data.sample(5)  # Random 5 elements
shuffled = data.shuffle   # Randomize order

# Partitioning
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
evens, odds = numbers.partition(&:even?)
# evens = [2, 4, 6, 8], odds = [1, 3, 5, 7, 9]

# Grouping
people = [
  { name: "Alice", age: 25 },
  { name: "Bob", age: 30 },
  { name: "Charlie", age: 25 },
  { name: "David", age: 30 }
]

by_age = people.group_by { |p| p[:age] }
# {25 => [{name: "Alice", age: 25}, {name: "Charlie", age: 25}],
#  30 => [{name: "Bob", age: 30}, {name: "David", age: 30}]}
```

### Real-World Array Example: Data Processing Pipeline
```ruby
class DataProcessor
  def self.process_sales_data(raw_data)
    raw_data
      .reject { |sale| sale[:amount].nil? }  # Remove invalid
      .select { |sale| sale[:status] == 'completed' }  # Only completed
      .sort_by { |sale| -sale[:amount] }  # Sort by amount desc
      .take(10)  # Top 10
      .map do |sale|
        {
          id: sale[:id],
          customer: sale[:customer_name],
          amount: "$#{'%.2f' % sale[:amount]}",
          date: sale[:date].strftime('%Y-%m-%d')
        }
      end
  end

  def self.calculate_statistics(numbers)
    sorted = numbers.sort
    {
      count: numbers.size,
      sum: numbers.sum,
      mean: numbers.sum.to_f / numbers.size,
      median: sorted[sorted.size / 2],
      min: numbers.min,
      max: numbers.max,
      range: numbers.max - numbers.min,
      std_dev: calculate_std_dev(numbers)
    }
  end

  private

  def self.calculate_std_dev(numbers)
    mean = numbers.sum.to_f / numbers.size
    variance = numbers.map { |n| (n - mean) ** 2 }.sum / numbers.size
    Math.sqrt(variance)
  end
end
```

### Practice Exercises

**Exercise 5.1:** Array Challenges
```ruby
# 1. Implement a method to find all subarrays of given size
def sliding_window(arr, size)
  # Input: [1, 2, 3, 4, 5], 3
  # Output: [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
end

# 2. Find the two numbers that sum to target
def two_sum(arr, target)
  # Input: [2, 7, 11, 15], 9
  # Output: [0, 1]  # indices
end

# 3. Rotate matrix 90 degrees clockwise
def rotate_matrix(matrix)
  # Input: [[1,2,3],[4,5,6],[7,8,9]]
  # Output: [[7,4,1],[8,5,2],[9,6,3]]
end

# 4. Find longest consecutive sequence
def longest_consecutive(arr)
  # Input: [100, 4, 200, 1, 3, 2]
  # Output: 4  # [1, 2, 3, 4]
end
```

---

## 6. Hashes - Deep Dive

### Hash Creation and Access
```ruby
# Different ways to create hashes
empty = {}
empty = Hash.new

# Literal notation
person = { name: "John", age: 30, city: "NYC" }

# String keys
config = { "host" => "localhost", "port" => 3000 }

# Mixed keys
mixed = { :symbol => "value", "string" => "value", 42 => "number key" }

# Hash with default value
counts = Hash.new(0)  # Default value is 0
counts[:apple] += 1   # Works even though :apple doesn't exist yet

# Hash with default block
fibonacci = Hash.new { |hash, key|
  hash[key] = hash[key-1] + hash[key-2]
}
fibonacci[0] = 0
fibonacci[1] = 1
puts fibonacci[10]  # Automatically calculates

# Accessing values
person[:name]         # "John"
person.fetch(:age)    # 30
person.fetch(:email, "N/A")  # "N/A" (default if not found)
person.fetch(:email) { |key| "No #{key} found" }  # Block for default

# Multiple assignment
name, age = person.values_at(:name, :age)
```

### Hash Manipulation
```ruby
# Merging hashes
defaults = { color: "blue", size: "medium", quantity: 1 }
options = { color: "red", quantity: 3 }

# Non-destructive merge
result = defaults.merge(options)
# { color: "red", size: "medium", quantity: 3 }

# Merge with block for conflicts
inventory1 = { apples: 5, oranges: 10 }
inventory2 = { apples: 3, bananas: 7 }

total = inventory1.merge(inventory2) do |key, old_val, new_val|
  old_val + new_val
end
# { apples: 8, oranges: 10, bananas: 7 }

# Nested hash manipulation
user = {
  name: "John",
  address: {
    street: "123 Main St",
    city: "NYC",
    coordinates: { lat: 40.7, lng: -74.0 }
  }
}

# Deep access
user.dig(:address, :coordinates, :lat)  # 40.7
user.dig(:address, :country)  # nil (safe navigation)

# Transform keys/values
hash = { a: 1, b: 2, c: 3 }

hash.transform_keys(&:to_s)    # {"a"=>1, "b"=>2, "c"=>3}
hash.transform_values { |v| v * 2 }  # {:a=>2, :b=>4, :c=>6}

# Filtering
hash.select { |k, v| v > 1 }   # {:b=>2, :c=>3}
hash.reject { |k, v| v.even? } # {:a=>1, :c=>3}
hash.compact  # Removes nil values

# Invert hash (swap keys and values)
colors = { red: "#FF0000", green: "#00FF00", blue: "#0000FF" }
hex_to_name = colors.invert
# {"#FF0000"=>:red, "#00FF00"=>:green, "#0000FF"=>:blue}
```

### Advanced Hash Patterns
```ruby
# Nested hash with safe defaults
class NestedHash < Hash
  def initialize
    super { |h, k| h[k] = NestedHash.new }
  end
end

stats = NestedHash.new
stats[:users][:active][:count] = 100  # Auto-creates nested structure

# Hash as cache/memoization
class ExpensiveCalculator
  def initialize
    @cache = {}
  end

  def fibonacci(n)
    @cache[n] ||= begin
      return n if n <= 1
      fibonacci(n - 1) + fibonacci(n - 2)
    end
  end
end

# Configuration pattern
class Configuration
  DEFAULTS = {
    database: {
      host: 'localhost',
      port: 5432,
      pool: 5
    },
    redis: {
      host: 'localhost',
      port: 6379
    }
  }.freeze

  def initialize(overrides = {})
    @config = deep_merge(DEFAULTS, overrides)
  end

  private

  def deep_merge(hash1, hash2)
    hash1.merge(hash2) do |key, old, new|
      if old.is_a?(Hash) && new.is_a?(Hash)
        deep_merge(old, new)
      else
        new
      end
    end
  end
end

# Word frequency counter
def word_frequency(text)
  text
    .downcase
    .scan(/\w+/)
    .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
    .sort_by { |word, count| -count }
    .to_h
end
```

### Real-World Hash Example: JSON API Response Handler
```ruby
class APIResponseHandler
  def self.parse_user_response(json_response)
    data = JSON.parse(json_response, symbolize_names: true)

    # Extract and transform user data
    {
      id: data[:id],
      name: "#{data[:first_name]} #{data[:last_name]}",
      email: data[:email]&.downcase,
      active: data[:status] == 'active',
      roles: data.fetch(:roles, []).map(&:to_sym),
      metadata: {
        created_at: Time.parse(data[:created_at]),
        last_login: data[:last_login] ? Time.parse(data[:last_login]) : nil,
        preferences: data.dig(:settings, :preferences) || {}
      }
    }
  rescue JSON::ParserError => e
    { error: "Invalid JSON: #{e.message}" }
  end

  def self.build_query_params(options = {})
    defaults = { page: 1, per_page: 20, sort: 'created_at' }
    params = defaults.merge(options.compact)

    params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
  end
end
```

### Practice Exercises

**Exercise 6.1:** Hash Operations
```ruby
# 1. Group array of hashes by multiple keys
def group_by_multiple(data, *keys)
  # Input: [{name: "John", dept: "IT", role: "Dev"},
  #         {name: "Jane", dept: "IT", role: "Dev"},
  #         {name: "Bob", dept: "HR", role: "Manager"}]
  # group_by_multiple(data, :dept, :role)
  # Output: {"IT"=>{"Dev"=>[john, jane]}, "HR"=>{"Manager"=>[bob]}}
end

# 2. Deep freeze nested hash
def deep_freeze(hash)
  # Make hash and all nested hashes immutable
end

# 3. Diff two hashes
def hash_diff(hash1, hash2)
  # Return differences between two hashes
  # Including nested differences
end

# 4. Flatten nested hash
def flatten_hash(hash, prefix = nil)
  # Input: {a: {b: {c: 1}}, d: 2}
  # Output: {"a.b.c" => 1, "d" => 2}
end
```

---

# Part 2: Core Ruby Concepts

## 7. Loops and Iterators - Complete Guide

### Traditional Loops
```ruby
# While loop
counter = 0
while counter < 5
  puts "Count: #{counter}"
  counter += 1
end

# Until loop (opposite of while)
number = 10
until number == 0
  puts number
  number -= 1
end

# Loop with break
loop do
  input = gets.chomp
  break if input == 'exit'
  puts "You said: #{input}"
end

# For loop (rarely used in Ruby)
for i in 1..5
  puts i
end

# Better Ruby way
(1..5).each { |i| puts i }
```

### Iterator Methods
```ruby
# Each - the foundation
[1, 2, 3].each do |number|
  puts number * 2
end

# Each with index
['a', 'b', 'c'].each_with_index do |letter, index|
  puts "#{index}: #{letter}"
end

# Each with object (accumulator pattern)
result = [1, 2, 3, 4].each_with_object({}) do |num, hash|
  hash[num] = num ** 2
end
# {1=>1, 2=>4, 3=>9, 4=>16}

# Map/Collect - transformation
names = ['alice', 'bob', 'charlie']
capitalized = names.map(&:capitalize)
# ["Alice", "Bob", "Charlie"]

# Map with index
indexed = names.map.with_index do |name, i|
  "#{i + 1}. #{name}"
end
# ["1. alice", "2. bob", "3. charlie"]

# Select/Filter
numbers = [1, 2, 3, 4, 5, 6]
evens = numbers.select(&:even?)  # [2, 4, 6]
odds = numbers.reject(&:even?)   # [1, 3, 5]

# Find/Detect
users = [
  { name: 'Alice', age: 25 },
  { name: 'Bob', age: 30 },
  { name: 'Charlie', age: 35 }
]

adult = users.find { |u| u[:age] >= 30 }  # First match
all_adults = users.find_all { |u| u[:age] >= 25 }  # All matches

# Reduce/Inject
sum = [1, 2, 3, 4, 5].reduce(0) { |total, n| total + n }
# Or shorter:
sum = [1, 2, 3, 4, 5].reduce(:+)

# Complex reduce example
orders = [
  { product: 'Laptop', price: 1000, quantity: 2 },
  { product: 'Mouse', price: 25, quantity: 5 },
  { product: 'Keyboard', price: 75, quantity: 3 }
]

total = orders.reduce(0) do |sum, order|
  sum + (order[:price] * order[:quantity])
end
# 2350
```

### Advanced Iteration Patterns
```ruby
# Lazy evaluation
# Process large datasets efficiently
(1..Float::INFINITY)
  .lazy
  .select { |n| n % 3 == 0 }
  .select { |n| n % 5 == 0 }
  .take(10)
  .to_a
# First 10 numbers divisible by both 3 and 5

# Cycle - infinite repetition
colors = ['red', 'green', 'blue']
colors.cycle(2) { |color| puts color }
# Prints each color twice

# Step iteration
(0..100).step(10) { |n| puts n }
# 0, 10, 20, 30, ..., 100

# Partition
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
small, large = numbers.partition { |n| n < 5 }
# small = [1, 2, 3, 4], large = [5, 6, 7, 8, 9]

# Group by
words = ['apple', 'banana', 'cherry', 'date', 'elderberry']
by_length = words.group_by(&:length)
# {5=>["apple"], 6=>["banana", "cherry"], 4=>["date"], 10=>["elderberry"]}

# Chunk
numbers = [1, 2, 2, 3, 3, 3, 4, 1, 1]
chunks = numbers.chunk(&:itself).map { |n, arr| [n, arr.size] }
# [[1, 1], [2, 2], [3, 3], [4, 1], [1, 2]]

# Slice methods
arr = [1, 2, 3, 4, 5, 6, 7, 8]
arr.each_slice(3) { |slice| p slice }
# [1, 2, 3], [4, 5, 6], [7, 8]

arr.each_cons(3) { |cons| p cons }
# [1, 2, 3], [2, 3, 4], [3, 4, 5], ..., [6, 7, 8]
```

### Real-World Iterator Example: Data Processing Pipeline
```ruby
class LogAnalyzer
  def analyze_logs(log_file)
    File.readlines(log_file)
      .lazy  # Process line by line, not loading all into memory
      .map(&:chomp)
      .reject { |line| line.empty? }
      .select { |line| line.include?('ERROR') }
      .map { |line| parse_log_line(line) }
      .group_by { |entry| entry[:category] }
      .transform_values { |entries|
        {
          count: entries.size,
          latest: entries.max_by { |e| e[:timestamp] },
          messages: entries.map { |e| e[:message] }.uniq
        }
      }
  end

  private

  def parse_log_line(line)
    match = line.match(/\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] ERROR \[(\w+)\] (.+)/)
    {
      timestamp: Time.parse(match[1]),
      category: match[2],
      message: match[3]
    }
  end
end

# Usage
analyzer = LogAnalyzer.new
error_summary = analyzer.analyze_logs('application.log')
```

### Practice Exercises

**Exercise 7.1:** Custom Iterators
```ruby
# 1. Implement times_with_index
class Integer
  def times_with_index
    # 5.times_with_index { |i| puts "Iteration #{i}" }
    # Should print: Iteration 0, Iteration 1, ..., Iteration 4
  end
end

# 2. Implement take_while_with_index
class Array
  def take_while_with_index
    # [1, 2, 3, 4, 5].take_while_with_index { |n, i| i < 3 }
    # Should return: [1, 2, 3]
  end
end

# 3. Batch processor
def process_in_batches(items, batch_size)
  # Process items in batches with progress
  # Show: "Processing batch 1/3 (items 1-10)"
end

# 4. Retry with backoff
def retry_with_backoff(max_attempts: 3)
  # Retry block with exponential backoff
  # retry_with_backoff { api_call }
  # Waits 1s, 2s, 4s between retries
end
```

---

## 8. Methods, Blocks, Procs, and Lambdas

### Methods - Complete Guide
```ruby
# Method definition styles
def simple_method
  "Hello"
end

# With parameters
def greet(name, greeting = "Hello")
  "#{greeting}, #{name}!"
end

# Optional parameters
def create_user(name, email, role: 'user', active: true)
  {
    name: name,
    email: email,
    role: role,
    active: active
  }
end

# Splat operator
def sum(*numbers)
  numbers.reduce(0, :+)
end

sum(1, 2, 3, 4, 5)  # 15

# Double splat (keyword arguments)
def configure(**options)
  defaults = { timeout: 30, retries: 3 }
  defaults.merge(options)
end

configure(timeout: 60, retries: 5, debug: true)

# Method with block
def with_timing(label = "Operation")
  start = Time.now
  result = yield if block_given?
  elapsed = Time.now - start
  puts "#{label} took #{elapsed} seconds"
  result
end

result = with_timing("Database query") do
  sleep(1)
  "Query result"
end

# Method aliasing
class String
  alias_method :original_upcase, :upcase

  def upcase
    puts "Upcasing: #{self}"
    original_upcase
  end
end

# Method visibility
class BankAccount
  def deposit(amount)
    add_to_balance(amount)
    log_transaction('deposit', amount)
  end

  private  # Everything below is private

  def add_to_balance(amount)
    @balance += amount
  end

  def log_transaction(type, amount)
    @transactions << { type: type, amount: amount }
  end

  protected  # Accessible by other instances of same class

  def internal_transfer(other_account, amount)
    # Can access other_account's protected methods
  end
end
```

### Blocks - The Ruby Way
```ruby
# Block basics
[1, 2, 3].each { |n| puts n }  # Single line

[1, 2, 3].each do |n|  # Multi-line
  square = n ** 2
  puts square
end

# Yield patterns
def execute_around
  puts "Setup"
  yield if block_given?
  puts "Cleanup"
end

execute_around do
  puts "Main operation"
end

# Yield with parameters
def repeat(times)
  times.times { |i| yield(i) }
end

repeat(3) { |i| puts "Iteration #{i}" }

# Block with return value
def transform
  result = yield(10)
  "Transformed: #{result}"
end

output = transform { |n| n * 2 }  # "Transformed: 20"

# Capturing blocks
def make_proc(&block)
  block  # Returns Proc object
end

my_proc = make_proc { |x| x * 2 }
my_proc.call(5)  # 10
```

### Procs - Stored Blocks
```ruby
# Creating Procs
my_proc = Proc.new { |x| x * 2 }
my_proc = proc { |x| x * 2 }  # Kernel#proc

# Calling Procs
my_proc.call(5)     # 10
my_proc[5]          # 10
my_proc.(5)         # 10
my_proc === 5       # 10 (case equality)

# Proc characteristics
flexible_proc = Proc.new { |a, b| "#{a} and #{b}" }
flexible_proc.call(1)        # "1 and " (no error!)
flexible_proc.call(1, 2, 3)  # "1 and 2" (ignores extra)

# Proc with return
def method_with_proc
  my_proc = Proc.new { return "Proc return" }
  my_proc.call
  "Method end"  # Never reached!
end

# Proc as callback
class EventEmitter
  def initialize
    @callbacks = Hash.new { |h, k| h[k] = [] }
  end

  def on(event, &block)
    @callbacks[event] << block
  end

  def emit(event, *args)
    @callbacks[event].each { |callback| callback.call(*args) }
  end
end

emitter = EventEmitter.new
emitter.on(:data) { |data| puts "Received: #{data}" }
emitter.emit(:data, "Hello")
```

### Lambdas - Stricter Procs
```ruby
# Creating Lambdas
my_lambda = lambda { |x| x * 2 }
my_lambda = ->(x) { x * 2 }  # Stabby lambda

# Lambda characteristics
strict_lambda = ->(a, b) { "#{a} and #{b}" }
# strict_lambda.call(1)      # ArgumentError
# strict_lambda.call(1, 2, 3) # ArgumentError
strict_lambda.call(1, 2)     # "1 and 2" (exact arity)

# Lambda with return
def method_with_lambda
  my_lambda = -> { return "Lambda return" }
  result = my_lambda.call
  "Method end: #{result}"  # This executes!
end

# Currying with lambdas
multiply = ->(x, y) { x * y }
double = multiply.curry[2]
triple = multiply.curry[3]

double.call(5)  # 10
triple.call(5)  # 15

# Functional composition
add_one = ->(x) { x + 1 }
double = ->(x) { x * 2 }
square = ->(x) { x ** 2 }

# Compose functions
composed = ->(x) { square.call(double.call(add_one.call(x))) }
composed.call(3)  # ((3 + 1) * 2) ** 2 = 64

# Method to lambda
def regular_method(x)
  x * 2
end

method_lambda = method(:regular_method).to_proc
method_lambda.call(5)  # 10
```

### Real-World Example: DSL Builder
```ruby
class DSLBuilder
  def initialize(&block)
    @routes = {}
    @middleware = []
    instance_eval(&block) if block_given?
  end

  def get(path, &handler)
    @routes[:get] ||= {}
    @routes[:get][path] = handler
  end

  def post(path, &handler)
    @routes[:post] ||= {}
    @routes[:post][path] = handler
  end

  def use(middleware)
    @middleware << middleware
  end

  def call(method, path, params = {})
    handler = @routes.dig(method, path)
    return "404 Not Found" unless handler

    # Apply middleware
    result = params
    @middleware.each do |mw|
      result = mw.call(result)
    end

    handler.call(result)
  end
end

# Usage
app = DSLBuilder.new do
  use ->(params) { params.merge(timestamp: Time.now) }
  use ->(params) { params.transform_keys(&:to_sym) }

  get '/hello' do |params|
    "Hello, #{params[:name] || 'World'}!"
  end

  post '/users' do |params|
    "Creating user: #{params[:name]}"
  end
end

puts app.call(:get, '/hello', { 'name' => 'Ruby' })
```

### Practice Exercises

**Exercise 8.1:** Method Design Patterns
```ruby
# 1. Create a method that accepts multiple types of arguments
def flexible_formatter(*args, **options)
  # flexible_formatter(1, 2, 3, separator: ', ', prefix: '[', suffix: ']')
  # Should return: "[1, 2, 3]"
end

# 2. Implement method memoization
def memoize(method_name)
  # Add memoization to any method
  # class Calculator
  #   memoize def expensive_calculation(n)
  #     sleep(1)
  #     n * n
  #   end
  # end
end

# 3. Create a retry mechanism
def with_retry(times: 3, delay: 1, &block)
  # Retry block on failure with exponential backoff
end

# 4. Build a pipeline processor
class Pipeline
  # Pipeline.new
  #   .add { |x| x * 2 }
  #   .add { |x| x + 1 }
  #   .process(5)  # => 11
end
```

---

# Part 3: Object-Oriented Programming

## 9. Classes and Objects - Mastery Level

### Class Definition and Object Creation
```ruby
# Basic class
class Person
  # Class variable (shared across all instances)
  @@count = 0

  # Constants
  SPECIES = "Homo sapiens"

  # Initialize method (constructor)
  def initialize(name, age)
    @name = name  # Instance variable
    @age = age
    @@count += 1
  end

  # Instance methods
  def introduce
    "Hi, I'm #{@name} and I'm #{@age} years old"
  end

  # Class methods
  def self.count
    @@count
  end

  def self.species
    SPECIES
  end
end

# Creating objects
person1 = Person.new("Alice", 30)
person2 = Person.new("Bob", 25)

puts Person.count  # 2
puts person1.introduce
```

### Attribute Accessors
```ruby
class Product
  attr_reader :name, :sku      # Read-only
  attr_writer :stock            # Write-only
  attr_accessor :price, :description  # Read/write

  def initialize(name, sku, price)
    @name = name
    @sku = sku
    @price = price
    @stock = 0
    @description = ""
  end

  # Custom getter
  def price_with_tax
    @price * 1.1
  end

  # Custom setter with validation
  def price=(value)
    raise "Price must be positive" if value <= 0
    @price = value
  end
end

product = Product.new("Laptop", "SKU123", 999.99)
product.price = 899.99
product.stock = 10
puts product.price_with_tax
```

### Inheritance
```ruby
# Base class
class Vehicle
  attr_reader :make, :model, :year

  def initialize(make, model, year)
    @make = make
    @model = model
    @year = year
  end

  def start
    "Starting the engine"
  end

  def info
    "#{@year} #{@make} #{@model}"
  end
end

# Derived class
class Car < Vehicle
  attr_reader :doors

  def initialize(make, model, year, doors)
    super(make, model, year)  # Call parent constructor
    @doors = doors
  end

  # Override parent method
  def start
    "#{super}... Vroom vroom!"  # Call parent method
  end

  # Additional method
  def honk
    "Beep beep!"
  end
end

class Motorcycle < Vehicle
  def start
    "#{super}... Vroom!"
  end

  def wheelie
    "Doing a wheelie!"
  end
end

car = Car.new("Toyota", "Camry", 2022, 4)
puts car.start  # "Starting the engine... Vroom vroom!"
puts car.info   # "2022 Toyota Camry"
```

### Modules and Mixins
```ruby
# Module as mixin
module Trackable
  def track
    @tracked_at = Time.now
    "Tracked at #{@tracked_at}"
  end

  def tracked?
    !@tracked_at.nil?
  end
end

# Module as namespace
module Authentication
  class User
    attr_reader :username

    def initialize(username, password)
      @username = username
      @password = encrypt(password)
    end

    private

    def encrypt(password)
      # Simple hash for demo
      password.bytes.sum
    end
  end

  class Session
    def self.create(user)
      "Session for #{user.username}"
    end
  end
end

# Multiple inheritance through mixins
module Payable
  def process_payment(amount)
    @balance ||= 0
    @balance += amount
    "Payment of $#{amount} processed"
  end
end

module Shippable
  def ship_to(address)
    @shipping_address = address
    "Shipping to #{address}"
  end
end

class Order
  include Trackable
  include Payable
  include Shippable

  attr_reader :id

  def initialize(id)
    @id = id
  end
end

order = Order.new(123)
puts order.track
puts order.process_payment(99.99)
puts order.ship_to("123 Main St")
```

### Advanced OOP Concepts
```ruby
# Singleton pattern
require 'singleton'

class Database
  include Singleton

  attr_reader :connection

  def initialize
    @connection = establish_connection
  end

  private

  def establish_connection
    "Connected to database"
  end
end

# Usage
db1 = Database.instance
db2 = Database.instance
puts db1.object_id == db2.object_id  # true

# Class inheritance chain
class Animal; end
module Walkable; end
module Swimmable; end

class Dog < Animal
  include Walkable
  prepend Swimmable
end

puts Dog.ancestors
# [Swimmable, Dog, Walkable, Animal, Object, Kernel, BasicObject]

# Method visibility and access control
class BankAccount
  def initialize(balance)
    @balance = balance
  end

  # Public method
  def deposit(amount)
    add_funds(amount)
    log_transaction("Deposit", amount)
  end

  def withdraw(amount)
    if sufficient_funds?(amount)
      subtract_funds(amount)
      log_transaction("Withdrawal", amount)
    else
      "Insufficient funds"
    end
  end

  private

  def add_funds(amount)
    @balance += amount
  end

  def subtract_funds(amount)
    @balance -= amount
  end

  def sufficient_funds?(amount)
    @balance >= amount
  end

  protected

  def log_transaction(type, amount)
    puts "[#{Time.now}] #{type}: $#{amount}"
  end
end
```

### Real-World OOP Example: E-commerce System
```ruby
# Base classes and modules
module Validatable
  def valid?
    validate
  end

  def errors
    @errors ||= []
  end

  private

  def add_error(message)
    errors << message
  end
end

module Timestampable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def with_timestamps
      attr_accessor :created_at, :updated_at

      define_method :initialize do |*args|
        super(*args)
        @created_at = Time.now
        @updated_at = Time.now
      end

      define_method :touch do
        @updated_at = Time.now
      end
    end
  end
end

class Product
  include Validatable
  include Timestampable

  with_timestamps

  attr_accessor :name, :price, :sku, :stock

  def initialize(name:, price:, sku:, stock: 0)
    @name = name
    @price = price
    @sku = sku
    @stock = stock
    super()
  end

  def in_stock?
    @stock > 0
  end

  def add_stock(quantity)
    @stock += quantity
    touch
  end

  private

  def validate
    add_error("Name can't be blank") if @name.nil? || @name.empty?
    add_error("Price must be positive") if @price <= 0
    add_error("SKU can't be blank") if @sku.nil? || @sku.empty?
    errors.empty?
  end
end

class Customer
  include Validatable

  attr_accessor :name, :email, :address

  def initialize(name:, email:, address: nil)
    @name = name
    @email = email
    @address = address
    @orders = []
  end

  def add_order(order)
    @orders << order
  end

  def order_history
    @orders
  end

  private

  def validate
    add_error("Name can't be blank") if @name.nil? || @name.empty?
    add_error("Invalid email") unless @email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    errors.empty?
  end
end

class Order
  include Timestampable

  with_timestamps

  attr_reader :customer, :items, :status

  def initialize(customer:)
    @customer = customer
    @items = []
    @status = :pending
    super()
  end

  def add_item(product, quantity)
    if product.in_stock? && product.stock >= quantity
      @items << { product: product, quantity: quantity }
      product.add_stock(-quantity)
      touch
      true
    else
      false
    end
  end

  def total
    @items.reduce(0) do |sum, item|
      sum + (item[:product].price * item[:quantity])
    end
  end

  def process!
    @status = :processing
    touch
  end

  def complete!
    @status = :completed
    @completed_at = Time.now
    touch
  end

  def cancel!
    @status = :cancelled
    @items.each do |item|
      item[:product].add_stock(item[:quantity])
    end
    touch
  end
end

# Usage
product1 = Product.new(name: "Laptop", price: 999.99, sku: "LAP001", stock: 10)
product2 = Product.new(name: "Mouse", price: 29.99, sku: "MOU001", stock: 50)

customer = Customer.new(name: "John Doe", email: "john@example.com")

if customer.valid?
  order = Order.new(customer: customer)
  order.add_item(product1, 1)
  order.add_item(product2, 2)

  puts "Order total: $#{order.total}"
  order.process!
  order.complete!

  customer.add_order(order)
else
  puts customer.errors
end
```

### Practice Exercises

**Exercise 9.1:** Design Pattern Implementation
```ruby
# 1. Implement Observer pattern
class Subject
  # Observers should be notified of state changes
end

class Observer
  # Should receive updates from subject
end

# 2. Implement Factory pattern
class VehicleFactory
  # Should create different types of vehicles based on input
  # VehicleFactory.create('car', make: 'Toyota', model: 'Camry')
  # VehicleFactory.create('motorcycle', make: 'Honda', model: 'CBR')
end

# 3. Implement Decorator pattern
class Coffee
  # Basic coffee
end

class CoffeeDecorator
  # Add features like milk, sugar, etc.
end

# Usage:
# coffee = Coffee.new
# coffee = MilkDecorator.new(coffee)
# coffee = SugarDecorator.new(coffee)
```

---

# Part 4: Advanced Ruby

## 10. Metaprogramming - The Ruby Magic

### Dynamic Method Definition
```ruby
# define_method
class DynamicClass
  # Define getters and setters dynamically
  [:name, :age, :email].each do |attribute|
    define_method(attribute) do
      instance_variable_get("@#{attribute}")
    end

    define_method("#{attribute}=") do |value|
      instance_variable_set("@#{attribute}", value)
    end
  end

  # Define methods with logic
  %w[create update delete].each do |action|
    define_method("#{action}_user") do |user_id|
      "#{action.capitalize} user with ID: #{user_id}"
    end
  end
end

obj = DynamicClass.new
obj.name = "John"
puts obj.name
puts obj.create_user(123)
```

### method_missing
```ruby
class FlexibleHash
  def initialize
    @attributes = {}
  end

  def method_missing(method_name, *args, &block)
    # Setter method (ends with =)
    if method_name.to_s.end_with?('=')
      attribute = method_name.to_s.chomp('=')
      @attributes[attribute.to_sym] = args.first
    # Getter method
    elsif @attributes.key?(method_name)
      @attributes[method_name]
    # Query method (ends with ?)
    elsif method_name.to_s.end_with?('?')
      attribute = method_name.to_s.chomp('?')
      !@attributes[attribute.to_sym].nil?
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.end_with?('=', '?') ||
    @attributes.key?(method_name) ||
    super
  end
end

obj = FlexibleHash.new
obj.name = "Ruby"
obj.version = 3.0
puts obj.name        # "Ruby"
puts obj.version     # 3.0
puts obj.name?       # true
puts obj.missing?    # false
```

### Class and Module Eval
```ruby
# class_eval / module_eval
class Person
  attr_accessor :name
end

Person.class_eval do
  def say_hello
    "Hello, I'm #{@name}"
  end

  attr_accessor :age
end

# Add methods to specific instance
person = Person.new
person.instance_eval do
  @name = "John"
  @secret = "I love Ruby"

  def reveal_secret
    @secret
  end
end

puts person.reveal_secret  # Works for this instance only

# Evaluate string as code
Person.class_eval <<-CODE
  def dynamic_method
    "Created from string"
  end
CODE

# Module extension
module Countable
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      attr_accessor :count

      def initialize(*args)
        super(*args) if defined?(super)
        @count = 0
        self.class.increment_total
      end
    end
  end

  module ClassMethods
    def total_count
      @total_count ||= 0
    end

    def increment_total
      @total_count = total_count + 1
    end
  end
end

class Widget
  include Countable
end

w1 = Widget.new
w2 = Widget.new
puts Widget.total_count  # 2
```

### Hook Methods
```ruby
# Method hooks
class TrackedClass
  def self.method_added(method_name)
    puts "Method added: #{method_name}"
  end

  def self.method_removed(method_name)
    puts "Method removed: #{method_name}"
  end

  def self.method_undefined(method_name)
    puts "Method undefined: #{method_name}"
  end
end

class SubClass < TrackedClass
  def new_method  # Triggers method_added
    "Hello"
  end

  remove_method :new_method  # Triggers method_removed
end

# Module hooks
module Trackable
  def self.included(base)
    puts "#{self} was included in #{base}"
    base.extend(ClassMethods)
  end

  def self.extended(base)
    puts "#{self} was extended by #{base}"
  end

  def self.prepended(base)
    puts "#{self} was prepended to #{base}"
  end

  module ClassMethods
    def tracked_method
      "This is a class method"
    end
  end
end

# Inheritance hook
class Parent
  def self.inherited(subclass)
    puts "#{subclass} inherits from #{self}"
    subclass.class_eval do
      def special_method
        "Added to all subclasses"
      end
    end
  end
end

class Child < Parent  # Triggers inherited hook
end
```

### Advanced Introspection
```ruby
class Inspector
  attr_accessor :name, :value

  def initialize(name, value)
    @name = name
    @value = value
    @secret = "hidden"
  end

  def public_method
    "Public"
  end

  private

  def private_method
    "Private"
  end

  protected

  def protected_method
    "Protected"
  end
end

obj = Inspector.new("Test", 123)

# Introspection methods
puts obj.class                          # Inspector
puts obj.class.superclass               # Object
puts obj.class.ancestors                # [Inspector, Object, Kernel, BasicObject]

puts obj.instance_variables             # [:@name, :@value, :@secret]
puts obj.instance_variable_get(:@secret) # "hidden"
obj.instance_variable_set(:@secret, "revealed")

puts obj.methods.grep(/method/)         # All methods containing "method"
puts obj.public_methods(false)          # Only public methods defined in class
puts obj.private_methods(false)         # Only private methods defined in class
puts obj.respond_to?(:public_method)    # true
puts obj.respond_to?(:private_method)   # false
puts obj.respond_to?(:private_method, true) # true (include private)

# Method objects
method_obj = obj.method(:public_method)
puts method_obj.call                    # "Public"
puts method_obj.owner                   # Inspector
puts method_obj.arity                   # 0 (number of arguments)
puts method_obj.source_location         # [filename, line_number]
```

### Real-World Metaprogramming: ORM Implementation
```ruby
# Simple Active Record-like ORM
module SimpleORM
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def table_name(name = nil)
      if name
        @table_name = name
      else
        @table_name ||= "#{self.name.downcase}s"
      end
    end

    def field(name, type = :string)
      fields[name] = type

      # Create getter
      define_method(name) do
        @attributes[name]
      end

      # Create setter
      define_method("#{name}=") do |value|
        @attributes[name] = cast_value(value, type)
      end

      # Create query method
      define_method("#{name}?") do
        !@attributes[name].nil? && @attributes[name] != false
      end
    end

    def fields
      @fields ||= {}
    end

    def find(id)
      # Simulate database fetch
      data = fetch_from_db(id)
      new(data)
    end

    def where(conditions)
      # Simulate database query
      results = query_db(conditions)
      results.map { |data| new(data) }
    end

    private

    def fetch_from_db(id)
      # Simulate database
      { id: id, name: "User #{id}", email: "user#{id}@example.com", age: 25 }
    end

    def query_db(conditions)
      # Simulate database query
      [
        { id: 1, name: "Alice", email: "alice@example.com", age: 30 },
        { id: 2, name: "Bob", email: "bob@example.com", age: 25 }
      ].select do |record|
        conditions.all? { |key, value| record[key] == value }
      end
    end
  end

  def initialize(attributes = {})
    @attributes = {}
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def save
    if @attributes[:id]
      update_record
    else
      create_record
    end
  end

  def attributes
    @attributes.dup
  end

  private

  def cast_value(value, type)
    case type
    when :integer
      value.to_i
    when :float
      value.to_f
    when :boolean
      !!value
    else
      value.to_s
    end
  end

  def create_record
    @attributes[:id] = Time.now.to_i
    puts "Creating record in #{self.class.table_name}: #{@attributes.inspect}"
    true
  end

  def update_record
    puts "Updating record in #{self.class.table_name}: #{@attributes.inspect}"
    true
  end
end

# Usage
class User
  include SimpleORM

  table_name :users

  field :id, :integer
  field :name, :string
  field :email, :string
  field :age, :integer
  field :active, :boolean
end

user = User.new(name: "John", email: "john@example.com", age: "30")
puts user.name       # "John"
puts user.age        # 30 (converted to integer)
user.active = true
puts user.active?    # true
user.save           # Creating record

found_user = User.find(1)
puts found_user.name # "User 1"
```

### Practice Exercises

**Exercise 10.1:** Build a DSL
```ruby
# Create a configuration DSL
class Configuration
  # Should support:
  # Configuration.build do
  #   database do
  #     host 'localhost'
  #     port 5432
  #     username 'admin'
  #   end
  #
  #   cache do
  #     provider :redis
  #     ttl 3600
  #   end
  # end
end

# Exercise 10.2: Method Chain Builder
class QueryBuilder
  # Should support:
  # QueryBuilder.new
  #   .select(:id, :name)
  #   .from(:users)
  #   .where(age: 18)
  #   .order(:created_at, :desc)
  #   .limit(10)
  #   .to_sql
  # => "SELECT id, name FROM users WHERE age = 18 ORDER BY created_at DESC LIMIT 10"
end

# Exercise 10.3: Attribute Validator
module Validatable
  # Should support:
  # class User
  #   include Validatable
  #
  #   validate :name, presence: true, length: { min: 2, max: 50 }
  #   validate :email, presence: true, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #   validate :age, numericality: { greater_than: 0, less_than: 150 }
  # end
end
```

---

# Part 5: Real-World Applications

## 11. File I/O and System Operations

### File Reading and Writing
```ruby
# Reading files - different methods
# Method 1: Read entire file
content = File.read('data.txt')

# Method 2: Read lines into array
lines = File.readlines('data.txt')
lines_chomped = File.readlines('data.txt', chomp: true)

# Method 3: Read with block (memory efficient)
File.open('large_file.txt', 'r') do |file|
  file.each_line do |line|
    process_line(line)
  end
end

# Method 4: Read specific bytes
File.open('binary.dat', 'rb') do |file|
  header = file.read(64)  # Read first 64 bytes
  file.seek(100)          # Skip to byte 100
  data = file.read(1024)  # Read 1KB
end

# Writing files
# Method 1: Write entire content
File.write('output.txt', "Hello World\n")

# Method 2: Append to file
File.write('log.txt', "New entry\n", mode: 'a')

# Method 3: Write with block
File.open('data.txt', 'w') do |file|
  file.puts "Line 1"
  file.write "Line 2\n"
  file << "Line 3\n"
end

# Method 4: Binary write
File.open('binary.dat', 'wb') do |file|
  file.write([1, 2, 3, 4].pack('C*'))  # Write bytes
end

# Atomic write (write to temp, then rename)
require 'tempfile'

def atomic_write(filename)
  temp_file = Tempfile.new(File.basename(filename))
  yield temp_file
  temp_file.close
  FileUtils.mv(temp_file.path, filename)
end

atomic_write('important.txt') do |file|
  file.write("Critical data")
end
```

### CSV Processing
```ruby
require 'csv'

# Reading CSV
CSV.foreach('data.csv', headers: true) do |row|
  puts "#{row['name']}: #{row['age']}"
end

# Parse CSV from string
csv_text = "name,age\nAlice,30\nBob,25"
data = CSV.parse(csv_text, headers: true)

# Writing CSV
CSV.open('output.csv', 'w') do |csv|
  csv << ['Name', 'Age', 'City']  # Headers
  csv << ['Alice', 30, 'NYC']
  csv << ['Bob', 25, 'LA']
end

# Generate CSV string
csv_string = CSV.generate do |csv|
  csv << ['Product', 'Price']
  products.each do |product|
    csv << [product.name, product.price]
  end
end

# Advanced CSV with converters
CSV.foreach('data.csv',
  headers: true,
  converters: [:numeric, :date],
  header_converters: :symbol
) do |row|
  # Headers are symbols, numbers/dates auto-converted
  puts row[:price]  # Already a number
  puts row[:date]   # Already a Date object
end
```

### JSON Handling
```ruby
require 'json'

# Parse JSON
json_string = '{"name": "Alice", "age": 30, "skills": ["Ruby", "JS"]}'
data = JSON.parse(json_string)
# With symbolized keys
data = JSON.parse(json_string, symbolize_names: true)

# Generate JSON
user = {
  name: "Bob",
  age: 25,
  active: true,
  skills: ["Python", "Go"]
}

json = JSON.generate(user)
pretty_json = JSON.pretty_generate(user)

# Streaming JSON parser for large files
require 'json/streaming'

File.open('large.json', 'r') do |file|
  parser = JSON::Stream::Parser.new

  parser.on_object do |object|
    process_object(object)
  end

  parser.parse(file)
end

# Custom JSON serialization
class User
  attr_accessor :name, :email, :age

  def to_json(*args)
    {
      name: @name,
      email: @email,
      age: @age,
      created_at: Time.now
    }.to_json(*args)
  end

  def self.from_json(json_string)
    data = JSON.parse(json_string)
    user = new
    user.name = data['name']
    user.email = data['email']
    user.age = data['age']
    user
  end
end
```

### System Operations
```ruby
# Execute system commands
# Method 1: Backticks (returns output)
output = `ls -la`
puts output

# Method 2: system (returns true/false)
success = system('git', 'status')
puts "Command succeeded" if success

# Method 3: exec (replaces current process)
# exec('ls', '-la')  # No code after this runs

# Method 4: spawn (non-blocking)
pid = spawn('long_running_process')
Process.wait(pid)  # Wait for completion

# Method 5: Open3 for advanced control
require 'open3'

stdout, stderr, status = Open3.capture3('ls', '-la')
puts "Output: #{stdout}"
puts "Errors: #{stderr}"
puts "Success: #{status.success?}"

# Stream processing
Open3.popen3('grep', 'pattern') do |stdin, stdout, stderr, thread|
  stdin.puts "Line with pattern"
  stdin.puts "Line without"
  stdin.close

  puts stdout.read
end

# Environment variables
ENV['MY_VAR'] = 'value'
puts ENV['PATH']
puts ENV.fetch('MISSING', 'default')

# Process information
puts Process.pid        # Current process ID
puts Process.ppid       # Parent process ID
puts Process.uid        # User ID
puts Process.gid        # Group ID

# Directory operations
Dir.mkdir('new_folder') unless Dir.exist?('new_folder')
Dir.chdir('new_folder') do
  # Work in new_folder
  puts Dir.pwd
end

# List files
files = Dir.glob('*.rb')
all_files = Dir.entries('.')
ruby_files = Dir['**/*.rb']  # Recursive

# File operations
File.rename('old.txt', 'new.txt')
File.delete('temp.txt') if File.exist?('temp.txt')
FileUtils.cp('source.txt', 'dest.txt')
FileUtils.mv('file.txt', 'other_folder/')
FileUtils.rm_rf('temp_directory')

# File information
stat = File.stat('file.txt')
puts stat.size        # File size
puts stat.mtime       # Modification time
puts stat.mode        # Permissions
puts File.executable?('script.sh')
puts File.writable?('file.txt')
```

### Real-World Example: Log File Analyzer
```ruby
class LogAnalyzer
  def initialize(log_file)
    @log_file = log_file
    @patterns = {
      error: /ERROR/,
      warning: /WARNING/,
      info: /INFO/,
      timestamp: /\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\]/,
      ip_address: /\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/
    }
  end

  def analyze
    stats = Hash.new(0)
    errors = []
    ip_addresses = Set.new

    File.foreach(@log_file) do |line|
      # Count log levels
      @patterns.each do |level, pattern|
        next if [:timestamp, :ip_address].include?(level)
        stats[level] += 1 if line.match?(pattern)
      end

      # Collect errors
      if line.match?(@patterns[:error])
        if timestamp = line.match(@patterns[:timestamp])
          errors << {
            time: timestamp[1],
            message: line.strip
          }
        end
      end

      # Extract IP addresses
      if ip = line.match(@patterns[:ip_address])
        ip_addresses << ip[0]
      end
    end

    {
      total_lines: `wc -l < #{@log_file}`.to_i,
      stats: stats,
      recent_errors: errors.last(10),
      unique_ips: ip_addresses.size,
      report_generated: Time.now
    }
  end

  def generate_report(output_file)
    analysis = analyze

    File.open(output_file, 'w') do |file|
      file.puts "Log Analysis Report"
      file.puts "=" * 50
      file.puts "Generated: #{analysis[:report_generated]}"
      file.puts "Total Lines: #{analysis[:total_lines]}"
      file.puts

      file.puts "Log Level Statistics:"
      analysis[:stats].each do |level, count|
        file.puts "  #{level.to_s.upcase}: #{count}"
      end
      file.puts

      file.puts "Unique IP Addresses: #{analysis[:unique_ips]}"
      file.puts

      if analysis[:recent_errors].any?
        file.puts "Recent Errors:"
        analysis[:recent_errors].each do |error|
          file.puts "  [#{error[:time]}] #{error[:message]}"
        end
      end
    end

    # Also save as JSON
    File.write(
      output_file.sub(/\.\w+$/, '.json'),
      JSON.pretty_generate(analysis)
    )
  end
end

# Usage
analyzer = LogAnalyzer.new('/var/log/application.log')
analyzer.generate_report('log_analysis.txt')
```

### Practice Exercises

**Exercise 11.1:** File System Navigator
```ruby
class FileExplorer
  # Build a file explorer that can:
  # 1. List directory contents with details
  # 2. Search for files by name pattern
  # 3. Find duplicate files by content
  # 4. Calculate directory size recursively
  # 5. Watch for file changes

  def initialize(root_path)
    @root = root_path
  end

  def list_contents(path = @root, options = {})
    # List files with size, permissions, modified time
    # Support sorting and filtering options
  end

  def search(pattern, path = @root)
    # Recursively search for files matching pattern
  end

  def find_duplicates
    # Find files with identical content
  end

  def directory_size(path = @root)
    # Calculate total size recursively
  end

  def watch_changes(&block)
    # Monitor directory for changes
  end
end
```

**Exercise 11.2:** Configuration Manager
```ruby
class ConfigManager
  # Create a configuration manager that:
  # 1. Loads config from multiple formats (JSON, YAML, ENV)
  # 2. Merges configurations with precedence
  # 3. Supports environment-specific configs
  # 4. Validates configuration
  # 5. Hot-reloads on file changes

  def load_config(environment = 'development')
    # Load and merge configurations
  end

  def validate
    # Check required fields and types
  end

  def watch_for_changes
    # Reload config when files change
  end
end
```

---

## 12. Testing and Debugging

### RSpec Testing Framework
```ruby
# Installation: gem install rspec

# Basic test structure
require 'rspec'

class Calculator
  def add(a, b)
    a + b
  end

  def divide(a, b)
    raise ArgumentError, "Division by zero" if b == 0
    a.to_f / b
  end
end

# RSpec tests
RSpec.describe Calculator do
  let(:calculator) { Calculator.new }

  describe '#add' do
    it 'adds two positive numbers' do
      expect(calculator.add(2, 3)).to eq(5)
    end

    it 'handles negative numbers' do
      expect(calculator.add(-5, 3)).to eq(-2)
    end

    it 'handles zero' do
      expect(calculator.add(0, 5)).to eq(5)
    end
  end

  describe '#divide' do
    it 'divides two numbers' do
      expect(calculator.divide(10, 2)).to eq(5.0)
    end

    it 'raises error for division by zero' do
      expect { calculator.divide(10, 0) }.to raise_error(ArgumentError, "Division by zero")
    end

    it 'returns float result' do
      expect(calculator.divide(5, 2)).to be_a(Float)
      expect(calculator.divide(5, 2)).to eq(2.5)
    end
  end
end

# Advanced RSpec features
class UserService
  def initialize(database, mailer)
    @database = database
    @mailer = mailer
  end

  def create_user(attributes)
    user = User.new(attributes)
    if user.valid?
      @database.save(user)
      @mailer.send_welcome_email(user)
      user
    else
      raise "Invalid user"
    end
  end
end

RSpec.describe UserService do
  let(:database) { double('Database') }
  let(:mailer) { double('Mailer') }
  let(:service) { UserService.new(database, mailer) }

  describe '#create_user' do
    context 'with valid attributes' do
      let(:attributes) { { name: 'John', email: 'john@example.com' } }
      let(:user) { double('User', valid?: true) }

      before do
        allow(User).to receive(:new).with(attributes).and_return(user)
        allow(database).to receive(:save).with(user)
        allow(mailer).to receive(:send_welcome_email).with(user)
      end

      it 'saves the user to database' do
        expect(database).to receive(:save).with(user)
        service.create_user(attributes)
      end

      it 'sends welcome email' do
        expect(mailer).to receive(:send_welcome_email).with(user)
        service.create_user(attributes)
      end

      it 'returns the user' do
        expect(service.create_user(attributes)).to eq(user)
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { name: '' } }
      let(:user) { double('User', valid?: false) }

      before do
        allow(User).to receive(:new).with(attributes).and_return(user)
      end

      it 'raises an error' do
        expect { service.create_user(attributes) }.to raise_error("Invalid user")
      end

      it 'does not save to database' do
        expect(database).not_to receive(:save)
        expect { service.create_user(attributes) }.to raise_error
      end
    end
  end
end
```

### Debugging Techniques
```ruby
# 1. puts debugging
def complex_calculation(x, y)
  puts "Starting with x=#{x}, y=#{y}"

  result = x * 2
  puts "After doubling x: #{result}"

  result += y
  puts "After adding y: #{result}"

  result
end

# 2. pp (pretty print)
require 'pp'

complex_data = {
  users: [
    { name: 'Alice', roles: ['admin', 'user'] },
    { name: 'Bob', roles: ['user'] }
  ],
  settings: { theme: 'dark', language: 'en' }
}

pp complex_data

# 3. binding.irb (Ruby 2.4+) or binding.pry
require 'irb'

def problematic_method(data)
  processed = data.map(&:upcase)

  binding.irb  # Drops into IRB console here

  final_result = processed.join(', ')
end

# 4. byebug debugging
require 'byebug'

def debug_this(arr)
  byebug  # Debugger stops here

  result = arr.map { |x| x * 2 }
  result.sum
end

# Byebug commands:
# n (next) - next line
# s (step) - step into
# c (continue) - continue execution
# l (list) - show current code
# p variable - print variable
# pp variable - pretty print
# backtrace - show call stack

# 5. Custom debug helper
class Debug
  def self.log(label, value = nil)
    if block_given?
      start = Time.now
      result = yield
      elapsed = Time.now - start
      puts "[DEBUG] #{label}: #{result} (took #{elapsed}s)"
      result
    else
      puts "[DEBUG] #{label}: #{value.inspect}"
      value
    end
  end
end

# Usage
Debug.log("User data", user)
result = Debug.log("Database query") do
  User.where(active: true).count
end

# 6. Stack trace analysis
begin
  risky_operation
rescue => e
  puts "Error: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.first(5)  # Show first 5 stack frames

  # Custom error with cause
  raise CustomError, "Operation failed", cause: e
end

# 7. Memory debugging
require 'objspace'

# Track object allocations
ObjectSpace.trace_object_allocations_start

# Your code here
big_array = Array.new(10000) { Object.new }

# Analyze memory
ObjectSpace.each_object(Object) do |obj|
  if ObjectSpace.allocation_sourcefile(obj) == __FILE__
    puts "Object: #{obj.class} at line #{ObjectSpace.allocation_sourceline(obj)}"
  end
end

# Memory profiling
GC.stat  # Garbage collection statistics
```

### Performance Testing
```ruby
require 'benchmark'

# Simple benchmark
time = Benchmark.measure do
  1000000.times { "test" * 100 }
end
puts time

# Comparing implementations
n = 1000000
Benchmark.bm(15) do |x|
  x.report("String +:")    { n.times { "hello" + " " + "world" } }
  x.report("String <<:")   { n.times { s = "hello"; s << " " << "world" } }
  x.report("Interpolation:") { n.times { "hello #{' '} world" } }
  x.report("Join:")        { n.times { ["hello", "world"].join(" ") } }
end

# Benchmark with comparison
require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("symbol") { :symbol.to_s }
  x.report("string") { "string" }

  x.compare!
end

# Memory benchmark
require 'benchmark/memory'

Benchmark.memory do |x|
  x.report("Array#map")    { [1,2,3].map { |n| n * 2 } }
  x.report("Array#each")   { arr = []; [1,2,3].each { |n| arr << n * 2 } }

  x.compare!
end

# Custom performance logger
class PerformanceLogger
  def self.measure(operation_name)
    start_time = Time.now
    start_memory = `ps -o rss= -p #{Process.pid}`.to_i

    result = yield

    end_time = Time.now
    end_memory = `ps -o rss= -p #{Process.pid}`.to_i

    puts "Performance: #{operation_name}"
    puts "  Time: #{(end_time - start_time).round(3)}s"
    puts "  Memory: #{((end_memory - start_memory) / 1024.0).round(2)}MB"

    result
  end
end

PerformanceLogger.measure("Heavy computation") do
  # Your code
end
```

### Practice Exercises

**Exercise 12.1:** Test Suite Builder
```ruby
# Create a testing framework
class TestCase
  # Build a mini testing framework that supports:
  # - Test definition with 'test' method
  # - Assertions (assert_equal, assert_true, assert_raises)
  # - Setup and teardown hooks
  # - Test execution with results

  def self.test(name, &block)
    # Define a test
  end

  def assert_equal(expected, actual)
    # Assert equality
  end

  def assert_true(value)
    # Assert truthy
  end

  def assert_raises(exception_class, &block)
    # Assert exception raised
  end
end

# Usage:
class CalculatorTest < TestCase
  def setup
    @calc = Calculator.new
  end

  test "addition" do
    assert_equal 5, @calc.add(2, 3)
  end

  test "division by zero" do
    assert_raises(ZeroDivisionError) { @calc.divide(10, 0) }
  end
end
```

**Exercise 12.2:** Debug Profiler
```ruby
class Profiler
  # Create a profiler that:
  # - Tracks method calls and execution time
  # - Identifies slow methods
  # - Detects memory leaks
  # - Generates performance reports

  def profile(object, method_name)
    # Profile specific method
  end

  def start_profiling
    # Start global profiling
  end

  def generate_report
    # Create performance report
  end
end
```

---

## Final Practice Projects

### Project 1: Build a Web Scraper
```ruby
class WebScraper
  # Requirements:
  # - Fetch web pages
  # - Parse HTML/CSS selectors
  # - Handle pagination
  # - Respect robots.txt
  # - Rate limiting
  # - Export to CSV/JSON
  # - Error handling and retries
end
```

### Project 2: Create a Task Runner (like Rake)
```ruby
class TaskRunner
  # Requirements:
  # - Define tasks with dependencies
  # - Execute tasks in order
  # - Handle arguments
  # - Parallel execution
  # - Namespace support
  # - Task descriptions
end
```

### Project 3: Build a Simple HTTP Server
```ruby
class HTTPServer
  # Requirements:
  # - Handle GET/POST requests
  # - Serve static files
  # - Route matching
  # - Middleware support
  # - Request/Response objects
  # - Basic authentication
end
```

### Project 4: Implement a Cache System
```ruby
class CacheSystem
  # Requirements:
  # - Multiple storage backends (memory, file, Redis)
  # - TTL support
  # - LRU eviction
  # - Cache warming
  # - Cache invalidation
  # - Statistics and monitoring
end
```

### Project 5: Create a Database Query Builder
```ruby
class QueryBuilder
  # Requirements:
  # - SELECT, INSERT, UPDATE, DELETE
  # - Joins and subqueries
  # - Where conditions
  # - Parameter binding
  # - Query optimization
  # - Migration support
end
```

---

## Ruby Best Practices Summary

1. **Code Style**
   - Use 2 spaces for indentation
   - Use snake_case for methods and variables
   - Use CamelCase for classes and modules
   - Use SCREAMING_SNAKE_CASE for constants

2. **Performance**
   - Use symbols for hash keys
   - Prefer single quotes for non-interpolated strings
   - Use lazy enumerators for large datasets
   - Memoize expensive calculations

3. **Safety**
   - Freeze constants and configuration
   - Use safe navigation operator (&.)
   - Handle exceptions appropriately
   - Validate input data

4. **Testing**
   - Write tests first (TDD)
   - Keep tests isolated
   - Use factories instead of fixtures
   - Mock external dependencies

5. **Metaprogramming**
   - Use it sparingly
   - Prefer define_method over eval
   - Always define respond_to_missing?
   - Document metaprogramming heavily

Remember: The path to Ruby mastery is through consistent practice, reading other's code, and building real projects. Focus on understanding concepts deeply rather than memorizing syntax.