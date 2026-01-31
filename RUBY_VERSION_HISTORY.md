# Ruby Version History - Complete Feature Guide

## Table of Contents
1. [Ruby Version Timeline](#ruby-version-timeline)
2. [Ruby 1.8 → 1.9 (Major Rewrite)](#ruby-18--19-major-rewrite)
3. [Ruby 2.0 (2013)](#ruby-20-2013)
4. [Ruby 2.1 (2013)](#ruby-21-2013)
5. [Ruby 2.2 (2014)](#ruby-22-2014)
6. [Ruby 2.3 (2015)](#ruby-23-2015)
7. [Ruby 2.4 (2016)](#ruby-24-2016)
8. [Ruby 2.5 (2017)](#ruby-25-2017)
9. [Ruby 2.6 (2018)](#ruby-26-2018)
10. [Ruby 2.7 (2019)](#ruby-27-2019)
11. [Ruby 3.0 (2020)](#ruby-30-2020)
12. [Ruby 3.1 (2021)](#ruby-31-2021)
13. [Ruby 3.2 (2022)](#ruby-32-2022)
14. [Ruby 3.3 (2023)](#ruby-33-2023)
15. [Performance Improvements Timeline](#performance-improvements-timeline)
16. [Migration Cheat Sheet](#migration-cheat-sheet)

---

## Ruby Version Timeline

```
1995 - Ruby created by Yukihiro "Matz" Matsumoto
2000 - Ruby 1.6 (First English documentation)
2003 - Ruby 1.8 (Stable, widely adopted)
2007 - Ruby 1.9 (YARV VM, major performance boost)
2013 - Ruby 2.0 (Keyword arguments, Module#prepend)
2013 - Ruby 2.1 (Generational GC)
2014 - Ruby 2.2 (Incremental GC)
2015 - Ruby 2.3 (Safe navigation operator &.)
2016 - Ruby 2.4 (Hash performance improvements)
2017 - Ruby 2.5 (yield_self, performance)
2018 - Ruby 2.6 (JIT compiler MJIT)
2019 - Ruby 2.7 (Pattern matching, numbered parameters)
2020 - Ruby 3.0 (3x3 goal achieved, Ractor, Fiber Scheduler)
2021 - Ruby 3.1 (YJIT, error_highlight)
2022 - Ruby 3.2 (WASI support, improved YJIT)
2023 - Ruby 3.3 (Prism parser, RJIT)
```

---

## Ruby 1.8 → 1.9 (Major Rewrite)

### The Biggest Change in Ruby History

#### 1. New VM: YARV (Yet Another Ruby VM)
```ruby
# Ruby 1.8 - Interpreted AST directly (slow)
# Ruby 1.9 - Bytecode VM (2-3x faster)

# Performance comparison
require 'benchmark'

# Ruby 1.9 is significantly faster for:
def fibonacci(n)
  return n if n <= 1
  fibonacci(n-1) + fibonacci(n-2)
end

# 1.8: ~5 seconds for fibonacci(35)
# 1.9: ~2 seconds for fibonacci(35)
```

#### 2. String Encoding (Major Breaking Change)
```ruby
# Ruby 1.8 - Strings were byte arrays
str = "Hello"
str[0]  # Returns 72 (ASCII code)

# Ruby 1.9 - Strings have encoding
str = "Hello"
str[0]  # Returns "H" (character)
str.encoding  # #<Encoding:UTF-8>

# Encoding operations
str.force_encoding("ASCII-8BIT")
str.encode("ISO-8859-1")

# Magic comment for source encoding
# encoding: utf-8
```

#### 3. Hash Syntax (Still Used Today)
```ruby
# Ruby 1.8 - Hash rocket only
hash = { :name => "John", :age => 30 }

# Ruby 1.9 - New syntax for symbol keys
hash = { name: "John", age: 30 }

# Both syntaxes work
mixed = { :old_style => "value", new_style: "value" }
```

#### 4. Block Parameters
```ruby
# Ruby 1.8 - Block parameters could override local variables
x = 10
[1, 2, 3].each { |x| puts x }
puts x  # x is now 3!

# Ruby 1.9 - Block parameters are always local
x = 10
[1, 2, 3].each { |x| puts x }
puts x  # x is still 10
```

---

## Ruby 2.0 (2013)

### "The 20th Anniversary Release"

#### 1. Keyword Arguments
```ruby
# Before Ruby 2.0 - Using options hash
def create_user(name, options = {})
  age = options[:age] || 18
  role = options[:role] || 'user'
  # ...
end

create_user("John", age: 25, role: 'admin')

# Ruby 2.0 - Native keyword arguments
def create_user(name, age: 18, role: 'user')
  puts "Creating #{name}, age #{age}, role #{role}"
end

create_user("John", age: 25, role: 'admin')

# Required keyword arguments (Ruby 2.1+)
def create_user(name:, email:, role: 'user')
  # name and email are required
end
```

#### 2. Module#prepend
```ruby
# Before Ruby 2.0 - Only include and extend
module Trackable
  def save
    puts "Tracking save"
    super
  end
end

class User
  include Trackable  # Trackable comes after User in method lookup
  def save
    puts "Saving user"
  end
end

# User.new.save outputs:
# "Saving user" (Trackable#save never called)

# Ruby 2.0 - prepend
class User
  prepend Trackable  # Trackable comes before User
  def save
    puts "Saving user"
  end
end

# User.new.save outputs:
# "Tracking save"
# "Saving user"
```

#### 3. Lazy Enumerables
```ruby
# Before Ruby 2.0 - Processes entire array
(1..Float::INFINITY).select(&:odd?).first(5)  # Hangs!

# Ruby 2.0 - Lazy evaluation
(1..Float::INFINITY).lazy.select(&:odd?).first(5)  # Works!
# => [1, 3, 5, 7, 9]

# Practical example
File.open('huge_file.txt').each_line.lazy
  .select { |line| line.include?('ERROR') }
  .map { |line| line.strip }
  .first(10)  # Only processes until 10 errors found
```

#### 4. Symbol Array Literals
```ruby
# Before Ruby 2.0
ROLES = [:admin, :moderator, :user]

# Ruby 2.0 - %i notation
ROLES = %i[admin moderator user]
ROLES_CAPS = %I[admin moderator user].map(&:upcase)
```

---

## Ruby 2.1 (2013)

### "Performance Focus"

#### 1. Required Keyword Arguments
```ruby
# Ruby 2.0 - Optional keywords only
def process(data, format: 'json')
  # ...
end

# Ruby 2.1 - Required keywords (no default value)
def process(data, format:)
  puts "Processing #{data} as #{format}"
end

process("data", format: "xml")  # OK
process("data")  # ArgumentError: missing keyword: format
```

#### 2. Generational Garbage Collection (RGenGC)
```ruby
# Automatic - no code changes needed
# 40% less GC time for typical Rails apps

# Check GC stats
GC.stat
# => {:count=>10, :heap_allocated_pages=>50, :heap_eden_pages=>50, ...}

# Ruby 2.1 introduces generational GC
# - Young objects (likely to die soon)
# - Old objects (likely to live long)
# More efficient memory management
```

#### 3. String#freeze Optimizations
```ruby
# Ruby 2.1 - Frozen string literals are deduplicated

def create_string
  "frozen".freeze
end

# Same object_id for all calls
create_string.object_id == create_string.object_id  # true

# Saves memory in large applications
CONSTANT = "constant_string".freeze
```

#### 4. Array#to_h and Enumerable#to_h
```ruby
# Convert array of pairs to hash
pairs = [[:a, 1], [:b, 2], [:c, 3]]

# Before Ruby 2.1
hash = Hash[pairs]

# Ruby 2.1
hash = pairs.to_h
# => {:a=>1, :b=>2, :c=>3}

# Works with map
users = User.all.map { |u| [u.id, u.name] }.to_h
```

---

## Ruby 2.2 (2014)

### "Garbage Collection Revolution"

#### 1. Incremental GC
```ruby
# Reduces maximum pause time
# Better for web applications

# Before: GC could pause app for 100ms+
# After: GC pauses reduced to ~10ms chunks

# Monitor GC performance
GC::Profiler.enable
# ... run code ...
GC::Profiler.report
```

#### 2. Symbol GC
```ruby
# Before Ruby 2.2 - Symbols were never garbage collected
# This could cause memory leaks:

100_000.times do |i|
  "user_#{i}".to_sym  # Created 100,000 symbols, never freed
end

# Ruby 2.2 - Dynamic symbols can be garbage collected
# Same code above no longer leaks memory
# Static symbols (from source code) still permanent
```

#### 3. Method.super_method and Method.curry
```ruby
# super_method - Find overridden method
class Parent
  def greet
    "Hello from Parent"
  end
end

class Child < Parent
  def greet
    "Hello from Child"
  end
end

method = Child.instance_method(:greet)
super_method = method.super_method
super_method.bind(Child.new).call  # "Hello from Parent"

# curry - Partial application
multiply = ->(x, y) { x * y }.curry
double = multiply[2]
double[5]  # => 10
```

#### 4. Binding#local_variables and #receiver
```ruby
def debug_context
  x = 10
  y = 20

  binding.local_variables  # [:x, :y]
  binding.receiver  # main or self
end

# Useful for debugging and metaprogramming
def inspect_binding(b)
  puts "Local variables: #{b.local_variables}"
  puts "Receiver: #{b.receiver}"
  b.local_variables.each do |var|
    puts "  #{var} = #{b.local_variable_get(var)}"
  end
end
```

---

## Ruby 2.3 (2015)

### "Developer Happiness"

#### 1. Safe Navigation Operator (&.)
```ruby
# Before Ruby 2.3 - Verbose nil checking
if user && user.address && user.address.city
  city = user.address.city.upcase
end

# Ruby 2.3 - Safe navigation
city = user&.address&.city&.upcase

# Works with arrays too
users&.first&.name

# Practical example
def get_user_email(user)
  user&.profile&.email || "No email"
end
```

#### 2. dig Method for Nested Access
```ruby
# Nested hash/array access
data = {
  user: {
    profile: {
      address: {
        city: "New York"
      }
    }
  }
}

# Before Ruby 2.3
city = data[:user] && data[:user][:profile] &&
       data[:user][:profile][:address] &&
       data[:user][:profile][:address][:city]

# Ruby 2.3 - dig method
city = data.dig(:user, :profile, :address, :city)  # "New York"
city = data.dig(:user, :settings, :theme)  # nil (no error)

# Works with arrays
data = [[1, [2, [3, 4]]]]
data.dig(0, 1, 1, 0)  # => 3
```

#### 3. Hash Comparison Operators
```ruby
# Ruby 2.3 - Hash subset/superset comparisons

h1 = {a: 1, b: 2}
h2 = {a: 1, b: 2, c: 3}

h1 < h2   # true (h1 is subset of h2)
h2 > h1   # true (h2 is superset of h1)
h1 <= h2  # true
h2 >= h1  # true

{a: 1} < {a: 1}  # false (not proper subset)
{a: 1} <= {a: 1}  # true (subset or equal)
```

#### 4. Frozen String Literal Pragma
```ruby
# frozen_string_literal: true

# All string literals in this file are frozen
str = "hello"  # Automatically frozen
str.frozen?  # true

# Explicit unfrozen string
mutable = +"hello"  # or "hello".dup
mutable.frozen?  # false

# Performance benefit: less object allocation
```

---

## Ruby 2.4 (2016)

### "Performance and Refinements"

#### 1. Hash Performance Improvements
```ruby
# Ruby 2.4 - Hash tables are ~40% faster

# Faster hash operations
large_hash = (1..1_000_000).map { |i| [i, i*2] }.to_h

# Benchmark shows significant improvement
require 'benchmark'
Benchmark.bm do |x|
  x.report("lookup") { 1_000_000.times { large_hash[rand(1_000_000)] } }
end
```

#### 2. Integer Unification
```ruby
# Before Ruby 2.4 - Fixnum and Bignum classes
1.class  # Fixnum
(10**100).class  # Bignum

# Ruby 2.4 - Unified as Integer
1.class  # Integer
(10**100).class  # Integer

# Automatic promotion still works
num = 2**62  # Was Fixnum limit
(num * 2).class  # Still Integer, no overflow
```

#### 3. String#match? and Regexp#match?
```ruby
# Before Ruby 2.4 - match creates MatchData (slower)
if str.match(/pattern/)
  # MatchData object created even if not used
end

# Ruby 2.4 - match? just returns true/false (faster)
if str.match?(/pattern/)
  # No MatchData created, more efficient
end

# Performance comparison
str = "hello world"
str.match(/world/)   # Creates MatchData object
str.match?(/world/)  # Just returns true, 3x faster
```

#### 4. Hash#transform_values and compact
```ruby
# transform_values
hash = {a: 1, b: 2, c: 3}
hash.transform_values { |v| v * 2 }  # {a: 2, b: 4, c: 6}
hash.transform_values(&:to_s)  # {a: "1", b: "2", c: "3"}

# compact - removes nil values
hash = {a: 1, b: nil, c: 3, d: nil}
hash.compact  # {a: 1, c: 3}
hash.compact!  # Modifies in place

# Array#concat with multiple arguments
arr = [1, 2]
arr.concat([3, 4], [5, 6])  # [1, 2, 3, 4, 5, 6]
```

---

## Ruby 2.5 (2017)

### "yield_self and Performance"

#### 1. yield_self (later aliased as then)
```ruby
# Method chaining for single values
# Similar to tap but returns the block result

# Before Ruby 2.5 - Awkward chaining
result = 5
result = result * 2
result = result + 3
result = result.to_s

# Ruby 2.5 - yield_self/then
result = 5
  .yield_self { |n| n * 2 }
  .yield_self { |n| n + 3 }
  .yield_self { |n| n.to_s }

# Ruby 2.6+ - Using 'then' alias
result = 5
  .then { |n| n * 2 }
  .then { |n| n + 3 }
  .then { |n| n.to_s }

# Practical example
user_data = fetch_user(id)
  .then { |u| u || create_default_user }
  .then { |u| enrich_with_profile(u) }
  .then { |u| format_for_api(u) }
```

#### 2. String#delete_prefix/delete_suffix
```ruby
# Before Ruby 2.5
filename = "photo.jpg"
name = filename.sub(/\.jpg\z/, '')

url = "https://example.com"
domain = url.sub(/\Ahttps:\/\//, '')

# Ruby 2.5
filename = "photo.jpg"
name = filename.delete_suffix('.jpg')  # "photo"

url = "https://example.com"
domain = url.delete_prefix('https://')  # "example.com"

# Also with bang versions
str = "Hello, World!"
str.delete_prefix!("Hello, ")  # Modifies in place
str  # "World!"
```

#### 3. Hash#slice
```ruby
# Extract subset of hash
user = {
  id: 1,
  name: "John",
  email: "john@example.com",
  password: "secret",
  admin: true
}

# Ruby 2.5 - slice
public_data = user.slice(:id, :name, :email)
# => {id: 1, name: "John", email: "john@example.com"}

# Useful for API responses
def user_json(user)
  user.slice(:id, :name, :email, :created_at).to_json
end
```

#### 4. ERB#result_with_hash
```ruby
require 'erb'

# Before Ruby 2.5 - Using binding
template = ERB.new("Hello <%= name %>, you are <%= age %>")
name = "John"
age = 30
template.result(binding)

# Ruby 2.5 - Direct hash
template = ERB.new("Hello <%= name %>, you are <%= age %>")
template.result_with_hash(name: "John", age: 30)
```

---

## Ruby 2.6 (2018)

### "JIT and Endless Range"

#### 1. JIT Compiler (MJIT)
```ruby
# Enable with --jit flag
# ruby --jit script.rb

# Or environment variable
ENV['RUBYOPT'] = '--jit'

# Check if JIT is enabled
RubyVM::MJIT.enabled?  # true/false

# JIT works best for:
# - Long-running processes
# - CPU-intensive operations
# - Not ideal for short scripts

# Benchmark example
def fibonacci(n)
  return n if n <= 1
  fibonacci(n-1) + fibonacci(n-2)
end

# With JIT: ~20% faster after warm-up
```

#### 2. Endless Range
```ruby
# Before Ruby 2.6 - Explicit upper bound
(1..Float::INFINITY)
(1..nil)  # Error!

# Ruby 2.6 - Endless range
(1..)  # From 1 to infinity
(1..).first(5)  # [1, 2, 3, 4, 5]

# Practical uses
case age
when (..17)
  "Minor"
when (18..64)
  "Adult"
when (65..)
  "Senior"
end

# Array slicing
arr = [1, 2, 3, 4, 5]
arr[2..]  # [3, 4, 5]

# Ruby 2.7 adds beginless range
arr[..2]  # [1, 2, 3]
```

#### 3. then as Alias for yield_self
```ruby
# Ruby 2.5
result = value.yield_self { |x| process(x) }

# Ruby 2.6 - More readable
result = value.then { |x| process(x) }

# Chain operations
data
  .then { |d| JSON.parse(d) }
  .then { |parsed| parsed['users'] }
  .then { |users| users.map { |u| u['name'] } }
```

#### 4. Array#union and difference
```ruby
# Ruby 2.6 - Array union (like | but accepts multiple arrays)
[1, 2, 3].union([3, 4], [4, 5])  # [1, 2, 3, 4, 5]

# Array difference (like - but accepts multiple arrays)
[1, 2, 3, 4, 5].difference([2, 3], [4])  # [1, 5]

# Comparison with operators
# Union
[1, 2] | [2, 3] | [3, 4]  # Chaining required
[1, 2].union([2, 3], [3, 4])  # Single call

# Difference
[1, 2, 3] - [2] - [3]  # Chaining required
[1, 2, 3].difference([2], [3])  # Single call
```

---

## Ruby 2.7 (2019)

### "Pattern Matching and Numbered Parameters"

#### 1. Pattern Matching (Experimental)
```ruby
# Basic pattern matching
case [1, 2, 3]
in [1, 2, 3]
  "exact match"
in [1, *rest]
  "starts with 1, rest: #{rest}"
end

# Hash pattern matching
user = {name: "John", age: 30, role: "admin"}

case user
in {name: "John", age:}
  puts "John is #{age} years old"
in {name:, role: "admin"}
  puts "Admin user: #{name}"
end

# Advanced patterns
def process_response(response)
  case response
  in {status: 200, body:}
    JSON.parse(body)
  in {status: 404}
    raise "Not found"
  in {status: 500..599}
    raise "Server error"
  end
end

# Array destructuring
case [1, [2, 3]]
in [a, [b, *c]]
  p a  # 1
  p b  # 2
  p c  # [3]
end
```

#### 2. Numbered Block Parameters
```ruby
# Before Ruby 2.7
[1, 2, 3].map { |n| n * 2 }

# Ruby 2.7 - Numbered parameters
[1, 2, 3].map { _1 * 2 }  # [2, 4, 6]

# Multiple parameters
hash = {a: 1, b: 2}
hash.map { "#{_1}: #{_2}" }  # ["a: 1", "b: 2"]

# More complex example
users.select { _1.age > 18 }.map { _1.name }

# Works up to _9
[[1,2,3], [4,5,6]].map { _1 + _2 + _3 }  # [6, 15]
```

#### 3. Beginless Range
```ruby
# Ruby 2.6 had endless range (1..)
# Ruby 2.7 adds beginless range

(..10)  # From -infinity to 10

# Practical use cases
case temperature
when (...0)
  "Freezing"
when (0..15)
  "Cold"
when (15..25)
  "Comfortable"
when (25..)
  "Hot"
end

# Array slicing
arr = [1, 2, 3, 4, 5]
arr[..2]   # [1, 2, 3]
arr[...2]  # [1, 2] (exclusive)
```

#### 4. Enumerator#produce and lazy
```ruby
# Enumerator.produce - Generate values
fibonacci = Enumerator.produce([0, 1]) do |a, b|
  [b, a + b]
end

fibonacci.take(10).map(&:first)
# => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

# Generate sequential IDs
ids = Enumerator.produce(1) { |n| n + 1 }
ids.take(5)  # [1, 2, 3, 4, 5]

# filter_map - Combined select + map
numbers = [1, 2, 3, 4, 5, 6]

# Before
numbers.select(&:even?).map { |n| n * 2 }

# Ruby 2.7
numbers.filter_map { |n| n * 2 if n.even? }  # [4, 8, 12]
```

---

## Ruby 3.0 (2020)

### "3x3 Goal Achieved!"

#### 1. Ractor - True Parallelism
```ruby
# Ractors run in parallel (not just concurrent)
# No GIL between Ractors!

# Create a Ractor
ractor = Ractor.new do
  # This runs in parallel
  sum = 0
  1000000.times { |i| sum += i }
  sum
end

# Get result
result = ractor.take  # Blocks until ractor finishes

# Parallel processing example
def parallel_sum(arrays)
  ractors = arrays.map do |array|
    Ractor.new(array) do |arr|
      arr.sum
    end
  end

  ractors.map(&:take).sum
end

data = Array.new(4) { Array.new(1000000) { rand(100) } }
parallel_sum(data)  # 4x faster on 4-core CPU

# Message passing
pipe = Ractor.new do
  loop do
    msg = Ractor.receive
    Ractor.yield(msg.upcase)
  end
end

pipe.send("hello")
pipe.take  # "HELLO"
```

#### 2. Fiber Scheduler - Async I/O
```ruby
require 'async'

# Non-blocking I/O with Fiber scheduler
Async do |task|
  # These run concurrently
  task.async do
    response1 = Net::HTTP.get(URI('http://api1.com'))
  end

  task.async do
    response2 = Net::HTTP.get(URI('http://api2.com'))
  end
end

# Database queries in parallel
Async do
  results = 10.times.map do |i|
    Async do
      User.find(i)  # Each runs in own Fiber
    end
  end.map(&:wait)
end
```

#### 3. RBS - Type Signatures
```ruby
# user.rbs file
class User
  attr_reader name: String
  attr_reader age: Integer

  def initialize: (name: String, age: Integer) -> void
  def adult?: () -> bool
  def greet: (?String) -> String
end

# Ruby file
class User
  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age = age
  end

  def adult?
    age >= 18
  end

  def greet(greeting = "Hello")
    "#{greeting}, I'm #{name}"
  end
end

# Type checking with Steep
# steep check user.rb
```

#### 4. Keyword Argument Separation
```ruby
# Ruby 2.x - Positional hash converted to keywords
def method(x, **kwargs)
  p kwargs
end

# Ruby 2.x behavior
method(1, {a: 1})  # kwargs = {a: 1}

# Ruby 3.0 - Strict separation
method(1, {a: 1})  # Error!
method(1, **{a: 1})  # Explicit - kwargs = {a: 1}
method(1, a: 1)  # Direct - kwargs = {a: 1}

# For delegation
def delegate(*args, **kwargs, &block)
  target(*args, **kwargs, &block)
end
```

#### 5. One-line Pattern Matching
```ruby
# Ruby 2.7 - case/in syntax
case expr
in pattern
  # ...
end

# Ruby 3.0 - One-line syntax
{name: "John", age: 30} => {name:, age:}
# name = "John", age = 30

# In conditionals
if {status: 200, body: data} => {status: 200, body:}
  process(body)
end

# Rightward assignment
42 => x
# x = 42
```

---

## Ruby 3.1 (2021)

### "YJIT and Developer Experience"

#### 1. YJIT - Yet Another JIT
```ruby
# Enable YJIT (better than MJIT for most cases)
# ruby --yjit script.rb

# Check if enabled
defined?(RubyVM::YJIT) && RubyVM::YJIT.enabled?

# YJIT stats
if defined?(RubyVM::YJIT)
  stats = RubyVM::YJIT.runtime_stats
  puts "Compiled blocks: #{stats[:compiled_block_count]}"
  puts "Inline code size: #{stats[:inline_code_size]}"
end

# 15-20% faster for typical Rails apps
# Better startup time than MJIT
```

#### 2. Anonymous Block Arguments
```ruby
# Ruby 3.1 - Block without parameters
[1, 2, 3].each { puts(_1) }  # Numbered parameters

# Ruby 3.1 - Anonymous block argument
def times_two(&)  # & without name
  yield(2)
end

times_two { |x| puts x }  # 2

# Method delegation with anonymous block
def delegate_method(*, **, &)
  target_method(*, **, &)
end
```

#### 3. Hash and Array Literal Value Omission
```ruby
# When variable name matches hash key
name = "John"
age = 30

# Before Ruby 3.1
user = {name: name, age: age}

# Ruby 3.1 - Value omission
user = {name:, age:}  # Same as above

# Works with string keys too
user = {"name" => name, "age" => age}
# Shorthand not available for string keys

# In method calls
create_user(name:, age:, email:)
```

#### 4. Pin Operator in Pattern Matching
```ruby
# Pin operator ^ to match against variable value
expected = 42

case value
in ^expected  # Match against expected's value (42)
  "Matched #{expected}"
in other
  "Got #{other}"
end

# Array pattern with pinning
first = 1
case [1, 2, 3]
in [^first, *rest]  # Match if first element equals first variable
  "Starts with #{first}"
end

# Useful for validation
valid_status = "active"
case user
in {status: ^valid_status, name:}
  "Active user: #{name}"
end
```

#### 5. error_highlight Gem
```ruby
# Built-in error highlighting
# Shows exactly where error occurred

def divide(a, b)
  a / b
end

divide(10, 0)
# Error message shows underline:
# divided by 0 (ZeroDivisionError)
#   a / b
#     ^^^

# Array access error
arr = [1, 2, 3]
arr[10].upcase
# undefined method `upcase' for nil:NilClass
#   arr[10].upcase
#          ^^^^^^^
```

---

## Ruby 3.2 (2022)

### "Performance and Productivity"

#### 1. WASI Support
```ruby
# WebAssembly System Interface support
# Run Ruby in browsers and edge computing

# Compile Ruby to WASM
# ruby --wasm script.rb

# Can run Ruby in:
# - Browsers
# - Cloudflare Workers
# - Wasmer
# - Node.js
```

#### 2. Data Class
```ruby
# Immutable value objects (like Struct but immutable)

# Before Ruby 3.2 - Using Struct
Person = Struct.new(:name, :age) do
  def adult?
    age >= 18
  end
end

person = Person.new("John", 30)
person.age = 31  # Mutable!

# Ruby 3.2 - Data class
Person = Data.define(:name, :age) do
  def adult?
    age >= 18
  end
end

person = Person.new(name: "John", age: 30)
# person.age = 31  # Error! Immutable

# Create modified copy
older_person = person.with(age: 31)

# Pattern matching support
case person
in Person[name:, age: 18..]
  "#{name} is an adult"
end

# Useful for value objects
Point = Data.define(:x, :y) do
  def distance_from_origin
    Math.sqrt(x**2 + y**2)
  end
end
```

#### 3. Set is Now Built-in
```ruby
# Before Ruby 3.2
require 'set'
set = Set.new([1, 2, 3])

# Ruby 3.2 - No require needed
set = Set[1, 2, 3]
set << 4
set.include?(3)  # true

# Set operations
set1 = Set[1, 2, 3]
set2 = Set[2, 3, 4]

set1 & set2  # Intersection: Set[2, 3]
set1 | set2  # Union: Set[1, 2, 3, 4]
set1 - set2  # Difference: Set[1]
```

#### 4. Improved YJIT
```ruby
# YJIT now production-ready
# 30-40% faster for compute-heavy code

# Memory usage reduced by 50%
# Better optimization for:
# - Method calls
# - Instance variables
# - Integer operations
# - String operations

# Enable in production
ENV['RUBYOPT'] = '--yjit'
```

---

## Ruby 3.3 (2023)

### "Parser Revolution"

#### 1. Prism Parser (formerly YARP)
```ruby
# New parser written in C
# 2x faster parsing
# Better error messages
# Foundation for future tooling

# Benefits:
# - Faster boot time
# - Better IDE support
# - More accurate syntax highlighting
# - Improved error recovery
```

#### 2. RJIT (Pure Ruby JIT)
```ruby
# Replaces MJIT
# Written in pure Ruby (easier to maintain)

# Enable RJIT
# ruby --rjit script.rb

# Performance similar to YJIT for some workloads
# Good for development/testing
```

#### 3. M:N Thread Scheduler
```ruby
# Maps M Ruby threads to N native threads
# Better concurrency without Ractors

# Automatic for I/O-bound operations
threads = 10.times.map do |i|
  Thread.new do
    # These can run on fewer OS threads
    response = Net::HTTP.get(URI("http://api.example.com/#{i}"))
    JSON.parse(response)
  end
end

results = threads.map(&:value)
```

#### 4. Range#overlap?
```ruby
# Check if ranges overlap
(1..5).overlap?(3..7)   # true
(1..5).overlap?(6..10)  # false
(1..5).overlap?(5..10)  # true (boundary overlap)

# Works with time ranges
morning = Time.parse("9:00")..Time.parse("12:00")
meeting = Time.parse("11:00")..Time.parse("13:00")
morning.overlap?(meeting)  # true

# Exclusive ranges
(1...5).overlap?(5..10)  # false
```

---

## Performance Improvements Timeline

### Memory Management Evolution
```ruby
# Ruby 1.8: Mark & Sweep GC
# - Stop-the-world collection
# - Long pauses

# Ruby 1.9: Lazy Sweep
# - Reduced pause times

# Ruby 2.0: Bitmap Marking
# - Copy-on-write friendly

# Ruby 2.1: Generational GC (RGenGC)
# - Young/Old generation
# - 40% less GC time

# Ruby 2.2: Incremental GC
# - Shorter pause times
# - Better for web apps

# Ruby 2.4: Unified Integer
# - Less memory for numbers

# Ruby 3.0: Compaction GC
GC.compact  # Defragment heap

# Ruby 3.1: Variable Width Allocation
# - Better memory usage for objects
```

### JIT Compiler Evolution
```ruby
# Ruby 2.6: MJIT (First JIT)
# - C-based JIT
# - 2-3x faster for specific workloads

# Ruby 3.0: MJIT improvements
# - Better optimization

# Ruby 3.1: YJIT (Shopify's JIT)
# - Better real-world performance
# - Lower memory overhead

# Ruby 3.2: YJIT Production Ready
# - 30-40% faster
# - Enabled at Shopify scale

# Ruby 3.3: RJIT
# - Pure Ruby JIT
# - Easier maintenance
```

---

## Migration Cheat Sheet

### Quick Decision Guide

#### Should I Upgrade?

**From 2.7 → 3.0+**
- ✅ Yes if: You want better performance, parallelism
- ⚠️  Careful if: Heavy metaprogramming, many gems
- Main work: Fix keyword argument separation

**From 3.0 → 3.1+**
- ✅ Yes if: You want YJIT performance
- ✅ Easy upgrade, few breaking changes

**From 3.1 → 3.2+**
- ✅ Yes if: You want Data classes, better YJIT
- ✅ Very easy upgrade

**From 3.2 → 3.3+**
- ✅ Yes if: You want latest features
- ✅ Seamless upgrade

### Breaking Changes Summary

#### Ruby 2.7 → 3.0
```ruby
# Keyword arguments
method({key: value})  # ❌ Breaks
method(**{key: value})  # ✅ Fixed

# Removed methods
File.exists?  # ❌ Removed
File.exist?   # ✅ Use this
```

#### Ruby 3.0 → 3.1
```ruby
# Minimal breaking changes
# Mostly additions
```

#### Ruby 3.1 → 3.2
```ruby
# No major breaking changes
# Set now built-in (might conflict if you defined Set)
```

#### Ruby 3.2 → 3.3
```ruby
# No breaking changes
# Parser improvements transparent
```

### Performance Gains by Version

```
Ruby 1.9: 2-3x faster than 1.8
Ruby 2.0: 10% faster than 1.9
Ruby 2.1: 20% faster (RGenGC)
Ruby 2.2: 30% faster (Incremental GC)
Ruby 2.3-2.5: 5-10% each
Ruby 2.6: 10% with MJIT
Ruby 2.7: 10% improvements
Ruby 3.0: 3x faster than 2.0 (goal achieved)
Ruby 3.1: +20% with YJIT
Ruby 3.2: +40% with YJIT
Ruby 3.3: +10% with parser improvements
```

Remember: Each Ruby version brings performance improvements, new features, and better developer experience. The Ruby core team maintains excellent backward compatibility while continuously improving the language.