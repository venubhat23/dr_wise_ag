# Complete SQL & Database Mastery Guide

## Table of Contents
1. [SQL Fundamentals](#sql-fundamentals)
2. [Advanced SQL Concepts](#advanced-sql-concepts)
3. [Rails ActiveRecord & Joins](#rails-activerecord--joins)
4. [Database Design Principles](#database-design-principles)
5. [Real-World Practice Queries](#real-world-practice-queries)
6. [Interview Questions & Answers](#interview-questions--answers)

---

# SQL Fundamentals

## 1. Basic SQL Commands

### SELECT Statement
```sql
-- Basic SELECT
SELECT * FROM users;

-- Specific columns
SELECT first_name, last_name, email FROM users;

-- With aliases
SELECT
    first_name AS fname,
    last_name AS lname,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM users;

-- DISTINCT values
SELECT DISTINCT city FROM customers;

-- With WHERE clause
SELECT * FROM orders
WHERE order_date >= '2024-01-01'
AND status = 'completed';
```

### INSERT Statement
```sql
-- Single row insert
INSERT INTO products (name, price, category)
VALUES ('Laptop', 999.99, 'Electronics');

-- Multiple rows insert
INSERT INTO products (name, price, category)
VALUES
    ('Mouse', 19.99, 'Electronics'),
    ('Keyboard', 49.99, 'Electronics'),
    ('Monitor', 299.99, 'Electronics');

-- Insert from another table
INSERT INTO archived_orders
SELECT * FROM orders WHERE order_date < '2023-01-01';
```

### UPDATE Statement
```sql
-- Basic update
UPDATE products
SET price = 899.99
WHERE id = 1;

-- Multiple columns update
UPDATE users
SET
    last_login = NOW(),
    login_count = login_count + 1
WHERE email = 'user@example.com';

-- Update with JOIN
UPDATE orders o
INNER JOIN customers c ON o.customer_id = c.id
SET o.discount = 10
WHERE c.membership_type = 'premium';
```

### DELETE Statement
```sql
-- Basic delete
DELETE FROM products WHERE id = 5;

-- Delete with subquery
DELETE FROM orders
WHERE customer_id IN (
    SELECT id FROM customers
    WHERE created_at < '2020-01-01'
    AND last_purchase IS NULL
);

-- Delete with JOIN
DELETE o FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
WHERE c.status = 'inactive';
```

## 2. Data Types

### Numeric Types
```sql
CREATE TABLE financial_records (
    id INTEGER PRIMARY KEY,
    amount DECIMAL(10, 2),      -- For money
    quantity INTEGER,            -- Whole numbers
    percentage FLOAT,            -- Floating point
    tax_rate NUMERIC(5, 2),     -- Precise decimals
    is_active BOOLEAN            -- True/False
);
```

### String Types
```sql
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),        -- Variable length
    password CHAR(64),          -- Fixed length (for hashes)
    bio TEXT,                   -- Long text
    country_code CHAR(2),       -- Fixed 2 chars
    tags TEXT[]                 -- Array of text (PostgreSQL)
);
```

### Date/Time Types
```sql
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_date DATE,            -- Date only
    event_time TIME,            -- Time only
    created_at TIMESTAMP,       -- Date and time
    updated_at TIMESTAMPTZ,     -- Timestamp with timezone
    duration INTERVAL           -- Time interval
);
```

## 3. Constraints

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    ssn VARCHAR(11) UNIQUE,
    age INTEGER CHECK (age >= 18),
    department_id INTEGER,
    manager_id INTEGER,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    hire_date DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (manager_id) REFERENCES employees(id),

    -- Composite unique constraint
    UNIQUE(first_name, last_name, birth_date)
);
```

---

# Advanced SQL Concepts

## 1. JOINS

### INNER JOIN
```sql
-- Basic INNER JOIN
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    c.email
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

-- Multiple INNER JOINs
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    oi.quantity,
    oi.price
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN order_items oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id;
```

### LEFT JOIN
```sql
-- All customers with their orders (including those without orders)
SELECT
    c.customer_name,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total_amount), 0) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.customer_name;

-- Find customers without orders
SELECT c.*
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;
```

### RIGHT JOIN
```sql
-- All orders with customer info (if available)
SELECT
    o.*,
    c.customer_name
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id;
```

### FULL OUTER JOIN
```sql
-- All customers and all orders
SELECT
    COALESCE(c.customer_name, 'No Customer') as customer,
    COALESCE(o.order_id, 'No Order') as order_ref
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id;
```

### CROSS JOIN
```sql
-- Generate all possible product-category combinations
SELECT
    p.product_name,
    c.category_name
FROM products p
CROSS JOIN categories c;
```

### SELF JOIN
```sql
-- Find employees and their managers
SELECT
    e.name AS employee,
    m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Find duplicate emails
SELECT a.email
FROM users a
JOIN users b ON a.email = b.email
WHERE a.id != b.id;
```

## 2. Subqueries

### Scalar Subqueries
```sql
-- Single value subquery
SELECT
    product_name,
    price,
    (SELECT AVG(price) FROM products) as avg_price,
    price - (SELECT AVG(price) FROM products) as price_diff
FROM products;
```

### Column Subqueries
```sql
-- IN operator
SELECT * FROM products
WHERE category_id IN (
    SELECT id FROM categories
    WHERE name IN ('Electronics', 'Books')
);

-- EXISTS operator
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.id
    AND o.total_amount > 1000
);
```

### Table Subqueries
```sql
-- Derived table
SELECT
    category,
    avg_price,
    max_price
FROM (
    SELECT
        category,
        AVG(price) as avg_price,
        MAX(price) as max_price
    FROM products
    GROUP BY category
) AS category_stats
WHERE avg_price > 100;
```

### Correlated Subqueries
```sql
-- Find products priced above their category average
SELECT p1.*
FROM products p1
WHERE price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category_id = p1.category_id
);
```

## 3. Window Functions

### ROW_NUMBER()
```sql
-- Assign row numbers
SELECT
    ROW_NUMBER() OVER (ORDER BY salary DESC) as rank,
    name,
    department,
    salary
FROM employees;

-- Row number per department
SELECT
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
    name,
    department,
    salary
FROM employees;
```

### RANK() and DENSE_RANK()
```sql
-- RANK with gaps
SELECT
    RANK() OVER (ORDER BY score DESC) as rank,
    name,
    score
FROM students;

-- DENSE_RANK without gaps
SELECT
    DENSE_RANK() OVER (ORDER BY score DESC) as rank,
    name,
    score
FROM students;
```

### LAG() and LEAD()
```sql
-- Compare with previous row
SELECT
    order_date,
    total_amount,
    LAG(total_amount, 1) OVER (ORDER BY order_date) as prev_amount,
    total_amount - LAG(total_amount, 1) OVER (ORDER BY order_date) as diff
FROM orders;

-- Look ahead
SELECT
    product_name,
    price,
    LEAD(price, 1) OVER (ORDER BY price) as next_price
FROM products;
```

### Running Totals and Moving Averages
```sql
-- Running total
SELECT
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date ROWS UNBOUNDED PRECEDING) as running_total
FROM orders;

