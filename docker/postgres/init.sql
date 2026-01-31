-- Initialize PostgreSQL for Insurebook Application
-- This script runs when the PostgreSQL container starts for the first time

-- Create additional databases for different environments
CREATE DATABASE insurebook_test;
CREATE DATABASE insurebook_staging;

-- Create a dedicated user for the application (optional for development)
-- In production, use different credentials
-- CREATE USER insurebook_user WITH PASSWORD 'secure_password_here';
-- GRANT ALL PRIVILEGES ON DATABASE insurebook_development TO insurebook_user;
-- GRANT ALL PRIVILEGES ON DATABASE insurebook_test TO insurebook_user;
-- GRANT ALL PRIVILEGES ON DATABASE insurebook_staging TO insurebook_user;

-- Enable required PostgreSQL extensions
\c insurebook_development;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

\c insurebook_test;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

\c insurebook_staging;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Performance tuning for development
-- These settings are for development only, adjust for production
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_duration = on;
ALTER SYSTEM SET log_min_duration_statement = 100;

-- Create indexes that might be commonly needed
-- (These would normally be created by Rails migrations)
-- This is just for demonstration purposes