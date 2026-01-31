# Ruby Mastery Syllabus - Complete Guide

## 📚 Table of Contents
1. [Foundation Level](#foundation-level)
2. [Intermediate Level](#intermediate-level)
3. [Advanced Level](#advanced-level)
4. [Expert Level](#expert-level)
5. [Practice Resources](#practice-resources)
6. [Interview Questions](#interview-questions)

---

## Foundation Level

### 1. Ruby Basics
- **Installation & Environment Setup**
  - RVM/rbenv setup
  - IRB and Pry console
  - Ruby version management

- **Basic Syntax**
  - Variables and constants
  - Data types (String, Integer, Float, Boolean, Symbol, nil)
  - Operators (arithmetic, comparison, logical, assignment)
  - Comments and documentation

- **Control Structures**
  - if/elsif/else/unless
  - case/when statements
  - Ternary operators
  - Modifier if/unless

### 2. Data Structures
- **Arrays**
  - Creation and manipulation
  - Array methods (push, pop, shift, unshift, etc.)
  - Iteration methods
  - Multi-dimensional arrays

- **Hashes**
  - Creation (literal vs Hash.new)
  - Symbol vs String keys
  - Nested hashes
  - Hash methods and iteration

- **Ranges**
  - Inclusive vs exclusive ranges
  - Range methods
  - Use in iterations and conditions

### 3. Loops & Iterators
- **Traditional Loops**
  - while/until loops
  - for loops
  - loop do...end

- **Iterators & Enumerables**
  - each, map, select, reject
  - find, find_all, any?, all?, none?
  - reduce/inject
  - each_with_index, each_with_object
  - zip, group_by, partition

### 4. Methods & Blocks
- **Method Definition**
  - Parameters (required, optional, default)
  - Return values (explicit vs implicit)
  - Method visibility (public, private, protected)

- **Blocks, Procs & Lambdas**
  - Block syntax ({ } vs do...end)
  - yield keyword
  - block_given?
  - Proc vs Lambda differences
  - Method objects

### 5. String Manipulation
- String interpolation
- String methods (upcase, downcase, strip, split, join)
- Regular expressions basics
- String formatting
- Encoding and character manipulation

---

## Intermediate Level

### 6. Object-Oriented Programming
- **Classes & Objects**
  - Class definition and instantiation
  - Instance variables (@)
  - Class variables (@@)
  - attr_accessor, attr_reader, attr_writer

- **Inheritance**
  - Single inheritance
  - Method overriding
  - super keyword
  - Method resolution order

- **Modules & Mixins**
  - Module definition
  - include, prepend, extend
  - Module as namespace
  - Comparable, Enumerable modules

### 7. Error Handling
- **Exceptions**
  - begin/rescue/ensure/else
  - raise and throw/catch
  - Custom exception classes
  - Exception hierarchy

- **Debugging Techniques**
  - puts debugging
  - byebug/pry debugging
  - Stack traces reading

### 8. File I/O & System
- **File Operations**
  - Reading/writing files
  - File.open vs File.read/write
  - CSV, JSON, YAML handling
  - File system operations

- **System Interaction**
  - System calls and backticks
  - ENV variables
  - ARGV and command-line arguments
  - Process management

### 9. Regular Expressions
- **Pattern Matching**
  - Regex syntax and anchors
  - Character classes
  - Quantifiers
  - Capturing groups
  - Look-ahead/look-behind

- **String Methods with Regex**
  - match, scan, split, gsub
  - Named captures
  - Regex options and flags

### 10. Testing
- **Testing Frameworks**
  - RSpec basics
  - Minitest
  - Test-driven development (TDD)

- **Testing Concepts**
  - Unit tests
  - Integration tests
  - Mocking and stubbing
  - Fixtures and factories

---

## Advanced Level

### 11. Metaprogramming
- **Dynamic Programming**
  - define_method
  - method_missing
  - const_missing
  - class_eval/instance_eval

- **Reflection**
  - respond_to?
  - send/public_send
  - Object introspection
  - Method and UnboundMethod objects

### 12. Advanced OOP Concepts
- **Design Patterns**
  - Singleton pattern
  - Factory pattern
  - Observer pattern
  - Strategy pattern
  - Decorator pattern

- **SOLID Principles**
  - Single Responsibility
  - Open/Closed
  - Liskov Substitution
  - Interface Segregation
  - Dependency Inversion

### 13. Concurrency & Parallelism
- **Threading**
  - Thread creation and management
  - Thread safety
  - Mutex and synchronization
  - Thread pools

- **Processes**
  - Fork and process management
  - Inter-process communication
  - Background jobs

### 14. Performance Optimization
- **Profiling**
  - Benchmark module
  - Ruby-prof
  - Memory profiling

- **Optimization Techniques**
  - Algorithm complexity
  - Memoization
  - Lazy evaluation
  - String vs Symbol performance

### 15. Web Development Foundations
- **Rack**
  - Rack middleware
  - Building Rack applications

- **HTTP & REST**
  - HTTP methods
  - Status codes
  - RESTful design

- **Database Interaction**
  - SQL basics
  - ActiveRecord (outside Rails)
  - Database connections and pooling

---

## Expert Level

### 16. Ruby Internals
- **MRI/CRuby**
  - YARV (Yet Another Ruby VM)
  - Garbage collection
  - Memory management
  - Global Interpreter Lock (GIL)

- **Alternative Ruby Implementations**
  - JRuby
  - Rubinius
  - TruffleRuby

### 17. Advanced Metaprogramming
- **DSL Creation**
  - Domain-Specific Languages
  - Method chaining
  - Fluent interfaces

- **Hook Methods**
  - inherited, included, extended
  - method_added, method_removed
  - const_set, const_get

### 18. Functional Programming in Ruby
- **Functional Concepts**
  - Immutability
  - Pure functions
  - Higher-order functions
  - Currying and partial application

- **Functional Libraries**
  - dry-rb ecosystem
  - Functional Ruby patterns

### 19. Advanced Testing
- **Test Strategies**
  - Property-based testing
  - Contract testing
  - Mutation testing

- **Performance Testing**
  - Load testing
  - Benchmark testing
  - Memory leak detection

### 20. Ruby Ecosystem
- **Gem Development**
  - Creating gems
  - Gem versioning
  - Publishing to RubyGems

- **Documentation**
  - RDoc
  - YARD
  - Documentation best practices

---

## Practice Resources

### Online Platforms
1. **Exercism.io** - https://exercism.io/tracks/ruby
   - Mentored practice problems
   - Community solutions review

2. **Codewars** - https://www.codewars.com
   - Ruby kata challenges
   - Difficulty progression

3. **HackerRank** - https://www.hackerrank.com/domains/ruby
   - Ruby domain challenges
   - Interview preparation

4. **LeetCode** - https://leetcode.com
   - Algorithm problems (solve in Ruby)

5. **Ruby Koans** - http://rubykoans.com
   - Test-driven learning
   - Progressive difficulty

### Books & Documentation
1. **Official Ruby Documentation** - https://ruby-doc.org
2. **Ruby Style Guide** - https://rubystyle.guide
3. **Metaprogramming Ruby 2** - By Paolo Perrotta
4. **Practical Object-Oriented Design in Ruby** - By Sandi Metz
5. **The Well-Grounded Rubyist** - By David A. Black

### Interactive Resources
1. **Try Ruby** - https://try.ruby-lang.org
2. **Ruby Warrior** - https://github.com/ryanb/ruby-warrior
3. **Ruby Monk** - https://rubymonk.com

### Video Courses
1. **RubyTapas** - https://www.rubytapas.com
2. **GoRails** - https://gorails.com
3. **Upcase by Thoughtbot** - https://thoughtbot.com/upcase

---

## Interview Questions

### Basic Level Questions

1. **What are symbols in Ruby? How are they different from strings?**
   - Symbols are immutable, reusable objects
   - Same symbol has same object_id
   - More memory efficient for repeated use

2. **Explain the difference between nil, false, and empty?**
   ```ruby
   nil.nil?     # true
   false.nil?   # false
   "".nil?      # false
   "".empty?    # true
   [].empty?    # true
   nil.empty?   # NoMethodError
   ```

3. **What's the difference between puts, print, and p?**
   ```ruby
   puts "hello"   # adds newline, returns nil
   print "hello"  # no newline, returns nil
   p "hello"      # inspect format, returns the object
   ```

4. **How do you create a range in Ruby?**
   ```ruby
   (1..10)   # inclusive: 1 to 10
   (1...10)  # exclusive: 1 to 9
   ```

5. **What are the differences between each and map?**
   ```ruby
   [1,2,3].each { |n| n * 2 }  # returns [1,2,3]
   [1,2,3].map { |n| n * 2 }   # returns [2,4,6]
   ```

### Intermediate Level Questions

6. **Explain the difference between Proc and Lambda**
   ```ruby
   # Return behavior
   def test_proc
     Proc.new { return "proc" }.call
     "method end"
   end

   def test_lambda
     lambda { return "lambda" }.call
     "method end"
   end

   # Arity checking
   proc = Proc.new { |a, b| [a, b] }
   proc.call(1)        # [1, nil]

   lam = lambda { |a, b| [a, b] }
   lam.call(1)         # ArgumentError
   ```

7. **What is the difference between include, prepend, and extend?**
   ```ruby
   module Greetable
     def hello
       "Hello!"
     end
   end

   class Person
     include Greetable    # adds as instance methods
   end

   class Robot
     extend Greetable     # adds as class methods
   end

   class Animal
     prepend Greetable    # adds before class in method lookup
   end
   ```

8. **Explain Ruby's method lookup chain**
   ```ruby
   class Animal; end
   class Dog < Animal
     include Walkable
     prepend Barkable
   end

   Dog.ancestors
   # [Barkable, Dog, Walkable, Animal, Object, Kernel, BasicObject]
   ```

9. **What is duck typing in Ruby?**
   ```ruby
   # If it walks like a duck and quacks like a duck, it's a duck
   def process_items(collection)
     collection.each { |item| puts item }
   end

   process_items([1, 2, 3])        # Array
   process_items({a: 1, b: 2})     # Hash
   process_items(1..5)              # Range
   ```

10. **How does garbage collection work in Ruby?**
    - Mark and sweep algorithm
    - Generational GC (since Ruby 2.1)
    - Incremental GC (since Ruby 2.2)

### Advanced Level Questions

11. **Explain metaprogramming with method_missing**
    ```ruby
    class DynamicHash
      def method_missing(method_name, *args)
        if method_name.to_s.end_with?('=')
          @attributes ||= {}
          @attributes[method_name.to_s.chop.to_sym] = args.first
        else
          @attributes[method_name]
        end
      end
    end
    ```

12. **What is the Singleton pattern in Ruby?**
    ```ruby
    require 'singleton'

    class Database
      include Singleton

      def connection
        @connection ||= establish_connection
      end
    end

    # Or manually:
    class Logger
      def self.instance
        @instance ||= new
      end

      private_class_method :new
    end
    ```

13. **How do you implement memoization?**
    ```ruby
    def expensive_calculation
      @result ||= begin
        sleep(3)
        complex_computation
      end
    end

    # For nil/false values:
    def calculation
      return @result if defined?(@result)
      @result = complex_computation
    end
    ```

14. **Explain eigenclass (singleton class)**
    ```ruby
    obj = Object.new

    class << obj
      def special_method
        "I'm special!"
      end
    end

    # Or
    obj.singleton_class.define_method(:another) { "method" }
    ```

15. **How do you handle thread safety?**
    ```ruby
    require 'thread'

    class Counter
      def initialize
        @count = 0
        @mutex = Mutex.new
      end

      def increment
        @mutex.synchronize do
          @count += 1
        end
      end
    end
    ```

### Problem-Solving Questions

16. **Implement a method to flatten an array without using flatten**
    ```ruby
    def custom_flatten(arr, result = [])
      arr.each do |element|
        if element.is_a?(Array)
          custom_flatten(element, result)
        else
          result << element
        end
      end
      result
    end
    ```

17. **Create a method chain DSL**
    ```ruby
    class QueryBuilder
      def initialize
        @conditions = []
      end

      def where(condition)
        @conditions << condition
        self
      end

      def order(field)
        @order = field
        self
      end

      def to_sql
        sql = "SELECT * FROM users"
        sql += " WHERE #{@conditions.join(' AND ')}" if @conditions.any?
        sql += " ORDER BY #{@order}" if @order
        sql
      end
    end

    # Usage: QueryBuilder.new.where("age > 18").where("active = true").order("name")
    ```

18. **Implement curry function**
    ```ruby
    def curry(method, arity = method.arity)
      define_method :curried do |*args|
        if args.length >= arity
          method.call(*args.first(arity))
        else
          curry(proc { |*rest| method.call(*(args + rest)) }, arity - args.length)
        end
      end
      method(:curried)
    end
    ```

19. **Create a simple dependency injection container**
    ```ruby
    class Container
      def initialize
        @services = {}
        @singletons = {}
      end

      def register(name, &block)
        @services[name] = block
      end

      def resolve(name)
        @singletons[name] ||= @services[name].call(self)
      end
    end
    ```

20. **Implement method chaining with lazy evaluation**
    ```ruby
    class LazyArray
      def initialize(array)
        @array = array
        @operations = []
      end

      def select(&block)
        @operations << [:select, block]
        self
      end

      def map(&block)
        @operations << [:map, block]
        self
      end

      def value
        @operations.reduce(@array) do |result, (method, block)|
          result.send(method, &block)
        end
      end
    end
    ```

### System Design Questions

21. **Design a rate limiter in Ruby**
22. **Implement a simple cache with TTL**
23. **Create a background job processor**
24. **Design a plugin system**
25. **Build a simple web server using only Ruby standard library**

### Performance Questions

26. **When to use Symbol vs String?**
27. **How to optimize database queries in ActiveRecord?**
28. **Explain N+1 query problem and solutions**
29. **Memory leaks in Ruby - causes and detection**
30. **When to use lazy enumerators?**

---

## Study Plan Recommendation

### Month 1-2: Foundation
- Complete Ruby basics
- Practice on Exercism.io (easy problems)
- Read "The Well-Grounded Rubyist"

### Month 3-4: Intermediate
- Deep dive into OOP
- Start Ruby Koans
- Practice Codewars (6-5 kyu problems)

### Month 5-6: Advanced
- Study metaprogramming
- Read "Metaprogramming Ruby 2"
- Practice Codewars (4-3 kyu problems)

### Month 7-8: Expert
- Contribute to open source
- Create your own gem
- Practice system design problems

### Ongoing:
- Daily coding practice (30-60 minutes)
- Weekly code reviews
- Monthly Ruby meetups/conferences
- Regular blog reading (Ruby Weekly, RubyFlow)

---

## Additional Resources

### Blogs & Newsletters
- Ruby Weekly: https://rubyweekly.com
- RubyFlow: http://www.rubyflow.com
- Thoughtbot Blog: https://thoughtbot.com/blog
- Evil Martians: https://evilmartians.com/chronicles

### Communities
- Ruby Reddit: https://reddit.com/r/ruby
- Ruby Forum: https://discuss.rubyonrails.org
- Stack Overflow Ruby Tag
- Ruby Discord/Slack communities

### Conferences & Talks
- RubyConf
- RailsConf
- RubyKaigi
- Regional Ruby conferences

---

## Tips for Mastery

1. **Write Ruby every day** - Consistency is key
2. **Read other people's code** - Study popular gems' source code
3. **Contribute to open source** - Start with documentation, then small features
4. **Build projects** - Apply what you learn in real applications
5. **Teach others** - Blog, mentor, or give talks
6. **Stay updated** - Follow Ruby releases and community trends
7. **Focus on idioms** - Learn the "Ruby way" of doing things
8. **Practice refactoring** - Improve code quality continuously
9. **Understand the why** - Don't just memorize, understand concepts
10. **Be patient** - Mastery takes time and practice

Remember: The journey to Ruby mastery is ongoing. Even experienced developers continue learning new patterns, techniques, and best practices. Focus on consistent practice and real-world application of concepts.