-- Moving average (last 7 days)
SELECT
    order_date,
    amount,
    AVG(amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7_days
FROM daily_sales;
```

## 4. Common Table Expressions (CTEs)

```sql
-- Basic CTE
WITH high_value_customers AS (
    SELECT
        customer_id,
        SUM(total_amount) as total_spent
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > 10000
)
SELECT
    c.name,
    hvc.total_spent
FROM customers c
INNER JOIN high_value_customers hvc ON c.id = hvc.customer_id;

-- Multiple CTEs
WITH
monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) as month,
        SUM(total_amount) as total
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
monthly_costs AS (
    SELECT
        DATE_TRUNC('month', expense_date) as month,
        SUM(amount) as total
    FROM expenses
    GROUP BY DATE_TRUNC('month', expense_date)
)
SELECT
    ms.month,
    ms.total as revenue,
    mc.total as costs,
    ms.total - mc.total as profit
FROM monthly_sales ms
LEFT JOIN monthly_costs mc ON ms.month = mc.month;

-- Recursive CTE (organizational hierarchy)
WITH RECURSIVE org_chart AS (
    -- Base case: top-level employees
    SELECT
        id,
        name,
        manager_id,
        1 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case
    SELECT
        e.id,
        e.name,
        e.manager_id,
        oc.level + 1,
        oc.path || ' > ' || e.name
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT * FROM org_chart ORDER BY level, name;
```

## 5. Advanced Aggregations

### GROUP BY with ROLLUP
```sql
-- Sales summary with subtotals
SELECT
    COALESCE(category, 'TOTAL') as category,
    COALESCE(product, 'Subtotal') as product,
    SUM(quantity) as total_quantity,
    SUM(amount) as total_amount
FROM sales
GROUP BY ROLLUP(category, product);
```

### GROUP BY with CUBE
```sql
-- All possible grouping combinations
SELECT
    year,
    month,
    category,
    SUM(amount) as total
FROM sales
GROUP BY CUBE(year, month, category);
```

### GROUPING SETS
```sql
-- Specific grouping combinations
SELECT
    year,
    month,
    category,
    SUM(amount) as total
FROM sales
GROUP BY GROUPING SETS (
    (year, month),
    (year, category),
    (category),
    ()
);
```

---

# Rails ActiveRecord & Joins

## 1. Basic ActiveRecord Queries

```ruby
# Basic queries
User.all
User.first
User.last
User.find(1)
User.find_by(email: 'user@example.com')

# Where conditions
User.where(active: true)
User.where('created_at > ?', 1.month.ago)
User.where(role: ['admin', 'moderator'])
User.where.not(status: 'banned')

# Chaining
User.where(active: true)
    .where('age >= ?', 18)
    .order(created_at: :desc)
    .limit(10)
```

## 2. ActiveRecord Joins

### includes (Eager Loading)
```ruby
# Prevent N+1 queries
posts = Post.includes(:comments)
posts.each do |post|
  post.comments.each do |comment|
    puts comment.text
  end
end

# Multiple associations
Order.includes(:customer, :order_items => :product)

# Nested includes
Category.includes(products: [:reviews, :supplier])
```

### joins (INNER JOIN)
```ruby
# Basic join
User.joins(:posts)

# Multiple joins
User.joins(:posts, :comments)

# Nested joins
Category.joins(products: :reviews)

# With conditions
User.joins(:posts).where(posts: { published: true })

# Custom join conditions
User.joins("INNER JOIN posts ON posts.user_id = users.id AND posts.featured = true")
```

### left_joins (LEFT OUTER JOIN)
```ruby
# All users, including those without posts
User.left_joins(:posts)

# Find users without posts
User.left_joins(:posts).where(posts: { id: nil })

# With group and count
User.left_joins(:posts)
    .group('users.id')
    .select('users.*, COUNT(posts.id) as posts_count')
```

### Complex Queries
```ruby
# Combining joins with other methods
Post.joins(:user, :category)
    .where(users: { active: true })
    .where(categories: { name: 'Technology' })
    .group('posts.id')
    .having('COUNT(comments.id) > 5')
    .order(created_at: :desc)

# Using merge
User.joins(:posts).merge(Post.published)

# Raw SQL with ActiveRecord
User.find_by_sql([
  "SELECT users.*, COUNT(posts.id) as post_count
   FROM users
   LEFT JOIN posts ON posts.user_id = users.id
   WHERE users.created_at > ?
   GROUP BY users.id",
  1.year.ago
])
```

## 3. ActiveRecord Associations

```ruby
# has_many
class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :commented_posts, through: :comments, source: :post
end

# belongs_to
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments
end

# has_many :through
class Doctor < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end

# has_one
class User < ApplicationRecord
  has_one :profile
  has_one :latest_post, -> { order(created_at: :desc) }, class_name: 'Post'
end

# Polymorphic associations
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class Post < ApplicationRecord
  has_many :comments, as: :commentable
end
```

## 4. Scopes and Query Methods

```ruby
class Post < ApplicationRecord
  # Scopes
  scope :published, -> { where(published: true) }
  scope :recent, -> { where('created_at > ?', 1.week.ago) }
  scope :by_category, ->(category) { joins(:category).where(categories: { name: category }) }

  # Class methods as scopes
  def self.popular
    where('views_count > ?', 1000)
  end

  # Chaining scopes
  # Post.published.recent.popular
end

# Using scopes
Post.published.recent
Post.by_category('Technology').published
```

## 5. Advanced ActiveRecord

```ruby
# Pluck - get array of values
User.pluck(:email)
User.pluck(:id, :name)

# Select specific columns
User.select(:id, :email, :created_at)

# Group and count
Order.group(:status).count
User.group(:role).average(:age)

# Having clause
Order.group(:customer_id)
     .having('SUM(total_amount) > ?', 1000)
     .sum(:total_amount)

# Exists?
User.exists?(email: 'user@example.com')
User.where(active: true).exists?

# Calculations
Order.sum(:total_amount)
Product.average(:price)
User.maximum(:age)
User.minimum(:created_at)

# Batching
User.find_each(batch_size: 1000) do |user|
  NewsMailer.weekly(user).deliver_later
end

# Update all
User.where(status: 'inactive').update_all(status: 'archived')

# Upsert
User.upsert_all([
  { email: 'user1@example.com', name: 'User 1' },
  { email: 'user2@example.com', name: 'User 2' }
], unique_by: :email)
```

---

# Database Design Principles

## 1. Normalization

### First Normal Form (1NF)
```sql
-- BAD: Repeating groups
CREATE TABLE orders_bad (
    order_id INT,
    customer_name VARCHAR(100),
    items VARCHAR(500)  -- "laptop,mouse,keyboard"
);

-- GOOD: Atomic values
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
```

### Second Normal Form (2NF)
```sql
-- BAD: Partial dependency
CREATE TABLE order_items_bad (
    order_id INT,
    product_id INT,
    product_name VARCHAR(100),  -- Depends only on product_id
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);

-- GOOD: Remove partial dependencies
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Third Normal Form (3NF)
```sql
-- BAD: Transitive dependency
CREATE TABLE employees_bad (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    dept_name VARCHAR(100),  -- Depends on dept_id, not emp_id
    dept_location VARCHAR(100)  -- Depends on dept_id
);

-- GOOD: Remove transitive dependencies
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    dept_location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
```

## 2. Denormalization Strategies

```sql
-- Materialized view for performance
CREATE MATERIALIZED VIEW sales_summary AS
SELECT
    DATE_TRUNC('month', order_date) as month,
    c.region,
    p.category,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.unit_price) as total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY DATE_TRUNC('month', order_date), c.region, p.category;

-- Denormalized table for reporting
CREATE TABLE order_summary AS
SELECT
    o.id as order_id,
    o.order_date,
    c.customer_name,
    c.customer_email,
    COUNT(oi.id) as item_count,
    SUM(oi.quantity * oi.unit_price) as total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.order_date, c.customer_name, c.customer_email;
```

## 3. Indexing Strategies

```sql
-- Primary key index (automatic)
CREATE TABLE users (
    id SERIAL PRIMARY KEY  -- Automatically creates unique index
);

-- Single column index
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Composite index
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Unique index
CREATE UNIQUE INDEX idx_users_username ON users(username);

-- Partial index
CREATE INDEX idx_orders_pending ON orders(status)
WHERE status = 'pending';

-- Expression index
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Full-text search index (PostgreSQL)
CREATE INDEX idx_products_search ON products
USING gin(to_tsvector('english', name || ' ' || description));

-- Check index usage
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 123
AND order_date >= '2024-01-01';
```

## 4. Database Patterns

### Entity-Attribute-Value (EAV)
```sql
-- Flexible schema for dynamic attributes
CREATE TABLE entities (
    id SERIAL PRIMARY KEY,
    entity_type VARCHAR(50),
    created_at TIMESTAMP
);

CREATE TABLE attributes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    data_type VARCHAR(20)
);

CREATE TABLE entity_attribute_values (
    entity_id INT,
    attribute_id INT,
    value TEXT,
    PRIMARY KEY (entity_id, attribute_id),
    FOREIGN KEY (entity_id) REFERENCES entities(id),
    FOREIGN KEY (attribute_id) REFERENCES attributes(id)
);
```

### Adjacency List (Hierarchical Data)
```sql
-- Simple parent-child relationship
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- Query to get full hierarchy
WITH RECURSIVE category_tree AS (
    SELECT id, name, parent_id, 1 as level
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id, c.name, c.parent_id, ct.level + 1
    FROM categories c
    INNER JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT * FROM category_tree ORDER BY level, name;
```

### Nested Set Model
```sql
-- Better for read-heavy hierarchical data
CREATE TABLE categories_nested (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    lft INT NOT NULL,
    rgt INT NOT NULL
);

-- Get all descendants
SELECT * FROM categories_nested
WHERE lft > 2 AND rgt < 11
ORDER BY lft;
```

### Audit Trail Pattern
```sql
-- Main table
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    account_number VARCHAR(20),
    balance DECIMAL(15, 2),
    updated_at TIMESTAMP
);

-- Audit table
CREATE TABLE accounts_audit (
    id SERIAL PRIMARY KEY,
    account_id INT,
    account_number VARCHAR(20),
    balance DECIMAL(15, 2),
    action VARCHAR(10),  -- INSERT, UPDATE, DELETE
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger for audit
CREATE TRIGGER accounts_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON accounts
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
```

## 5. Performance Optimization

### Query Optimization
```sql
-- Use EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT c.name, COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Optimize with proper indexes
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Use covering index
CREATE INDEX idx_orders_covering
ON orders(customer_id, status, total_amount);

-- Partition large tables
CREATE TABLE orders_2024 PARTITION OF orders
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
```

### Connection Pooling
```ruby
# Rails database.yml
production:
  adapter: postgresql
  pool: 25
  checkout_timeout: 5
  reaping_frequency: 10
  idle_timeout: 300
```

---

# Real-World Practice Queries

## E-Commerce Database

```sql
-- 1. Find top 10 customers by total spending
SELECT
    c.id,
    c.name,
    c.email,
    COUNT(DISTINCT o.id) as order_count,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.id, c.name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Product sales analysis with running total
WITH product_sales AS (
    SELECT
        p.id,
        p.name,
        p.category,
        DATE_TRUNC('month', o.order_date) as month,
        SUM(oi.quantity) as units_sold,
        SUM(oi.quantity * oi.unit_price) as revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status = 'completed'
    GROUP BY p.id, p.name, p.category, DATE_TRUNC('month', o.order_date)
)
SELECT
    *,
    SUM(revenue) OVER (
        PARTITION BY id
        ORDER BY month
        ROWS UNBOUNDED PRECEDING
    ) as cumulative_revenue
FROM product_sales
ORDER BY id, month;

-- 3. Customer retention cohort analysis
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) as cohort_month
    FROM orders
    GROUP BY customer_id
),
cohort_data AS (
    SELECT
        fp.cohort_month,
        DATE_TRUNC('month', o.order_date) as order_month,
        COUNT(DISTINCT o.customer_id) as customers
    FROM first_purchase fp
    JOIN orders o ON fp.customer_id = o.customer_id
    GROUP BY fp.cohort_month, DATE_TRUNC('month', o.order_date)
)
SELECT
    cohort_month,
    order_month,
    customers,
    EXTRACT(MONTH FROM AGE(order_month, cohort_month)) as months_since_first,
    customers::float / FIRST_VALUE(customers) OVER (
        PARTITION BY cohort_month
        ORDER BY order_month
    ) * 100 as retention_rate
FROM cohort_data
ORDER BY cohort_month, order_month;

-- 4. Inventory management - products needing restock
SELECT
    p.id,
    p.name,
    p.sku,
    i.quantity_on_hand,
    COALESCE(recent_sales.units_sold_30d, 0) as units_sold_last_30_days,
    COALESCE(recent_sales.units_sold_7d, 0) as units_sold_last_7_days,
    CASE
        WHEN recent_sales.units_sold_7d > 0 THEN
            i.quantity_on_hand::float / (recent_sales.units_sold_7d * 4)
        ELSE NULL
    END as weeks_of_stock_remaining
FROM products p
JOIN inventory i ON p.id = i.product_id
LEFT JOIN (
    SELECT
        oi.product_id,
        SUM(CASE WHEN o.order_date >= CURRENT_DATE - INTERVAL '30 days'
            THEN oi.quantity ELSE 0 END) as units_sold_30d,
        SUM(CASE WHEN o.order_date >= CURRENT_DATE - INTERVAL '7 days'
            THEN oi.quantity ELSE 0 END) as units_sold_7d
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status = 'completed'
    GROUP BY oi.product_id
) recent_sales ON p.id = recent_sales.product_id
WHERE i.quantity_on_hand < i.reorder_point
ORDER BY weeks_of_stock_remaining NULLS LAST;

-- 5. Customer lifetime value calculation
WITH customer_values AS (
    SELECT
        c.id,
        c.name,
        c.acquired_date,
        COUNT(DISTINCT o.id) as total_orders,
        SUM(o.total_amount) as lifetime_value,
        AVG(o.total_amount) as avg_order_value,
        MAX(o.order_date) as last_order_date,
        EXTRACT(DAY FROM AGE(CURRENT_DATE, c.acquired_date)) as customer_age_days
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
    GROUP BY c.id, c.name, c.acquired_date
),
customer_segments AS (
    SELECT
        *,
        CASE
            WHEN lifetime_value > 10000 THEN 'VIP'
            WHEN lifetime_value > 5000 THEN 'Gold'
            WHEN lifetime_value > 1000 THEN 'Silver'
            ELSE 'Bronze'
        END as customer_segment,
        CASE
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
            WHEN last_order_date >= CURRENT_DATE - INTERVAL '180 days' THEN 'Dormant'
            ELSE 'Lost'
        END as activity_status,
        lifetime_value / NULLIF(customer_age_days, 0) * 365 as annual_value
    FROM customer_values
)
SELECT * FROM customer_segments
ORDER BY lifetime_value DESC;
```

## Social Media Database

```sql
-- 1. Find influencers (users with most followers)
SELECT
    u.id,
    u.username,
    u.verified,
    COUNT(DISTINCT f.follower_id) as follower_count,
    COUNT(DISTINCT p.id) as post_count,
    AVG(p.likes_count) as avg_likes_per_post,
    SUM(p.likes_count)::float / NULLIF(COUNT(DISTINCT f.follower_id), 0) as engagement_rate
FROM users u
LEFT JOIN follows f ON u.id = f.followed_id
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username, u.verified
HAVING COUNT(DISTINCT f.follower_id) > 1000
ORDER BY follower_count DESC;

-- 2. Viral content detection
WITH post_metrics AS (
    SELECT
        p.id,
        p.user_id,
        p.content,
        p.created_at,
        p.likes_count,
        p.comments_count,
        p.shares_count,
        (p.likes_count + p.comments_count * 2 + p.shares_count * 3) as virality_score,
        EXTRACT(HOUR FROM AGE(CURRENT_TIMESTAMP, p.created_at)) as hours_since_post
    FROM posts p
    WHERE p.created_at >= CURRENT_DATE - INTERVAL '7 days'
),
viral_threshold AS (
    SELECT
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY virality_score) as threshold
    FROM post_metrics
)
SELECT
    pm.*,
    u.username,
    pm.virality_score / NULLIF(pm.hours_since_post, 0) as virality_velocity
FROM post_metrics pm
CROSS JOIN viral_threshold vt
JOIN users u ON pm.user_id = u.id
WHERE pm.virality_score > vt.threshold
ORDER BY virality_velocity DESC;

-- 3. User engagement patterns
SELECT
    u.id,
    u.username,
    DATE_PART('hour', p.created_at) as hour_of_day,
    DATE_PART('dow', p.created_at) as day_of_week,
    COUNT(*) as post_count,
    AVG(p.likes_count) as avg_likes,
    AVG(p.comments_count) as avg_comments
FROM users u
JOIN posts p ON u.id = p.user_id
WHERE p.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.id, u.username, DATE_PART('hour', p.created_at), DATE_PART('dow', p.created_at)
ORDER BY u.id, day_of_week, hour_of_day;
```

## Banking Database

```sql
-- 1. Detect suspicious transactions
WITH transaction_patterns AS (
    SELECT
        account_id,
        AVG(amount) as avg_amount,
        STDDEV(amount) as stddev_amount,
        MAX(amount) as max_amount
    FROM transactions
    WHERE transaction_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY account_id
)
SELECT
    t.*,
    a.account_holder_name,
    tp.avg_amount,
    tp.stddev_amount,
    CASE
        WHEN t.amount > tp.avg_amount + (3 * tp.stddev_amount) THEN 'High Risk'
        WHEN t.amount > tp.avg_amount + (2 * tp.stddev_amount) THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_level
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN transaction_patterns tp ON t.account_id = tp.account_id
WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '1 day'
  AND t.amount > tp.avg_amount + (2 * tp.stddev_amount);

-- 2. Calculate account balances with running total
WITH account_transactions AS (
    SELECT
        account_id,
        transaction_date,
        transaction_type,
        amount,
        CASE
            WHEN transaction_type = 'deposit' THEN amount
            WHEN transaction_type = 'withdrawal' THEN -amount
            ELSE 0
        END as signed_amount
    FROM transactions
    WHERE status = 'completed'
)
SELECT
    account_id,
    transaction_date,
    transaction_type,
    amount,
    SUM(signed_amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date, id
        ROWS UNBOUNDED PRECEDING
    ) as running_balance
FROM account_transactions
ORDER BY account_id, transaction_date;

-- 3. Monthly financial summary
SELECT
    DATE_TRUNC('month', t.transaction_date) as month,
    a.account_type,
    COUNT(DISTINCT t.account_id) as active_accounts,
    COUNT(*) as transaction_count,
    SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) as total_deposits,
    SUM(CASE WHEN t.transaction_type = 'withdrawal' THEN t.amount ELSE 0 END) as total_withdrawals,
    AVG(t.amount) as avg_transaction_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.id
WHERE t.status = 'completed'
GROUP BY DATE_TRUNC('month', t.transaction_date), a.account_type
ORDER BY month DESC, account_type;
```

## Healthcare Database

```sql
-- 1. Patient appointment analysis
WITH appointment_stats AS (
    SELECT
        p.id as patient_id,
        p.name as patient_name,
        COUNT(*) as total_appointments,
        SUM(CASE WHEN a.status = 'completed' THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN a.status = 'cancelled' THEN 1 ELSE 0 END) as cancelled,
        SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) as no_shows,
        AVG(EXTRACT(EPOCH FROM (a.end_time - a.start_time))/60) as avg_duration_minutes
    FROM patients p
    JOIN appointments a ON p.id = a.patient_id
    WHERE a.appointment_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY p.id, p.name
)
SELECT
    *,
    ROUND(cancelled::numeric / total_appointments * 100, 2) as cancellation_rate,
    ROUND(no_shows::numeric / total_appointments * 100, 2) as no_show_rate
FROM appointment_stats
WHERE total_appointments >= 5
ORDER BY no_show_rate DESC;

-- 2. Doctor workload analysis
SELECT
    d.id,
    d.name,
    d.specialization,
    COUNT(DISTINCT a.appointment_date) as days_worked,
    COUNT(*) as total_appointments,
    COUNT(DISTINCT a.patient_id) as unique_patients,
    AVG(EXTRACT(EPOCH FROM (a.end_time - a.start_time))/60) as avg_appointment_duration,
    SUM(EXTRACT(EPOCH FROM (a.end_time - a.start_time))/3600) as total_hours_worked
FROM doctors d
JOIN appointments a ON d.id = a.doctor_id
WHERE a.appointment_date >= CURRENT_DATE - INTERVAL '30 days'
  AND a.status = 'completed'
GROUP BY d.id, d.name, d.specialization
ORDER BY total_appointments DESC;

-- 3. Medicine prescription patterns
WITH prescription_frequency AS (
    SELECT
        m.name as medicine_name,
        m.category,
        COUNT(DISTINCT p.id) as prescription_count,
        COUNT(DISTINCT p.patient_id) as patient_count,
        COUNT(DISTINCT p.doctor_id) as prescribing_doctors,
        AVG(pm.dosage_amount) as avg_dosage
    FROM medicines m
    JOIN prescription_medicines pm ON m.id = pm.medicine_id
    JOIN prescriptions p ON pm.prescription_id = p.id
    WHERE p.prescription_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY m.name, m.category
)
SELECT
    *,
    RANK() OVER (PARTITION BY category ORDER BY prescription_count DESC) as rank_in_category
FROM prescription_frequency
ORDER BY category, prescription_count DESC;
```

---

# Interview Questions & Answers

## Basic SQL Questions

### Q1: What is the difference between WHERE and HAVING?
**Answer:**
- WHERE filters rows before grouping
- HAVING filters groups after GROUP BY
```sql
-- WHERE: Filter before grouping
SELECT category, COUNT(*)
FROM products
WHERE price > 100
GROUP BY category;

-- HAVING: Filter after grouping
SELECT category, COUNT(*) as product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 5;
```

### Q2: Explain different types of JOINs
**Answer:**
- **INNER JOIN**: Returns matching rows from both tables
- **LEFT JOIN**: All rows from left table, matching from right
- **RIGHT JOIN**: All rows from right table, matching from left
- **FULL OUTER JOIN**: All rows from both tables
- **CROSS JOIN**: Cartesian product of both tables

### Q3: What is the difference between UNION and UNION ALL?
**Answer:**
- UNION removes duplicates, UNION ALL keeps all rows
```sql
-- UNION: Removes duplicates
SELECT name FROM customers
UNION
SELECT name FROM suppliers;

-- UNION ALL: Keeps duplicates (faster)
SELECT name FROM customers
UNION ALL
SELECT name FROM suppliers;
```

### Q4: What are indexes and why use them?
**Answer:**
Indexes are database structures that improve query performance by creating a sorted reference to table data.

**Benefits:**
- Faster data retrieval
- Improved JOIN performance
- Enforce uniqueness

**Drawbacks:**
- Slower INSERT/UPDATE/DELETE
- Additional storage space
- Maintenance overhead

### Q5: What is database normalization?
**Answer:**
Process of organizing data to minimize redundancy:
- **1NF**: Atomic values, no repeating groups
- **2NF**: 1NF + no partial dependencies
- **3NF**: 2NF + no transitive dependencies
- **BCNF**: 3NF + every determinant is a candidate key

## Advanced SQL Questions

### Q6: Explain window functions
**Answer:**
Window functions perform calculations across a set of rows related to current row without grouping.
```sql
-- Example: Rank employees by salary within department
SELECT
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary
FROM employees;
```

### Q7: How to find duplicate records?
**Answer:**
```sql
-- Method 1: Using GROUP BY and HAVING
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Method 2: Using Window Function
WITH duplicates AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) as rn
    FROM users
)
SELECT * FROM duplicates WHERE rn > 1;

-- Method 3: Self-join
SELECT a.*
FROM users a
JOIN users b ON a.email = b.email
WHERE a.id > b.id;
```

### Q8: How to delete duplicate records keeping one?
**Answer:**
```sql
-- Method 1: Using CTE and ROW_NUMBER
WITH duplicates AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) as rn
    FROM users
)
DELETE FROM users
WHERE id IN (SELECT id FROM duplicates WHERE rn > 1);

-- Method 2: Using self-join
DELETE a
FROM users a
JOIN users b ON a.email = b.email
WHERE a.id > b.id;
```

### Q9: Write a query to find nth highest salary
**Answer:**
```sql
-- Method 1: Using LIMIT and OFFSET
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET n-1;

-- Method 2: Using Dense Rank
WITH ranked_salaries AS (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) as rank
    FROM employees
)
SELECT salary FROM ranked_salaries WHERE rank = n;

-- Method 3: Using correlated subquery
SELECT DISTINCT salary
FROM employees e1
WHERE n-1 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary > e1.salary
);
```

### Q10: Explain ACID properties
**Answer:**
- **Atomicity**: Transaction completes fully or not at all
- **Consistency**: Database remains in valid state
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed changes persist permanently

## Database Design Questions

### Q11: When to use denormalization?
**Answer:**
Denormalize when:
- Read performance is critical
- Joins are expensive
- Data is mostly read-only
- Reporting/analytics requirements

Examples:
- Materialized views for reports
- Caching calculated values
- Data warehousing

### Q12: Explain different types of database relationships
**Answer:**
1. **One-to-One**: User → Profile
2. **One-to-Many**: User → Posts
3. **Many-to-Many**: Students ↔ Courses (via junction table)
4. **Self-referencing**: Employee → Manager (same table)

### Q13: What are database transactions?
**Answer:**
A transaction is a sequence of operations performed as a single logical unit.
```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- or ROLLBACK if error
```

### Q14: Explain database isolation levels
**Answer:**
1. **READ UNCOMMITTED**: Can read uncommitted changes (dirty reads)
2. **READ COMMITTED**: Only read committed changes
3. **REPEATABLE READ**: Same query returns same results
4. **SERIALIZABLE**: Full isolation, transactions appear sequential

### Q15: How to optimize slow queries?
**Answer:**
1. Use EXPLAIN ANALYZE to understand query plan
2. Add appropriate indexes
3. Avoid SELECT *
4. Use proper JOIN types
5. Partition large tables
6. Use query caching
7. Optimize subqueries (use JOINs instead)
8. Update statistics regularly

## Rails ActiveRecord Questions

### Q16: N+1 query problem and solutions
**Answer:**
N+1 occurs when fetching associated records in a loop:
```ruby
# Problem: N+1 queries
posts = Post.all
posts.each do |post|
  puts post.comments.count  # Query for each post
end

# Solution 1: includes (eager loading)
posts = Post.includes(:comments)

# Solution 2: joins (when you need conditions)
posts = Post.joins(:comments).where(comments: { approved: true })

# Solution 3: Counter cache
# Add comments_count column to posts table
class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
end
```

### Q17: Difference between includes, joins, and preload
**Answer:**
```ruby
# includes: Eager loading, separate queries
Post.includes(:comments)
# SELECT * FROM posts
# SELECT * FROM comments WHERE post_id IN (1,2,3...)

# joins: INNER JOIN, single query
Post.joins(:comments)
# SELECT posts.* FROM posts INNER JOIN comments ON comments.post_id = posts.id

# preload: Always separate queries
Post.preload(:comments)
# SELECT * FROM posts
# SELECT * FROM comments WHERE post_id IN (1,2,3...)

# eager_load: Always LEFT OUTER JOIN
Post.eager_load(:comments)
# SELECT * FROM posts LEFT OUTER JOIN comments ON comments.post_id = posts.id
```

### Q18: Database migrations best practices
**Answer:**
```ruby
# 1. Always reversible
class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
  end
end

# 2. Use up/down for complex migrations
class ComplexMigration < ActiveRecord::Migration[7.0]
  def up
    # Forward migration
  end

  def down
    # Reverse migration
  end
end

# 3. Data migrations separate from schema
class MigrateUserData < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      user.update_column(:status, 'active')
    end
  end
end

# 4. Add database constraints
add_foreign_key :posts, :users
add_check_constraint :products, "price > 0", name: "price_positive"
```

### Q19: Optimistic vs Pessimistic Locking
**Answer:**
```ruby
# Optimistic Locking (using lock_version column)
class Product < ApplicationRecord
  # Assumes lock_version column exists
end

product = Product.find(1)
product.name = "New Name"
product.save!  # Raises StaleObjectError if another update happened

# Pessimistic Locking
Product.transaction do
  product = Product.lock.find(1)  # SELECT ... FOR UPDATE
  product.update!(quantity: product.quantity - 1)
end
```

### Q20: Database connection pooling
**Answer:**
```yaml
# database.yml
production:
  adapter: postgresql
  pool: 25          # Max connections
  timeout: 5000     # Connection timeout
  checkout_timeout: 5  # Wait time for connection
  reaping_frequency: 10  # Check for dead connections
```

## System Design & Architecture Questions

### Q21: How would you design a URL shortener database?
**Answer:**
```sql
-- Core tables
CREATE TABLE urls (
    id BIGSERIAL PRIMARY KEY,
    short_code VARCHAR(10) UNIQUE NOT NULL,
    long_url TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    click_count INTEGER DEFAULT 0
);

CREATE TABLE clicks (
    id BIGSERIAL PRIMARY KEY,
    url_id BIGINT REFERENCES urls(id),
    clicked_at TIMESTAMP DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    referrer TEXT
);

-- Indexes for performance
CREATE INDEX idx_urls_short_code ON urls(short_code);
CREATE INDEX idx_urls_expires_at ON urls(expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX idx_clicks_url_id_date ON clicks(url_id, clicked_at);
```

### Q22: Design a messaging system database
**Answer:**
```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE conversations (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE conversation_participants (
    conversation_id BIGINT REFERENCES conversations(id),
    user_id BIGINT REFERENCES users(id),
    joined_at TIMESTAMP DEFAULT NOW(),
    last_read_message_id BIGINT,
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    conversation_id BIGINT REFERENCES conversations(id),
    sender_id BIGINT REFERENCES users(id),
    content TEXT,
    sent_at TIMESTAMP DEFAULT NOW(),
    edited_at TIMESTAMP
);

-- Indexes
CREATE INDEX idx_messages_conversation_sent ON messages(conversation_id, sent_at DESC);
CREATE INDEX idx_participants_user ON conversation_participants(user_id);
```

### Q23: How to handle database sharding?
**Answer:**
1. **Horizontal Sharding**: Split by range (user_id % 4)
2. **Vertical Sharding**: Split by features
3. **Geographic Sharding**: Split by region

```sql
-- Example: Shard by user_id
-- Shard 1: user_id % 4 = 0
-- Shard 2: user_id % 4 = 1
-- etc.

-- Application level sharding
def get_shard(user_id)
  shard_number = user_id % 4
  case shard_number
  when 0 then Database::Shard1
  when 1 then Database::Shard2
  when 2 then Database::Shard3
  when 3 then Database::Shard4
  end
end
```

## Performance & Optimization Questions

### Q24: How to identify slow queries?
**Answer:**
```sql
-- PostgreSQL: Enable slow query log
ALTER SYSTEM SET log_min_duration_statement = 1000; -- Log queries > 1 second

-- Find missing indexes
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE schemaname = 'public'
AND n_distinct > 100
AND correlation < 0.1
ORDER BY n_distinct DESC;

-- Query execution stats
SELECT
    query,
    calls,
    total_time,
    mean_time,
    max_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### Q25: Caching strategies for databases
**Answer:**
1. **Query Result Cache**: Cache entire query results
2. **Object Cache**: Cache individual records (Redis)
3. **HTTP Cache**: Cache at web server level
4. **Database Query Cache**: Built-in database caching

```ruby
# Rails caching example
class Product < ApplicationRecord
  def expensive_calculation
    Rails.cache.fetch("product/#{id}/calculation", expires_in: 1.hour) do
      # Expensive computation
    end
  end
end
```

## Common Practical Problems

### Q26: Find managers with more than 5 employees
```sql
SELECT
    m.id,
    m.name,
    COUNT(e.id) as employee_count
FROM employees m
INNER JOIN employees e ON m.id = e.manager_id
GROUP BY m.id, m.name
HAVING COUNT(e.id) > 5;
```

### Q27: Calculate running average
```sql
SELECT
    date,
    sales_amount,
    AVG(sales_amount) OVER (
        ORDER BY date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7days
FROM daily_sales;
```

### Q28: Find gaps in sequential data
```sql
-- Find missing invoice numbers
WITH invoice_numbers AS (
    SELECT
        invoice_number,
        LEAD(invoice_number) OVER (ORDER BY invoice_number) as next_number
    FROM invoices
)
SELECT
    invoice_number + 1 as gap_start,
    next_number - 1 as gap_end
FROM invoice_numbers
WHERE next_number - invoice_number > 1;
```

### Q29: Hierarchical data query
```sql
-- Get employee hierarchy
WITH RECURSIVE emp_hierarchy AS (
    SELECT id, name, manager_id, 0 as level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees e
    JOIN emp_hierarchy h ON e.manager_id = h.id
)
SELECT
    REPEAT('  ', level) || name as org_chart,
    level
FROM emp_hierarchy
ORDER BY level, name;
```

### Q30: Pivot table query
```sql
-- Sales by product and month
SELECT
    product_name,
    SUM(CASE WHEN EXTRACT(MONTH FROM order_date) = 1 THEN amount ELSE 0 END) as Jan,
    SUM(CASE WHEN EXTRACT(MONTH FROM order_date) = 2 THEN amount ELSE 0 END) as Feb,
    SUM(CASE WHEN EXTRACT(MONTH FROM order_date) = 3 THEN amount ELSE 0 END) as Mar,
    SUM(amount) as Total
FROM sales
WHERE EXTRACT(YEAR FROM order_date) = 2024
GROUP BY product_name;
```

---

# Practice Exercises

## Exercise Set 1: E-Commerce Database

```sql
-- Schema
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INTEGER
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date TIMESTAMP,
    status VARCHAR(20),
    total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER,
    unit_price DECIMAL(10,2)
);
```

### Practice Questions:
1. Find customers who have never placed an order
2. Get the top 5 best-selling products
3. Calculate month-over-month growth in sales
4. Find products that are frequently bought together
5. Identify VIP customers (top 10% by spending)

## Exercise Set 2: Social Media Database

```sql
-- Schema
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(255),
    created_at TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    content TEXT,
    created_at TIMESTAMP,
    likes_count INTEGER DEFAULT 0
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts(id),
    user_id INTEGER REFERENCES users(id),
    content TEXT,
    created_at TIMESTAMP
);

