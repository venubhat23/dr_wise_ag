# 🚀 Complete Docker & Kubernetes Mastery Guide
*Production-Ready Guide for Rails Applications with Real-World Scenarios*

## 📋 Table of Contents

### 🐳 Docker Fundamentals
- [Why Docker?](#why-docker)
- [Core Concepts](#docker-core-concepts)
- [Best Practices](#docker-best-practices)
- [Common Mistakes](#docker-common-mistakes)

### ⚓ Kubernetes Fundamentals
- [Why Kubernetes?](#why-kubernetes)
- [Architecture](#kubernetes-architecture)
- [Core Resources](#kubernetes-core-resources)
- [Production Patterns](#kubernetes-production-patterns)

### 🛠️ Practical Implementation
- [Rails Application Setup](#rails-application-setup)
- [Production Deployment](#production-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Logging](#monitoring-logging)

### 🔥 Production Scenarios
- [Zero-Downtime Deployments](#zero-downtime-deployments)
- [Auto-Scaling](#auto-scaling)
- [Disaster Recovery](#disaster-recovery)
- [Performance Optimization](#performance-optimization)

### 💼 Interview Preparation
- [Docker Interview Questions](#docker-interview-questions)
- [Kubernetes Interview Questions](#kubernetes-interview-questions)
- [Scenario-Based Questions](#scenario-based-questions)
- [Hands-On Challenges](#hands-on-challenges)

---

## Why Docker?

### The Problem Before Docker

**Development Hell:**
```bash
Developer A: "It works on my machine!"
- Ruby 3.0.0, Rails 7.0, PostgreSQL 14
- macOS with specific configurations
- Local environment variables

Developer B: "It doesn't work on mine!"
- Ruby 2.7.4, Rails 6.1, PostgreSQL 12
- Ubuntu with different packages
- Different environment setup

Production Server: "500 Internal Server Error"
- Ruby 3.1.0, Rails 7.0, PostgreSQL 15
- CentOS with security patches
- Different file permissions
```

### The Docker Solution

**Consistent Environments:**
```dockerfile
# Same exact environment everywhere
FROM ruby:3.1-alpine
COPY Gemfile* ./
RUN bundle install
COPY . .
CMD ["rails", "server"]

# Result: Identical behavior across all environments
```

### Real-World Benefits

1. **Environment Consistency**: Same OS, dependencies, configurations
2. **Faster Onboarding**: `docker-compose up` vs hours of setup
3. **Scalability**: Easy horizontal scaling
4. **Isolation**: Multiple applications without conflicts
5. **Resource Efficiency**: Containers vs Virtual Machines

---

## Docker Core Concepts

### Images vs Containers

**Think of it like this:**
```
Image = Recipe (Class in OOP)
Container = Cooked meal (Object instance)

You can:
- Share recipes (push/pull images)
- Cook multiple meals from one recipe (run multiple containers)
- Modify recipes (build new images)
- Customize meals (environment variables)
```

### Dockerfile Best Practices

#### ✅ Production-Ready Dockerfile

```dockerfile
# Multi-stage build for optimization
FROM ruby:3.1-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn

WORKDIR /app

# Copy dependency files first (leverage Docker layer caching)
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc)

# Copy and build assets
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

COPY . .
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Production stage
FROM ruby:3.1-alpine AS production

# Runtime dependencies only
RUN apk add --no-cache postgresql-client tzdata curl

# Security: Non-root user
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

WORKDIR /app

# Copy from builder
COPY --from=builder --chown=appuser:appuser /app /app
COPY --from=builder /usr/local/bundle /usr/local/bundle

USER appuser

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

#### ❌ Common Dockerfile Mistakes

```dockerfile
# BAD Example - Don't do this!
FROM ubuntu:latest  # ❌ Use specific versions

# Install everything in one layer
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    # ... 50+ packages  # ❌ Install only what's needed

# Copy everything first
COPY . .  # ❌ This invalidates cache on every code change
RUN bundle install  # ❌ This runs every time code changes

# Run as root
USER root  # ❌ Security risk

# No health check
# ❌ How do you know if container is healthy?

# Store secrets
ENV SECRET_KEY=abc123  # ❌ Never store secrets in images
```

### Docker Compose Production Setup

#### Real-World docker-compose.yml

```yaml
version: '3.8'

services:
  # Database with performance tuning
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: insurebook_production
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./config/postgres.conf:/etc/postgresql/postgresql.conf
    command: postgres -c config_file=/etc/postgresql/postgresql.conf
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
      timeout: 5s
      retries: 5
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    networks:
      - backend

  # Redis with persistence
  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --maxmemory 512mb
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    networks:
      - backend

  # Rails application
  web:
    build:
      context: .
      target: production
    environment:
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/insurebook_production
      - REDIS_URL=redis://redis:6379/0
      - RAILS_ENV=production
      - RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - frontend
      - backend
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 1G
          cpus: '0.5'

  # Background jobs
  sidekiq:
    build:
      context: .
      target: production
    environment:
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/insurebook_production
      - REDIS_URL=redis://redis:6379/0
      - RAILS_ENV=production
    command: bundle exec sidekiq
    depends_on:
      - db
      - redis
    networks:
      - backend

  # Load balancer
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./config/nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/ssl/certs
    depends_on:
      - web
    networks:
      - frontend

volumes:
  postgres_data:
  redis_data:

networks:
  frontend:
  backend:
```

---

## Why Kubernetes?

### Problems Docker Compose Can't Solve

**Scenario: Black Friday Traffic Spike**

```bash
# With Docker Compose:
Normal traffic: 1000 users/min → 3 containers handle fine
Black Friday: 50,000 users/min → 💥 Site crashes

Problems:
1. ❌ No auto-scaling
2. ❌ Manual failover if container dies
3. ❌ Load balancing is basic
4. ❌ No rolling updates (downtime required)
5. ❌ Single server limitation
6. ❌ No health checks and auto-healing
```

**With Kubernetes:**

```yaml
# Auto-scaling based on CPU/memory
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rails-hpa
spec:
  minReplicas: 3
  maxReplicas: 50  # Automatically scale to 50 pods!
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### Kubernetes Solves

1. **Auto-scaling**: Automatically add/remove containers based on load
2. **Self-healing**: Restart failed containers automatically
3. **Rolling updates**: Zero-downtime deployments
4. **Load balancing**: Distribute traffic intelligently
5. **Multi-server**: Scale across multiple machines
6. **Service discovery**: Containers find each other automatically
7. **Configuration management**: Centralized config and secrets
8. **Resource management**: CPU/memory limits and requests

---

## Kubernetes Architecture

### Cluster Components

```
🎛️  Master Node (Control Plane)
├── 🧠 API Server (receives all requests)
├── 📊 etcd (cluster state database)
├── 📅 Scheduler (decides pod placement)
└── 🎯 Controller Manager (maintains desired state)

👷 Worker Nodes (where your apps run)
├── 🤖 kubelet (node agent, talks to master)
├── 🌐 kube-proxy (networking, load balancing)
└── 🐳 Container Runtime (Docker/containerd)
```

### Resource Hierarchy

```
🏢 Cluster (entire Kubernetes installation)
└── 📁 Namespace (environment isolation)
    ├── 🚀 Deployment (manages app replicas)
    │   └── 📦 ReplicaSet (ensures pod count)
    │       └── 🏃 Pod (runs your containers)
    ├── 🌐 Service (networking/load balancing)
    ├── ⚙️ ConfigMap (configuration data)
    ├── 🔐 Secret (sensitive data)
    ├── 🚪 Ingress (external access)
    └── 💾 PersistentVolume (storage)
```

---

## Kubernetes Core Resources

### 1. Pods - Smallest Deployable Unit

```yaml
# Basic Pod (usually managed by Deployment)
apiVersion: v1
kind: Pod
metadata:
  name: rails-app
spec:
  containers:
  - name: rails
    image: insurebook:latest
    ports:
    - containerPort: 3000
    env:
    - name: RAILS_ENV
      value: "production"
    resources:
      requests:
        memory: "256Mi"
        cpu: "125m"
      limits:
        memory: "512Mi"
        cpu: "250m"
    livenessProbe:
      httpGet:
        path: /health
        port: 3000
      initialDelaySeconds: 30
      periodSeconds: 10
```

### 2. Deployments - Manage Pod Replicas

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app
spec:
  replicas: 3  # Always maintain 3 pods
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1  # Only 1 pod down at a time
      maxSurge: 1        # Create 1 extra pod during updates
  selector:
    matchLabels:
      app: rails-app
  template:
    metadata:
      labels:
        app: rails-app
    spec:
      containers:
      - name: rails
        image: insurebook:v1.2.0
        # ... container spec
```

### 3. Services - Networking & Load Balancing

```yaml
# ClusterIP Service (internal communication)
apiVersion: v1
kind: Service
metadata:
  name: rails-service
spec:
  selector:
    app: rails-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: ClusterIP  # Default, internal only

---
# LoadBalancer Service (external access)
apiVersion: v1
kind: Service
metadata:
  name: rails-external
spec:
  selector:
    app: rails-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: LoadBalancer  # Creates external load balancer
```

### 4. ConfigMaps & Secrets

```yaml
# ConfigMap for non-sensitive data
apiVersion: v1
kind: ConfigMap
metadata:
  name: rails-config
data:
  RAILS_ENV: "production"
  DATABASE_POOL: "25"
  REDIS_TIMEOUT: "5"

---
# Secret for sensitive data
apiVersion: v1
kind: Secret
metadata:
  name: rails-secrets
type: Opaque
data:
  database-password: <base64-encoded-password>
  rails-master-key: <base64-encoded-key>
```

### 5. Ingress - External HTTP/HTTPS Access

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rails-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - insurebook.com
    secretName: tls-secret
  rules:
  - host: insurebook.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rails-service
            port:
              number: 80
```

---

## Rails Application Setup

### Complete Rails Kubernetes Deployment

#### 1. Namespace and Configuration

```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: insurebook
  labels:
    environment: production
```

#### 2. Database Setup (PostgreSQL)

```yaml
# postgres.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: insurebook
spec:
  serviceName: postgres
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        env:
        - name: POSTGRES_DB
          value: insurebook_production
        - name: POSTGRES_USER
          value: postgres
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
  volumeClaimTemplates:
  - metadata:
      name: postgres-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 20Gi
```

#### 3. Rails Application with Auto-Scaling

```yaml
# rails-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app
  namespace: insurebook
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: rails-app
  template:
    metadata:
      labels:
        app: rails-app
    spec:
      initContainers:
      # Wait for database to be ready
      - name: wait-for-db
        image: postgres:15-alpine
        command:
        - sh
        - -c
        - until pg_isready -h postgres -p 5432; do sleep 1; done

      # Run database migrations
      - name: migrate
        image: insurebook:latest
        command: ["bundle", "exec", "rails", "db:migrate"]
        envFrom:
        - configMapRef:
            name: rails-config
        - secretRef:
            name: rails-secrets

      containers:
      - name: rails
        image: insurebook:latest
        ports:
        - containerPort: 3000
        envFrom:
        - configMapRef:
            name: rails-config
        - secretRef:
            name: rails-secrets

        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"

        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 60
          periodSeconds: 30

        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10

---
# Auto-scaling configuration
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rails-hpa
  namespace: insurebook
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: rails-app
  minReplicas: 3
  maxReplicas: 20
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
```

---

## Production Scenarios

### Scenario 1: Zero-Downtime Deployment

**Problem**: Deploy new version without any downtime

**Solution**: Rolling Update Strategy

```yaml
# Deployment strategy for zero downtime
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%  # Keep 75% pods running
      maxSurge: 25%        # Create 25% extra pods during update

# Commands for deployment
kubectl set image deployment/rails-app rails=insurebook:v2.0.0
kubectl rollout status deployment/rails-app
kubectl rollout history deployment/rails-app
kubectl rollout undo deployment/rails-app  # Rollback if needed
```

**Real-world Example:**
```bash
# Before update: 4 pods running (v1.0.0)
# Step 1: Create 1 new pod (v2.0.0) - now 5 pods total
# Step 2: Terminate 1 old pod - now 4 pods (3 old, 1 new)
# Step 3: Create 1 new pod - now 5 pods (2 old, 3 new)
# Step 4: Terminate 1 old pod - now 4 pods (1 old, 3 new)
# Continue until all pods are v2.0.0
```

### Scenario 2: Handling Traffic Spikes

**Problem**: Black Friday traffic surge (10x normal load)

**Before Kubernetes:**
```bash
Normal: 1000 users/min → Server dies
Manual intervention needed → Downtime
```

**With Kubernetes Auto-Scaling:**
```yaml
# HPA scales based on metrics
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rails-hpa
spec:
  minReplicas: 3
  maxReplicas: 50  # Can scale to 50 pods!
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  # Custom metrics
  - type: Pods
    pods:
      metric:
        name: requests_per_second
      target:
        type: AverageValue
        averageValue: "100"

# Result: Automatic scaling from 3 to 50 pods based on load
```

### Scenario 3: Database Connection Pool Exhaustion

**Problem**: "could not obtain a database connection within 5.000 seconds"

**Diagnosis Steps:**
```bash
# 1. Check current connections
kubectl exec -it postgres-0 -- psql -U postgres -c "
SELECT count(*) as current_connections,
       setting as max_connections
FROM pg_stat_activity, pg_settings
WHERE name='max_connections';
"

# 2. Check Rails pool settings
kubectl exec -it rails-app-xxx -- env | grep DATABASE_POOL

# 3. Check number of Rails pods
kubectl get pods -l app=rails-app
```

**Solutions:**
```yaml
# Solution 1: Increase connection pool
apiVersion: v1
kind: ConfigMap
metadata:
  name: rails-config
data:
  DATABASE_POOL: "50"  # Increase from 25

# Solution 2: Use PgBouncer
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pgbouncer
spec:
  replicas: 2
  template:
    spec:
      containers:
      - name: pgbouncer
        image: pgbouncer/pgbouncer:latest
        env:
        - name: POOL_MODE
          value: "transaction"
        - name: MAX_CLIENT_CONN
          value: "1000"
        - name: DEFAULT_POOL_SIZE
          value: "25"

# Solution 3: Scale down pods temporarily
kubectl scale deployment rails-app --replicas=2
```

### Scenario 4: Pod Keeps Crashing (CrashLoopBackOff)

**Problem**: Pod won't start, keeps restarting

**Debugging Process:**
```bash
# 1. Check pod status
kubectl describe pod rails-app-xxx

# 2. Check logs
kubectl logs rails-app-xxx
kubectl logs rails-app-xxx --previous  # Previous container logs

# 3. Common causes and fixes:

# Cause: Health check failing
# Fix: Adjust probe settings
livenessProbe:
  initialDelaySeconds: 60  # Increase delay
  periodSeconds: 30
  timeoutSeconds: 10
  failureThreshold: 5      # Allow more failures

# Cause: Resource limits too low
# Fix: Increase limits
resources:
  limits:
    memory: "1Gi"   # Was 512Mi
    cpu: "500m"     # Was 250m

# Cause: Missing environment variables
# Fix: Check ConfigMap/Secret
kubectl get configmap rails-config -o yaml
kubectl get secret rails-secrets -o yaml

# Cause: Database connection fails
# Fix: Check service discovery
kubectl get svc
kubectl exec -it rails-app-xxx -- nslookup postgres
```

### Scenario 5: Memory Leak Detection & Resolution

**Problem**: Rails app consuming excessive memory over time

**Detection:**
```bash
# Monitor resource usage
kubectl top pods -l app=rails-app
kubectl top nodes

# Check memory limits
kubectl describe pod rails-app-xxx | grep -A 5 "Limits"

# Get detailed metrics
kubectl exec -it rails-app-xxx -- cat /proc/meminfo
kubectl exec -it rails-app-xxx -- ps aux --sort=-%mem | head -10
```

**Solutions:**
```yaml
# 1. Set proper resource limits
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"     # Hard limit prevents OOM
    cpu: "500m"

# 2. Enable Ruby garbage collection tuning
env:
- name: RUBY_GC_HEAP_INIT_SLOTS
  value: "10000"
- name: RUBY_GC_HEAP_FREE_SLOTS
  value: "10000"
- name: RUBY_GC_HEAP_GROWTH_FACTOR
  value: "1.1"
- name: MALLOC_ARENA_MAX
  value: "2"

# 3. Implement pod restart policy
spec:
  restartPolicy: Always

# 4. Use liveness probe to restart unhealthy pods
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 30
  periodSeconds: 10
  failureThreshold: 3  # Restart after 3 failures
```

---

## Advanced Production Patterns

### Blue-Green Deployment

```yaml
# Blue deployment (current)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app-blue
  labels:
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rails-app
      version: blue

# Green deployment (new version)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app-green
  labels:
    version: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rails-app
      version: green

# Service switches between blue and green
apiVersion: v1
kind: Service
metadata:
  name: rails-service
spec:
  selector:
    app: rails-app
    version: blue  # Switch to 'green' when ready

# Deployment script
#!/bin/bash
# Deploy green
kubectl apply -f rails-app-green.yaml

# Wait for ready
kubectl wait --for=condition=available deployment/rails-app-green

# Run tests against green
curl -f http://green-service/health

# Switch traffic
kubectl patch service rails-service -p '{"spec":{"selector":{"version":"green"}}}'

# Monitor, rollback if issues
# kubectl patch service rails-service -p '{"spec":{"selector":{"version":"blue"}}}'
```

### Canary Deployment with Istio

```yaml
# Istio VirtualService for canary
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: rails-canary
spec:
  http:
  - match:
    - headers:
        canary:
          exact: "true"
    route:
    - destination:
        host: rails-service
        subset: v2
  - route:
    - destination:
        host: rails-service
        subset: v1
      weight: 95
    - destination:
        host: rails-service
        subset: v2
      weight: 5  # 5% traffic to new version
```

---

## Interview Questions & Answers

### Docker Interview Questions

#### Q1: Explain the difference between ADD and COPY in Dockerfile

**Answer:**
```dockerfile
# COPY - Simple file/directory copy (preferred)
COPY src/ /app/src/

# ADD - Has additional features but less predictable:
ADD https://example.com/file.tar.gz /app/  # Downloads and extracts
ADD local-file.tar.gz /app/               # Auto-extracts

# Best Practice: Use COPY unless you specifically need ADD features
# COPY is more explicit and predictable
```

**Why COPY is preferred:**
- More transparent behavior
- Doesn't auto-extract archives
- Doesn't support URLs (use RUN curl instead)
- Better for security auditing

#### Q2: How do you optimize Docker image size?

**Answer with practical example:**
```dockerfile
# ❌ BAD - Large image (1.2GB)
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y ruby-full
RUN apt-get install -y nodejs
RUN apt-get install -y postgresql-client
COPY . /app
WORKDIR /app
RUN bundle install

# ✅ GOOD - Optimized image (150MB)
FROM ruby:3.1-alpine AS builder
WORKDIR /app

# Install build dependencies in one layer
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    postgresql-dev \
    && rm -rf /var/cache/apk/*

# Copy dependency files first
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc)

COPY . .
RUN bundle exec rails assets:precompile

# Production stage
FROM ruby:3.1-alpine
RUN apk add --no-cache postgresql-client

# Copy only what's needed
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Remove unnecessary files
RUN rm -rf /app/spec /app/test /app/.git

USER 1001
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

**Optimization techniques:**
1. **Multi-stage builds**: Separate build and runtime
2. **Alpine images**: Smaller base images
3. **Layer caching**: Order commands by change frequency
4. **Combine RUN commands**: Reduce layers
5. **Remove package managers**: Clean up after install
6. **.dockerignore**: Exclude unnecessary files

#### Q3: How do you handle secrets in Docker?

**Answer with multiple approaches:**

```bash
# ❌ BAD - Never do this
ENV SECRET_KEY=abc123  # Visible in image layers

# ✅ GOOD - Multiple secure approaches:

# 1. Environment variables at runtime
docker run -e SECRET_KEY_BASE=$SECRET_KEY_BASE app

# 2. Docker secrets (Swarm mode)
echo "my_secret" | docker secret create db_password -
docker service create --secret db_password app

# 3. External secret management (HashiCorp Vault)
docker run -v vault-secrets:/secrets app

# 4. Init containers (Kubernetes pattern)
# 5. Mounted files
docker run -v /host/secrets:/secrets:ro app

# 6. Build-time secrets (BuildKit)
# syntax=docker/dockerfile:1
FROM alpine
RUN --mount=type=secret,id=api_key \
    API_KEY=$(cat /run/secrets/api_key) && \
    curl -H "Authorization: $API_KEY" https://api.example.com
```

### Kubernetes Interview Questions

#### Q4: Explain Deployment vs StatefulSet vs DaemonSet

**Answer with practical examples:**

```yaml
# Deployment - Stateless applications (web servers)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-web
spec:
  replicas: 5
  # Features:
  # - Pods are interchangeable
  # - Random names (rails-web-abc123, rails-web-def456)
  # - Rolling updates
  # - Horizontal scaling
  # Use for: Web apps, APIs, microservices

# StatefulSet - Stateful applications (databases)
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  replicas: 3
  # Features:
  # - Pods have stable identities (postgres-0, postgres-1, postgres-2)
  # - Ordered deployment/termination
  # - Stable network identities
  # - Persistent volumes per pod
  # Use for: Databases, message queues, any clustered app

# DaemonSet - One pod per node (monitoring, logging)
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-collector
spec:
  # Features:
  # - Ensures one pod per node
  # - Automatically scales with cluster
  # - Pods follow node lifecycle
  # Use for: Log collectors, monitoring agents, network proxies
```

#### Q5: How do you troubleshoot a pod stuck in Pending state?

**Answer with systematic debugging:**

```bash
# 1. Check pod description for events
kubectl describe pod <pod-name>

# Common causes and solutions:

# Cause 1: Insufficient resources
# Look for: "Insufficient cpu" or "Insufficient memory"
kubectl top nodes  # Check node resources
kubectl describe nodes  # See allocatable resources

# Solution: Reduce resource requests or add nodes
resources:
  requests:
    memory: "256Mi"  # Reduce from 1Gi
    cpu: "125m"      # Reduce from 500m

# Cause 2: No nodes matching selector
# Look for: "0/3 nodes are available: 3 node(s) didn't match Pod's node affinity"
kubectl get nodes --show-labels
kubectl describe pod <pod> | grep -A 5 "Node-Selectors"

# Solution: Fix node selector or add labels to nodes
kubectl label nodes worker1 environment=production

# Cause 3: PVC not bound
# Look for: "pod has unbound immediate PersistentVolumeClaims"
kubectl get pvc
kubectl describe pvc <pvc-name>

# Solution: Check storage class or create PV
kubectl get storageclass
kubectl get pv

# Cause 4: Image pull issues
# Look for: "Failed to pull image" or "ErrImagePull"
kubectl get events --sort-by='.metadata.creationTimestamp'

# Solution: Check image name, registry access, pull secrets
kubectl create secret docker-registry my-secret \
  --docker-server=registry.com \
  --docker-username=user \
  --docker-password=pass

# Cause 5: Security context issues
# Look for: "container has runAsNonRoot and image runs as UID 0"
# Solution: Fix security context
securityContext:
  runAsUser: 1001
  runAsGroup: 1001
  runAsNonRoot: true
```

#### Q6: Explain Kubernetes networking

**Answer with detailed breakdown:**

```yaml
# Kubernetes Networking Model

# 1. Pod-to-Pod Communication
# All pods can communicate with all other pods without NAT
# Each pod gets its own IP address

# Example: Pod A (10.244.0.5) can directly reach Pod B (10.244.1.8)

# 2. Service Types and Use Cases

# ClusterIP - Internal communication only
apiVersion: v1
kind: Service
metadata:
  name: internal-service
spec:
  type: ClusterIP  # Default
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 3000
# Use case: Database, internal APIs

# NodePort - External access via node IP
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 3000
    nodePort: 30080  # Accessible via <NodeIP>:30080
# Use case: Development, testing

# LoadBalancer - Cloud provider load balancer
apiVersion: v1
kind: Service
metadata:
  name: loadbalancer-service
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 3000
# Use case: Production external access

# 3. Ingress - HTTP/HTTPS routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
# Use case: Domain-based routing, SSL termination

# 4. Network Policies - Security
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
# Blocks all traffic by default

# Allow specific communication
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 3000
```

#### Q7: How would you implement auto-scaling in Kubernetes?

**Answer with comprehensive solution:**

```yaml
# 1. Horizontal Pod Autoscaler (HPA)
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rails-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: rails-app
  minReplicas: 3
  maxReplicas: 50
  metrics:
  # CPU-based scaling
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  # Memory-based scaling
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  # Custom metrics (requires metrics server)
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: "1000"
  - type: Pods
    pods:
      metric:
        name: sidekiq_queue_length
      target:
        type: AverageValue
        averageValue: "50"

  # Scaling behavior
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300  # Wait 5 min before scaling down
      policies:
      - type: Percent
        value: 50         # Scale down max 50% at a time
        periodSeconds: 60
      - type: Pods
        value: 2          # Or max 2 pods at a time
        periodSeconds: 60
      selectPolicy: Min   # Use most conservative policy

    scaleUp:
      stabilizationWindowSeconds: 60   # Quick scale up
      policies:
      - type: Percent
        value: 100        # Double pods if needed
        periodSeconds: 15
      - type: Pods
        value: 4          # Or add 4 pods max
        periodSeconds: 15
      selectPolicy: Max   # Use most aggressive policy

# 2. Vertical Pod Autoscaler (VPA) - Adjusts resource requests
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: rails-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: rails-app
  updatePolicy:
    updateMode: "Auto"  # Automatically restart pods with new resources
  resourcePolicy:
    containerPolicies:
    - containerName: rails
      minAllowed:
        cpu: 100m
        memory: 128Mi
      maxAllowed:
        cpu: 2
        memory: 4Gi
      controlledResources: ["cpu", "memory"]

# 3. Cluster Autoscaler - Scales nodes
# Usually configured as deployment in kube-system namespace
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      containers:
      - image: k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.0
        name: cluster-autoscaler
        command:
        - ./cluster-autoscaler
        - --v=4
        - --stderrthreshold=info
        - --cloud-provider=aws
        - --skip-nodes-with-local-storage=false
        - --expander=least-waste
        - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/kubernetes-cluster-name
        - --scale-down-enabled=true
        - --scale-down-delay-after-add=10m
        - --scale-down-unneeded-time=10m

# 4. Monitoring and Metrics
# Ensure metrics-server is installed
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Check HPA status
kubectl get hpa
kubectl describe hpa rails-hpa

# Custom metrics (example using Prometheus)
apiVersion: v1
kind: ServiceMonitor
metadata:
  name: rails-metrics
spec:
  selector:
    matchLabels:
      app: rails-app
  endpoints:
  - port: metrics
```

### Scenario-Based Interview Questions

#### Q8: Your application suddenly stops responding. Walk me through your debugging process.

**Answer with systematic approach:**

```bash
# Step 1: Check pod status
kubectl get pods -l app=rails-app
# Look for: CrashLoopBackOff, Error, Pending

# Step 2: Check recent events
kubectl get events --sort-by=.metadata.creationTimestamp --field-selector involvedObject.kind=Pod

# Step 3: Examine pod details
kubectl describe pod <failing-pod>
# Look for: Failed health checks, resource limits, scheduling issues

# Step 4: Check application logs
kubectl logs <pod-name> --previous  # Previous container
kubectl logs <pod-name> -f          # Follow current logs

# Step 5: Check resource usage
kubectl top pods
kubectl top nodes

# Step 6: Verify service connectivity
kubectl get svc
kubectl describe svc rails-service

# Check endpoints
kubectl get endpoints rails-service

# Step 7: Test connectivity
kubectl exec -it <pod> -- wget -O- http://rails-service/health

# Step 8: Check external dependencies
# Database
kubectl exec -it postgres-0 -- pg_isready
kubectl exec -it postgres-0 -- psql -U postgres -c "SELECT 1"

# Redis
kubectl exec -it redis-0 -- redis-cli ping

# Step 9: Check ingress/load balancer
kubectl describe ingress rails-ingress
kubectl get ingress

# Step 10: Network policies
kubectl get networkpolicy
kubectl describe networkpolicy <policy-name>

# Common fixes based on findings:

# Fix 1: Health check failing
kubectl edit deployment rails-app
# Increase initialDelaySeconds, adjust failure threshold

# Fix 2: Resource exhaustion
kubectl patch deployment rails-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"rails","resources":{"limits":{"memory":"2Gi","cpu":"1"}}}]}}}}'

# Fix 3: Database connection issues
kubectl scale deployment rails-app --replicas=1  # Reduce load
kubectl exec -it postgres-0 -- psql -U postgres -c "SELECT count(*) FROM pg_stat_activity;"

# Fix 4: Rollback bad deployment
kubectl rollout undo deployment/rails-app

# Fix 5: Scale based on load
kubectl scale deployment rails-app --replicas=10
```

#### Q9: You need to perform a database migration without downtime. How do you do it?

**Answer with production strategy:**

```yaml
# Strategy 1: Blue-Green with Migration Job
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migrate-v2-1-0
  namespace: insurebook
spec:
  template:
    spec:
      restartPolicy: Never
      initContainers:
      # Ensure only one migration runs at a time
      - name: migration-lock
        image: postgres:15-alpine
        command:
        - sh
        - -c
        - |
          # Create advisory lock
          psql $DATABASE_URL -c "SELECT pg_advisory_lock(12345);" || exit 1

      containers:
      - name: migrate
        image: insurebook:v2.1.0
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: rails-secrets
              key: database-url
        command:
        - sh
        - -c
        - |
          echo "Starting migration..."
          bundle exec rails db:migrate
          echo "Migration completed successfully"

      # Release lock in sidecar
      - name: unlock
        image: postgres:15-alpine
        command:
        - sh
        - -c
        - |
          # Wait for main container to finish
          while [ ! -f /tmp/migration-done ]; do sleep 1; done
          # Release advisory lock
          psql $DATABASE_URL -c "SELECT pg_advisory_unlock(12345);"

# Strategy 2: Rolling Migration with Backward Compatibility
# Phase 1: Deploy code that works with both old and new schema
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rails-app-compatible
spec:
  template:
    spec:
      initContainers:
      - name: check-migration-needed
        image: insurebook:v2.1.0-compatible
        command:
        - sh
        - -c
        - |
          # Check if migration is needed
          if bundle exec rails runner "
            begin
              ActiveRecord::Base.connection.execute('SELECT 1 FROM new_table LIMIT 1')
              puts 'Migration already applied'
            rescue
              puts 'Migration needed'
              exit 1
            end
          "; then
            echo "No migration needed"
          else
            echo "Running migration..."
            bundle exec rails db:migrate
          fi

# Strategy 3: Online Schema Change (for large tables)
# Use tools like gh-ost or pt-online-schema-change
apiVersion: batch/v1
kind: Job
metadata:
  name: online-schema-change
spec:
  template:
    spec:
      containers:
      - name: gh-ost
        image: github/gh-ost
        command:
        - gh-ost
        - --user=app_user
        - --password=$DB_PASSWORD
        - --host=postgres-service
        - --database=insurebook_production
        - --table=large_table
        - --alter="ADD COLUMN new_field VARCHAR(255)"
        - --exact-rowcount
        - --concurrent-rowcount
        - --default-retries=120
        - --panic-flag-file=/tmp/ghost.panic.flag
        - --execute

# Best Practices for Zero-Downtime Migrations:

# 1. Backward Compatible Changes First
# Instead of: ALTER TABLE users DROP COLUMN old_field;
# Do:
#   Step 1: Deploy code that doesn't use old_field
#   Step 2: Wait, monitor
#   Step 3: Drop column in next release

# 2. Use Database Migration Strategies
class AddIndexConcurrently < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!  # Required for concurrent operations

  def up
    add_index :large_table, :new_column, algorithm: :concurrently
  end

  def down
    remove_index :large_table, :new_column
  end
end

# 3. Monitor Migration Progress
kubectl logs job/db-migrate-v2-1-0 -f
kubectl describe job db-migrate-v2-1-0

# 4. Rollback Plan
# Always have a rollback script ready
apiVersion: batch/v1
kind: Job
metadata:
  name: db-rollback-v2-1-0
spec:
  template:
    spec:
      containers:
      - name: rollback
        image: insurebook:v2.0.0
        command: ["bundle", "exec", "rails", "db:rollback", "STEP=1"]
```

---

## Hands-On Practice Challenges

### Challenge 1: Complete Application Deployment

**Objective**: Deploy the Insurebook Rails application to Kubernetes with all components

**Requirements:**
1. PostgreSQL with persistence
2. Redis for caching
3. Rails application with auto-scaling
4. Sidekiq for background jobs
5. Ingress with SSL
6. Monitoring and logging

**Evaluation Criteria:**
- All pods are running and healthy
- Application accessible via HTTPS
- Auto-scaling works under load
- Persistent data survives pod restarts
- Logs are collected centrally

### Challenge 2: Production Incident Response

**Scenario**: It's Black Friday, traffic is 20x normal, and the application is down

**Your task:**
1. Diagnose the issue
2. Implement immediate fixes
3. Prevent future occurrences
4. Document the incident

**Given symptoms:**
- Users report 503 errors
- Database connection timeouts
- High memory usage on pods
- Some pods in CrashLoopBackOff

**Expected resolution time**: 15 minutes

### Challenge 3: Advanced Deployment Strategy

**Objective**: Implement canary deployment with automated rollback

**Requirements:**
1. Deploy new version to 5% of traffic
2. Monitor error rates and response times
3. Automatically rollback if error rate > 1%
4. Gradually increase traffic if healthy
5. Complete rollout or full rollback within 30 minutes

### Challenge 4: Security Hardening

**Objective**: Secure the Kubernetes deployment

**Tasks:**
1. Implement Pod Security Standards
2. Configure Network Policies
3. Use non-root containers
4. Implement RBAC
5. Secure secrets management
6. Enable audit logging

**Evaluation**: Security scan should pass with no critical issues

### Challenge 5: Cost Optimization

**Scenario**: Reduce infrastructure costs by 40% without impacting performance

**Approaches:**
1. Right-size resource requests and limits
2. Implement cluster autoscaling
3. Use spot instances where appropriate
4. Optimize storage usage
5. Implement pod disruption budgets

---

## Study Resources & Learning Path

### Beginner (0-3 months)
1. **Docker Basics**
   - Official Docker Tutorial: https://docs.docker.com/get-started/
   - Play with Docker: https://labs.play-with-docker.com/
   - Complete: Docker Fundamentals course

2. **Kubernetes Basics**
   - Kubernetes Basics: https://kubernetes.io/docs/tutorials/kubernetes-basics/
   - Play with Kubernetes: https://labs.play-with-k8s.com/
   - Complete: Introduction to Kubernetes course

### Intermediate (3-6 months)
1. **Advanced Docker**
   - Multi-stage builds
   - Docker Compose for development
   - Container security best practices

2. **Kubernetes Operations**
   - Deployments, Services, Ingress
   - ConfigMaps and Secrets
   - Persistent Volumes
   - Auto-scaling

### Advanced (6-12 months)
1. **Production Kubernetes**
   - Cluster administration
   - Monitoring and logging
   - Security and compliance
   - Disaster recovery

2. **Certification**
   - CKAD (Certified Kubernetes Application Developer)
   - CKA (Certified Kubernetes Administrator)
   - DCA (Docker Certified Associate)

### Hands-On Projects
1. **Project 1**: Containerize a Rails application
2. **Project 2**: Deploy to local Kubernetes cluster
3. **Project 3**: Implement CI/CD pipeline
4. **Project 4**: Production-grade deployment with monitoring
5. **Project 5**: Multi-environment setup (dev/staging/prod)

### Books & References
- "Docker Deep Dive" by Nigel Poulton
- "Kubernetes in Action" by Marko Lukša
- "Kubernetes Up & Running" by Kelsey Hightower
- "Production Kubernetes" by Josh Rosso

### Practice Platforms
- **Katacoda**: Interactive scenarios
- **KodeKloud**: Hands-on labs
- **A Cloud Guru**: Comprehensive courses
- **Linux Academy**: Practice environments

---

## Quick Reference

### Essential Docker Commands
```bash
# Build and tag
docker build -t app:latest .

# Run with environment
docker run -e RAILS_ENV=production -p 3000:3000 app:latest

# Debug running container
docker exec -it <container-id> /bin/bash

# View logs
docker logs <container-id> -f

# Clean up
docker system prune -a

# Compose operations
docker-compose up -d
docker-compose logs -f
docker-compose down -v
```

### Essential Kubernetes Commands
```bash
# Apply manifests
kubectl apply -f .

# Get resources
kubectl get pods,svc,deploy -o wide

# Describe for debugging
kubectl describe pod <pod-name>

# Logs
kubectl logs -f deployment/app

# Execute commands
kubectl exec -it <pod-name> -- /bin/bash

# Port forwarding
kubectl port-forward svc/app 3000:80

# Scale
kubectl scale deployment app --replicas=5

# Rollout management
kubectl rollout status deployment/app
kubectl rollout undo deployment/app

# Resource usage
kubectl top nodes
kubectl top pods
```

### Troubleshooting Commands
```bash
# Check cluster health
kubectl cluster-info
kubectl get componentstatuses

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Debug networking
kubectl exec -it pod -- nslookup service-name
kubectl exec -it pod -- curl http://service-name/health

# Check resource quotas
kubectl describe resourcequota

# Debug persistent volumes
kubectl get pv,pvc
kubectl describe pv <pv-name>
```

This comprehensive guide provides everything you need to master Docker and Kubernetes for production Rails applications. Practice each concept hands-on, and you'll be ready for any interview or production scenario! 🚀