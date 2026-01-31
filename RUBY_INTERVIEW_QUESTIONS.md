# Complete Ruby Interview Questions Collection

## Table of Contents
1. [Basic Level Questions (Entry Level)](#basic-level-questions-entry-level)
2. [Intermediate Level Questions (2-4 Years)](#intermediate-level-questions-2-4-years)
3. [Advanced Level Questions (5+ Years)](#advanced-level-questions-5-years)
4. [Expert Level Questions (Senior/Architect)](#expert-level-questions-seniorarchitect)
5. [Framework-Specific Questions](#framework-specific-questions)
6. [System Design Questions](#system-design-questions)
7. [Coding Challenges](#coding-challenges)
8. [Scenario-Based Questions](#scenario-based-questions)

---

## Basic Level Questions (Entry Level)

### Variables and Data Types

**Q1: What are the different types of variables in Ruby?**
```ruby
# Global variables
$global_var = "Accessible everywhere"

# Instance variables
@instance_var = "Belongs to object"

# Class variables
@@class_var = "Shared by all instances"

# Local variables
local_var = "Limited to scope"

# Constants
CONSTANT = "Should not change"
```

**Q2: Difference between symbols and strings?**
```ruby
# Strings - new object each time
str1 = "hello"
str2 = "hello"
str1.object_id == str2.object_id  # false

# Symbols - same object always
sym1 = :hello
sym2 = :hello
sym1.object_id == sym2.object_id  # true

# Memory efficiency
1000.times { :symbol }  # 1 object
1000.times { "string" }  # 1000 objects
```

**Q3: What is nil in Ruby?**
```ruby
# nil is Ruby's representation of "nothing"
nil.class  # NilClass

# Only nil and false are falsy
!!nil     # false
!!false   # false
!!0       # true (different from other languages)
!!""      # true
!![]      # true

# nil checking
value.nil?
value&.some_method  # Safe navigation (Ruby 2.3+)
```

**Q4: How do you create an array and hash?**
```ruby
# Arrays
arr1 = []
arr2 = Array.new(3)         # [nil, nil, nil]
arr3 = Array.new(3, 0)      # [0, 0, 0]
arr4 = %w[apple banana]     # ["apple", "banana"]
arr5 = %i[red green blue]   # [:red, :green, :blue]

# Hashes
hash1 = {}
hash2 = Hash.new
hash3 = Hash.new(0)         # Default value 0
hash4 = { name: "John", age: 30 }
hash5 = { :name => "John", :age => 30 }
```

### Methods and Blocks

**Q5: What's the difference between puts, print, and p?**
```ruby
puts "hello"   # Prints with newline, returns nil
print "hello"  # Prints without newline, returns nil
p "hello"      # Prints inspect format, returns object

puts nil       # (blank line)
print nil      # (nothing)
p nil          # nil
```

**Q6: How do you define a method with default parameters?**
```ruby
# Default parameters
def greet(name = "World", greeting = "Hello")
  "#{greeting}, #{name}!"
end

# Keyword arguments (Ruby 2.0+)
def create_user(name:, email:, role: 'user')
  { name: name, email: email, role: role }
end

# Required keyword arguments (Ruby 2.1+)
def process(data:, format:)  # Both required
  "Processing #{data} as #{format}"
end
```

**Q7: What are blocks and how do you use them?**
```ruby
# Block with each
[1, 2, 3].each { |n| puts n }

[1, 2, 3].each do |n|
  puts n * 2
end

# yield in methods
def my_method
  yield if block_given?
  yield "parameter" if block_given?
end

my_method { |param| puts param }

# Block with return value
def transform
  result = yield(10)
  "Result: #{result}"
end

transform { |x| x * 2 }  # "Result: 20"
```

### Basic Ruby Features

**Q8: What are ranges in Ruby?**
```ruby
# Inclusive range
(1..5).to_a        # [1, 2, 3, 4, 5]

# Exclusive range
(1...5).to_a       # [1, 2, 3, 4]

# Character ranges
('a'..'e').to_a    # ["a", "b", "c", "d", "e"]

# Use in case statements
age = 25
case age
when 0..17
  "Minor"
when 18..64
  "Adult"
when 65..120
  "Senior"
end
```

**Q9: How do you iterate over arrays and hashes?**
```ruby
# Arrays
arr = ['a', 'b', 'c']

arr.each { |item| puts item }
arr.each_with_index { |item, i| puts "#{i}: #{item}" }

# Hashes
hash = { name: "John", age: 30 }

hash.each { |key, value| puts "#{key}: #{value}" }
hash.each_key { |key| puts key }
hash.each_value { |value| puts value }
```

**Q10: What's the difference between single and double quotes?**
```ruby
name = "World"

# Single quotes - literal
puts 'Hello, #{name}'  # "Hello, #{name}"

# Double quotes - interpolation
puts "Hello, #{name}"  # "Hello, World"

# Escape sequences
puts 'It\'s a string'  # It's a string
puts "First line\nSecond line"
```

---

## Intermediate Level Questions (2-4 Years)

### Object-Oriented Programming

**Q11: Explain the difference between class and instance variables.**
```ruby
class Counter
  @@total = 0     # Class variable - shared by all instances

  def initialize
    @count = 0    # Instance variable - unique per instance
    @@total += 1
  end

  def increment
    @count += 1
  end

  def self.total
    @@total
  end
end

c1 = Counter.new
c2 = Counter.new
Counter.total  # 2
```

**Q12: What is inheritance and how does it work in Ruby?**
```ruby
class Animal
  def speak
    "Some sound"
  end

  def move
    "Moving"
  end
end

class Dog < Animal
  def speak    # Override parent method
    "Woof"
  end

  def fetch
    "Fetching ball"
  end
end

dog = Dog.new
dog.speak  # "Woof"
dog.move   # "Moving" (inherited)
dog.fetch  # "Fetching ball"

# super keyword
class Cat < Animal
  def speak
    "#{super} but meow"  # "Some sound but meow"
  end
end
```

**Q13: What are modules and mixins?**
```ruby
# Module as namespace
module Authentication
  class User
  end

  class Session
  end
end

# Module as mixin
module Greetable
  def hello
    "Hello!"
  end
end

class Person
  include Greetable  # Instance methods
end

class Robot
  extend Greetable   # Class methods
end

Person.new.hello  # Works
Robot.hello       # Works
```

**Q14: Difference between include, extend, and prepend?**
```ruby
module TestModule
  def test_method
    "From module"
  end
end

class TestClass
  def test_method
    "From class"
  end
end

# include - adds after class in lookup chain
class IncludeTest < TestClass
  include TestModule
end
IncludeTest.new.test_method  # "From class"

# prepend - adds before class in lookup chain
class PrependTest < TestClass
  prepend TestModule
end
PrependTest.new.test_method  # "From module"

# extend - adds as class methods
class ExtendTest < TestClass
  extend TestModule
end
ExtendTest.test_method  # "From module"
```

### Advanced Methods and Blocks

**Q15: What are Proc and Lambda?**
```ruby
# Proc
my_proc = Proc.new { |x| x * 2 }
my_proc = proc { |x| x * 2 }

# Lambda
my_lambda = lambda { |x| x * 2 }
my_lambda = ->(x) { x * 2 }

# Key differences:

# 1. Argument checking
flexible_proc = Proc.new { |a, b| [a, b] }
flexible_proc.call(1)        # [1, nil] - no error
strict_lambda = lambda { |a, b| [a, b] }
# strict_lambda.call(1)      # ArgumentError

# 2. Return behavior
def proc_test
  my_proc = Proc.new { return "proc return" }
  my_proc.call
  "method end"  # Never reached
end

def lambda_test
  my_lambda = lambda { return "lambda return" }
  result = my_lambda.call
  "method end: #{result}"  # This executes
end
```

**Q16: How do you capture blocks as objects?**
```ruby
def method_with_block(&block)
  block.class  # Proc
  block.call if block
end

# Store block for later
class EventHandler
  def initialize
    @callbacks = []
  end

  def on_event(&block)
    @callbacks << block
  end

  def trigger_event(data)
    @callbacks.each { |callback| callback.call(data) }
  end
end

handler = EventHandler.new
handler.on_event { |data| puts "Event: #{data}" }
handler.trigger_event("Something happened")
```

### Error Handling

**Q17: How do you handle exceptions in Ruby?**
```ruby
begin
  # Code that might raise exception
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Can't divide by zero: #{e.message}"
rescue StandardError => e
  puts "General error: #{e.message}"
else
  puts "No exceptions occurred"
ensure
  puts "This always runs"
end

# Custom exceptions
class ValidationError < StandardError
  attr_reader :field

  def initialize(message, field = nil)
    super(message)
    @field = field
  end
end

# Raising exceptions
raise ValidationError.new("Name is required", :name)

# Rescue inline
result = risky_operation rescue "default_value"
```

**Q18: What's the difference between throw/catch and raise/rescue?**
```ruby
# throw/catch - for control flow (not errors)
catch :done do
  1000.times do |i|
    throw :done if i == 500
    puts i
  end
end

# raise/rescue - for exceptions
begin
  raise "Something went wrong"
rescue => e
  puts e.message
end

# Practical throw/catch example
def find_in_nested_array(array, target)
  catch :found do
    array.each do |sub_array|
      sub_array.each do |item|
        throw :found, item if item == target
      end
    end
    nil
  end
end
```

### Regular Expressions

**Q19: How do regular expressions work in Ruby?**
```ruby
# Creating regex
regex1 = /pattern/
regex2 = Regexp.new("pattern")

# Matching
"hello world" =~ /world/     # Returns index or nil
"hello world".match(/world/) # Returns MatchData or nil
"hello world".match?(/world/) # Returns true/false (Ruby 2.4+)

# Captures
match = "2023-12-25".match(/(\d{4})-(\d{2})-(\d{2})/)
match[0]  # "2023-12-25" (full match)
match[1]  # "2023" (first capture)
match[2]  # "12" (second capture)

# String methods with regex
"hello world".split(/\s+/)           # ["hello", "world"]
"hello world".gsub(/\w+/) { |word| word.capitalize }
"hello world".scan(/\w+/)            # ["hello", "world"]
```

### Enumerables and Iterators

**Q20: Explain map, select, and reduce.**
```ruby
numbers = [1, 2, 3, 4, 5]

# map - transform each element
doubled = numbers.map { |n| n * 2 }  # [2, 4, 6, 8, 10]

# select - filter elements
evens = numbers.select { |n| n.even? }  # [2, 4]

# reduce/inject - accumulate value
sum = numbers.reduce(0) { |total, n| total + n }  # 15
sum = numbers.reduce(:+)  # Same as above

# Real example
users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 },
  { name: "Charlie", age: 35 }
]

# Chain operations
adult_names = users
  .select { |u| u[:age] >= 25 }
  .map { |u| u[:name] }
  .sort
```

**Q21: What are the differences between each, map, and select?**
```ruby
arr = [1, 2, 3]

# each - iteration, returns original
result = arr.each { |n| n * 2 }  # Returns [1, 2, 3]

# map - transformation, returns new array
result = arr.map { |n| n * 2 }   # Returns [2, 4, 6]

# select - filtering, returns subset
result = arr.select { |n| n > 1 } # Returns [2, 3]

# collect is alias for map
result = arr.collect { |n| n * 2 } # Same as map

# find vs find_all
arr.find { |n| n > 1 }      # Returns 2 (first match)
arr.find_all { |n| n > 1 }  # Returns [2, 3] (all matches)
```

---

## Advanced Level Questions (5+ Years)

### Metaprogramming

**Q22: Explain method_missing and how to implement it safely.**
```ruby
class FlexibleAPI
  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?('find_by_')
      attribute = method_name.to_s.sub('find_by_', '')
      find_by_attribute(attribute, args.first)
    else
      super  # Important: call super for unknown methods
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('find_by_') || super
  end

  private

  def find_by_attribute(attr, value)
    "Finding records where #{attr} = #{value}"
  end
end

api = FlexibleAPI.new
api.find_by_name("John")
api.find_by_email("john@example.com")
```

**Q23: How do you define methods dynamically?**
```ruby
class DynamicMethods
  # Define methods for each HTTP verb
  %w[get post put delete].each do |verb|
    define_method("#{verb}_request") do |url|
      "#{verb.upcase} #{url}"
    end
  end

  # Define getter/setter methods
  def self.attr_accessor_with_history(*attrs)
    attrs.each do |attr|
      define_method(attr) do
        instance_variable_get("@#{attr}")
      end

      define_method("#{attr}=") do |value|
        @history ||= {}
        @history[attr] ||= []
        @history[attr] << instance_variable_get("@#{attr}")
        instance_variable_set("@#{attr}", value)
      end

      define_method("#{attr}_history") do
        @history ||= {}
        @history[attr] || []
      end
    end
  end
end

class User
  extend DynamicMethods
  attr_accessor_with_history :name, :email
end

user = User.new
user.name = "John"
user.name = "Jane"
user.name_history  # ["John"]
```

**Q24: What is the eigenclass/singleton class?**
```ruby
# Every object has a singleton class
obj = Object.new

# Add method to specific instance
def obj.special_method
  "I'm special!"
end

# This method lives in obj's eigenclass
eigenclass = obj.singleton_class
eigenclass.instance_methods(false)  # [:special_method]

# Class methods are singleton methods of the class object
class MyClass
  def self.class_method  # Singleton method
    "Class method"
  end
end

# Same as:
class << MyClass
  def class_method
    "Class method"
  end
end

# Eigenclass inheritance
class Parent; end
class Child < Parent; end

child = Child.new
class << child
  def unique_method
    "Only for this instance"
  end
end
```

**Q25: How do hook methods work?**
```ruby
class HookedClass
  def self.inherited(subclass)
    puts "#{subclass} inherits from #{self}"

    # Add methods to all subclasses
    subclass.define_method(:special_method) do
      "Added by hook"
    end
  end

  def self.method_added(method_name)
    puts "Method #{method_name} was added"
    return if @defining_wrapper

    @defining_wrapper = true

    # Wrap all methods with logging
    original_method = instance_method(method_name)
    define_method(method_name) do |*args|
      puts "Calling #{method_name}"
      result = original_method.bind(self).call(*args)
      puts "#{method_name} returned #{result}"
      result
    end

    @defining_wrapper = false
  end
end

class Child < HookedClass
  def test_method
    "test result"
  end
end

Child.new.test_method
```

### Memory Management and Performance

**Q26: How does Ruby's garbage collection work?**
```ruby
# Ruby uses mark-and-sweep GC with generations
GC.stat  # Get GC statistics

# Generational GC (Ruby 2.1+)
# - Young generation: newly created objects
# - Old generation: objects that survived multiple GC cycles

# Manual GC control
GC.disable
# Memory intensive work
GC.enable
GC.start  # Force collection

# GC tuning environment variables
# RUBY_GC_HEAP_INIT_SLOTS=600000
# RUBY_GC_MALLOC_LIMIT=100000000
# RUBY_GC_HEAP_GROWTH_FACTOR=1.8

# Memory profiling
require 'objspace'

ObjectSpace.memsize_of(object)
ObjectSpace.count_objects
ObjectSpace.dump_all  # Full heap dump
```

**Q27: What are some Ruby performance optimization techniques?**
```ruby
# 1. String concatenation
# Slow
result = ""
1000.times { |i| result += i.to_s }

# Fast
result = []
1000.times { |i| result << i.to_s }
result.join

# 2. Memoization
class ExpensiveCalculator
  def fibonacci(n)
    @fib_cache ||= {}
    @fib_cache[n] ||= calculate_fibonacci(n)
  end

  private

  def calculate_fibonacci(n)
    return n if n <= 1
    fibonacci(n-1) + fibonacci(n-2)
  end
end

# 3. Use symbols for hash keys
# Slow - creates new strings
options = {"timeout" => 30, "retries" => 3}

# Fast - reuses symbol objects
options = {timeout: 30, retries: 3}

# 4. Avoid creating unnecessary objects
# Slow
1000.times { |i| "Item #{i}" }

# Faster
template = "Item %d"
1000.times { |i| template % i }

# 5. Use lazy evaluation for large datasets
(1..1_000_000).lazy
  .select { |n| n % 2 == 0 }
  .map { |n| n * n }
  .first(10)
```

### Concurrency and Threading

**Q28: How do threads work in Ruby? What is the GIL?**
```ruby
# Global Interpreter Lock (GIL) explanation:
# - Only one Ruby thread can execute at a time
# - I/O operations release the GIL
# - CPU-bound tasks don't benefit from threads

# Thread creation
thread = Thread.new do
  # This code runs in a separate thread
  puts "Thread running"
end

thread.join  # Wait for thread to finish

# Thread-safe operations
mutex = Mutex.new
shared_resource = 0

threads = 10.times.map do
  Thread.new do
    1000.times do
      mutex.synchronize do
        shared_resource += 1
      end
    end
  end
end

threads.each(&:join)
puts shared_resource  # Should be 10000

# Thread-local variables
Thread.current[:user_id] = 123
Thread.current[:session_id] = "abc"
```

**Q29: What are Ractors and how do they differ from threads?**
```ruby
# Ractors (Ruby 3.0+) - True parallelism
# No shared memory, communication via messages

# Simple Ractor
ractor = Ractor.new do
  Ractor.yield("Hello from Ractor")
end

puts ractor.take  # "Hello from Ractor"

# Ractor with input
worker = Ractor.new do
  while msg = Ractor.receive
    case msg
    when Integer
      Ractor.yield(msg * 2)
    when String
      Ractor.yield(msg.upcase)
    when :exit
      break
    end
  end
end

worker.send(10)
puts worker.take  # 20

worker.send("hello")
puts worker.take  # "HELLO"

worker.send(:exit)

# Parallel processing with Ractors
def parallel_map(array, &block)
  ractors = array.map do |item|
    Ractor.new(item, &block)
  end

  ractors.map(&:take)
end

result = parallel_map([1, 2, 3, 4]) { |n| n ** 2 }
```

**Q30: Explain Fibers and their use cases.**
```ruby
# Fibers - cooperative concurrency
fiber = Fiber.new do
  puts "Fiber started"
  Fiber.yield "first yield"
  puts "Fiber resumed"
  Fiber.yield "second yield"
  "final value"
end

puts fiber.resume  # "Fiber started", returns "first yield"
puts fiber.resume  # "Fiber resumed", returns "second yield"
puts fiber.resume  # Returns "final value"

# Generator pattern
def number_generator
  Fiber.new do
    n = 0
    loop do
      Fiber.yield n
      n += 1
    end
  end
end

gen = number_generator
5.times { puts gen.resume }  # 0, 1, 2, 3, 4

# Async-style programming (Ruby 3.0+)
require 'async'

Async do |task|
  task.async do
    puts "Starting task 1"
    sleep 1  # Non-blocking with Fiber scheduler
    puts "Task 1 complete"
  end

  task.async do
    puts "Starting task 2"
    sleep 0.5
    puts "Task 2 complete"
  end
end
```

---

## Expert Level Questions (Senior/Architect)

### Advanced Metaprogramming

**Q31: Implement a simple ORM using metaprogramming.**
```ruby
class SimpleORM
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def table_name(name = nil)
      if name
        @table_name = name
      else
        @table_name ||= self.name.downcase + 's'
      end
    end

    def field(name, type = :string, options = {})
      fields[name] = { type: type, options: options }

      define_method(name) do
        @attributes[name]
      end

      define_method("#{name}=") do |value|
        @attributes[name] = cast_value(value, type)
      end
    end

    def fields
      @fields ||= {}
    end

    def find(id)
      # Simulate database query
      data = { id: id, name: "User #{id}", created_at: Time.now }
      new(data)
    end

    def where(conditions)
      # Simulate query
      [new({ id: 1, name: "Alice" }), new({ id: 2, name: "Bob" })]
    end
  end

  def initialize(attributes = {})
    @attributes = {}
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def save
    puts "Saving #{self.class.name} with #{@attributes}"
  end

  private

  def cast_value(value, type)
    case type
    when :integer then value.to_i
    when :string then value.to_s
    when :boolean then !!value
    else value
    end
  end
end

# Usage
class User
  include SimpleORM

  table_name :users
  field :id, :integer
  field :name, :string
  field :active, :boolean, default: true
end

user = User.new(id: 1, name: "John", active: true)
user.save
```

**Q32: Create a DSL for building SQL queries.**
```ruby
class QueryBuilder
  def initialize(table)
    @table = table
    @conditions = []
    @joins = []
    @order = []
    @limit_value = nil
    @select_fields = ['*']
  end

  def select(*fields)
    @select_fields = fields
    self
  end

  def where(conditions)
    case conditions
    when Hash
      conditions.each do |key, value|
        @conditions << "#{key} = #{quote(value)}"
      end
    when String
      @conditions << conditions
    end
    self
  end

  def join(table, on:)
    @joins << "JOIN #{table} ON #{on}"
    self
  end

  def order(field, direction = :asc)
    @order << "#{field} #{direction.to_s.upcase}"
    self
  end

  def limit(count)
    @limit_value = count
    self
  end

  def to_sql
    sql = "SELECT #{@select_fields.join(', ')} FROM #{@table}"
    sql += " #{@joins.join(' ')}" if @joins.any?
    sql += " WHERE #{@conditions.join(' AND ')}" if @conditions.any?
    sql += " ORDER BY #{@order.join(', ')}" if @order.any?
    sql += " LIMIT #{@limit_value}" if @limit_value
    sql
  end

  private

  def quote(value)
    case value
    when String then "'#{value}'"
    when Integer, Float then value.to_s
    when nil then 'NULL'
    else "'#{value}'"
    end
  end
end

# Usage
query = QueryBuilder.new(:users)
  .select(:id, :name, :email)
  .where(active: true, role: 'admin')
  .join(:profiles, on: 'users.id = profiles.user_id')
  .order(:created_at, :desc)
  .limit(10)

puts query.to_sql
```

### Design Patterns

**Q33: Implement the Observer pattern in Ruby.**
```ruby
module Observable
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer unless @observers.include?(observer)
  end

  def remove_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers(*args)
    @observers.each { |observer| observer.update(self, *args) }
  end
end

class Stock
  include Observable

  attr_reader :symbol, :price

  def initialize(symbol, price)
    super()
    @symbol = symbol
    @price = price
  end

  def price=(new_price)
    old_price = @price
    @price = new_price
    notify_observers(old_price, new_price)
  end
end

class Investor
  def initialize(name)
    @name = name
  end

  def update(stock, old_price, new_price)
    direction = new_price > old_price ? "up" : "down"
    puts "#{@name} notified: #{stock.symbol} went #{direction} from $#{old_price} to $#{new_price}"
  end
end

# Usage
stock = Stock.new("AAPL", 150.0)
investor1 = Investor.new("Warren Buffett")
investor2 = Investor.new("Peter Lynch")

stock.add_observer(investor1)
stock.add_observer(investor2)

stock.price = 155.0  # Both investors get notified
```

**Q34: Implement a Command pattern with undo functionality.**
```ruby
class Command
  def execute
    raise NotImplementedError
  end

  def undo
    raise NotImplementedError
  end
end

class CreateFileCommand < Command
  def initialize(filename, content)
    @filename = filename
    @content = content
  end

  def execute
    File.write(@filename, @content)
    puts "Created file: #{@filename}"
  end

  def undo
    File.delete(@filename) if File.exist?(@filename)
    puts "Deleted file: #{@filename}"
  end
end

class AppendToFileCommand < Command
  def initialize(filename, content)
    @filename = filename
    @content = content
    @original_size = nil
  end

  def execute
    @original_size = File.exist?(@filename) ? File.size(@filename) : 0
    File.open(@filename, 'a') { |f| f.write(@content) }
    puts "Appended to file: #{@filename}"
  end

  def undo
    if File.exist?(@filename)
      File.truncate(@filename, @original_size)
      puts "Reverted append to: #{@filename}"
    end
  end
end

class CommandHistory
  def initialize
    @history = []
    @current = -1
  end

  def execute(command)
    command.execute
    @history = @history[0..@current]  # Remove any commands after current
    @history << command
    @current += 1
  end

  def undo
    if can_undo?
      @history[@current].undo
      @current -= 1
    end
  end

  def redo
    if can_redo?
      @current += 1
      @history[@current].execute
    end
  end

  def can_undo?
    @current >= 0
  end

  def can_redo?
    @current < @history.length - 1
  end
end

# Usage
history = CommandHistory.new

cmd1 = CreateFileCommand.new("test.txt", "Hello")
cmd2 = AppendToFileCommand.new("test.txt", " World")

history.execute(cmd1)  # Creates file
history.execute(cmd2)  # Appends to file

history.undo  # Reverts append
history.undo  # Deletes file
history.redo  # Recreates file
```

### Advanced Ruby Internals

**Q35: How does method lookup work in Ruby?**
```ruby
# Method lookup order:
# 1. Singleton methods
# 2. Modules (in reverse order of inclusion)
# 3. Class methods
# 4. Superclass methods
# 5. Superclass modules
# ... up the chain to BasicObject

module A
  def test; "A"; end
end

module B
  def test; "B"; end
end

class Parent
  def test; "Parent"; end
end

class Child < Parent
  include A
  include B  # This comes first in lookup

  def test; "Child"; end
end

# Lookup chain:
Child.ancestors
# => [Child, B, A, Parent, Object, Kernel, BasicObject]

obj = Child.new
# Add singleton method
def obj.test
  "Singleton"
end

obj.test  # "Singleton" - singleton methods come first

# Method lookup visualization
class MethodLookupTracer
  def self.trace_lookup(klass, method_name)
    puts "Looking up #{method_name} in #{klass}"

    klass.ancestors.each do |ancestor|
      if ancestor.instance_methods(false).include?(method_name)
        puts "  Found in #{ancestor}"
        return ancestor
      end
      puts "  Not in #{ancestor}"
    end

    puts "  Method not found!"
    nil
  end
end
```

**Q36: Explain const_missing and autoloading.**
```ruby
# Autoloading pattern
module AutoLoader
  def self.const_missing(name)
    puts "Attempting to load #{name}"

    # Convert constant name to file path
    file_path = name.to_s
      .gsub(/([A-Z])/, '_\1')
      .downcase
      .sub(/^_/, '')

    begin
      require_relative file_path

      if const_defined?(name)
        const_get(name)
      else
        raise NameError, "uninitialized constant #{name}"
      end
    rescue LoadError
      # Try alternative naming
      alt_path = name.to_s.downcase
      require_relative alt_path

      if const_defined?(name)
        const_get(name)
      else
        super
      end
    end
  end
end

# Rails-style autoloading
class SimpleAutoloader
  def self.autoload_paths
    @autoload_paths ||= ['lib', 'app/models', 'app/controllers']
  end

  def self.const_missing(name)
    file_name = underscore(name.to_s)

    autoload_paths.each do |path|
      full_path = File.join(path, "#{file_name}.rb")

      if File.exist?(full_path)
        require_relative full_path
        return const_get(name) if const_defined?(name)
      end
    end

    super
  end

  private

  def self.underscore(camel_cased_word)
    camel_cased_word
      .gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr("-", "_")
      .downcase
  end
end
```

---

## Framework-Specific Questions

### Ruby on Rails

**Q37: Explain the Rails request/response cycle.**
```ruby
# 1. Routing - config/routes.rb
Rails.application.routes.draw do
  get '/users/:id', to: 'users#show'
  resources :posts do
    member do
      post :publish
    end
  end
end

# 2. Controller
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show, :edit, :update]

  def show
    @posts = @user.posts.published.includes(:comments)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end

# 3. Model
class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  def full_name
    "#{first_name} #{last_name}"
  end
end

# 4. View - show.html.erb
# <h1><%= @user.full_name %></h1>
# <% @posts.each do |post| %>
#   <h2><%= link_to post.title, post_path(post) %></h2>
# <% end %>

# 5. Response rendered and sent to browser
```

**Q38: What are Rails ActiveRecord associations?**
```ruby
class User < ApplicationRecord
  # One-to-many
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Many-to-many through join table
  has_many :memberships
  has_many :organizations, through: :memberships

  # One-to-one
  has_one :profile, dependent: :destroy

  # Polymorphic association
  has_many :attachments, as: :attachable
end

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Self-referential association
  belongs_to :parent_post, class_name: 'Post', optional: true
  has_many :child_posts, class_name: 'Post', foreign_key: 'parent_post_id'

  # Callbacks
  before_save :set_slug
  after_create :notify_followers

  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :user_id, presence: true

  # Scopes
  scope :published, -> { where(published: true) }
  scope :by_author, ->(author) { where(user: author) }

  private

  def set_slug
    self.slug = title.parameterize
  end

  def notify_followers
    NotificationJob.perform_later(self)
  end
end
```

**Q39: How do Rails validations work?**
```ruby
class User < ApplicationRecord
  # Built-in validations
  validates :email, presence: true,
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :age, numericality: { greater_than: 0, less_than: 150 }
  validates :password, length: { minimum: 8 }, confirmation: true
  validates :role, inclusion: { in: %w[admin user moderator] }

  # Custom validations
  validate :password_complexity
  validate :unique_email_per_domain

  private

  def password_complexity
    return unless password.present?

    unless password.match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      errors.add(:password, 'must contain lowercase, uppercase, and digit')
    end
  end

  def unique_email_per_domain
    return unless email.present?

    domain = email.split('@').last
    if User.where.not(id: id).joins(:profile)
           .where(profiles: { company_domain: domain }).exists?
      errors.add(:email, 'domain already exists in company')
    end
  end
end

# Custom validator class
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add(attribute, 'is not a valid email')
    end
  end
end

class User < ApplicationRecord
  validates :email, email: true
end
```

### Sinatra

**Q40: How does Sinatra routing work?**
```ruby
require 'sinatra'

# Basic routes
get '/' do
  'Hello World'
end

post '/users' do
  # Create user
  user = User.create(params[:user])
  redirect "/users/#{user.id}"
end

# Route parameters
get '/users/:id' do
  @user = User.find(params[:id])
  erb :user
end

# Wildcard routes
get '/download/*' do
  file_path = params['splat'].first
  send_file File.join('files', file_path)
end

# Route patterns
get %r{/hello/([\w]+)} do
  "Hello #{params['captures'].first}"
end

# Conditions
get '/admin', :agent => /Chrome/ do
  'Admin area for Chrome users'
end

# Filters
before do
  @current_user = User.find(session[:user_id]) if session[:user_id]
end

before '/admin/*' do
  halt 401, 'Access denied' unless @current_user&.admin?
end

# Error handling
error 404 do
  'Page not found'
end

error ActiveRecord::RecordNotFound do
  status 404
  'Record not found'
end

# Helpers
helpers do
  def protected!
    halt 401, 'Access denied' unless authorized?
  end

  def authorized?
    session[:user_id] == params[:id].to_i
  end
end
```

---

## System Design Questions

**Q41: Design a URL shortener service like bit.ly**
```ruby
# Database schema design
class ShortenedUrl < ApplicationRecord
  # id (primary key)
  # original_url (string, indexed)
  # short_code (string, unique, indexed)
  # user_id (foreign key, optional)
  # clicks (integer, default: 0)
  # created_at, updated_at

  belongs_to :user, optional: true
  has_many :clicks, dependent: :destroy

  validates :original_url, presence: true, format: URI.regexp
  validates :short_code, presence: true, uniqueness: true

  before_create :generate_short_code

  def increment_clicks!
    increment!(:clicks)
    clicks.create!(
      ip_address: request_ip,
      user_agent: request_user_agent,
      clicked_at: Time.current
    )
  end

  private

  def generate_short_code
    loop do
      self.short_code = SecureRandom.urlsafe_base64(6)
      break unless ShortenedUrl.exists?(short_code: short_code)
    end
  end
end

# Service class
class UrlShortenerService
  CACHE_TTL = 1.hour

  def self.shorten(original_url, user: nil)
    # Check if URL already shortened by this user
    if user && (existing = user.shortened_urls.find_by(original_url: original_url))
      return existing
    end

    # Create new shortened URL
    ShortenedUrl.create!(
      original_url: normalize_url(original_url),
      user: user
    )
  end

  def self.expand(short_code)
    # Try cache first
    cached = Rails.cache.read("short_url:#{short_code}")
    return cached if cached

    # Database lookup
    url = ShortenedUrl.find_by!(short_code: short_code)

    # Cache the result
    Rails.cache.write("short_url:#{short_code}", url.original_url, expires_in: CACHE_TTL)

    url
  end

  private

  def self.normalize_url(url)
    uri = URI.parse(url)
    uri.scheme ||= 'http'
    uri.to_s
  end
end

# Controller
class ShortUrlsController < ApplicationController
  before_action :find_short_url, only: [:show, :stats]

  def create
    @short_url = UrlShortenerService.shorten(
      params[:url],
      user: current_user
    )

    if @short_url.persisted?
      render json: {
        short_url: short_url_path(@short_url.short_code),
        original_url: @short_url.original_url
      }
    else
      render json: { errors: @short_url.errors }, status: 422
    end
  end

  def show
    @short_url.increment_clicks!
    redirect_to @short_url.original_url, status: 301
  end

  def stats
    render json: {
      original_url: @short_url.original_url,
      clicks: @short_url.clicks,
      created_at: @short_url.created_at,
      daily_clicks: @short_url.clicks.group_by_day(:clicked_at).count
    }
  end

  private

  def find_short_url
    @short_url = UrlShortenerService.expand(params[:code])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'URL not found' }, status: 404
  end
end

# Scaling considerations:
# 1. Read replicas for expand operations
# 2. Redis cache for frequently accessed URLs
# 3. CDN for global distribution
# 4. Rate limiting to prevent abuse
# 5. Database sharding for horizontal scaling
```

**Q42: Design a rate limiter**
```ruby
# Token bucket algorithm implementation
class TokenBucket
  def initialize(capacity, refill_rate, redis_client = Redis.current)
    @capacity = capacity.to_f
    @refill_rate = refill_rate.to_f  # tokens per second
    @redis = redis_client
  end

  def allow_request?(key, tokens_requested = 1)
    current_time = Time.now.to_f
    bucket_key = "rate_limit:#{key}"

    @redis.multi do |multi|
      # Get current state
      multi.hmget(bucket_key, 'tokens', 'last_refill')
    end.then do |results|
      tokens, last_refill = results.first

      tokens = tokens ? tokens.to_f : @capacity
      last_refill = last_refill ? last_refill.to_f : current_time

      # Calculate tokens to add
      time_elapsed = current_time - last_refill
      tokens_to_add = time_elapsed * @refill_rate
      tokens = [tokens + tokens_to_add, @capacity].min

      if tokens >= tokens_requested
        # Allow request
        tokens -= tokens_requested

        @redis.hmset(bucket_key,
          'tokens', tokens,
          'last_refill', current_time
        )
        @redis.expire(bucket_key, 3600)  # 1 hour TTL

        true
      else
        # Update last_refill even for rejected requests
        @redis.hmset(bucket_key, 'last_refill', current_time)
        @redis.expire(bucket_key, 3600)

        false
      end
    end
  end
end

# Sliding window rate limiter
class SlidingWindowRateLimiter
  def initialize(window_size, max_requests, redis_client = Redis.current)
    @window_size = window_size  # in seconds
    @max_requests = max_requests
    @redis = redis_client
  end

  def allow_request?(key)
    current_time = Time.now.to_f
    window_key = "sliding_window:#{key}"
    cutoff_time = current_time - @window_size

    @redis.multi do |multi|
      # Remove old entries
      multi.zremrangebyscore(window_key, 0, cutoff_time)

      # Count current requests
      multi.zcard(window_key)

      # Add current request
      multi.zadd(window_key, current_time, "#{current_time}:#{rand}")

      # Set expiry
      multi.expire(window_key, @window_size + 1)
    end.then do |results|
      current_count = results[1]

      if current_count < @max_requests
        true
      else
        # Remove the request we just added
        @redis.zremrangebylex(window_key, "[#{current_time}:#{rand}", "+")
        false
      end
    end
  end
end

# Rate limiter middleware
class RateLimitMiddleware
  def initialize(app)
    @app = app
    @limiters = {}
  end

  def call(env)
    request = Rack::Request.new(env)

    # Different limits based on endpoint
    rate_limit = get_rate_limit(request.path_info)
    return @app.call(env) unless rate_limit

    limiter = get_limiter(rate_limit)
    client_id = get_client_id(request)

    if limiter.allow_request?(client_id)
      @app.call(env)
    else
      [429,
       {'Content-Type' => 'application/json',
        'Retry-After' => rate_limit[:window].to_s},
       [JSON.generate(error: 'Rate limit exceeded')]]
    end
  end

  private

  def get_rate_limit(path)
    case path
    when %r{^/api/auth/}
      { max_requests: 5, window: 300 }    # 5 requests per 5 minutes
    when %r{^/api/}
      { max_requests: 100, window: 60 }   # 100 requests per minute
    else
      nil  # No rate limit
    end
  end

  def get_limiter(rate_limit)
    key = "#{rate_limit[:max_requests]}/#{rate_limit[:window]}"
    @limiters[key] ||= SlidingWindowRateLimiter.new(
      rate_limit[:window],
      rate_limit[:max_requests]
    )
  end

  def get_client_id(request)
    # Try user ID first, fallback to IP
    if (user_id = request.env['USER_ID'])
      "user:#{user_id}"
    else
      "ip:#{request.ip}"
    end
  end
end
```

---

## Coding Challenges

**Q43: Implement a LRU (Least Recently Used) Cache**
```ruby
class LRUCache
  def initialize(capacity)
    @capacity = capacity
    @cache = {}
    @head = Node.new(nil, nil)
    @tail = Node.new(nil, nil)
    @head.next = @tail
    @tail.prev = @head
  end

  def get(key)
    if (node = @cache[key])
      move_to_head(node)
      node.value
    else
      nil
    end
  end

  def put(key, value)
    if (node = @cache[key])
      # Update existing
      node.value = value
      move_to_head(node)
    else
      # Add new
      new_node = Node.new(key, value)
      @cache[key] = new_node
      add_to_head(new_node)

      if @cache.size > @capacity
        # Remove least recently used
        last_node = remove_tail
        @cache.delete(last_node.key)
      end
    end
  end

  private

  class Node
    attr_accessor :key, :value, :prev, :next

    def initialize(key, value)
      @key = key
      @value = value
      @prev = nil
      @next = nil
    end
  end

  def add_to_head(node)
    node.prev = @head
    node.next = @head.next
    @head.next.prev = node
    @head.next = node
  end

  def remove_node(node)
    node.prev.next = node.next
    node.next.prev = node.prev
  end

  def move_to_head(node)
    remove_node(node)
    add_to_head(node)
  end

  def remove_tail
    last_node = @tail.prev
    remove_node(last_node)
    last_node
  end
end

# Usage
cache = LRUCache.new(3)
cache.put(1, "one")
cache.put(2, "two")
cache.put(3, "three")
cache.get(1)  # "one" - moves to head
cache.put(4, "four")  # Evicts 2 (least recently used)
cache.get(2)  # nil
```

**Q44: Implement a thread-safe counter**
```ruby
class ThreadSafeCounter
  def initialize(initial_value = 0)
    @value = initial_value
    @mutex = Mutex.new
  end

  def increment(amount = 1)
    @mutex.synchronize do
      @value += amount
    end
  end

  def decrement(amount = 1)
    @mutex.synchronize do
      @value -= amount
    end
  end

  def value
    @mutex.synchronize { @value }
  end

  def reset(new_value = 0)
    @mutex.synchronize do
      old_value = @value
      @value = new_value
      old_value
    end
  end
end

# Lock-free version using atomic operations (Ruby 3.0+)
require 'concurrent'

class AtomicCounter
  def initialize(initial_value = 0)
    @value = Concurrent::AtomicFixnum.new(initial_value)
  end

  def increment(amount = 1)
    @value.update { |current| current + amount }
  end

  def decrement(amount = 1)
    @value.update { |current| current - amount }
  end

  def value
    @value.value
  end

  def reset(new_value = 0)
    @value.swap(new_value)
  end
end

# Test thread safety
counter = ThreadSafeCounter.new
threads = 10.times.map do
  Thread.new do
    1000.times { counter.increment }
  end
end

threads.each(&:join)
puts counter.value  # Should always be 10000
```

**Q45: Implement a binary search tree**
```ruby
class BinarySearchTree
  attr_accessor :value, :left, :right

  def initialize(value = nil)
    @value = value
    @left = nil
    @right = nil
  end

  def insert(value)
    if @value.nil?
      @value = value
    elsif value <= @value
      @left ||= BinarySearchTree.new
      @left.insert(value)
    else
      @right ||= BinarySearchTree.new
      @right.insert(value)
    end
    self
  end

  def search(value)
    return true if @value == value
    return false if @value.nil?

    if value < @value && @left
      @left.search(value)
    elsif value > @value && @right
      @right.search(value)
    else
      false
    end
  end

  def delete(value)
    return nil if @value.nil?

    if value < @value
      @left = @left&.delete(value)
    elsif value > @value
      @right = @right&.delete(value)
    else
      # Node to delete found
      if @left.nil? && @right.nil?
        return nil
      elsif @left.nil?
        return @right
      elsif @right.nil?
        return @left
      else
        # Node has two children
        min_right = find_min(@right)
        @value = min_right.value
        @right = @right.delete(min_right.value)
      end
    end
    self
  end

  def inorder_traversal
    result = []
    inorder_helper(result)
    result
  end

  def preorder_traversal
    result = []
    preorder_helper(result)
    result
  end

  def postorder_traversal
    result = []
    postorder_helper(result)
    result
  end

  def height
    return 0 if @value.nil?

    left_height = @left ? @left.height : 0
    right_height = @right ? @right.height : 0

    1 + [left_height, right_height].max
  end

  def balanced?
    return true if @value.nil?

    left_height = @left ? @left.height : 0
    right_height = @right ? @right.height : 0

    (left_height - right_height).abs <= 1 &&
      (@left.nil? || @left.balanced?) &&
      (@right.nil? || @right.balanced?)
  end

  private

  def find_min(node)
    while node.left
      node = node.left
    end
    node
  end

  def inorder_helper(result)
    @left&.inorder_helper(result)
    result << @value unless @value.nil?
    @right&.inorder_helper(result)
  end

  def preorder_helper(result)
    result << @value unless @value.nil?
    @left&.preorder_helper(result)
    @right&.preorder_helper(result)
  end

  def postorder_helper(result)
    @left&.postorder_helper(result)
    @right&.postorder_helper(result)
    result << @value unless @value.nil?
  end
end

# Usage
bst = BinarySearchTree.new
[5, 3, 7, 1, 9, 2, 8].each { |value| bst.insert(value) }

puts bst.search(7)  # true
puts bst.search(4)  # false
puts bst.inorder_traversal  # [1, 2, 3, 5, 7, 8, 9]
puts bst.height  # 4
puts bst.balanced?  # false
```

---

## Scenario-Based Questions

**Q46: You have a slow-performing Rails application. How would you debug and optimize it?**

```ruby
# 1. Performance Profiling
# Add to Gemfile
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'ruby-prof'

# 2. Database Query Analysis
# Enable query logging
ActiveRecord::Base.logger = Logger.new(STDOUT)

# Find N+1 queries
gem 'bullet'  # Add to development group

# In application.rb
config.after_initialize do
  Bullet.enable = true
  Bullet.bullet_logger = true
  Bullet.console = true
end

# 3. Slow query identification
# config/initializers/slow_query_logger.rb
ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
  duration = finish - start
  if duration > 1.0  # Log queries taking more than 1 second
    Rails.logger.warn "Slow Query (#{duration.round(2)}s): #{payload[:sql]}"
  end
end

# 4. Memory analysis
def analyze_memory_usage
  report = MemoryProfiler.report do
    # Your suspected code here
    User.includes(:posts, :comments).limit(100).each do |user|
      user.posts.map(&:title)
    end
  end

  report.pretty_print
end

# 5. Code-level optimizations
# Before - N+1 queries
def inefficient_users_with_posts
  users = User.all
  users.each do |user|
    puts "#{user.name}: #{user.posts.count} posts"  # N+1 query!
  end
end

# After - Single query with includes
def efficient_users_with_posts
  users = User.includes(:posts)
  users.each do |user|
    puts "#{user.name}: #{user.posts.length} posts"  # Uses loaded association
  end
end

# 6. Database indexing
class AddIndexesToImprovePerformance < ActiveRecord::Migration[6.1]
  def change
    # Add indexes for frequently queried columns
    add_index :posts, :user_id
    add_index :posts, [:published, :created_at]
    add_index :users, :email, unique: true

    # Partial indexes for performance
    add_index :posts, :created_at, where: 'published = true'
  end
end

# 7. Caching strategies
class PostsController < ApplicationController
  def index
    @posts = Rails.cache.fetch("posts/recent", expires_in: 5.minutes) do
      Post.published.includes(:user).recent.limit(10).to_a
    end
  end

  def show
    @post = Rails.cache.fetch(["post", params[:id]], expires_in: 1.hour) do
      Post.includes(:comments, :user).find(params[:id])
    end
  end
end

# 8. Background jobs for heavy tasks
class SlowProcessingController < ApplicationController
  def process_data
    ProcessDataJob.perform_later(current_user, params[:data])
    render json: { status: 'processing' }
  end
end

class ProcessDataJob < ApplicationJob
  def perform(user, data)
    # Heavy processing moved to background
    result = ExpensiveDataProcessor.process(data)
    UserMailer.processing_complete(user, result).deliver_now
  end
end
```

**Q47: How would you implement authentication and authorization in a Ruby application?**

```ruby
# 1. Authentication with bcrypt
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: :password_digest_changed?

  enum role: { user: 0, admin: 1, moderator: 2 }

  def self.authenticate(email, password)
    user = find_by(email: email)
    user&.authenticate(password)
  end
end

# 2. Session management
class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'Logged out successfully'
  end
end

# 3. JWT Authentication for API
require 'jwt'

class JWTService
  SECRET = Rails.application.secret_key_base

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end

class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    return render_unauthorized unless token

    decoded_token = JWTService.decode(token)
    return render_unauthorized unless decoded_token

    @current_user = User.find(decoded_token[:user_id])
  rescue ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: 401
  end
end

# 4. Role-based authorization
class AuthorizationService
  def self.can?(user, action, resource)
    case [user.role, action, resource.class.name]
    when ['admin', _, _]
      true
    when ['moderator', 'read', _]
      true
    when ['moderator', 'update', 'Post']
      true
    when ['user', 'read', _]
      true
    when ['user', 'update', 'Post']
      resource.user_id == user.id
    when ['user', 'create', 'Post']
      true
    else
      false
    end
  end
end

# 5. Authorization concern
module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :authorize_action
  end

  private

  def authorize_action
    resource = instance_variable_get("@#{controller_name.singularize}")
    resource ||= controller_name.classify.constantize

    action_name = case action_name
    when 'show', 'index' then 'read'
    when 'new', 'create' then 'create'
    when 'edit', 'update' then 'update'
    when 'destroy' then 'delete'
    else action_name
    end

    unless AuthorizationService.can?(current_user, action_name, resource)
      render json: { error: 'Forbidden' }, status: 403
    end
  end
end

# 6. Policy-based authorization (Pundit-style)
class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def show?
    post.published? || user == post.user || user.admin?
  end

  def create?
    user.present?
  end

  def update?
    user == post.user || user.admin?
  end

  def destroy?
    user == post.user || user.admin?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(published: true).or(scope.where(user: user))
      end
    end
  end
end

# Usage in controller
class PostsController < ApplicationController
  def index
    @posts = PostPolicy::Scope.new(current_user, Post).resolve
  end

  def show
    @post = Post.find(params[:id])
    authorize @post, :show?
  end

  private

  def authorize(resource, action)
    policy = "#{resource.class}Policy".constantize.new(current_user, resource)
    unless policy.public_send(action)
      render json: { error: 'Forbidden' }, status: 403
    end
  end
end

# 7. Two-factor authentication
class User < ApplicationRecord
  has_secure_password

  def enable_two_factor!
    self.two_factor_secret = ROTP::Base32.random_base32
    self.two_factor_enabled = true
    save!
  end

  def verify_two_factor(token)
    return false unless two_factor_enabled?

    totp = ROTP::TOTP.new(two_factor_secret)
    totp.verify(token, drift_ahead: 30, drift_behind: 30)
  end

  def two_factor_qr_code
    return unless two_factor_secret

    totp = ROTP::TOTP.new(two_factor_secret, issuer: 'MyApp')
    totp.provisioning_uri(email)
  end
end
```

**Q48: Design a job queue system for background processing**

```ruby
# 1. Simple in-memory job queue
class SimpleJobQueue
  def initialize
    @queue = Queue.new
    @workers = []
    @running = false
  end

  def start(worker_count = 3)
    @running = true

    worker_count.times do
      @workers << Thread.new do
        while @running
          job = @queue.pop
          break if job == :stop

          begin
            job.perform
          rescue => e
            puts "Job failed: #{e.message}"
          end
        end
      end
    end
  end

  def stop
    @running = false
    @workers.size.times { @queue << :stop }
    @workers.each(&:join)
  end

  def enqueue(job)
    @queue << job
  end
end

# 2. Persistent job queue with Redis
require 'redis'
require 'json'

class PersistentJobQueue
  def initialize(redis = Redis.new)
    @redis = redis
    @queue_key = 'job_queue'
    @processing_key = 'job_processing'
    @failed_key = 'job_failed'
  end

  def enqueue(job_class, *args)
    job_data = {
      id: SecureRandom.uuid,
      class: job_class.to_s,
      args: args,
      enqueued_at: Time.now.to_f,
      attempts: 0
    }

    @redis.lpush(@queue_key, JSON.generate(job_data))
  end

  def work
    loop do
      # Blocking pop from queue
      _, job_json = @redis.brpop(@queue_key, timeout: 5)
      next unless job_json

      job_data = JSON.parse(job_json)

      begin
        # Move to processing queue
        @redis.lpush(@processing_key, job_json)

        # Execute job
        job_class = job_data['class'].constantize
        job_class.new.perform(*job_data['args'])

        # Remove from processing queue
        @redis.lrem(@processing_key, 1, job_json)

      rescue => e
        puts "Job failed: #{e.message}"

        # Remove from processing
        @redis.lrem(@processing_key, 1, job_json)

        # Handle retry logic
        job_data['attempts'] += 1
        job_data['error'] = e.message
        job_data['failed_at'] = Time.now.to_f

        if job_data['attempts'] < 3
          # Retry with exponential backoff
          delay = 2 ** job_data['attempts']

          Thread.new do
            sleep(delay)
            @redis.lpush(@queue_key, JSON.generate(job_data))
          end
        else
          # Move to failed queue
          @redis.lpush(@failed_key, JSON.generate(job_data))
        end
      end
    end
  end
end

# 3. Job base class
class ApplicationJob
  include ActiveJob::Core

  attr_accessor :job_id, :queue_name, :priority

  def self.perform_later(*args)
    job = new
    job.job_id = SecureRandom.uuid
    job.queue_name = queue_name_from_class

    JobQueue.instance.enqueue(job, *args)
  end

  def self.perform_now(*args)
    new.perform(*args)
  end

  def perform(*args)
    raise NotImplementedError
  end

  def retry_job(wait: 10.seconds, attempts: 3)
    # Retry logic implementation
  end

  private

  def self.queue_name_from_class
    name.underscore.gsub('_job', '')
  end
end

# 4. Specific job implementations
class EmailDeliveryJob < ApplicationJob
  queue_as :high_priority

  def perform(user_id, template, data)
    user = User.find(user_id)
    UserMailer.send(template, user, data).deliver_now
  rescue ActiveRecord::RecordNotFound
    # Don't retry if user doesn't exist
    logger.info "User #{user_id} not found, skipping email"
  rescue Net::SMTPServerBusy => e
    # Retry SMTP errors
    retry_job(wait: 5.minutes, attempts: 5)
    raise e
  end
end

class ImageProcessingJob < ApplicationJob
  queue_as :low_priority

  def perform(image_id)
    image = Image.find(image_id)

    # Create thumbnails
    %w[small medium large].each do |size|
      processed = ImageProcessor.resize(image.file, size)
      image.update!("#{size}_url" => upload_to_cdn(processed))
    end
  end

  private

  def upload_to_cdn(file)
    # Upload implementation
  end
end

# 5. Priority queue implementation
class PriorityJobQueue
  PRIORITIES = {
    high: 1,
    normal: 2,
    low: 3
  }.freeze

  def initialize
    @queues = PRIORITIES.keys.map { |p| [p, Queue.new] }.to_h
    @workers = []
  end

  def enqueue(job, priority: :normal)
    @queues[priority] << job
  end

  def work
    loop do
      job = next_job

      if job
        job.perform
      else
        sleep(0.1)  # No jobs available
      end
    end
  end

  private

  def next_job
    # Check queues in priority order
    PRIORITIES.keys.each do |priority|
      queue = @queues[priority]
      return queue.pop(true) unless queue.empty?
    end
    nil
  rescue ThreadError
    nil
  end
end

# 6. Job scheduler for recurring tasks
class JobScheduler
  def initialize
    @scheduled_jobs = {}
    @running = false
  end

  def start
    @running = true

    Thread.new do
      while @running
        check_scheduled_jobs
        sleep(60)  # Check every minute
      end
    end
  end

  def schedule(name, job_class, cron_pattern, *args)
    @scheduled_jobs[name] = {
      job_class: job_class,
      cron: Cron.new(cron_pattern),
      args: args,
      last_run: nil
    }
  end

  private

  def check_scheduled_jobs
    current_time = Time.now

    @scheduled_jobs.each do |name, config|
      if should_run?(config, current_time)
        config[:job_class].perform_later(*config[:args])
        config[:last_run] = current_time
      end
    end
  end

  def should_run?(config, current_time)
    return true unless config[:last_run]

    config[:cron].should_run_at?(current_time) &&
      current_time - config[:last_run] >= 60
  end
end

# Usage
scheduler = JobScheduler.new
scheduler.schedule(
  'daily_cleanup',
  CleanupJob,
  '0 2 * * *',  # Daily at 2 AM
  older_than: 30.days
)
scheduler.start
```

---

## Best Practices Summary

### Code Quality
1. **Follow Ruby style guide** (RuboCop)
2. **Write tests first** (TDD)
3. **Keep methods small** (< 10 lines)
4. **Use meaningful names**
5. **Handle exceptions properly**

### Performance
1. **Profile before optimizing**
2. **Use appropriate data structures**
3. **Cache expensive operations**
4. **Optimize database queries**
5. **Use background jobs for heavy tasks**

### Security
1. **Sanitize all inputs**
2. **Use parameterized queries**
3. **Validate on both client and server**
4. **Keep dependencies updated**
5. **Follow OWASP guidelines**

### Architecture
1. **Single Responsibility Principle**
2. **Don't Repeat Yourself (DRY)**
3. **Composition over inheritance**
4. **Dependency injection**
5. **Fail fast and loud**

Remember: These questions test not just Ruby knowledge but also problem-solving skills, system design thinking, and real-world experience. Always explain your thought process and trade-offs when answering.