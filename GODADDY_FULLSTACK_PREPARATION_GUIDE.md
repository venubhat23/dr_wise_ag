# GoDaddy Senior Software Development Engineer - FullStack Position
## Complete Preparation Guide

---

## Table of Contents
1. [Position Overview](#position-overview)
2. [Core Programming Languages](#core-programming-languages)
3. [Frontend Technologies](#frontend-technologies)
4. [Backend Technologies](#backend-technologies)
5. [Database Systems](#database-systems)
6. [Cloud & DevOps](#cloud--devops)
7. [System Design & Architecture](#system-design--architecture)
8. [Data Processing & Big Data](#data-processing--big-data)
9. [Machine Learning & AI](#machine-learning--ai)
10. [Interview Preparation Strategy](#interview-preparation-strategy)
11. [Project Portfolio Recommendations](#project-portfolio-recommendations)
12. [Behavioral Interview Preparation](#behavioral-interview-preparation)

---

## Position Overview

### Key Focus Areas
- **Next Best Action Platform**: AI-based personalization system
- **Ads Platform**: Advertisement experience optimization
- **Global Scale**: World's largest domain registrar services
- **End-to-End Ownership**: Full stack development from API to persistence layer

### Core Responsibilities
1. Build scalable, cloud-ready applications
2. Develop APIs and data transformation pipelines
3. Implement both batch and streaming data processing
4. Lead technical projects through architecture to implementation
5. Ensure code quality through testing and reviews

---

## Core Programming Languages

### 1. Java (Primary Backend Language)

#### Core Concepts to Master

**Java Fundamentals**
```java
// OOP Concepts
public abstract class Vehicle {
    protected String brand;
    protected int year;

    public abstract void start();
    public abstract void stop();
}

public class Car extends Vehicle implements Serializable {
    private String model;

    @Override
    public void start() {
        System.out.println("Car starting...");
    }

    @Override
    public void stop() {
        System.out.println("Car stopping...");
    }
}

// Generics
public class GenericRepository<T> {
    private List<T> items = new ArrayList<>();

    public void add(T item) {
        items.add(item);
    }

    public T get(int index) {
        return items.get(index);
    }
}
```

**Collections Framework**
```java
// Important Collections
List<String> arrayList = new ArrayList<>();        // Dynamic array
List<String> linkedList = new LinkedList<>();      // Doubly-linked list
Set<String> hashSet = new HashSet<>();            // No duplicates, unordered
Set<String> treeSet = new TreeSet<>();            // Sorted set
Map<String, Integer> hashMap = new HashMap<>();   // Key-value pairs
Map<String, Integer> treeMap = new TreeMap<>();   // Sorted map

// Stream API (Java 8+)
List<User> users = getUserList();
List<String> activeUserNames = users.stream()
    .filter(user -> user.isActive())
    .map(User::getName)
    .sorted()
    .collect(Collectors.toList());

// Parallel Processing
long count = users.parallelStream()
    .filter(user -> user.getAge() > 18)
    .count();
```

**Concurrency & Multithreading**
```java
// Thread Creation
public class Worker extends Thread {
    @Override
    public void run() {
        // Task implementation
    }
}

// Using Runnable
Runnable task = () -> {
    System.out.println("Running in thread: " + Thread.currentThread().getName());
};

// ExecutorService (Thread Pools)
ExecutorService executor = Executors.newFixedThreadPool(10);
Future<String> future = executor.submit(() -> {
    // Async task
    return "Result";
});

// CompletableFuture (Async Programming)
CompletableFuture<String> future = CompletableFuture
    .supplyAsync(() -> fetchData())
    .thenApply(data -> processData(data))
    .thenCompose(result -> saveAsync(result));
```

**Spring Framework (Essential for Enterprise Java)**
```java
// Spring Boot Application
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

// REST Controller
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        return ResponseEntity.ok(userService.findById(id));
    }

    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody @Valid User user) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(userService.save(user));
    }
}

// Service Layer
@Service
@Transactional
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User save(User user) {
        return userRepository.save(user);
    }
}

// Repository Layer
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    List<User> findByAgeGreaterThan(int age);
}
```

### 2. Python (Data Processing & ML)

#### Core Python Concepts

**Python Fundamentals**
```python
# Data Structures
# Lists (mutable, ordered)
numbers = [1, 2, 3, 4, 5]
numbers.append(6)
squared = [x**2 for x in numbers]  # List comprehension

# Tuples (immutable, ordered)
coordinates = (10, 20)
x, y = coordinates  # Unpacking

# Sets (unique, unordered)
unique_items = {1, 2, 3, 3, 4}  # {1, 2, 3, 4}

# Dictionaries (key-value pairs)
user = {
    'name': 'John',
    'age': 30,
    'email': 'john@example.com'
}

# Generators (memory-efficient iterators)
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# Decorators
def timer_decorator(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start} seconds")
        return result
    return wrapper

@timer_decorator
def slow_function():
    time.sleep(2)
    return "Done"
```

**Object-Oriented Programming in Python**
```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import List, Optional

# Abstract Base Class
class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

    @abstractmethod
    def perimeter(self) -> float:
        pass

# Inheritance
class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)

# Dataclass (Python 3.7+)
@dataclass
class User:
    id: int
    name: str
    email: str
    age: Optional[int] = None

    def is_adult(self) -> bool:
        return self.age >= 18 if self.age else False

# Context Managers
class DatabaseConnection:
    def __enter__(self):
        self.connection = create_connection()
        return self.connection

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.connection.close()

# Usage
with DatabaseConnection() as conn:
    conn.execute("SELECT * FROM users")
```

**Async Programming in Python**
```python
import asyncio
import aiohttp

async def fetch_data(url: str) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

async def process_urls(urls: List[str]) -> List[dict]:
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

# Run async function
urls = ["http://api1.com", "http://api2.com"]
results = asyncio.run(process_urls(urls))
```

### 3. Golang (Modern Backend Development)

#### Go Fundamentals

**Basic Syntax & Structures**
```go
package main

import (
    "fmt"
    "sync"
)

// Struct definition
type User struct {
    ID       int    `json:"id"`
    Name     string `json:"name"`
    Email    string `json:"email"`
    IsActive bool   `json:"is_active"`
}

// Method on struct
func (u *User) Validate() error {
    if u.Email == "" {
        return fmt.Errorf("email is required")
    }
    return nil
}

// Interface
type Repository interface {
    Save(user User) error
    FindByID(id int) (*User, error)
    Delete(id int) error
}

// Implementation
type UserRepository struct {
    db *sql.DB
}

func (r *UserRepository) Save(user User) error {
    query := `INSERT INTO users (name, email, is_active) VALUES ($1, $2, $3)`
    _, err := r.db.Exec(query, user.Name, user.Email, user.IsActive)
    return err
}
```

**Goroutines & Channels (Concurrency)**
```go
// Goroutines
func worker(id int, jobs <-chan int, results chan<- int) {
    for j := range jobs {
        fmt.Printf("Worker %d processing job %d\n", id, j)
        results <- j * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)

    // Start workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }

    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)

    // Collect results
    for a := 1; a <= 5; a++ {
        <-results
    }
}

// Mutex for synchronization
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

// WaitGroup
func processItems(items []string) {
    var wg sync.WaitGroup

    for _, item := range items {
        wg.Add(1)
        go func(item string) {
            defer wg.Done()
            processItem(item)
        }(item)
    }

    wg.Wait()
}
```

---

## Frontend Technologies

### 1. JavaScript (ES6+)

#### Modern JavaScript Features

**ES6+ Syntax**
```javascript
// Arrow Functions
const add = (a, b) => a + b;
const greet = name => `Hello, ${name}!`;

// Destructuring
const user = { name: 'John', age: 30, email: 'john@example.com' };
const { name, age } = user;

const numbers = [1, 2, 3, 4, 5];
const [first, second, ...rest] = numbers;

// Spread Operator
const newUser = { ...user, location: 'USA' };
const combined = [...numbers, ...rest];

// Template Literals
const message = `User ${name} is ${age} years old`;

// Classes
class Vehicle {
    constructor(brand, model) {
        this.brand = brand;
        this.model = model;
    }

    start() {
        console.log(`${this.brand} ${this.model} is starting`);
    }
}

class Car extends Vehicle {
    constructor(brand, model, doors) {
        super(brand, model);
        this.doors = doors;
    }

    honk() {
        console.log('Beep!');
    }
}

// Promises
const fetchData = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve({ data: 'Some data' });
        }, 1000);
    });
};

// Async/Await
const getData = async () => {
    try {
        const result = await fetchData();
        console.log(result);
    } catch (error) {
        console.error(error);
    }
};

// Modules
export const utility = {
    formatDate: (date) => date.toISOString(),
    parseJSON: (str) => JSON.parse(str)
};

import { utility } from './utils.js';
```

**Advanced JavaScript Concepts**
```javascript
// Closures
function createCounter() {
    let count = 0;
    return {
        increment: () => ++count,
        decrement: () => --count,
        getCount: () => count
    };
}

const counter = createCounter();
counter.increment(); // 1

// Prototypes
function Person(name) {
    this.name = name;
}

Person.prototype.greet = function() {
    return `Hello, I'm ${this.name}`;
};

// Event Loop & Async
console.log('1');
setTimeout(() => console.log('2'), 0);
Promise.resolve().then(() => console.log('3'));
console.log('4');
// Output: 1, 4, 3, 2

// Higher-Order Functions
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);
const sum = numbers.reduce((acc, n) => acc + n, 0);

// Currying
const multiply = a => b => a * b;
const double = multiply(2);
console.log(double(5)); // 10

// Debouncing
function debounce(func, delay) {
    let timeoutId;
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
}

// Throttling
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}
```

### 2. React.js

#### React Fundamentals & Advanced Patterns

**Core Concepts**
```jsx
import React, { useState, useEffect, useContext, useReducer, useMemo, useCallback } from 'react';

// Functional Component with Hooks
const UserProfile = ({ userId }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchUser = async () => {
            try {
                setLoading(true);
                const response = await fetch(`/api/users/${userId}`);
                const data = await response.json();
                setUser(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchUser();
    }, [userId]);

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div>
            <h1>{user.name}</h1>
            <p>{user.email}</p>
        </div>
    );
};

// Custom Hook
const useApi = (url) => {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                const response = await fetch(url);
                const result = await response.json();
                setData(result);
            } catch (err) {
                setError(err);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, [url]);

    return { data, loading, error };
};

// Context API
const ThemeContext = React.createContext();

const ThemeProvider = ({ children }) => {
    const [theme, setTheme] = useState('light');

    const toggleTheme = () => {
        setTheme(prev => prev === 'light' ? 'dark' : 'light');
    };

    return (
        <ThemeContext.Provider value={{ theme, toggleTheme }}>
            {children}
        </ThemeContext.Provider>
    );
};

// useReducer for Complex State
const initialState = {
    users: [],
    loading: false,
    error: null
};

const userReducer = (state, action) => {
    switch (action.type) {
        case 'FETCH_START':
            return { ...state, loading: true, error: null };
        case 'FETCH_SUCCESS':
            return { ...state, loading: false, users: action.payload };
        case 'FETCH_ERROR':
            return { ...state, loading: false, error: action.payload };
        case 'ADD_USER':
            return { ...state, users: [...state.users, action.payload] };
        case 'DELETE_USER':
            return {
                ...state,
                users: state.users.filter(u => u.id !== action.payload)
            };
        default:
            return state;
    }
};

const UserManagement = () => {
    const [state, dispatch] = useReducer(userReducer, initialState);

    const fetchUsers = async () => {
        dispatch({ type: 'FETCH_START' });
        try {
            const response = await fetch('/api/users');
            const data = await response.json();
            dispatch({ type: 'FETCH_SUCCESS', payload: data });
        } catch (error) {
            dispatch({ type: 'FETCH_ERROR', payload: error.message });
        }
    };

    return (
        <div>
            {/* Component UI */}
        </div>
    );
};

// Performance Optimization
const ExpensiveComponent = ({ data, filter }) => {
    // Memoize expensive calculation
    const filteredData = useMemo(() => {
        return data.filter(item => item.category === filter);
    }, [data, filter]);

    // Memoize callback function
    const handleClick = useCallback((id) => {
        console.log(`Clicked item ${id}`);
    }, []);

    return (
        <div>
            {filteredData.map(item => (
                <div key={item.id} onClick={() => handleClick(item.id)}>
                    {item.name}
                </div>
            ))}
        </div>
    );
};

// React.memo for component memoization
const MemoizedComponent = React.memo(({ data }) => {
    return <div>{data.name}</div>;
}, (prevProps, nextProps) => {
    return prevProps.data.id === nextProps.data.id;
});
```

**Advanced React Patterns**
```jsx
// Compound Components
const Tabs = ({ children, defaultTab }) => {
    const [activeTab, setActiveTab] = useState(defaultTab);

    return (
        <TabContext.Provider value={{ activeTab, setActiveTab }}>
            {children}
        </TabContext.Provider>
    );
};

Tabs.List = ({ children }) => <div className="tab-list">{children}</div>;
Tabs.Tab = ({ index, children }) => {
    const { activeTab, setActiveTab } = useContext(TabContext);
    return (
        <button
            className={activeTab === index ? 'active' : ''}
            onClick={() => setActiveTab(index)}
        >
            {children}
        </button>
    );
};
Tabs.Panel = ({ index, children }) => {
    const { activeTab } = useContext(TabContext);
    return activeTab === index ? <div>{children}</div> : null;
};

// Render Props
const DataProvider = ({ render }) => {
    const [data, setData] = useState(null);

    useEffect(() => {
        fetchData().then(setData);
    }, []);

    return render(data);
};

// Higher-Order Component (HOC)
const withAuth = (Component) => {
    return (props) => {
        const [isAuthenticated, setIsAuthenticated] = useState(false);

        useEffect(() => {
            checkAuth().then(setIsAuthenticated);
        }, []);

        if (!isAuthenticated) return <div>Please login</div>;

        return <Component {...props} />;
    };
};

// Custom Hook for Form Handling
const useForm = (initialValues, validate) => {
    const [values, setValues] = useState(initialValues);
    const [errors, setErrors] = useState({});
    const [touched, setTouched] = useState({});

    const handleChange = (e) => {
        const { name, value } = e.target;
        setValues(prev => ({ ...prev, [name]: value }));
    };

    const handleBlur = (e) => {
        const { name } = e.target;
        setTouched(prev => ({ ...prev, [name]: true }));

        if (validate) {
            const validationErrors = validate(values);
            setErrors(validationErrors);
        }
    };

    const handleSubmit = (callback) => (e) => {
        e.preventDefault();
        if (validate) {
            const validationErrors = validate(values);
            setErrors(validationErrors);
            if (Object.keys(validationErrors).length === 0) {
                callback(values);
            }
        } else {
            callback(values);
        }
    };

    return {
        values,
        errors,
        touched,
        handleChange,
        handleBlur,
        handleSubmit
    };
};
```

### 3. Node.js

#### Server-Side JavaScript

**Express.js Framework**
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');

const app = express();

// Middleware
app.use(helmet()); // Security headers
app.use(cors()); // CORS
app.use(express.json()); // JSON parsing
app.use(morgan('combined')); // Logging

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// Custom middleware
const authenticate = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        if (!token) {
            return res.status(401).json({ error: 'No token provided' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = await User.findById(decoded.id);
        next();
    } catch (error) {
        res.status(401).json({ error: 'Invalid token' });
    }
};

// Routes
app.get('/api/users', authenticate, async (req, res) => {
    try {
        const users = await User.find().select('-password');
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.post('/api/users', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Validation
        if (!name || !email || !password) {
            return res.status(400).json({ error: 'All fields required' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        const user = new User({
            name,
            email,
            password: hashedPassword
        });

        await user.save();
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(err.status || 500).json({
        error: process.env.NODE_ENV === 'production'
            ? 'Something went wrong!'
            : err.message
    });
});

// WebSocket with Socket.io
const http = require('http');
const socketIo = require('socket.io');

const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        methods: ['GET', 'POST']
    }
});

io.on('connection', (socket) => {
    console.log('New client connected');

    socket.on('join-room', (roomId) => {
        socket.join(roomId);
        socket.to(roomId).emit('user-joined', socket.id);
    });

    socket.on('message', (data) => {
        io.to(data.room).emit('new-message', data);
    });

    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

**File System & Streams**
```javascript
const fs = require('fs').promises;
const { createReadStream, createWriteStream } = require('fs');
const { pipeline } = require('stream/promises');
const csv = require('csv-parser');

// Async file operations
const readFile = async (filePath) => {
    try {
        const data = await fs.readFile(filePath, 'utf-8');
        return data;
    } catch (error) {
        console.error('Error reading file:', error);
    }
};

// Stream processing for large files
const processLargeFile = async () => {
    const readStream = createReadStream('large-file.csv');
    const writeStream = createWriteStream('output.json');

    const results = [];

    await pipeline(
        readStream,
        csv(),
        async function* (source) {
            for await (const chunk of source) {
                // Process each row
                const processed = await processRow(chunk);
                yield JSON.stringify(processed) + '\n';
            }
        },
        writeStream
    );
};

// Worker Threads for CPU-intensive tasks
const { Worker, isMainThread, parentPort } = require('worker_threads');

if (isMainThread) {
    const worker = new Worker(__filename);
    worker.on('message', (result) => {
        console.log('Result from worker:', result);
    });
    worker.postMessage({ cmd: 'calculate', data: [1, 2, 3, 4, 5] });
} else {
    parentPort.on('message', (task) => {
        if (task.cmd === 'calculate') {
            const result = task.data.reduce((a, b) => a + b, 0);
            parentPort.postMessage(result);
        }
    });
}
```

---

## Database Systems

### 1. SQL Databases

#### PostgreSQL / MySQL

**Advanced SQL Queries**
```sql
-- Complex JOINs
SELECT
    u.id,
    u.name,
    u.email,
    COUNT(DISTINCT o.id) as total_orders,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value,
    MAX(o.created_at) as last_order_date,
    CASE
        WHEN SUM(o.total_amount) > 10000 THEN 'Premium'
        WHEN SUM(o.total_amount) > 5000 THEN 'Gold'
        ELSE 'Regular'
    END as customer_tier
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY u.id, u.name, u.email
HAVING COUNT(o.id) > 0
ORDER BY total_spent DESC;

-- Window Functions
SELECT
    id,
    name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg_salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank,
    LAG(salary, 1) OVER (ORDER BY hire_date) as previous_salary,
    SUM(salary) OVER (ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM employees;

-- Common Table Expressions (CTEs)
WITH RECURSIVE category_tree AS (
    -- Anchor member
    SELECT
        id,
        name,
        parent_id,
        0 as level
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive member
    SELECT
        c.id,
        c.name,
        c.parent_id,
        ct.level + 1
    FROM categories c
    INNER JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT * FROM category_tree ORDER BY level, name;

-- Indexing Strategies
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);
CREATE INDEX idx_products_category_price ON products(category_id, price);

-- Partial Index (PostgreSQL)
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

-- Full-text search (PostgreSQL)
CREATE INDEX idx_products_search ON products USING gin(to_tsvector('english', name || ' ' || description));

SELECT * FROM products
WHERE to_tsvector('english', name || ' ' || description) @@ to_tsquery('laptop & gaming');

-- JSON Operations (PostgreSQL)
SELECT
    id,
    data->>'name' as name,
    data->'address'->>'city' as city,
    jsonb_array_elements(data->'orders') as orders
FROM users
WHERE data @> '{"status": "active"}'::jsonb;

-- Materialized Views
CREATE MATERIALIZED VIEW sales_summary AS
SELECT
    DATE_TRUNC('month', created_at) as month,
    COUNT(*) as total_orders,
    SUM(total_amount) as revenue
FROM orders
GROUP BY DATE_TRUNC('month', created_at);

CREATE UNIQUE INDEX ON sales_summary(month);
REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary;
```

**Database Optimization**
```sql
-- Query Optimization
EXPLAIN ANALYZE
SELECT u.*, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

-- Partitioning (PostgreSQL)
CREATE TABLE orders_2024 PARTITION OF orders
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Stored Procedures
DELIMITER //
CREATE PROCEDURE GetUserOrders(IN userId INT)
BEGIN
    SELECT * FROM orders WHERE user_id = userId;
    SELECT SUM(total_amount) FROM orders WHERE user_id = userId;
END //
DELIMITER ;

-- Triggers
CREATE TRIGGER update_user_stats
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE users
    SET
        total_orders = total_orders + 1,
        total_spent = total_spent + NEW.total_amount
    WHERE id = NEW.user_id;
END;
```

### 2. NoSQL Databases

#### MongoDB

**MongoDB Operations**
```javascript
// Connection and Basic Operations
const { MongoClient, ObjectId } = require('mongodb');

const client = new MongoClient(uri);

// CRUD Operations
async function crudOperations() {
    const db = client.db('myapp');
    const users = db.collection('users');

    // Create
    const newUser = await users.insertOne({
        name: 'John Doe',
        email: 'john@example.com',
        age: 30,
        interests: ['coding', 'reading'],
        address: {
            city: 'New York',
            country: 'USA'
        }
    });

    // Read with complex queries
    const results = await users.find({
        age: { $gte: 18, $lte: 65 },
        interests: { $in: ['coding', 'design'] },
        'address.country': 'USA'
    }).toArray();

    // Update
    await users.updateOne(
        { _id: ObjectId('...') },
        {
            $set: { status: 'active' },
            $inc: { loginCount: 1 },
            $push: { interests: 'music' }
        }
    );

    // Delete
    await users.deleteOne({ _id: ObjectId('...') });
}

// Aggregation Pipeline
async function aggregationExample() {
    const pipeline = [
        // Stage 1: Match
        { $match: { status: 'active' } },

        // Stage 2: Lookup (JOIN)
        {
            $lookup: {
                from: 'orders',
                localField: '_id',
                foreignField: 'userId',
                as: 'orders'
            }
        },

        // Stage 3: Unwind
        { $unwind: '$orders' },

        // Stage 4: Group
        {
            $group: {
                _id: '$_id',
                name: { $first: '$name' },
                totalOrders: { $sum: 1 },
                totalAmount: { $sum: '$orders.amount' }
            }
        },

        // Stage 5: Sort
        { $sort: { totalAmount: -1 } },

        // Stage 6: Limit
        { $limit: 10 }
    ];

    const results = await users.aggregate(pipeline).toArray();
}

// Indexing
async function createIndexes() {
    await users.createIndex({ email: 1 }, { unique: true });
    await users.createIndex({ 'address.city': 1, age: -1 });
    await users.createIndex(
        { name: 'text', description: 'text' },
        { weights: { name: 10, description: 5 } }
    );
}

// Transactions
async function transactionExample() {
    const session = client.startSession();

    try {
        await session.withTransaction(async () => {
            await users.updateOne(
                { _id: senderId },
                { $inc: { balance: -amount } },
                { session }
            );

            await users.updateOne(
                { _id: receiverId },
                { $inc: { balance: amount } },
                { session }
            );
        });
    } finally {
        await session.endSession();
    }
}
```

#### Redis

**Redis Operations & Patterns**
```javascript
const redis = require('redis');
const client = redis.createClient();

// Basic Operations
await client.set('user:1', JSON.stringify({ name: 'John', age: 30 }));
const user = JSON.parse(await client.get('user:1'));

// Expiration
await client.setex('session:abc123', 3600, 'user_data');

// Lists
await client.lpush('queue:jobs', JSON.stringify(job));
const nextJob = JSON.parse(await client.rpop('queue:jobs'));

// Sets
await client.sadd('users:online', 'user1', 'user2');
const onlineUsers = await client.smembers('users:online');

// Sorted Sets (Leaderboard)
await client.zadd('leaderboard', 100, 'player1', 85, 'player2');
const topPlayers = await client.zrevrange('leaderboard', 0, 9, 'WITHSCORES');

// Hashes
await client.hset('user:1', 'name', 'John', 'age', '30');
const userData = await client.hgetall('user:1');

// Pub/Sub
const subscriber = redis.createClient();
subscriber.subscribe('notifications');
subscriber.on('message', (channel, message) => {
    console.log(`Received ${message} from ${channel}`);
});

const publisher = redis.createClient();
publisher.publish('notifications', 'New message');

// Caching Pattern
async function getCachedData(key, fetchFunction) {
    let data = await client.get(key);

    if (!data) {
        data = await fetchFunction();
        await client.setex(key, 3600, JSON.stringify(data));
    } else {
        data = JSON.parse(data);
    }

    return data;
}

// Distributed Lock
async function acquireLock(resource, ttl = 10000) {
    const identifier = uuid.v4();
    const result = await client.set(
        `lock:${resource}`,
        identifier,
        'NX',
        'PX',
        ttl
    );
    return result ? identifier : null;
}
```

---

## Cloud & DevOps

### 1. AWS Services

#### Core AWS Services for Development

**EC2 & Auto Scaling**
```yaml
# CloudFormation Template
Resources:
  WebServerInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0123456789abcdef0
      InstanceType: t2.micro
      SecurityGroups:
        - !Ref WebServerSecurityGroup
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          yum update -y
          yum install -y docker
          service docker start
          docker run -d -p 80:80 myapp:latest

  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      MinSize: 2
      MaxSize: 10
      DesiredCapacity: 4
      LaunchTemplate:
        LaunchTemplateId: !Ref LaunchTemplate
      TargetGroupARNs:
        - !Ref TargetGroup
```

**S3 Operations**
```javascript
const AWS = require('aws-sdk');
const s3 = new AWS.S3();

// Upload file
async function uploadFile(file, bucket, key) {
    const params = {
        Bucket: bucket,
        Key: key,
        Body: file,
        ContentType: 'image/jpeg',
        ACL: 'public-read'
    };

    return await s3.upload(params).promise();
}

// Generate presigned URL
async function getPresignedUrl(bucket, key) {
    const params = {
        Bucket: bucket,
        Key: key,
        Expires: 3600 // 1 hour
    };

    return s3.getSignedUrl('getObject', params);
}

// Multipart upload for large files
async function multipartUpload(filePath, bucket, key) {
    const fileStream = fs.createReadStream(filePath);
    const uploadParams = {
        Bucket: bucket,
        Key: key,
        Body: fileStream
    };

    const options = {
        partSize: 10 * 1024 * 1024, // 10 MB
        queueSize: 10
    };

    return s3.upload(uploadParams, options).promise();
}
```

**Lambda Functions**
```javascript
// Lambda handler
exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event));

    try {
        // Process SQS messages
        if (event.Records) {
            for (const record of event.Records) {
                const body = JSON.parse(record.body);
                await processMessage(body);
            }
        }

        // API Gateway integration
        if (event.httpMethod) {
            const { httpMethod, path, body, headers } = event;

            switch (httpMethod) {
                case 'GET':
                    return {
                        statusCode: 200,
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ message: 'Success' })
                    };
                case 'POST':
                    const data = JSON.parse(body);
                    const result = await processData(data);
                    return {
                        statusCode: 201,
                        body: JSON.stringify(result)
                    };
            }
        }
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message })
        };
    }
};

// DynamoDB operations in Lambda
const dynamodb = new AWS.DynamoDB.DocumentClient();

async function saveItem(item) {
    const params = {
        TableName: 'MyTable',
        Item: item
    };

    return await dynamodb.put(params).promise();
}

async function queryItems(userId) {
    const params = {
        TableName: 'MyTable',
        KeyConditionExpression: 'userId = :userId',
        ExpressionAttributeValues: {
            ':userId': userId
        }
    };

    return await dynamodb.query(params).promise();
}
```

### 2. Docker & Kubernetes

#### Docker

**Dockerfile Best Practices**
```dockerfile
# Multi-stage build for Node.js application
FROM node:16-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Build application
RUN npm run build

# Production stage
FROM node:16-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy built application
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start application
CMD ["node", "dist/index.js"]
```

**Docker Compose**
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      DATABASE_URL: postgres://user:pass@db:5432/mydb
      REDIS_URL: redis://cache:6379
    depends_on:
      - db
      - cache
    networks:
      - app-network
    volumes:
      - ./uploads:/app/uploads
    restart: unless-stopped

  db:
    image: postgres:14
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network

  cache:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - app-network

volumes:
  postgres-data:
  redis-data:

networks:
  app-network:
    driver: bridge
```

#### Kubernetes

**Kubernetes Manifests**
```yaml
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: production
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: myapp-secret
              key: database-url
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

---
# Service
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 3000
  type: LoadBalancer

---
# Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
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

---
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: myapp-config
data:
  app.conf: |
    server {
      listen 80;
      server_name myapp.com;
      location / {
        proxy_pass http://app:3000;
      }
    }

---
# Secret
apiVersion: v1
kind: Secret
metadata:
  name: myapp-secret
type: Opaque
data:
  database-url: cG9zdGdyZXM6Ly91c2VyOnBhc3NAZGI6NTQzMi9teWRi # base64 encoded
```

### 3. CI/CD Pipelines

#### GitHub Actions
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '16'
  DOCKER_REGISTRY: docker.io
  IMAGE_NAME: myapp

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run linting
      run: npm run lint

    - name: Run tests
      run: npm test -- --coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
    - uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: |
          ${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          ${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
        cache-from: type=registry,ref=${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache
        cache-to: type=registry,ref=${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
    - name: Deploy to Kubernetes
      uses: azure/k8s-deploy@v4
      with:
        namespace: production
        manifests: |
          k8s/deployment.yaml
          k8s/service.yaml
        images: |
          ${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
```

---

## System Design & Architecture

### 1. Microservices Architecture

#### Design Patterns

**Service Communication**
```javascript
// API Gateway Pattern
const express = require('express');
const httpProxy = require('http-proxy-middleware');

const app = express();

// Service registry
const services = {
    users: 'http://users-service:3001',
    orders: 'http://orders-service:3002',
    products: 'http://products-service:3003'
};

// Proxy middleware
Object.keys(services).forEach(path => {
    app.use(
        `/api/${path}`,
        httpProxy.createProxyMiddleware({
            target: services[path],
            changeOrigin: true,
            pathRewrite: { [`^/api/${path}`]: '' }
        })
    );
});

// Circuit Breaker Pattern
class CircuitBreaker {
    constructor(fn, options = {}) {
        this.fn = fn;
        this.state = 'CLOSED';
        this.failureThreshold = options.failureThreshold || 5;
        this.resetTimeout = options.resetTimeout || 60000;
        this.failureCount = 0;
        this.nextAttempt = Date.now();
    }

    async call(...args) {
        if (this.state === 'OPEN') {
            if (Date.now() < this.nextAttempt) {
                throw new Error('Circuit breaker is OPEN');
            }
            this.state = 'HALF_OPEN';
        }

        try {
            const result = await this.fn(...args);
            this.onSuccess();
            return result;
        } catch (error) {
            this.onFailure();
            throw error;
        }
    }

    onSuccess() {
        this.failureCount = 0;
        this.state = 'CLOSED';
    }

    onFailure() {
        this.failureCount++;
        if (this.failureCount >= this.failureThreshold) {
            this.state = 'OPEN';
            this.nextAttempt = Date.now() + this.resetTimeout;
        }
    }
}

// Service Mesh Communication
const consul = require('consul')();

// Service registration
async function registerService() {
    await consul.agent.service.register({
        name: 'user-service',
        id: 'user-service-1',
        address: '192.168.1.100',
        port: 3001,
        check: {
            http: 'http://192.168.1.100:3001/health',
            interval: '10s'
        }
    });
}

// Service discovery
async function discoverService(serviceName) {
    const services = await consul.health.service(serviceName);
    const healthyServices = services.filter(s => s.Checks.every(c => c.Status === 'passing'));
    return healthyServices[Math.floor(Math.random() * healthyServices.length)];
}
```

**Event-Driven Architecture**
```javascript
// Message Queue with RabbitMQ
const amqp = require('amqplib');

class MessageBroker {
    async connect() {
        this.connection = await amqp.connect('amqp://localhost');
        this.channel = await this.connection.createChannel();
    }

    async publish(exchange, routingKey, message) {
        await this.channel.assertExchange(exchange, 'topic', { durable: true });
        this.channel.publish(
            exchange,
            routingKey,
            Buffer.from(JSON.stringify(message)),
            { persistent: true }
        );
    }

    async subscribe(exchange, pattern, handler) {
        await this.channel.assertExchange(exchange, 'topic', { durable: true });
        const q = await this.channel.assertQueue('', { exclusive: true });

        await this.channel.bindQueue(q.queue, exchange, pattern);

        this.channel.consume(q.queue, async (msg) => {
            try {
                const content = JSON.parse(msg.content.toString());
                await handler(content);
                this.channel.ack(msg);
            } catch (error) {
                console.error('Error processing message:', error);
                this.channel.nack(msg, false, false);
            }
        });
    }
}

// Saga Pattern for distributed transactions
class OrderSaga {
    constructor(orderService, paymentService, inventoryService) {
        this.orderService = orderService;
        this.paymentService = paymentService;
        this.inventoryService = inventoryService;
    }

    async createOrder(orderData) {
        const compensations = [];

        try {
            // Step 1: Create order
            const order = await this.orderService.create(orderData);
            compensations.push(() => this.orderService.cancel(order.id));

            // Step 2: Reserve inventory
            await this.inventoryService.reserve(orderData.items);
            compensations.push(() => this.inventoryService.release(orderData.items));

            // Step 3: Process payment
            await this.paymentService.charge(orderData.payment);
            compensations.push(() => this.paymentService.refund(orderData.payment));

            // Step 4: Confirm order
            await this.orderService.confirm(order.id);

            return order;
        } catch (error) {
            // Compensate in reverse order
            for (const compensation of compensations.reverse()) {
                try {
                    await compensation();
                } catch (compError) {
                    console.error('Compensation failed:', compError);
                }
            }
            throw error;
        }
    }
}
```

### 2. Scalability Patterns

**Caching Strategies**
```javascript
// Multi-level caching
class CacheManager {
    constructor() {
        this.l1Cache = new Map(); // In-memory cache
        this.l2Cache = redis.createClient(); // Redis cache
    }

    async get(key) {
        // Check L1 cache
        if (this.l1Cache.has(key)) {
            return this.l1Cache.get(key);
        }

        // Check L2 cache
        const l2Value = await this.l2Cache.get(key);
        if (l2Value) {
            const value = JSON.parse(l2Value);
            this.l1Cache.set(key, value);
            return value;
        }

        return null;
    }

    async set(key, value, ttl = 3600) {
        // Set in both caches
        this.l1Cache.set(key, value);
        await this.l2Cache.setex(key, ttl, JSON.stringify(value));

        // Implement LRU for L1 cache
        if (this.l1Cache.size > 1000) {
            const firstKey = this.l1Cache.keys().next().value;
            this.l1Cache.delete(firstKey);
        }
    }

    async invalidate(pattern) {
        // Invalidate L1 cache
        for (const key of this.l1Cache.keys()) {
            if (key.match(pattern)) {
                this.l1Cache.delete(key);
            }
        }

        // Invalidate L2 cache
        const keys = await this.l2Cache.keys(pattern);
        if (keys.length > 0) {
            await this.l2Cache.del(...keys);
        }
    }
}

// Read-through cache pattern
async function getWithCache(key, fetchFn) {
    const cached = await cache.get(key);
    if (cached) return cached;

    const fresh = await fetchFn();
    await cache.set(key, fresh);
    return fresh;
}

// Write-through cache pattern
async function updateWithCache(key, data, updateFn) {
    await updateFn(data);
    await cache.set(key, data);
}

// Write-behind (write-back) cache pattern
class WriteBackCache {
    constructor() {
        this.writeBuffer = new Map();
        this.startFlushTimer();
    }

    async write(key, data) {
        this.writeBuffer.set(key, data);
        await cache.set(key, data);
    }

    startFlushTimer() {
        setInterval(async () => {
            const batch = Array.from(this.writeBuffer.entries());
            this.writeBuffer.clear();

            if (batch.length > 0) {
                await this.flushToDatabase(batch);
            }
        }, 5000);
    }

    async flushToDatabase(batch) {
        // Batch write to database
        await db.batchWrite(batch);
    }
}
```

**Load Balancing & Sharding**
```javascript
// Consistent Hashing for Sharding
class ConsistentHash {
    constructor(nodes, virtualNodes = 150) {
        this.nodes = nodes;
        this.virtualNodes = virtualNodes;
        this.ring = new Map();
        this.buildRing();
    }

    hash(key) {
        // Simple hash function (use crypto.createHash in production)
        let hash = 0;
        for (let i = 0; i < key.length; i++) {
            hash = ((hash << 5) - hash) + key.charCodeAt(i);
            hash = hash & hash;
        }
        return Math.abs(hash);
    }

    buildRing() {
        for (const node of this.nodes) {
            for (let i = 0; i < this.virtualNodes; i++) {
                const virtualKey = `${node}:${i}`;
                const hash = this.hash(virtualKey);
                this.ring.set(hash, node);
            }
        }
    }

    getNode(key) {
        const hash = this.hash(key);
        const sortedHashes = Array.from(this.ring.keys()).sort((a, b) => a - b);

        for (const nodeHash of sortedHashes) {
            if (nodeHash >= hash) {
                return this.ring.get(nodeHash);
            }
        }

        return this.ring.get(sortedHashes[0]);
    }
}

// Database Sharding
class ShardedDatabase {
    constructor(shards) {
        this.shards = shards;
        this.consistentHash = new ConsistentHash(
            shards.map((s, i) => `shard-${i}`)
        );
    }

    getShard(key) {
        const shardName = this.consistentHash.getNode(key);
        const shardIndex = parseInt(shardName.split('-')[1]);
        return this.shards[shardIndex];
    }

    async insert(key, data) {
        const shard = this.getShard(key);
        return await shard.insert(key, data);
    }

    async query(key) {
        const shard = this.getShard(key);
        return await shard.query(key);
    }
}
```

---

## Data Processing & Big Data

### 1. Apache Spark Concepts

**Spark with PySpark**
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.window import Window

# Initialize Spark
spark = SparkSession.builder \
    .appName("DataProcessing") \
    .config("spark.sql.adaptive.enabled", "true") \
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
    .getOrCreate()

# Read data
df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv("hdfs://path/to/data.csv")

# Data transformations
processed_df = df \
    .filter(col("status") == "active") \
    .withColumn("year", year("created_date")) \
    .withColumn("month", month("created_date")) \
    .groupBy("year", "month", "category") \
    .agg(
        count("*").alias("count"),
        sum("amount").alias("total_amount"),
        avg("amount").alias("avg_amount"),
        max("amount").alias("max_amount")
    ) \
    .orderBy("year", "month")

# Window functions
windowSpec = Window.partitionBy("category").orderBy("date")
df_with_rank = df.withColumn(
    "rank",
    rank().over(windowSpec)
).withColumn(
    "running_total",
    sum("amount").over(windowSpec.rowsBetween(Window.unboundedPreceding, Window.currentRow))
)

# Join operations
users_df = spark.read.parquet("hdfs://path/to/users.parquet")
orders_df = spark.read.parquet("hdfs://path/to/orders.parquet")

joined_df = orders_df.join(
    users_df,
    orders_df.user_id == users_df.id,
    "left"
).select(
    orders_df["*"],
    users_df.name.alias("user_name"),
    users_df.email.alias("user_email")
)

# User Defined Functions (UDF)
from pyspark.sql.types import StringType

def classify_amount(amount):
    if amount < 100:
        return "small"
    elif amount < 1000:
        return "medium"
    else:
        return "large"

classify_udf = udf(classify_amount, StringType())
df_classified = df.withColumn("size_category", classify_udf(col("amount")))

# Write results
processed_df.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .parquet("hdfs://path/to/output")
```

### 2. Stream Processing

**Apache Kafka & Stream Processing**
```javascript
const { Kafka } = require('kafkajs');

// Kafka Producer
class KafkaProducer {
    constructor() {
        this.kafka = new Kafka({
            clientId: 'my-app',
            brokers: ['kafka1:9092', 'kafka2:9092']
        });
        this.producer = this.kafka.producer();
    }

    async connect() {
        await this.producer.connect();
    }

    async send(topic, messages) {
        await this.producer.send({
            topic,
            messages: messages.map(m => ({
                key: m.key,
                value: JSON.stringify(m.value),
                headers: m.headers
            }))
        });
    }
}

// Kafka Consumer with Stream Processing
class StreamProcessor {
    constructor() {
        this.kafka = new Kafka({
            clientId: 'stream-processor',
            brokers: ['kafka1:9092', 'kafka2:9092']
        });

        this.consumer = this.kafka.consumer({
            groupId: 'processing-group',
            sessionTimeout: 30000,
            heartbeatInterval: 3000
        });
    }

    async start() {
        await this.consumer.connect();
        await this.consumer.subscribe({
            topics: ['events'],
            fromBeginning: false
        });

        // Windowing for aggregation
        const window = new Map();
        const windowSize = 60000; // 1 minute

        await this.consumer.run({
            eachMessage: async ({ topic, partition, message }) => {
                const event = JSON.parse(message.value);
                const timestamp = parseInt(message.timestamp);
                const windowKey = Math.floor(timestamp / windowSize) * windowSize;

                // Update window
                if (!window.has(windowKey)) {
                    window.set(windowKey, []);
                }
                window.get(windowKey).push(event);

                // Process completed windows
                for (const [key, events] of window.entries()) {
                    if (timestamp - key > windowSize * 2) {
                        await this.processWindow(key, events);
                        window.delete(key);
                    }
                }
            }
        });
    }

    async processWindow(windowStart, events) {
        // Aggregate events in the window
        const aggregated = events.reduce((acc, event) => {
            acc.count++;
            acc.sum += event.value;
            return acc;
        }, { count: 0, sum: 0 });

        aggregated.avg = aggregated.sum / aggregated.count;
        aggregated.windowStart = new Date(windowStart);

        // Store or forward results
        await this.storeResults(aggregated);
    }
}
```

---

## Machine Learning & AI

### 1. Machine Learning Basics

**Python ML with scikit-learn**
```python
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, precision_recall_fscore_support
import joblib

# Data preparation
def prepare_data(df):
    # Handle missing values
    df.fillna(df.mean(), inplace=True)

    # Encode categorical variables
    label_encoders = {}
    for column in df.select_dtypes(include=['object']).columns:
        le = LabelEncoder()
        df[column] = le.fit_transform(df[column])
        label_encoders[column] = le

    # Feature scaling
    scaler = StandardScaler()
    numeric_columns = df.select_dtypes(include=['float64', 'int64']).columns
    df[numeric_columns] = scaler.fit_transform(df[numeric_columns])

    return df, scaler, label_encoders

# Model training
def train_model(X_train, y_train):
    # Hyperparameter tuning
    param_grid = {
        'n_estimators': [100, 200, 300],
        'max_depth': [10, 20, None],
        'min_samples_split': [2, 5, 10],
        'min_samples_leaf': [1, 2, 4]
    }

    rf = RandomForestClassifier(random_state=42)
    grid_search = GridSearchCV(
        rf,
        param_grid,
        cv=5,
        scoring='accuracy',
        n_jobs=-1
    )

    grid_search.fit(X_train, y_train)
    return grid_search.best_estimator_

# Feature importance
def get_feature_importance(model, feature_names):
    importance = model.feature_importances_
    indices = np.argsort(importance)[::-1]

    print("Feature ranking:")
    for i in range(len(feature_names)):
        print(f"{i + 1}. {feature_names[indices[i]]}: {importance[indices[i]]:.4f}")

# Model evaluation
def evaluate_model(model, X_test, y_test):
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    precision, recall, f1, _ = precision_recall_fscore_support(
        y_test,
        predictions,
        average='weighted'
    )

    return {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1_score': f1
    }

# Save and load model
def save_model(model, scaler, label_encoders):
    joblib.dump(model, 'model.pkl')
    joblib.dump(scaler, 'scaler.pkl')
    joblib.dump(label_encoders, 'label_encoders.pkl')

def load_model():
    model = joblib.load('model.pkl')
    scaler = joblib.load('scaler.pkl')
    label_encoders = joblib.load('label_encoders.pkl')
    return model, scaler, label_encoders

# Real-time prediction API
from flask import Flask, request, jsonify

app = Flask(__name__)
model, scaler, label_encoders = load_model()

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    df = pd.DataFrame([data])

    # Preprocess
    for column, le in label_encoders.items():
        if column in df:
            df[column] = le.transform(df[column])

    numeric_columns = df.select_dtypes(include=['float64', 'int64']).columns
    df[numeric_columns] = scaler.transform(df[numeric_columns])

    # Predict
    prediction = model.predict(df)[0]
    probability = model.predict_proba(df)[0].max()

    return jsonify({
        'prediction': int(prediction),
        'confidence': float(probability)
    })
```

### 2. Deep Learning with TensorFlow

**Neural Network for Recommendation System**
```python
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np

# Build recommendation model
def build_recommendation_model(num_users, num_items, embedding_dim=50):
    # Input layers
    user_input = layers.Input(shape=(1,), name='user_input')
    item_input = layers.Input(shape=(1,), name='item_input')

    # Embedding layers
    user_embedding = layers.Embedding(
        num_users,
        embedding_dim,
        name='user_embedding'
    )(user_input)
    item_embedding = layers.Embedding(
        num_items,
        embedding_dim,
        name='item_embedding'
    )(item_input)

    # Flatten embeddings
    user_vec = layers.Flatten()(user_embedding)
    item_vec = layers.Flatten()(item_embedding)

    # Concatenate and add dense layers
    concat = layers.Concatenate()([user_vec, item_vec])
    dense1 = layers.Dense(128, activation='relu')(concat)
    dropout1 = layers.Dropout(0.5)(dense1)
    dense2 = layers.Dense(64, activation='relu')(dropout1)
    dropout2 = layers.Dropout(0.5)(dense2)

    # Output layer
    output = layers.Dense(1, activation='sigmoid')(dropout2)

    # Build model
    model = keras.Model(
        inputs=[user_input, item_input],
        outputs=output
    )

    model.compile(
        optimizer='adam',
        loss='binary_crossentropy',
        metrics=['accuracy', keras.metrics.AUC()]
    )

    return model

# Custom training loop with callbacks
class RecommendationTrainer:
    def __init__(self, model):
        self.model = model

    def train(self, train_data, val_data, epochs=10):
        # Callbacks
        callbacks = [
            keras.callbacks.EarlyStopping(
                monitor='val_loss',
                patience=3,
                restore_best_weights=True
            ),
            keras.callbacks.ReduceLROnPlateau(
                monitor='val_loss',
                factor=0.5,
                patience=2,
                min_lr=1e-6
            ),
            keras.callbacks.ModelCheckpoint(
                'best_model.h5',
                monitor='val_auc',
                mode='max',
                save_best_only=True
            )
        ]

        # Training
        history = self.model.fit(
            train_data,
            validation_data=val_data,
            epochs=epochs,
            callbacks=callbacks,
            verbose=1
        )

        return history

    def predict_recommendations(self, user_id, all_items, top_k=10):
        # Generate predictions for all items
        user_array = np.array([user_id] * len(all_items))
        predictions = self.model.predict([user_array, all_items])

        # Get top-k recommendations
        top_indices = np.argsort(predictions.flatten())[-top_k:][::-1]
        return all_items[top_indices], predictions[top_indices]

# Real-time serving with TensorFlow Serving
def export_for_serving(model, export_path):
    tf.saved_model.save(model, export_path)

    # Serving signature
    @tf.function
    def serving_fn(user_id, item_id):
        return model([user_id, item_id])

    signatures = {
        'serving_default': serving_fn.get_concrete_function(
            user_id=tf.TensorSpec(shape=[None, 1], dtype=tf.int32),
            item_id=tf.TensorSpec(shape=[None, 1], dtype=tf.int32)
        )
    }

    tf.saved_model.save(model, export_path, signatures=signatures)
```

---

## Interview Preparation Strategy

### 1. Technical Interview Structure

#### Round 1: Coding Challenge (1-2 hours)
**Focus Areas:**
- Data Structures & Algorithms
- Problem-solving approach
- Code quality and optimization

**Practice Problems:**
```python
# Example: Design a LRU Cache
class LRUCache:
    def __init__(self, capacity):
        self.capacity = capacity
        self.cache = {}
        self.order = []

    def get(self, key):
        if key not in self.cache:
            return -1

        # Move to end (most recently used)
        self.order.remove(key)
        self.order.append(key)
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.order.remove(key)
        elif len(self.cache) >= self.capacity:
            # Remove least recently used
            lru = self.order.pop(0)
            del self.cache[lru]

        self.cache[key] = value
        self.order.append(key)

# Example: Find all anagrams in a string
def find_anagrams(s, p):
    from collections import Counter

    result = []
    p_count = Counter(p)
    window = Counter(s[:len(p)])

    if window == p_count:
        result.append(0)

    for i in range(len(p), len(s)):
        window[s[i]] += 1
        window[s[i - len(p)]] -= 1

        if window[s[i - len(p)]] == 0:
            del window[s[i - len(p)]]

        if window == p_count:
            result.append(i - len(p) + 1)

    return result
```

#### Round 2: System Design (1 hour)
**Topics to Cover:**
1. Design a URL shortener
2. Design a recommendation system
3. Design a real-time analytics platform
4. Design a distributed cache
5. Design an e-commerce platform

**System Design Template:**
1. Requirements Gathering
   - Functional requirements
   - Non-functional requirements
   - Scale estimation

2. High-Level Design
   - Architecture diagram
   - Component identification

3. Detailed Design
   - API design
   - Data model
   - Algorithm selection

4. Scale & Performance
   - Bottleneck identification
   - Optimization strategies

5. Trade-offs & Alternatives

#### Round 3: Behavioral Interview
**STAR Method Examples:**
- **Situation**: Describe the context
- **Task**: Explain what needed to be done
- **Action**: Detail what you did
- **Result**: Share the outcome

**Key Questions to Prepare:**
1. Tell me about a challenging project
2. Describe a time you had to learn new technology quickly
3. How do you handle disagreements with team members?
4. Describe a time you improved system performance
5. Tell me about a failure and what you learned

### 2. Project Portfolio Recommendations

#### Project 1: Full-Stack E-Commerce Platform
**Technologies**: React, Node.js, MongoDB, Redis, Docker
**Features**:
- User authentication with JWT
- Product catalog with search and filters
- Shopping cart with Redis session storage
- Payment integration (Stripe)
- Real-time inventory updates
- Admin dashboard with analytics

#### Project 2: Real-Time Recommendation System
**Technologies**: Python, TensorFlow, Kafka, Spark, Elasticsearch
**Features**:
- Collaborative filtering algorithm
- Content-based recommendations
- Real-time event streaming
- A/B testing framework
- Performance monitoring dashboard

#### Project 3: Microservices Architecture
**Technologies**: Go, Kubernetes, gRPC, RabbitMQ, PostgreSQL
**Features**:
- Service mesh with Istio
- Circuit breaker implementation
- Distributed tracing with Jaeger
- CI/CD pipeline with GitHub Actions
- Monitoring with Prometheus and Grafana

### 3. Study Schedule (8 Weeks)

#### Weeks 1-2: Programming Languages
- Java: Spring Boot, concurrency, JVM internals
- Python: Advanced features, async programming
- JavaScript/Node.js: Event loop, async patterns

#### Weeks 3-4: Frontend & Databases
- React: Hooks, performance optimization, testing
- SQL: Query optimization, indexes, transactions
- NoSQL: MongoDB aggregations, Redis patterns

#### Weeks 5-6: System Design & Cloud
- Microservices patterns
- AWS services deep dive
- Docker & Kubernetes
- CI/CD pipelines

#### Week 7: Data Processing & ML
- Spark fundamentals
- Stream processing with Kafka
- Basic ML algorithms
- Recommendation systems

#### Week 8: Interview Practice
- Mock interviews
- Coding challenges (LeetCode/HackerRank)
- System design walkthroughs
- Behavioral interview preparation

### 4. Resources & References

#### Books
1. "Designing Data-Intensive Applications" - Martin Kleppmann
2. "Clean Code" - Robert C. Martin
3. "System Design Interview" - Alex Xu
4. "Cracking the Coding Interview" - Gayle Laakmann McDowell

#### Online Platforms
1. LeetCode - Algorithm practice
2. System Design Primer (GitHub)
3. Pramp - Mock interviews
4. Educative.io - System design courses

#### Documentation
1. AWS Documentation
2. Kubernetes Documentation
3. Spring Framework Documentation
4. React Documentation

---

## Final Tips for Success

### 1. Technical Excellence
- Write clean, maintainable code
- Focus on scalability from the start
- Understand trade-offs in your decisions
- Keep learning new technologies

### 2. Communication Skills
- Explain your thought process clearly
- Ask clarifying questions
- Discuss trade-offs openly
- Be receptive to feedback

### 3. Problem-Solving Approach
- Break complex problems into smaller parts
- Think about edge cases
- Consider multiple solutions
- Optimize after getting a working solution

### 4. Cultural Fit
- Show enthusiasm for the company's mission
- Demonstrate collaboration skills
- Highlight your impact in previous roles
- Ask thoughtful questions about the team and projects

### 5. Continuous Learning
- Stay updated with industry trends
- Contribute to open-source projects
- Write technical blogs
- Attend conferences and meetups

---

## Conclusion

This comprehensive guide covers all the essential technologies and concepts required for the GoDaddy Senior Software Development Engineer - FullStack position. Focus on:

1. **Strong fundamentals** in at least one primary language (Java/Python/Go)
2. **Full-stack capabilities** with both frontend (React) and backend expertise
3. **Cloud and DevOps** knowledge, especially AWS and containerization
4. **System design** skills for building scalable applications
5. **Data processing** understanding for handling large-scale data

Remember that GoDaddy values:
- End-to-end ownership
- Scalable solutions
- Data-driven decision making
- Collaborative teamwork
- Continuous learning

Practice regularly, build projects that demonstrate these skills, and approach the interview with confidence. Good luck with your preparation!