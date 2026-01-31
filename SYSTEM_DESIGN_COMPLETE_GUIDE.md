# Complete System Design Guide: From Basics to Interview Mastery

## Table of Contents
1. [Introduction & Fundamentals](#introduction--fundamentals)
2. [High-Level Design (HLD)](#high-level-design-hld)
3. [Low-Level Design (LLD)](#low-level-design-lld)
4. [Core Concepts with Examples](#core-concepts-with-examples)
5. [Real-World System Design Examples](#real-world-system-design-examples)
6. [Interview Preparation Strategy](#interview-preparation-strategy)
7. [Practice Problems & Solutions](#practice-problems--solutions)

---

## 1. Introduction & Fundamentals

### What is System Design?
System design is the process of defining the architecture, components, modules, interfaces, and data flow for a system to satisfy specified requirements.

### Why System Design Matters
- **Scalability**: Handle millions of users
- **Reliability**: 99.99% uptime
- **Performance**: Sub-second response times
- **Maintainability**: Easy to update and debug
- **Cost-Effective**: Optimize resource usage

### System Design Levels

#### High-Level Design (HLD)
- Overall system architecture
- Major components and their interactions
- Technology choices
- Data flow between systems

#### Low-Level Design (LLD)
- Detailed component design
- Class diagrams and relationships
- Database schemas
- API contracts
- Algorithm choices

---

## 2. High-Level Design (HLD)

### Key Components of HLD

#### 1. System Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                      Load Balancer                          │
└─────────────┬───────────────────────┬──────────────────────┘
              │                       │
    ┌─────────▼──────────┐ ┌─────────▼──────────┐
    │   Web Server 1     │ │   Web Server 2     │
    └─────────┬──────────┘ └─────────┬──────────┘
              │                       │
    ┌─────────▼───────────────────────▼──────────┐
    │         Application Servers                 │
    └─────────┬───────────────────────┬──────────┘
              │                       │
    ┌─────────▼──────────┐ ┌─────────▼──────────┐
    │     Database      │ │      Cache         │
    └────────────────────┘ └────────────────────┘
```

#### 2. Component Interaction
**Example: E-commerce Order Processing**
```
User → Web Server → App Server → Order Service → Payment Service
                                       ↓
                                  Database ← Inventory Service
```

### HLD Example: URL Shortener

#### Requirements
- Shorten long URLs
- Handle 100M requests/day
- Analytics tracking
- Custom aliases

#### High-Level Architecture
```
┌──────────────────────────────────────────────────────────┐
│                         CDN                              │
└────────────────────────┬─────────────────────────────────┘
                         │
┌────────────────────────▼─────────────────────────────────┐
│                   Load Balancer                          │
└──────┬──────────────────┬──────────────────┬────────────┘
       │                  │                  │
┌──────▼──────┐    ┌──────▼──────┐   ┌──────▼──────┐
│  Web Server │    │  Web Server │   │  Web Server │
└──────┬──────┘    └──────┬──────┘   └──────┬──────┘
       │                  │                  │
┌──────▼──────────────────▼──────────────────▼────────────┐
│                 Application Layer                        │
│  ┌────────────┐  ┌──────────────┐  ┌─────────────┐    │
│  │URL Shortener│  │ URL Resolver │  │  Analytics  │    │
│  └────────────┘  └──────────────┘  └─────────────┘    │
└──────┬──────────────────┬──────────────────┬────────────┘
       │                  │                  │
┌──────▼──────┐    ┌──────▼──────┐   ┌──────▼──────┐
│   MySQL     │    │    Redis    │   │  Cassandra  │
│  (Metadata) │    │   (Cache)   │   │ (Analytics) │
└─────────────┘    └─────────────┘   └─────────────┘
```

---

## 3. Low-Level Design (LLD)

### Key Components of LLD

#### 1. Class Design
**Example: Library Management System**

```java
// Book Class
public class Book {
    private String isbn;
    private String title;
    private String author;
    private BookStatus status;
    private Date publishDate;

    public boolean isAvailable() {
        return status == BookStatus.AVAILABLE;
    }
}

// Member Class
public class Member {
    private String memberId;
    private String name;
    private List<Book> borrowedBooks;
    private static final int MAX_BOOKS = 5;

    public boolean canBorrow() {
        return borrowedBooks.size() < MAX_BOOKS;
    }

    public void borrowBook(Book book) {
        if (canBorrow() && book.isAvailable()) {
            borrowedBooks.add(book);
            book.setStatus(BookStatus.BORROWED);
        }
    }
}

// Library System
public class Library {
    private Map<String, Book> books;
    private Map<String, Member> members;
    private List<Transaction> transactions;

    public void issueBook(String memberId, String isbn) {
        Member member = members.get(memberId);
        Book book = books.get(isbn);

        if (member.canBorrow() && book.isAvailable()) {
            member.borrowBook(book);
            transactions.add(new Transaction(member, book, new Date()));
        }
    }
}
```

#### 2. Database Schema Design
**Example: Social Media Platform**

```sql
-- Users Table
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Posts Table
CREATE TABLE posts (
    post_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    content TEXT,
    media_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_user_created (user_id, created_at)
);

-- Followers Table (Many-to-Many)
CREATE TABLE followers (
    follower_id BIGINT NOT NULL,
    following_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (following_id) REFERENCES users(user_id),
    INDEX idx_following (following_id)
);
```

#### 3. API Design
**Example: RESTful API for Blog Platform**

```yaml
# API Endpoints

# Authentication
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh

# Users
GET    /api/users/{id}
PUT    /api/users/{id}
DELETE /api/users/{id}

# Posts
GET    /api/posts              # List all posts
POST   /api/posts              # Create new post
GET    /api/posts/{id}         # Get specific post
PUT    /api/posts/{id}         # Update post
DELETE /api/posts/{id}         # Delete post

# Comments
GET    /api/posts/{id}/comments
POST   /api/posts/{id}/comments
DELETE /api/comments/{id}

# Request/Response Example
POST /api/posts
Request:
{
  "title": "System Design Basics",
  "content": "Understanding system design...",
  "tags": ["tech", "design"],
  "published": true
}

Response:
{
  "id": "12345",
  "title": "System Design Basics",
  "content": "Understanding system design...",
  "author": {
    "id": "user123",
    "name": "John Doe"
  },
  "tags": ["tech", "design"],
  "published": true,
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-15T10:00:00Z"
}
```

---

## 4. Core Concepts with Examples

### 1. Scalability

#### Horizontal Scaling (Scale Out)
**When to use**: Stateless applications, read-heavy workloads
```
Before: 1 server handling 1000 req/s
After:  10 servers each handling 100 req/s = 1000 req/s total

Example: Web servers behind load balancer
```

#### Vertical Scaling (Scale Up)
**When to use**: Databases, applications with complex state
```
Before: Server with 4 CPU, 8GB RAM
After:  Server with 16 CPU, 64GB RAM

Example: Database server upgrade
```

### 2. Load Balancing

#### Types and When to Use

**Round Robin**
```
Request 1 → Server A
Request 2 → Server B
Request 3 → Server C
Request 4 → Server A (cycle repeats)

Use Case: When all servers have similar capacity
```

**Least Connections**
```
Current connections:
Server A: 50 connections
Server B: 30 connections
Server C: 40 connections

New request → Server B (least loaded)

Use Case: Long-lived connections (WebSocket, streaming)
```

**IP Hash**
```
hash(client_ip) % num_servers = server_index

Client 192.168.1.1 → Always Server B

Use Case: Session affinity required
```

### 3. Caching

#### Cache Levels and Strategies

**L1: Browser Cache**
```javascript
// Service Worker Example
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});
```

**L2: CDN Cache**
```
User Request → CDN Edge Location → Origin Server
                     ↓
              Cached Response

Example: Static assets (images, CSS, JS)
TTL: 1 hour to 1 year
```

**L3: Application Cache (Redis)**
```python
import redis

cache = redis.Redis(host='localhost', port=6379)

def get_user(user_id):
    # Check cache first
    cached = cache.get(f"user:{user_id}")
    if cached:
        return json.loads(cached)

    # Cache miss - fetch from DB
    user = db.query(f"SELECT * FROM users WHERE id = {user_id}")

    # Store in cache for 1 hour
    cache.setex(f"user:{user_id}", 3600, json.dumps(user))
    return user
```

**L4: Database Query Cache**
```sql
-- MySQL Query Cache
SELECT SQL_CACHE * FROM products WHERE category = 'electronics';
```

### 4. Database Design

#### SQL vs NoSQL Decision Matrix

| Criteria | SQL | NoSQL |
|----------|-----|--------|
| **Use Case** | Transactions, ACID | Flexible schema, Big Data |
| **Example** | Banking system | Social media feed |
| **Scaling** | Vertical (initially) | Horizontal |
| **Query** | Complex joins | Simple lookups |
| **Schema** | Fixed | Flexible |

#### Sharding Strategies

**Range-Based Sharding**
```
User IDs 1-1M     → Shard 1
User IDs 1M-2M    → Shard 2
User IDs 2M-3M    → Shard 3

Pros: Simple to implement
Cons: Uneven distribution
```

**Hash-Based Sharding**
```
shard_id = hash(user_id) % num_shards

Example:
hash(12345) % 3 = 2 → Shard 2

Pros: Even distribution
Cons: Resharding is complex
```

**Geographic Sharding**
```
US users  → US Database
EU users  → EU Database
Asia users → Asia Database

Pros: Low latency for users
Cons: Cross-region queries are slow
```

### 5. Message Queues

#### When to Use Message Queues

**Asynchronous Processing**
```python
# Without Queue (Synchronous)
def register_user(email, name):
    user = create_user(email, name)  # 50ms
    send_email(email)                 # 2000ms
    update_analytics()                # 500ms
    return user                       # Total: 2550ms

# With Queue (Asynchronous)
def register_user(email, name):
    user = create_user(email, name)  # 50ms
    queue.push("send_email", email)  # 5ms
    queue.push("analytics", user)    # 5ms
    return user                       # Total: 60ms
```

**Decoupling Services**
```
Order Service → Queue → Inventory Service
              ↘       ↗
                Email Service

If Email Service is down, orders still process
```

### 6. Microservices Architecture

#### Monolith to Microservices Evolution

**Monolithic Application**
```
┌─────────────────────────────┐
│      Single Application     │
│  ┌────────┐  ┌──────────┐ │
│  │  User   │  │ Product  │ │
│  │ Module  │  │  Module  │ │
│  └────────┘  └──────────┘ │
│  ┌────────┐  ┌──────────┐ │
│  │ Order   │  │ Payment  │ │
│  │ Module  │  │  Module  │ │
│  └────────┘  └──────────┘ │
└─────────────────────────────┘
         ↓
    Single Database
```

**Microservices Architecture**
```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│   User   │  │ Product  │  │  Order   │  │ Payment  │
│ Service  │  │ Service  │  │ Service  │  │ Service  │
└────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │              │              │
┌────▼────┐  ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
│ User DB │  │Prod DB  │   │Order DB │   │ Pay DB  │
└─────────┘  └─────────┘   └─────────┘   └─────────┘
```

#### Service Communication Patterns

**Synchronous (REST)**
```javascript
// Order Service calls Payment Service
async function createOrder(orderData) {
    const order = await saveOrder(orderData);

    // Synchronous call to Payment Service
    const payment = await fetch('http://payment-service/process', {
        method: 'POST',
        body: JSON.stringify({
            orderId: order.id,
            amount: order.total
        })
    });

    if (payment.status === 'success') {
        order.status = 'confirmed';
        await updateOrder(order);
    }

    return order;
}
```

**Asynchronous (Message Queue)**
```javascript
// Order Service publishes event
async function createOrder(orderData) {
    const order = await saveOrder(orderData);

    // Publish event to message queue
    await publishEvent('order.created', {
        orderId: order.id,
        customerId: order.customerId,
        amount: order.total
    });

    return order;
}

// Payment Service subscribes to events
subscribeToEvent('order.created', async (event) => {
    await processPayment(event.orderId, event.amount);

    // Publish completion event
    await publishEvent('payment.completed', {
        orderId: event.orderId,
        status: 'success'
    });
});
```

### 7. Distributed System Concepts

#### CAP Theorem
**Choose 2 out of 3:**
- **Consistency**: All nodes see the same data
- **Availability**: System remains operational
- **Partition Tolerance**: System continues despite network failures

**Real-World Examples:**
```
CA System: Traditional RDBMS (MySQL with single master)
CP System: MongoDB, HBase (Consistency over Availability)
AP System: Cassandra, DynamoDB (Availability over Consistency)
```

#### Consistency Patterns

**Strong Consistency**
```
Write to Node A → Replicate to all nodes → Acknowledge
Read from any node → Same data

Example: Bank transactions
Latency: High
Use Case: Financial systems
```

**Eventual Consistency**
```
Write to Node A → Acknowledge → Replicate asynchronously
Read might return old data temporarily

Example: Social media likes count
Latency: Low
Use Case: Social networks
```

**Weak Consistency**
```
Write to Node A → Acknowledge
No guarantee when/if other nodes get the update

Example: Video streaming, VoIP
Latency: Very Low
Use Case: Real-time systems
```

---

## 5. Real-World System Design Examples

### Example 1: Design WhatsApp

#### Requirements
- 1-to-1 messaging
- Group messaging
- Online/Offline status
- Read receipts
- Media sharing
- 1 billion daily active users

#### High-Level Design

```
┌─────────────────────────────────────────────────────┐
│                   Gateway Servers                    │
│              (WebSocket Connections)                 │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│                 Message Routers                      │
│         (Route messages to correct server)          │
└──────┬───────────────────────────────────┬──────────┘
       │                                   │
┌──────▼──────────┐              ┌────────▼──────────┐
│  Message Queue  │              │  Presence Service │
│   (Kafka)       │              │    (Redis)        │
└──────┬──────────┘              └───────────────────┘
       │
┌──────▼──────────────────────────────────────────────┐
│              Message Storage Service                 │
│                 (Cassandra)                         │
└──────────────────────────────────────────────────────┘
       │
┌──────▼──────────────────────────────────────────────┐
│               Media Storage Service                  │
│                    (S3 + CDN)                       │
└──────────────────────────────────────────────────────┘
```

#### Database Schema

```sql
-- Messages Table (Cassandra)
CREATE TABLE messages (
    conversation_id UUID,
    message_id TIMEUUID,
    sender_id UUID,
    content TEXT,
    media_url TEXT,
    status TEXT, -- sent, delivered, read
    created_at TIMESTAMP,
    PRIMARY KEY (conversation_id, message_id)
) WITH CLUSTERING ORDER BY (message_id DESC);

-- User Sessions (Redis)
user:{user_id}:status = "online"
user:{user_id}:last_seen = "2024-01-15 10:30:00"
user:{user_id}:devices = ["device1", "device2"]
```

### Example 2: Design YouTube

#### Requirements
- Video upload and storage
- Video streaming
- Comments and likes
- Recommendations
- 2 billion users
- 500 hours of video uploaded per minute

#### Architecture

```
┌────────────────────────────────────────────────────┐
│                      CDN                           │
│         (Global video content delivery)           │
└─────────────────┬──────────────────────────────────┘
                  │
┌─────────────────▼──────────────────────────────────┐
│              Load Balancers                        │
└────┬────────────┬─────────────┬────────────┬──────┘
     │            │             │            │
┌────▼───┐  ┌────▼────┐  ┌────▼────┐  ┌────▼────┐
│ Upload │  │Streaming│  │Metadata │  │Analytics│
│Service │  │ Service │  │ Service │  │ Service │
└────┬───┘  └────┬────┘  └────┬────┘  └────┬────┘
     │           │             │            │
┌────▼───────────▼─────────────▼────────────▼────┐
│           Message Queue (Kafka)                 │
└────┬───────────┬─────────────┬─────────────────┘
     │           │             │
┌────▼────┐ ┌───▼────┐  ┌─────▼──────┐
│ Object  │ │NoSQL DB│  │ Search     │
│Storage  │ │(Bigtable)  │ Engine    │
│  (GFS)  │ │         │  │(Elastic)  │
└─────────┘ └────────┘  └────────────┘
```

#### Video Processing Pipeline

```python
def process_video_upload(video_file, metadata):
    # 1. Upload original to storage
    video_id = generate_unique_id()
    original_url = upload_to_storage(video_file, f"raw/{video_id}")

    # 2. Queue for processing
    queue.push("transcode", {
        "video_id": video_id,
        "original_url": original_url,
        "resolutions": ["360p", "480p", "720p", "1080p", "4k"]
    })

    # 3. Generate thumbnails
    queue.push("thumbnail", {
        "video_id": video_id,
        "timestamps": [0, 25, 50, 75]  # percentage points
    })

    # 4. Content analysis
    queue.push("analyze", {
        "video_id": video_id,
        "checks": ["copyright", "inappropriate_content", "auto_captions"]
    })

    # 5. Update metadata
    save_video_metadata(video_id, metadata)

    return video_id
```

### Example 3: Design Uber

#### Requirements
- Real-time location tracking
- Driver-passenger matching
- Route optimization
- Pricing calculation
- Payment processing
- 100 million rides per day

#### System Architecture

```
┌──────────────────────────────────────────────────┐
│            API Gateway / Load Balancer           │
└────────┬──────────────────────────┬──────────────┘
         │                          │
    ┌────▼────────┐           ┌────▼────────┐
    │  Passenger  │           │   Driver    │
    │   Service   │           │   Service   │
    └────┬────────┘           └────┬────────┘
         │                          │
┌────────▼──────────────────────────▼──────────────┐
│            Location Service (Real-time)          │
│                  (Redis + WebSocket)             │
└────────┬──────────────────────────────────────────┘
         │
┌────────▼──────────────────────────────────────────┐
│              Matching Service                     │
│         (QuadTree + Geohashing)                  │
└────────┬──────────────────────────────────────────┘
         │
┌────────▼──────────────────────────────────────────┐
│   ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│   │ Pricing  │  │  Route   │  │ Payment  │     │
│   │ Service  │  │ Service  │  │ Service  │     │
│   └──────────┘  └──────────┘  └──────────┘     │
└────────┬──────────────────────────────────────────┘
         │
┌────────▼──────────────────────────────────────────┐
│          Databases (Sharded by city)             │
│   PostgreSQL (Trips) | Cassandra (Location logs) │
└──────────────────────────────────────────────────┘
```

#### Matching Algorithm

```python
class DriverMatcher:
    def __init__(self):
        self.quadtree = QuadTree()  # Spatial index
        self.driver_locations = {}   # driver_id -> location

    def find_nearest_drivers(self, passenger_location, radius_km=5):
        # Get grid cells within radius
        cells = self.get_cells_in_radius(passenger_location, radius_km)

        available_drivers = []
        for cell in cells:
            drivers_in_cell = self.quadtree.query(cell)
            for driver_id in drivers_in_cell:
                if self.is_driver_available(driver_id):
                    distance = calculate_distance(
                        passenger_location,
                        self.driver_locations[driver_id]
                    )
                    if distance <= radius_km:
                        available_drivers.append({
                            'driver_id': driver_id,
                            'distance': distance,
                            'eta': distance / AVG_SPEED
                        })

        # Sort by distance and return top N
        available_drivers.sort(key=lambda x: x['distance'])
        return available_drivers[:10]

    def match_ride(self, passenger_id, passenger_location):
        drivers = self.find_nearest_drivers(passenger_location)

        for driver in drivers:
            # Send request to driver
            response = send_ride_request(driver['driver_id'], {
                'passenger_id': passenger_id,
                'pickup_location': passenger_location,
                'eta': driver['eta']
            })

            if response == 'accepted':
                return driver['driver_id']

        return None  # No driver found
```

---

## 6. Interview Preparation Strategy

### System Design Interview Process

#### 1. Requirements Gathering (5-10 minutes)
```
Questions to Ask:
✓ Functional Requirements
  - What are the core features?
  - Who are the users?
  - What's the expected behavior?

✓ Non-Functional Requirements
  - What's the scale? (users, requests/sec)
  - What's the expected latency?
  - What's the availability requirement?
  - Any specific constraints?

✓ Out of Scope
  - What features can we skip for now?
```

#### 2. Capacity Estimation (5 minutes)
```
Example: Design Twitter

Daily Active Users: 500M
Tweets per day: 500M
Average tweet size: 280 chars = 560 bytes
Media attachment: 20% tweets have media, avg 200KB

Storage per day:
Text: 500M * 560 bytes = 280 GB
Media: 500M * 0.2 * 200KB = 20 TB
Total: ~20 TB/day

Bandwidth:
Read:Write ratio = 100:1
Write QPS: 500M / 86400 = 6000 tweets/sec
Read QPS: 600,000 requests/sec
```

#### 3. System Design (25-30 minutes)

**Start Simple, Then Scale**
```
Version 1: Single Server
┌─────────┐
│ Server  │
└────┬────┘
     │
┌────▼────┐
│Database │
└─────────┘

Version 2: Add Load Balancer & Cache
┌──────────┐
│    LB    │
└────┬─────┘
     │
┌────▼────┐  ┌─────┐
│Servers  │←→│Cache│
└────┬────┘  └─────┘
     │
┌────▼────┐
│Database │
└─────────┘

Version 3: Full Architecture
[Add CDN, Queue, Microservices, etc.]
```

#### 4. Deep Dive (10-15 minutes)
```
Interviewer might ask about:
- Database choice and schema
- API design
- Algorithm for specific feature
- Handling edge cases
- Monitoring and logging
```

### Common System Design Questions

#### Beginner Level
1. **URL Shortener** (TinyURL)
2. **Pastebin** (Text sharing)
3. **File Storage** (Dropbox basics)
4. **Cache System** (Memcached)

#### Intermediate Level
1. **Twitter Timeline**
2. **YouTube/Netflix**
3. **Uber/Lyft**
4. **WhatsApp/Messenger**
5. **Instagram**

#### Advanced Level
1. **Distributed Message Queue** (Kafka)
2. **Search Engine** (Google)
3. **Recommendation System** (Netflix)
4. **Payment System** (Stripe)
5. **Distributed Database** (Cassandra)

### Evaluation Criteria

```
What Interviewers Look For:
✓ Problem-solving approach
✓ Trade-off analysis
✓ Scalability considerations
✓ Knowledge of components
✓ Communication skills
✓ Handling ambiguity

Red Flags:
✗ Over-engineering simple problems
✗ Not asking clarifying questions
✗ Ignoring requirements
✗ Not considering trade-offs
✗ Poor communication
```

---

## 7. Practice Problems & Solutions

### Problem 1: Design a Chat Application

#### Requirements Analysis
```
Functional:
- 1-to-1 messaging
- Group chats (up to 100 users)
- Online/offline status
- Message history
- File sharing

Non-Functional:
- 10M daily active users
- < 100ms message delivery
- Messages stored for 1 year
- 99.9% availability
```

#### Solution Approach

**Step 1: API Design**
```yaml
# WebSocket Events
connect:
  params: {user_id, auth_token}

send_message:
  params: {conversation_id, content, type}

receive_message:
  params: {message_id, sender_id, content, timestamp}

# REST APIs
POST /api/conversations
GET  /api/conversations/{id}/messages
POST /api/conversations/{id}/members
```

**Step 2: Database Design**
```sql
-- Users
users: user_id, username, status, last_seen

-- Conversations
conversations: conversation_id, type, created_at

-- Messages (Cassandra for scale)
messages: conversation_id, message_id, sender_id, content, timestamp

-- Participants
participants: conversation_id, user_id, joined_at
```

**Step 3: Message Flow**
```
1. Client A sends message via WebSocket
2. Gateway server receives message
3. Message saved to database (async)
4. Message pushed to queue
5. Queue processor finds recipient's server
6. Message delivered to Client B
7. Delivery receipt sent back to Client A
```

### Problem 2: Design a Ride-Sharing Service

#### Core Components
```python
class RideService:
    def request_ride(self, passenger_location, destination):
        # 1. Find nearby drivers
        drivers = self.location_service.find_nearby_drivers(
            passenger_location,
            radius_km=5
        )

        # 2. Calculate fare estimate
        fare = self.pricing_service.calculate_fare(
            passenger_location,
            destination,
            surge_multiplier=self.get_surge_multiplier()
        )

        # 3. Match with driver
        matched_driver = self.matching_service.match(
            passenger_location,
            drivers
        )

        # 4. Create ride
        ride = Ride(
            passenger_id=self.current_user.id,
            driver_id=matched_driver.id,
            pickup=passenger_location,
            destination=destination,
            fare=fare
        )

        return ride
```

### Problem 3: Design a Distributed Cache

#### LRU Cache Implementation
```python
class LRUCache:
    def __init__(self, capacity):
        self.capacity = capacity
        self.cache = OrderedDict()

    def get(self, key):
        if key in self.cache:
            # Move to end (most recent)
            self.cache.move_to_end(key)
            return self.cache[key]
        return None

    def put(self, key, value):
        if key in self.cache:
            # Update and move to end
            self.cache.move_to_end(key)
        elif len(self.cache) >= self.capacity:
            # Remove least recently used
            self.cache.popitem(last=False)

        self.cache[key] = value
```

#### Distributed Cache with Consistent Hashing
```python
class DistributedCache:
    def __init__(self, nodes):
        self.nodes = nodes
        self.hash_ring = ConsistentHashRing(nodes)

    def get(self, key):
        node = self.hash_ring.get_node(key)
        return node.get(key)

    def put(self, key, value):
        node = self.hash_ring.get_node(key)
        node.put(key, value)

        # Replicate to N nodes for fault tolerance
        replica_nodes = self.hash_ring.get_replicas(key, n=2)
        for replica in replica_nodes:
            replica.put_replica(key, value)
```

---

## System Design Cheat Sheet

### Quick Reference Card

#### Latency Numbers (2024)
```
L1 cache reference ......................... 0.5 ns
L2 cache reference ........................... 7 ns
Main memory reference ...................... 100 ns
SSD random read .......................... 16,000 ns
HDD seek ................................ 4,000,000 ns
Send 1K over network .................... 10,000 ns
Read 1MB from SSD ...................... 250,000 ns
Read 1MB from HDD .................... 20,000,000 ns
Round trip within datacenter ............ 500,000 ns
```

#### Availability Percentages
```
99.9% (three 9s)    = 8.76 hours downtime/year
99.99% (four 9s)    = 52.56 minutes downtime/year
99.999% (five 9s)   = 5.26 minutes downtime/year
```

#### Database Comparisons
```
RDBMS (MySQL, PostgreSQL)
✓ ACID compliance
✓ Complex queries
✓ Transactions
✗ Horizontal scaling difficult

NoSQL - Document (MongoDB)
✓ Flexible schema
✓ Good for nested data
✗ No joins
✗ Eventually consistent

NoSQL - Column Family (Cassandra)
✓ High write throughput
✓ Time-series data
✗ No joins
✗ Complex queries difficult

NoSQL - Key-Value (Redis)
✓ Ultra-fast
✓ Simple data model
✗ Limited query capability
✗ Data must fit in memory

NoSQL - Graph (Neo4j)
✓ Relationship queries
✓ Social networks
✗ Not for tabular data
✗ Complex to scale
```

#### Message Queue Comparison
```
RabbitMQ
✓ Feature-rich
✓ Multiple protocols
✓ Good for complex routing
✗ Lower throughput than Kafka

Apache Kafka
✓ Very high throughput
✓ Distributed & fault-tolerant
✓ Message replay capability
✗ Complex setup

Amazon SQS
✓ Fully managed
✓ Simple to use
✓ Auto-scaling
✗ Vendor lock-in

Redis Pub/Sub
✓ Very low latency
✓ Simple
✗ No persistence
✗ No replay
```

---

## Interview Day Tips

### Before the Interview
```
1. Review your prepared designs
2. Practice drawing architectures
3. Prepare questions about requirements
4. Review latency and capacity numbers
5. Sleep well - freshness matters!
```

### During the Interview
```
1. Start with requirements - always!
2. Think out loud
3. Draw as you explain
4. Consider trade-offs explicitly
5. Start simple, then add complexity
6. Don't forget non-functional requirements
7. Leave time for questions
```

### Common Mistakes to Avoid
```
❌ Jumping to implementation without requirements
❌ Over-engineering the solution
❌ Ignoring data consistency issues
❌ Not considering failure scenarios
❌ Forgetting about monitoring/logging
❌ Not discussing trade-offs
❌ Being too detailed too early
```

---

## Resources for Continued Learning

### Books
1. **"Designing Data-Intensive Applications"** - Martin Kleppmann
2. **"System Design Interview"** - Alex Xu
3. **"Building Microservices"** - Sam Newman
4. **"Site Reliability Engineering"** - Google

### Online Courses
1. **Grokking the System Design Interview** (Educative)
2. **System Design Primer** (GitHub)
3. **Distributed Systems** (MIT 6.824)
4. **High Scalability** (Blog)

### Practice Platforms
1. **Pramp** - Mock interviews
2. **System Design Interview** - Practice problems
3. **LeetCode System Design** - Discussion forum
4. **High Scalability** - Real architecture articles

### Engineering Blogs
1. **Uber Engineering**
2. **Airbnb Engineering**
3. **Netflix Tech Blog**
4. **Facebook Engineering**
5. **AWS Architecture Center**

---

## Conclusion

System design is both an art and a science. The key to mastery is:

1. **Understand fundamentals** - Know your building blocks
2. **Practice regularly** - Design systems frequently
3. **Learn from real systems** - Study existing architectures
4. **Think about trade-offs** - No solution is perfect
5. **Communicate clearly** - Explain your reasoning

Remember: There's rarely one "correct" answer in system design. What matters is your thought process, trade-off analysis, and ability to design systems that meet the given requirements.

Good luck with your system design journey! 🚀

---

## Quick Reference: Design Patterns

### 1. Singleton Pattern
```java
public class Database {
    private static Database instance;

    private Database() {}

    public static synchronized Database getInstance() {
        if (instance == null) {
            instance = new Database();
        }
        return instance;
    }
}
```

### 2. Factory Pattern
```java
public interface DatabaseFactory {
    Database createDatabase(String type);
}

public class DatabaseFactoryImpl implements DatabaseFactory {
    public Database createDatabase(String type) {
        switch(type) {
            case "mysql": return new MySQLDatabase();
            case "postgres": return new PostgresDatabase();
            case "mongodb": return new MongoDatabase();
            default: throw new IllegalArgumentException();
        }
    }
}
```

### 3. Observer Pattern
```java
public interface EventListener {
    void update(String event);
}

public class EventPublisher {
    private List<EventListener> listeners = new ArrayList<>();

    public void subscribe(EventListener listener) {
        listeners.add(listener);
    }

    public void notify(String event) {
        for (EventListener listener : listeners) {
            listener.update(event);
        }
    }
}
```

### 4. Strategy Pattern
```java
public interface PricingStrategy {
    double calculatePrice(Ride ride);
}

public class RegularPricing implements PricingStrategy {
    public double calculatePrice(Ride ride) {
        return ride.getDistance() * BASE_RATE;
    }
}

public class SurgePricing implements PricingStrategy {
    public double calculatePrice(Ride ride) {
        return ride.getDistance() * BASE_RATE * SURGE_MULTIPLIER;
    }
}
```

---

**Last Updated**: January 2025
**Version**: 1.0
**Total Pages**: 50+
**Examples**: 30+
**Diagrams**: 25+