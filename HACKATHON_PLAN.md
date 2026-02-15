# AfriVoice - 24-Hour Hackathon Execution Plan

## Product Overview
**A voice-first AI tutor for students in Africa. No typing. Just talk and learn.**

Focus: Education accessibility, low literacy, mobile-first, voice as the interface.

---

## 1. MVP Feature List (Must-Have Only)

### Core Features
1. **User Authentication**
   - Sign up / Login via Clerk
   - Simple user profile (name, email only)

2. **Voice Tutor Session**
   - Single "Start Voice Tutor" button
   - Voice input from user (via Vapi)
   - AI voice response (via Vapi)
   - Real-time conversation display

3. **Transcript Saving**
   - Save conversation transcript to Supabase
   - View past conversations in a simple list

### Features We're NOT Building (Out of Scope)
- Subject selection
- Progress tracking/analytics
- Multi-user classrooms
- Video/screen sharing
- Payment/monetization
- Advanced dashboard
- Mobile apps (web only)
- Offline mode

---

## 2. System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      FRONTEND (Next.js)                  │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │   Login     │  │   Dashboard  │  │  Voice Tutor   │ │
│  │   (Clerk)   │  │  (Sessions)  │  │   (Vapi SDK)   │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
└─────────────────────────────────────────────────────────┘
                           │
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │  Clerk   │    │ Supabase │    │   Vapi   │
    │  (Auth)  │    │   (DB)   │    │ (Voice)  │
    └──────────┘    └──────────┘    └──────────┘
```

### Data Flow
1. User logs in → Clerk authenticates → redirects to dashboard
2. User clicks "Start Voice Tutor" → initializes Vapi session
3. User speaks → Vapi transcribes → sends to AI → AI responds
4. Transcript saved → Next.js API route → Supabase
5. User views past sessions → fetch from Supabase

### Tech Stack Integration
- **Next.js 14 (App Router)**: Frontend + API routes
- **Clerk**: Authentication (no custom backend needed)
- **Supabase**: PostgreSQL database + Auth helpers
- **Vapi**: Voice AI SDK (handles STT, LLM, TTS)
- **Tailwind + shadcn/ui**: Styling
- **Sentry**: Error tracking

---

## 3. Supabase Schema

### Table: `users`
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clerk_id TEXT UNIQUE NOT NULL,
  email TEXT NOT NULL,
  full_name TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Table: `sessions`
```sql
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  started_at TIMESTAMP DEFAULT NOW(),
  ended_at TIMESTAMP,
  duration_seconds INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Table: `transcripts`
```sql
CREATE TABLE transcripts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
  speaker TEXT NOT NULL, -- 'user' or 'ai'
  message TEXT NOT NULL,
  timestamp TIMESTAMP DEFAULT NOW()
);
```

### Row Level Security (RLS)
```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transcripts ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY "Users can view own data" ON users
  FOR SELECT USING (clerk_id = auth.jwt() ->> 'sub');

CREATE POLICY "Users can view own sessions" ON sessions
  FOR ALL USING (user_id IN (
    SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
  ));

CREATE POLICY "Users can view own transcripts" ON transcripts
  FOR ALL USING (session_id IN (
    SELECT id FROM sessions WHERE user_id IN (
      SELECT id FROM users WHERE clerk_id = auth.jwt() ->> 'sub'
    )
  ));
```

---

## 4. AI System Prompt

```
You are an enthusiastic and patient AI tutor for African students. Your goal is to make learning accessible through natural conversation.

CORE PRINCIPLES:
1. Use simple, clear language - avoid jargon
2. Explain concepts like you're talking to a curious 10-year-old
3. Be encouraging and supportive
4. Use African examples and contexts when possible (e.g., "Like a matatu in Nairobi" instead of "Like a bus in New York")
5. Keep responses under 30 seconds of speech
6. Ask follow-up questions to check understanding

TEACHING STYLE:
- Start with "Great question!" or similar encouragement
- Break complex topics into small chunks
- Use analogies and real-world examples
- Repeat key concepts differently if needed
- Celebrate when the student understands

EXAMPLE INTERACTION:
Student: "Explain blockchain like I'm 10"
Tutor: "Great question! Imagine you and your friends have a notebook where you write down who owes who money. But instead of one notebook, everyone has a copy. When someone makes a change, everyone's notebook updates. That's blockchain - a shared record that everyone can see and trust, because no one person controls it. Like when your whole class agrees on something together! Does that make sense?"

Remember: You're speaking out loud, not typing. Be conversational, warm, and clear.
```

---

## 5. Role-Based Task Breakdown

### Frontend Developer

#### Hour 0-8: Setup & Core UI
- [ ] Initialize Next.js 14 project with TypeScript
- [ ] Install dependencies: `@clerk/nextjs`, `tailwindcss`, `shadcn/ui`
- [ ] Setup Clerk authentication (sign-in, sign-up pages)
- [ ] Create basic layout with header/navigation
- [ ] Build Dashboard page (skeleton)
- [ ] Build Voice Tutor page (skeleton)
- [ ] Configure Tailwind + install shadcn button, card components

#### Hour 8-16: Voice Integration
- [ ] Install Vapi SDK: `@vapi-ai/web`
- [ ] Create Voice Tutor component with start/stop buttons
- [ ] Implement Vapi initialization and session handling
- [ ] Display real-time transcript on screen
- [ ] Add loading states and error handling
- [ ] Style the voice interface (pulse animation, mic icon)

