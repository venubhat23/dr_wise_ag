# Ruby Advanced Concepts - Complete Guide

## Table of Contents
1. [Scope and Binding](#scope-and-binding)
2. [Threading and Concurrency](#threading-and-concurrency)
3. [Fibers and Continuations](#fibers-and-continuations)
4. [Memory Management](#memory-management)
5. [Method Lookup and Eigenclass](#method-lookup-and-eigenclass)
6. [Advanced Metaprogramming](#advanced-metaprogramming)
7. [DSL Creation](#dsl-creation)
8. [Hook Methods Deep Dive](#hook-methods-deep-dive)
9. [Advanced Module Patterns](#advanced-module-patterns)
10. [Performance Optimization](#performance-optimization)
11. [Security Concepts](#security-concepts)
12. [Advanced Debugging](#advanced-debugging)

---

## 1. Scope and Binding

### Understanding Ruby Scope

**What is Scope?**
Scope is the context where variables are accessible. Think of it like rooms in a house - you can only see what's in the room you're in.

#### Types of Scope in Ruby

```ruby
# 1. Global Scope - Accessible everywhere (like house address)
$global_var = "I'm everywhere"

class MyClass
  def show_global
    puts $global_var  # Works anywhere
  end
end

# 2. Class Scope - Inside class definition
class User
  # This is class scope
  @@class_var = 0  # Shared by all instances
  CONSTANT = "FIXED"  # Also in class scope

  def self.in_class_scope
    puts "Class method has access to @@class_var: #{@@class_var}"
  end
end

# 3. Instance Scope - Specific to each object
class Person
  def initialize(name)
    @name = name  # Instance scope - each person has own @name
  end

  def greet
    # Method has access to instance variables
    puts "Hello, I'm #{@name}"
  end
end

# 4. Local Scope - Limited to method/block
def my_method
  local_var = "Only here"  # Dies when method ends

  # Block creates new scope but can see outer variables
  [1, 2, 3].each do |num|
    block_var = num * 2  # Only exists in block
    puts local_var  # Can see outer scope
  end

  # puts block_var  # Error! block_var doesn't exist here
end

# 5. Block Scope - Special case
x = 10
[1, 2].each do |x|  # This x shadows outer x
  puts x  # 1, then 2
end
puts x  # Still 10 (outer x unchanged)
```

### Scope Gates (Where Scope Changes)

```ruby
# Three scope gates in Ruby: class, module, def

v1 = 1  # Local variable

class MyClass  # SCOPE GATE - entering class
  v2 = 2  # New local scope
  # puts v1  # Error! Can't see v1

  def my_method  # SCOPE GATE - entering method
    v3 = 3
    # puts v2  # Error! Can't see v2
  end
end

# Flattening Scope - Avoiding scope gates
my_var = "outer"

MyClass = Class.new do  # Using Class.new instead of class keyword
  puts my_var  # Works! No scope gate

  define_method :my_method do  # Using define_method instead of def
    puts my_var  # Works! Can access outer variable
  end
end
```

### Binding - Capturing Scope

```ruby
# Binding is like taking a photograph of the current scope

def create_binding
  x = 10
  y = 20
  binding  # Returns current scope as object
end

b = create_binding

# Later, we can evaluate code in that scope
eval("x + y", b)  # 30
eval("x = 100", b)  # Change x in that binding
eval("x", b)  # 100

# Practical example: Template rendering
class Template
  def initialize(template_string)
    @template = template_string
  end

  def render(data_binding)
    ERB.new(@template).result(data_binding)
  end
end

name = "John"
age = 30
template = Template.new("Hello <%= name %>, you are <%= age %>")
puts template.render(binding)  # "Hello John, you are 30"

# Advanced: Creating custom scope
class ScopeBuilder
  def initialize
    @vars = {}
  end

  def set(name, value)
    @vars[name] = value
  end

  def get_binding
    @vars.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
    binding
  end
end

scope = ScopeBuilder.new
scope.set(:user, "Alice")
scope.set(:role, "Admin")
eval("puts @user", scope.get_binding)  # Alice
```

### Closures - Functions That Remember

```ruby
# Closure is a function that "closes over" variables from its creation scope

def create_counter(initial = 0)
  count = initial  # Local variable

  # These lambdas "close over" the count variable
  increment = -> { count += 1 }
  decrement = -> { count -= 1 }
  get_count = -> { count }

  {increment: increment, decrement: decrement, current: get_count}
end

counter = create_counter(10)
counter[:increment].call  # 11
counter[:increment].call  # 12
counter[:decrement].call  # 11
counter[:current].call    # 11

# The 'count' variable lives on even after create_counter returns!

# Real-world example: Rate limiter
def rate_limiter(max_calls, time_window)
  calls = []

  lambda do
    now = Time.now
    # Remove old calls outside time window
    calls.reject! { |time| now - time > time_window }

    if calls.size < max_calls
      calls << now
      true  # Allow call
    else
      false  # Rate limit exceeded
    end
  end
end

api_limiter = rate_limiter(10, 60)  # 10 calls per 60 seconds
10.times { api_limiter.call }  # All return true
api_limiter.call  # Returns false (limit exceeded)
```

---

## 2. Threading and Concurrency

### Understanding Threads

**What are Threads?**
Threads are like multiple workers doing tasks simultaneously in your program. Think of it like having multiple browser tabs open - each can load independently.

```ruby
# Basic thread creation
thread = Thread.new do
  5.times do |i|
    puts "Thread: #{i}"
    sleep(0.1)
  end
end

# Main thread continues
5.times do |i|
  puts "Main: #{i}"
  sleep(0.1)
end

thread.join  # Wait for thread to finish

# Multiple threads
threads = []
10.times do |i|
  threads << Thread.new do
    sleep(rand(0.1..0.5))
    puts "Thread #{i} finished"
  end
end

threads.each(&:join)  # Wait for all threads
```

### Thread Safety and Race Conditions

```ruby
# PROBLEM: Race Condition
counter = 0
threads = 10.times.map do
  Thread.new do
    1000.times do
      counter += 1  # NOT thread-safe!
    end
  end
end
threads.each(&:join)
puts counter  # Often less than 10000!

# SOLUTION 1: Mutex (Mutual Exclusion)
counter = 0
mutex = Mutex.new

threads = 10.times.map do
  Thread.new do
    1000.times do
      mutex.synchronize do
        counter += 1  # Now thread-safe
      end
    end
  end
end
threads.each(&:join)
puts counter  # Always 10000

# SOLUTION 2: Thread-safe data structures
require 'concurrent'
counter = Concurrent::AtomicFixnum.new(0)

threads = 10.times.map do
  Thread.new do
    1000.times do
      counter.increment  # Thread-safe
    end
  end
end
threads.each(&:join)
puts counter.value  # Always 10000
```

### Thread Pool Pattern

```ruby
# Managing threads efficiently
class ThreadPool
  def initialize(size)
    @size = size
    @jobs = Queue.new  # Thread-safe queue
    @pool = Array.new(size) do
      Thread.new do
        loop do
          job = @jobs.pop  # Blocks until job available
          break if job == :shutdown
          job.call
        end
      end
    end
  end

  def schedule(&block)
    @jobs << block
  end

  def shutdown
    @size.times { @jobs << :shutdown }
    @pool.each(&:join)
  end
end

# Usage
pool = ThreadPool.new(5)

100.times do |i|
  pool.schedule do
    puts "Processing job #{i}"
    sleep(0.1)
  end
end

pool.shutdown
```

### Thread Variables and Communication

```ruby
# Thread-local variables
Thread.new do
  Thread.current[:user_id] = 123
  Thread.current[:request_id] = "abc-456"

  # These variables only exist in this thread
  puts Thread.current[:user_id]
end.join

# Thread communication with Queue
queue = Queue.new

producer = Thread.new do
  5.times do |i|
    queue << "Message #{i}"
    sleep(0.5)
  end
  queue << :done
end

consumer = Thread.new do
  loop do
    msg = queue.pop
    break if msg == :done
    puts "Received: #{msg}"
  end
end

[producer, consumer].each(&:join)

# SizedQueue - Bounded queue
queue = SizedQueue.new(3)  # Max 3 items

Thread.new do
  10.times do |i|
    puts "Pushing #{i}"
    queue.push(i)  # Blocks if queue full
  end
end

Thread.new do
  10.times do
    sleep(0.5)
    puts "Popped: #{queue.pop}"
  end
end.join
```

### Deadlock Prevention

```ruby
# Deadlock example - DON'T DO THIS
mutex1 = Mutex.new
mutex2 = Mutex.new

thread1 = Thread.new do
  mutex1.synchronize do
    sleep(0.1)
    mutex2.synchronize do
      puts "Thread 1"
    end
  end
end

thread2 = Thread.new do
  mutex2.synchronize do
    sleep(0.1)
    mutex1.synchronize do  # Deadlock! Waiting for mutex1
      puts "Thread 2"
    end
  end
end

# Solution: Always acquire locks in same order
class SafeTransfer
  def initialize
    @mutex = Mutex.new
    @accounts = {}
  end

  def transfer(from, to, amount)
    # Always lock accounts in same order (by ID)
    first, second = [from, to].sort

    @mutex.synchronize do
      @accounts[from] -= amount
      @accounts[to] += amount
    end
  end
end
```

---

## 3. Fibers and Continuations

### Fibers - Lightweight Concurrency

**What are Fibers?**
Fibers are like threads but YOU control when they switch (cooperative multitasking). Think of it like reading multiple books - you decide when to switch between them.

```ruby
# Basic Fiber
fiber = Fiber.new do
  puts "Fiber started"
  Fiber.yield "First yield"  # Pause and return value
  puts "Fiber resumed"
  Fiber.yield "Second yield"
  puts "Fiber ending"
  "Final value"
end

puts fiber.resume  # "Fiber started" then "First yield"
puts fiber.resume  # "Fiber resumed" then "Second yield"
puts fiber.resume  # "Fiber ending" then "Final value"
# fiber.resume  # Error: dead fiber

# Producer-Consumer with Fibers
producer = Fiber.new do
  3.times do |i|
    puts "Producing: #{i}"
    Fiber.yield i * 2  # Produce value
  end
end

consumer = Fiber.new do
  loop do
    value = producer.resume
    break unless producer.alive?
    puts "Consumed: #{value}"
  end
end

consumer.resume

# Enumerator uses Fibers internally
enum = Enumerator.new do |yielder|
  count = 0
  loop do
    yielder << count
    count += 1
  end
end

puts enum.next  # 0
puts enum.next  # 1
puts enum.next  # 2
```

### Advanced Fiber Patterns

```ruby
# Fiber for async-like operations
class AsyncTask
  def initialize(&block)
    @fiber = Fiber.new do
      block.call
    end
  end

  def run_until_blocked
    @fiber.resume if @fiber.alive?
  end

  def done?
    !@fiber.alive?
  end
end

# Simulating async I/O
task = AsyncTask.new do
  puts "Starting download..."
  Fiber.yield  # Simulate waiting for I/O
  puts "Download 50%..."
  Fiber.yield
  puts "Download complete!"
end

until task.done?
  task.run_until_blocked
  sleep(0.5)  # Do other work
end

# Fiber-based Generator
def fibonacci_generator
  Fiber.new do
    a, b = 0, 1
    loop do
      Fiber.yield a
      a, b = b, a + b
    end
  end
end

fib = fibonacci_generator
10.times { puts fib.resume }
```

### Fiber Scheduler (Ruby 3.0+)

```ruby
require 'async'

# Non-blocking I/O with Fiber Scheduler
Async do |task|
  # These run concurrently without threads
  task.async do
    puts "Task 1 starting"
    sleep 1  # Non-blocking sleep
    puts "Task 1 done"
  end

  task.async do
    puts "Task 2 starting"
    sleep 0.5
    puts "Task 2 done"
  end
end

# Real-world example: Concurrent HTTP requests
require 'async'
require 'async/http/internet'

Async do
  internet = Async::HTTP::Internet.new

  responses = ["google.com", "github.com", "ruby-lang.org"].map do |site|
    Async do
      response = internet.get("https://#{site}")
      [site, response.status]
    end
  end.map(&:wait)

  responses.each do |site, status|
    puts "#{site}: #{status}"
  end
ensure
  internet&.close
end
```

---

## 4. Memory Management

### Understanding Ruby's Memory Model

```ruby
# Object allocation
obj = Object.new
puts obj.object_id  # Unique identifier

# Immediate values (no heap allocation)
# Fixnum (small integers), true, false, nil, symbols
a = 42
b = 42
a.object_id == b.object_id  # true (same object)

s1 = "hello"
s2 = "hello"
s1.object_id == s2.object_id  # false (different objects)

sym1 = :hello
sym2 = :hello
sym1.object_id == sym2.object_id  # true (same object)

# Memory profiling
require 'objspace'

ObjectSpace.memsize_of("hello")  # Bytes used
ObjectSpace.memsize_of({a: 1, b: 2})
ObjectSpace.memsize_of([1, 2, 3, 4, 5])

# Count objects
GC.start  # Force garbage collection
ObjectSpace.count_objects
# {:TOTAL=>50000, :FREE=>30000, :T_OBJECT=>1000, ...}
```

### Garbage Collection Deep Dive

```ruby
# GC Statistics
GC.stat
# {:count=>10, :heap_allocated_pages=>100, ...}

# Disable/Enable GC
GC.disable
# Do memory-intensive work
GC.enable
GC.start  # Force collection

# Generational GC
class MyClass
  attr_accessor :data

  def initialize
    @data = "x" * 1000000  # 1MB string
  end
end

# Monitor object generation
obj = MyClass.new
ObjectSpace.dump(obj)  # JSON dump of object

# GC Tuning
# Set environment variables:
# RUBY_GC_HEAP_INIT_SLOTS=100000
# RUBY_GC_HEAP_GROWTH_FACTOR=1.8
# RUBY_GC_MALLOC_LIMIT=90000000

# Weak References - Allow GC
require 'weakref'

class Cache
  def initialize
    @cache = {}
  end

  def get(key)
    ref = @cache[key]
    ref && ref.weakref_alive? ? ref.__getobj__ : nil
  end

  def set(key, value)
    @cache[key] = WeakRef.new(value)
  end
end

cache = Cache.new
big_data = "x" * 10_000_000
cache.set(:data, big_data)

big_data = nil
GC.start  # May collect the cached data

cache.get(:data)  # Might be nil if GC'd
```

### Memory Optimization Techniques

```ruby
# 1. String Freezing
CONSTANT_STRING = "immutable".freeze
# Ruby 3.0+ has frozen string literals by default

# 2. Symbol vs String
# Bad - Creates new string each time
def status_string(code)
  statuses = {"200" => "OK", "404" => "Not Found"}
  statuses[code]
end

# Good - Uses symbols (single instance)
def status_symbol(code)
  statuses = {200 => "OK", 404 => "Not Found"}
  statuses[code]
end

# 3. Object Pooling
class ConnectionPool
  def initialize(size)
    @pool = Queue.new
    size.times { @pool << create_connection }
  end

  def with_connection
    conn = @pool.pop
    yield conn
  ensure
    @pool << conn
  end

  private
  def create_connection
    # Expensive connection creation
    TCPSocket.new('localhost', 5432)
  end
end

# 4. Lazy Loading
class User
  def profile
    @profile ||= expensive_profile_load
  end

  private
  def expensive_profile_load
    # Load only when needed
    Profile.find(id)
  end
end

# 5. Memory Profiling
require 'memory_profiler'

report = MemoryProfiler.report do
  1000.times { "string" * 100 }
end

report.pretty_print
```

---

## 5. Method Lookup and Eigenclass

### Method Lookup Chain

```ruby
# Ruby looks for methods in specific order

class Animal
  def speak
    "Generic sound"
  end
end

module Swimmer
  def swim
    "Swimming"
  end
end

class Dog < Animal
  include Swimmer

  def speak
    "Woof"
  end
end

# Method lookup chain:
Dog.ancestors
# [Dog, Swimmer, Animal, Object, Kernel, BasicObject]

# Ruby searches in order until method found
```

### Eigenclass (Singleton Class)

**What is Eigenclass?**
Every object has a hidden class just for itself where singleton methods live. It's like a personal assistant that only serves one object.

```ruby
# Every object has an eigenclass
obj = "hello"

# Access eigenclass
eigenclass = class << obj
  self  # Returns the eigenclass
end

# Or
eigenclass = obj.singleton_class

# Add singleton method
def obj.shout
  self.upcase + "!"
end

obj.shout  # "HELLO!"
"other".shout  # Error! Only obj has this method

# Where singleton methods live
class Person
  def self.species  # This is singleton method on Person class
    "Homo sapiens"
  end
end

# Person class itself is an object
# Its singleton methods live in Person's eigenclass

# Eigenclass chain
class C; end
obj = C.new

# obj's lookup chain:
# [obj's eigenclass] -> C -> Object -> Kernel -> BasicObject

def obj.special_method
  "I'm special"
end

# Now:
# [obj's eigenclass with special_method] -> C -> Object...

# Class methods are singleton methods
class MyClass
  class << self  # Opening eigenclass of MyClass
    def class_method1
      "Method 1"
    end

    def class_method2
      "Method 2"
    end
  end
end
```

### Advanced Eigenclass Patterns

```ruby
# Eigenclass of eigenclass
obj = Object.new
eigenclass = obj.singleton_class
eigen_eigenclass = eigenclass.singleton_class  # 🤯

# Include modules in eigenclass
module Greetable
  def hello
    "Hi there!"
  end
end

obj = Object.new
class << obj
  include Greetable
end

obj.hello  # "Hi there!"

# Real-world: Per-instance behavior
class User
  attr_reader :name, :role

  def initialize(name, role)
    @name = name
    @role = role

    # Add role-specific methods
    if role == :admin
      class << self
        def delete_user(user)
          puts "#{@name} deleted #{user}"
        end

        def system_report
          "System is running"
        end
      end
    end
  end
end

admin = User.new("Alice", :admin)
user = User.new("Bob", :user)

admin.delete_user("Charlie")  # Works
# user.delete_user("Charlie")  # Error!
```

---

## 6. Advanced Metaprogramming

### Code That Writes Code

```ruby
# Dynamic method creation
class DynamicClass
  # Create getters/setters dynamically
  %w[name age email].each do |attr|
    define_method(attr) do
      instance_variable_get("@#{attr}")
    end

    define_method("#{attr}=") do |value|
      instance_variable_set("@#{attr}", value)
    end
  end
end

# Method generation from data
class APIClient
  ENDPOINTS = {
    users: '/api/users',
    posts: '/api/posts',
    comments: '/api/comments'
  }

  ENDPOINTS.each do |name, path|
    define_method("get_#{name}") do |id = nil|
      url = id ? "#{path}/#{id}" : path
      HTTP.get(url)
    end

    define_method("create_#{name}") do |data|
      HTTP.post(path, data)
    end
  end
end

client = APIClient.new
client.get_users
client.get_users(123)
client.create_posts({title: "Hello"})
```

### const_missing and autoloading

```ruby
# Auto-load classes when referenced
class Module
  def const_missing(name)
    # Try to load file based on constant name
    file_name = name.to_s.downcase
    require_relative file_name

    # Check if constant now exists
    if const_defined?(name)
      const_get(name)
    else
      super
    end
  end
end

# Lazy loading pattern
module LazyLoader
  def self.const_missing(name)
    case name
    when :HeavyClass
      puts "Loading HeavyClass..."
      const_set(name, Class.new do
        def initialize
          @data = "x" * 1000000
        end
      end)
    else
      super
    end
  end
end

# HeavyClass loaded only when first used
obj = LazyLoader::HeavyClass.new
```

### TracePoint API

```ruby
# Monitor Ruby execution
trace = TracePoint.new(:call, :return) do |tp|
  puts "#{tp.event} #{tp.defined_class}##{tp.method_id}"
end

trace.enable
# Your code here
"hello".upcase
trace.disable

# Method call tracking
class MethodProfiler
  def self.profile(klass, method_name)
    TracePoint.new(:call, :return) do |tp|
      if tp.defined_class == klass && tp.method_id == method_name
        if tp.event == :call
          @start = Time.now
        else
          puts "#{klass}##{method_name} took #{Time.now - @start}s"
        end
      end
    end
  end
end

profiler = MethodProfiler.profile(String, :upcase)
profiler.enable
"hello".upcase
profiler.disable
```

### ObjectSpace Manipulation

```ruby
# Find all instances of a class
ObjectSpace.each_object(String) do |str|
  puts str if str.length > 10
end

# Count instances
count = ObjectSpace.each_object(Hash).count

# Find object by ID
obj = Object.new
id = obj.object_id
found = ObjectSpace._id2ref(id)  # Get object from ID

# Finalizers - Code to run when object GC'd
class Resource
  def initialize(name)
    @name = name
    ObjectSpace.define_finalizer(self, self.class.finalize(@name))
  end

  def self.finalize(name)
    proc { puts "#{name} is being garbage collected" }
  end
end

res = Resource.new("Important")
res = nil
GC.start  # Triggers finalizer
```

---

## 7. DSL Creation

### Building Domain-Specific Languages

```ruby
# Simple DSL for configuration
class Config
  def self.build(&block)
    config = new
    config.instance_eval(&block)
    config
  end

  def database(&block)
    @database = Database.new
    @database.instance_eval(&block) if block
    @database
  end

  class Database
    attr_accessor :host, :port, :name

    def host(value = nil)
      value ? @host = value : @host
    end

    def port(value = nil)
      value ? @port = value : @port
    end
  end
end

# Usage
config = Config.build do
  database do
    host 'localhost'
    port 5432
  end
end

# HTML DSL
class HTML
  def initialize(&block)
    @output = ""
    instance_eval(&block)
  end

  def method_missing(tag, *args, &block)
    attributes = args.first || {}
    @output << "<#{tag}"

    attributes.each do |key, value|
      @output << " #{key}='#{value}'"
    end

    if block
      @output << ">"
      instance_eval(&block)
      @output << "</#{tag}>"
    else
      @output << "/>"
    end
  end

  def text(content)
    @output << content
  end

  def to_s
    @output
  end
end

# Usage
html = HTML.new do
  div class: 'container' do
    h1 { text "Welcome" }
    p { text "This is a paragraph" }
    img src: 'photo.jpg'
  end
end

puts html.to_s
```

### Advanced DSL Patterns

```ruby
# Routing DSL (like Sinatra)
class WebApp
  def self.routes
    @routes ||= {}
  end

  def self.get(path, &block)
    routes["GET #{path}"] = block
  end

  def self.post(path, &block)
    routes["POST #{path}"] = block
  end

  def self.call(method, path, params = {})
    route = routes["#{method} #{path}"]
    route ? route.call(params) : "404 Not Found"
  end
end

# Define routes
class MyApp < WebApp
  get '/users' do |params|
    "List of users"
  end

  get '/users/:id' do |params|
    "User #{params[:id]}"
  end

  post '/users' do |params|
    "Creating user with #{params.inspect}"
  end
end

# Use routes
MyApp.call('GET', '/users')
MyApp.call('POST', '/users', name: 'John')

# Testing DSL
class TestFramework
  def self.describe(description, &block)
    puts "Testing: #{description}"
    suite = new
    suite.instance_eval(&block)
    suite.run_tests
  end

  def initialize
    @tests = []
    @before_each = nil
  end

  def before_each(&block)
    @before_each = block
  end

  def it(description, &block)
    @tests << { description: description, block: block }
  end

  def run_tests
    @tests.each do |test|
      @before_each&.call
      begin
        test[:block].call
        puts "  ✓ #{test[:description]}"
      rescue => e
        puts "  ✗ #{test[:description]}: #{e.message}"
      end
    end
  end
end

# Usage
TestFramework.describe "Calculator" do
  before_each do
    @calc = Calculator.new
  end

  it "adds numbers" do
    raise "Failed" unless @calc.add(2, 3) == 5
  end

  it "multiplies numbers" do
    raise "Failed" unless @calc.multiply(3, 4) == 12
  end
end
```

---

## 8. Hook Methods Deep Dive

### All Ruby Hook Methods

```ruby
# 1. Class/Module Hooks
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

class Child < Parent  # Triggers inherited
end

# 2. Module Hooks
module Trackable
  def self.included(base)
    puts "#{self} included in #{base}"
    base.extend(ClassMethods)
    base.class_eval do
      attr_accessor :tracked_at
    end
  end

  def self.extended(base)
    puts "#{self} extended by #{base}"
  end

  def self.prepended(base)
    puts "#{self} prepended to #{base}"
  end

  module ClassMethods
    def track_method(name)
      alias_method "#{name}_without_tracking", name
      define_method(name) do |*args|
        puts "Calling #{name}"
        result = send("#{name}_without_tracking", *args)
        puts "Finished #{name}"
        result
      end
    end
  end
end

# 3. Method Hooks
class MethodTracker
  def self.method_added(name)
    puts "Instance method added: #{name}"
    return if @adding  # Prevent infinite loop
    @adding = true

    alias_method "#{name}_original", name
    define_method(name) do |*args|
      puts "Calling #{name}"
      send("#{name}_original", *args)
    end

    @adding = false
  end

  def self.singleton_method_added(name)
    puts "Class method added: #{name}"
  end

  def self.method_removed(name)
    puts "Method removed: #{name}"
  end

  def self.method_undefined(name)
    puts "Method undefined: #{name}"
  end
end

# 4. Constant Hooks
module ConstantTracker
  def self.const_missing(name)
    puts "Missing constant: #{name}"
    const_set(name, "Generated value for #{name}")
  end

  def self.const_added(name)
    puts "Constant added: #{name}"
  end
end

# 5. Object Lifecycle Hooks
class Lifecycle
  def initialize
    puts "Object created"
    ObjectSpace.define_finalizer(self, self.class.finalize(self.object_id))
  end

  def self.finalize(id)
    proc { puts "Object #{id} garbage collected" }
  end
end

# 6. Method Call Hooks
module Callable
  def method_missing(name, *args)
    if name.to_s.start_with?('find_by_')
      attribute = name.to_s.sub('find_by_', '')
      puts "Finding by #{attribute}: #{args.first}"
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s.start_with?('find_by_') || super
  end
end
```

---

## 9. Advanced Module Patterns

### Module Builders

```ruby
# Creating modules dynamically
def create_accessor_module(*attributes)
  Module.new do
    attributes.each do |attr|
      define_method(attr) do
        instance_variable_get("@#{attr}")
      end

      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value)
      end
    end
  end
end

class Person
  include create_accessor_module(:name, :age, :email)
end

# Module with configuration
module Configurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :timeout, :retries, :logger

    def initialize
      @timeout = 30
      @retries = 3
      @logger = Logger.new(STDOUT)
    end
  end
end

class APIClient
  include Configurable

  configure do |config|
    config.timeout = 60
    config.retries = 5
  end
end
```

### Concern Pattern

```ruby
# Rails-like concerns
module Concern
  def self.extended(base)
    base.instance_variable_set(:@_dependencies, [])
  end

  def append_features(base)
    if base.instance_variable_defined?(:@_dependencies)
      base.instance_variable_get(:@_dependencies) << self
      return false
    else
      return super
    end
  end

  def included(base = nil, &block)
    if base.nil?
      if instance_variable_defined?(:@_included)
        @_included_block = block
      end
    else
      super
    end
  end

  def class_methods(&block)
    @_class_methods = Module.new(&block)
  end
end

# Usage
module Timestamps
  extend Concern

  included do
    attr_accessor :created_at, :updated_at
  end

  class_methods do
    def with_timestamps
      puts "Timestamps enabled"
    end
  end

  def touch
    @updated_at = Time.now
  end
end

# Module composition
module Cacheable
  def cache_key
    "#{self.class.name.downcase}_#{id}"
  end

  def expire_cache
    Rails.cache.delete(cache_key)
  end
end

module Searchable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def search(query)
      where("name LIKE ?", "%#{query}%")
    end
  end
end

class Product
  include Cacheable
  include Searchable
  include Timestamps
end
```

---

## 10. Performance Optimization

### Benchmarking and Profiling

```ruby
require 'benchmark'

# Simple benchmark
time = Benchmark.measure do
  1000000.times { "test" * 100 }
end
puts time

# Comparative benchmark
n = 1000000
Benchmark.bm(20) do |x|
  x.report("String concatenation:") { n.times { "hello" + " " + "world" } }
  x.report("String interpolation:") { n.times { "hello #{' '} world" } }
  x.report("Array join:") { n.times { ["hello", "world"].join(" ") } }
end

# Memory benchmark
require 'benchmark/memory'

Benchmark.memory do |x|
  x.report("Array") { Array.new(1000) { rand } }
  x.report("Hash") { Hash[*(1..2000).to_a] }
  x.compare!
end

# CPU Profiling
require 'ruby-prof'

RubyProf.start
# Your code here
1000.times { "a" * 100 }
result = RubyProf.stop

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)
```

### Optimization Techniques

```ruby
# 1. Memoization
class Calculator
  def expensive_calculation(n)
    @cache ||= {}
    @cache[n] ||= begin
      sleep(1)  # Simulate expensive operation
      n * n
    end
  end
end

# 2. Lazy Evaluation
class LazyList
  def initialize(enum)
    @enum = enum
  end

  def select(&block)
    LazyList.new(@enum.lazy.select(&block))
  end

  def map(&block)
    LazyList.new(@enum.lazy.map(&block))
  end

  def take(n)
    @enum.take(n).to_a
  end
end

# Usage
list = LazyList.new(1..Float::INFINITY)
result = list.select { |n| n % 2 == 0 }
             .map { |n| n * n }
             .take(10)

# 3. String Optimization
# Bad
result = ""
1000.times { |i| result += i.to_s }

# Good
result = ""
1000.times { |i| result << i.to_s }

# Better
result = Array.new(1000) { |i| i.to_s }.join

# 4. Algorithm Optimization
# Bad - O(n²)
def has_duplicates_slow?(array)
  array.each_with_index do |item, i|
    array.each_with_index do |other, j|
      return true if i != j && item == other
    end
  end
  false
end

# Good - O(n)
def has_duplicates_fast?(array)
  seen = Set.new
  array.each do |item|
    return true if seen.include?(item)
    seen << item
  end
  false
end

# 5. Database Query Optimization
# Bad - N+1 query
users = User.all
users.each do |user|
  puts user.posts.count  # Query for each user
end

# Good - Eager loading
users = User.includes(:posts)
users.each do |user|
  puts user.posts.count  # No additional queries
end
```

---

## 11. Security Concepts

### Input Validation and Sanitization

```ruby
# Dangerous - Command injection
def run_command(input)
  `echo #{input}`  # DANGEROUS!
end

# Safe version
require 'shellwords'

def safe_run_command(input)
  `echo #{Shellwords.escape(input)}`
end

# Or better - avoid shell
def safest_run_command(input)
  system("echo", input)  # Passes as argument, not through shell
end

# SQL Injection Prevention
# Dangerous
def find_user(name)
  User.where("name = '#{name}'")  # SQL injection vulnerability
end

# Safe
def find_user_safe(name)
  User.where("name = ?", name)  # Parameterized query
  # Or
  User.where(name: name)
end

# Mass Assignment Protection
class User
  attr_accessor :name, :email
  attr_reader :role  # Not mass-assignable

  def update_attributes(params)
    # Whitelist allowed attributes
    allowed = params.slice(:name, :email)
    allowed.each do |key, value|
      send("#{key}=", value)
    end
  end
end
```

### Cryptography and Secrets

```ruby
require 'openssl'
require 'securerandom'

# Generate secure random values
token = SecureRandom.hex(32)
uuid = SecureRandom.uuid

# Password hashing (use bcrypt in production)
require 'bcrypt'

password = BCrypt::Password.create("my_password")
password == "my_password"  # true
password == "wrong"        # false

# Encryption/Decryption
class Encryptor
  def initialize(key)
    @key = key
  end

  def encrypt(plaintext)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = Digest::SHA256.digest(@key)
    iv = cipher.random_iv

    encrypted = cipher.update(plaintext) + cipher.final
    Base64.encode64(iv + encrypted)
  end

  def decrypt(ciphertext)
    decoded = Base64.decode64(ciphertext)

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.decrypt
    cipher.key = Digest::SHA256.digest(@key)
    cipher.iv = decoded[0..15]

    cipher.update(decoded[16..-1]) + cipher.final
  end
end

# Timing attack prevention
def secure_compare(a, b)
  return false unless a.bytesize == b.bytesize

  l = a.unpack("C*")
  r = 0
  b.each_byte { |byte| r |= byte ^ l.shift }
  r == 0
end
```

---

## 12. Advanced Debugging

### Custom Debugging Tools

```ruby
# Debug method
def debug(label = "Debug", &block)
  puts "=" * 40
  puts label
  puts "-" * 40

  if block_given?
    start = Time.now
    result = yield
    elapsed = Time.now - start

    puts "Result: #{result.inspect}"
    puts "Time: #{elapsed}s"
  else
    caller.first(5).each { |line| puts line }
  end

  puts "=" * 40
  result
end

# Usage
value = debug("Calculation") do
  (1..1000).reduce(:+)
end

# Trace method calls
class MethodTracer
  def self.trace(object, method)
    original_method = object.method(method)

    object.define_singleton_method(method) do |*args, &block|
      puts "Calling #{method} with #{args.inspect}"
      result = original_method.call(*args, &block)
      puts "#{method} returned #{result.inspect}"
      result
    end
  end
end

# Usage
arr = [1, 2, 3]
MethodTracer.trace(arr, :push)
arr.push(4)  # Outputs trace information

# Memory leak detection
class MemoryMonitor
  def self.check
    before = ObjectSpace.count_objects
    yield
    after = ObjectSpace.count_objects

    diff = {}
    after.each do |key, value|
      diff[key] = value - before[key] if value != before[key]
    end

    puts "Object allocation changes:"
    diff.each do |type, count|
      puts "  #{type}: #{count > 0 ? '+' : ''}#{count}"
    end
  end
end

# Usage
MemoryMonitor.check do
  1000.times { "string" }
  100.times { [] }
  50.times { {} }
end

# Stack trace analyzer
def analyze_stack
  caller_locations.each_with_index do |location, i|
    puts "#{i}: #{location.path}:#{location.lineno} in `#{location.label}'"
  end
end

# Exception debugging
class DetailedException < StandardError
  attr_reader :context

  def initialize(message, context = {})
    super(message)
    @context = context
  end

  def detailed_message
    "#{message}\nContext: #{context.inspect}\nBacktrace:\n#{backtrace.first(5).join("\n")}"
  end
end

# Usage
begin
  raise DetailedException.new("Something went wrong", user_id: 123, action: "update")
rescue DetailedException => e
  puts e.detailed_message
end
```

### Production Debugging

```ruby
# Safe production debugging
module SafeDebug
  def self.enabled?
    ENV['DEBUG'] == 'true' && ENV['RAILS_ENV'] != 'production'
  end

  def self.log(message)
    return unless enabled?

    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    caller_info = caller.first.split(':')[0..1].join(':')

    File.open('debug.log', 'a') do |f|
      f.puts "[#{timestamp}] #{caller_info}: #{message}"
    end
  end

  def self.measure(label)
    return yield unless enabled?

    start = Time.now
    result = yield
    elapsed = Time.now - start

    log("#{label}: #{elapsed}s")
    result
  end
end

# Usage
SafeDebug.measure("Database query") do
  User.where(active: true).count
end

# Conditional breakpoints
def conditional_debugger
  if defined?(Pry) && ENV['DEBUG']
    yield if block_given?
    binding.pry if $debug_condition
  end
end

# Request-specific debugging
class ApplicationController
  around_action :debug_request

  def debug_request
    if params[:debug] == ENV['DEBUG_TOKEN']
      Rails.logger.level = Logger::DEBUG
      response.headers['X-Debug-Info'] = 'true'
    end

    yield
  ensure
    Rails.logger.level = Logger::INFO
  end
end
```

---

## Advanced Ruby Patterns Summary

### Key Takeaways

1. **Scope & Binding**: Understanding scope gates and closures is crucial for metaprogramming
2. **Threading**: Use Mutex for thread safety, prefer Ractors for true parallelism
3. **Fibers**: Great for cooperative concurrency and generators
4. **Memory**: Profile regularly, use weak references for caches
5. **Eigenclass**: Every object has one, class methods live there
6. **Metaprogramming**: Use sparingly, document heavily
7. **DSLs**: Make code expressive but don't overdo it
8. **Hooks**: Powerful for frameworks, careful with performance
9. **Security**: Never trust user input, use parameterized queries
10. **Debugging**: Build debugging into your code from the start

Remember: With great power comes great responsibility. These advanced features should be used judiciously to solve real problems, not to show off clever code.