CREATE TABLE follows (
    follower_id INTEGER REFERENCES users(id),
    followed_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP,
    PRIMARY KEY (follower_id, followed_id)
);
```

### Practice Questions:
1. Find mutual followers between two users
2. Get trending posts from the last 24 hours
3. Find users who follow each other
4. Calculate engagement rate per user
5. Find the most active commenting users

## Rails ActiveRecord Practice

```ruby
# Models
class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :orders
  has_many :products, through: :orders
end

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes

  scope :published, -> { where(published: true) }
  scope :recent, -> { where('created_at > ?', 1.week.ago) }
end

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  scope :completed, -> { where(status: 'completed') }
end
```

### ActiveRecord Exercises:
1. Find users with more than 10 posts
2. Get posts with their comment count (avoid N+1)
3. Find users who ordered a specific product
4. Calculate total revenue per user
5. Find the most popular posts this week

---

# Quick Reference Cheat Sheet

## SQL Commands
```sql
-- DDL (Data Definition Language)
CREATE, ALTER, DROP, TRUNCATE

-- DML (Data Manipulation Language)
SELECT, INSERT, UPDATE, DELETE

-- DCL (Data Control Language)
GRANT, REVOKE

-- TCL (Transaction Control Language)
BEGIN, COMMIT, ROLLBACK, SAVEPOINT
```

## Join Syntax
```sql
-- ANSI SQL
FROM table1
[INNER | LEFT | RIGHT | FULL] JOIN table2
ON table1.column = table2.column

-- Old style (avoid)
FROM table1, table2
WHERE table1.column = table2.column
```

## Common Functions
```sql
-- Aggregate
COUNT(), SUM(), AVG(), MIN(), MAX()

-- String
CONCAT(), LENGTH(), UPPER(), LOWER(), SUBSTRING()

-- Date
NOW(), DATE(), EXTRACT(), DATE_TRUNC()

-- Window
ROW_NUMBER(), RANK(), DENSE_RANK(), LAG(), LEAD()
```

## Rails ActiveRecord Methods
```ruby
# Query Methods
where, order, limit, offset, group, having, joins, includes, select, distinct

# Finder Methods
find, find_by, find_by!, first, last, take

# Calculations
count, sum, average, minimum, maximum

# Batching
find_each, find_in_batches, in_batches
```

---

# Conclusion

This comprehensive guide covers all essential SQL and database concepts needed for both practical development and interview preparation. Practice these queries regularly, understand the underlying concepts, and always consider performance implications in your database design decisions.

Remember:
- Always test queries on sample data first
- Use EXPLAIN ANALYZE to understand performance
- Consider indexes but don't over-index
- Normalize for data integrity, denormalize for performance
- Keep learning and practicing with real-world scenarios

Happy querying! 🚀