#### Hour 16-24: Polish & Testing
- [ ] Connect transcript to backend API
- [ ] Display past sessions on dashboard
- [ ] Add responsive mobile styling
- [ ] Test on mobile device
- [ ] Fix bugs and edge cases
- [ ] Deploy to Vercel

---

### Backend Developer

#### Hour 0-8: Database Setup
- [ ] Create Supabase project
- [ ] Run schema SQL (users, sessions, transcripts tables)
- [ ] Setup Row Level Security policies
- [ ] Create API key for Next.js
- [ ] Test connection from Next.js
- [ ] Create helper functions for DB operations

#### Hour 8-16: API Routes
- [ ] Create `/api/sessions/create` endpoint (start session)
- [ ] Create `/api/sessions/[id]/end` endpoint (end session)
- [ ] Create `/api/transcripts/save` endpoint (save messages)
- [ ] Create `/api/sessions/list` endpoint (get user's sessions)
- [ ] Add Clerk webhook for user creation sync
- [ ] Test all endpoints with Postman/curl

#### Hour 16-24: Integration & Monitoring
- [ ] Setup Sentry for error tracking
- [ ] Add logging to all API routes
- [ ] Optimize database queries
- [ ] Add input validation
- [ ] Handle edge cases (concurrent sessions, etc.)
- [ ] Load test with sample data

---

### API/AI Developer

#### Hour 0-8: Vapi Setup
- [ ] Create Vapi account and get API key
- [ ] Create AI assistant in Vapi dashboard
- [ ] Configure voice model (e.g., ElevenLabs)
- [ ] Set AI system prompt (from section 4 above)
- [ ] Test assistant via Vapi playground
- [ ] Document API integration steps

#### Hour 8-16: Voice AI Integration
- [ ] Create Vapi assistant configuration in code
- [ ] Implement server-side Vapi assistant creation
- [ ] Create `/api/vapi/token` endpoint for client auth
- [ ] Test voice conversation flow end-to-end
- [ ] Tune AI parameters (temperature, max tokens)
- [ ] Add conversation context handling

#### Hour 16-24: Optimization & Demo Prep
- [ ] Optimize voice latency
- [ ] Improve AI response quality with prompt engineering
- [ ] Add fallback responses for errors
- [ ] Create demo account with sample data
- [ ] Prepare demo script talking points
- [ ] Test demo flow 5+ times

---

## 6. Two-Minute Demo Script

### Setup (Before Demo)
- Have demo account logged in
- Clear recent sessions or have 1-2 sample sessions
- Test audio/microphone works
- Have backup video if live demo fails

### Demo Flow (2 minutes)

**[0:00-0:20] Hook**
> "Many students in Africa struggle with reading and typing. Textbooks are expensive, internet is slow, and not everyone can read well. But everyone can talk and listen. So we built AfriVoice - a voice-first AI tutor."

**[0:20-0:40] Product Intro**
> "It's incredibly simple. You log in, click one button, and start learning by talking - just like you're chatting with a teacher. No complex menus, no typing. Just your voice."

**[0:40-1:30] Live Demo**
1. Show dashboard: "Here are my past learning sessions"
2. Click "Start Voice Tutor" button
3. Speak: **"Explain blockchain like I'm 10"**
4. Let AI respond (15-20 seconds)
5. Show transcript updating in real-time
6. End session
7. Show saved transcript in session list

**[1:30-2:00] Impact**
> "This is perfect for students with low literacy, slow internet, or those who learn better by listening. We're making education accessible through the most natural interface - conversation. And because it's voice-first, it works great on cheap phones with slow connections."

**[Closing Line]**
> "AfriVoice: Learn by talking. Teach by listening."

---

## Tech Setup Checklist (All Devs)

### Environment Variables (.env.local)
```bash
# Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJxxx...
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...

# Vapi
NEXT_PUBLIC_VAPI_PUBLIC_KEY=xxx
VAPI_PRIVATE_KEY=xxx

# Sentry (optional)
NEXT_PUBLIC_SENTRY_DSN=https://xxx@sentry.io/xxx
```

### Quick Start Commands
```bash
# Install
npm install

# Development
npm run dev

# Build
npm run build

# Deploy
vercel --prod
```

---

## Success Metrics (For Judges)

1. **Simplicity**: Can anyone use it in < 10 seconds?
2. **Voice Quality**: Is the AI voice clear and natural?
3. **Educational Value**: Does it actually help learning?
4. **Mobile Experience**: Does it work well on phones?
5. **Impact Potential**: Can this scale to millions of African students?

---

## Backup Plans (If Things Break)

1. **Vapi fails**: Pre-record demo video
2. **Database slow**: Use local mock data for demo
3. **Auth issues**: Have pre-logged-in session
4. **Internet drops**: Have offline video backup
5. **Audio fails**: Show typed version of demo

---

## Post-Hackathon (If We Win)

1. Add subject categories (Math, Science, History)
2. Progress tracking and achievements
3. WhatsApp integration (voice notes)
4. Swahili/French language support
5. Teacher dashboard
6. Offline mode with cached lessons
7. SMS fallback for voice
8. Partnership with African schools

---

## Final Notes

**Remember:**
- This is an MVP - prioritize working over perfect
- Cut features aggressively if running out of time
- The demo is more important than perfect code
- Voice quality matters more than UI polish
- Test on actual mobile devices
- Have fun! This is about impact, not perfection.

**Emergency Contact:**
If stuck for >30 minutes on any issue, flag it in team chat and pivot to next task. We can't afford to be blocked.

**Deployment Target:**
- Deploy to Vercel (automatic from GitHub)
- Have live URL ready 2 hours before demo
- Test live URL on mobile device

Good luck team! 🚀🎓
