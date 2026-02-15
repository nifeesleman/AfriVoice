-- AfriVoice Database Schema
-- Run this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
-- Stores user information synced from Clerk
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clerk_id TEXT UNIQUE NOT NULL,
  email TEXT NOT NULL,
  full_name TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Sessions Table
-- Stores each voice tutoring session
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  started_at TIMESTAMP DEFAULT NOW(),
  ended_at TIMESTAMP,
  duration_seconds INTEGER,
  topic TEXT, -- What the user asked about
  created_at TIMESTAMP DEFAULT NOW()
);

-- Transcripts Table
-- Stores the conversation transcript for each session
CREATE TABLE transcripts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
  speaker TEXT NOT NULL CHECK (speaker IN ('user', 'ai')),
  message TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_created_at ON sessions(created_at DESC);
CREATE INDEX idx_transcripts_session_id ON transcripts(session_id);
CREATE INDEX idx_transcripts_timestamp ON transcripts(timestamp);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transcripts ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT 
  USING (clerk_id = auth.jwt() ->> 'sub');

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE 
  USING (clerk_id = auth.jwt() ->> 'sub');

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT 
  WITH CHECK (clerk_id = auth.jwt() ->> 'sub');

-- RLS Policies for sessions table
CREATE POLICY "Users can view own sessions" ON sessions
  FOR SELECT 
  USING (user_id IN (
    SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
  ));

CREATE POLICY "Users can create own sessions" ON sessions
  FOR INSERT 
  WITH CHECK (user_id IN (
    SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
  ));

CREATE POLICY "Users can update own sessions" ON sessions
  FOR UPDATE 
  USING (user_id IN (
    SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
  ));

-- RLS Policies for transcripts table
CREATE POLICY "Users can view own transcripts" ON transcripts
  FOR SELECT 
  USING (session_id IN (
    SELECT id FROM sessions WHERE user_id IN (
      SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
    )
  ));

CREATE POLICY "Users can create own transcripts" ON transcripts
  FOR INSERT 
  WITH CHECK (session_id IN (
    SELECT id FROM sessions WHERE user_id IN (
      SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
    )
  ));

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Sample data (optional - for testing)
-- Uncomment these lines if you want sample data

-- INSERT INTO users (clerk_id, email, full_name) VALUES 
--   ('user_test123', 'demo@afrivoice.com', 'Demo User');

-- INSERT INTO sessions (user_id, topic, ended_at, duration_seconds) VALUES 
--   ((SELECT id FROM users WHERE email = 'demo@afrivoice.com'), 
--    'Blockchain explained', 
--    NOW() - INTERVAL '1 hour', 
--    180);

-- INSERT INTO transcripts (session_id, speaker, message) VALUES 
--   ((SELECT id FROM sessions LIMIT 1), 'user', 'Explain blockchain like I am 10'),
--   ((SELECT id FROM sessions LIMIT 1), 'ai', 'Great question! Imagine you and your friends have a notebook...');
