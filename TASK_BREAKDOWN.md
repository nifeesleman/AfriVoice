# Task Breakdown - 3 Developers × 24 Hours

## Overview
This document breaks down exactly what each developer should do hour-by-hour during the 24-hour hackathon.

---

## Frontend Developer (@frontend-dev)

### Hour 0-8: Foundation & Authentication ⏰ 8 hours

#### Hour 0-2: Project Setup
- [ ] Create Next.js 14 project with TypeScript
  ```bash
  npx create-next-app@latest afrivoice --typescript --tailwind --app
  ```
- [ ] Install dependencies
  ```bash
  npm install @clerk/nextjs @radix-ui/react-slot class-variance-authority clsx tailwind-merge lucide-react
  ```
- [ ] Setup folder structure (app/, components/, lib/, types/)
- [ ] Configure `tailwind.config.js` and globals.css
- [ ] Test dev server runs: `npm run dev`

#### Hour 2-4: Authentication Setup
- [ ] Setup Clerk account and get API keys
- [ ] Add Clerk environment variables to `.env.local`
- [ ] Wrap app in ClerkProvider (`src/app/layout.tsx`)
- [ ] Create sign-in page: `src/app/(auth)/sign-in/[[...sign-in]]/page.tsx`
- [ ] Create sign-up page: `src/app/(auth)/sign-up/[[...sign-up]]/page.tsx`
- [ ] Test sign-up flow works
- [ ] Test sign-in flow works

#### Hour 4-6: Core Layout & Pages
- [ ] Create main layout with header/nav
- [ ] Install shadcn/ui: `npx shadcn-ui@latest init`
- [ ] Add shadcn components: button, card, avatar
- [ ] Create landing page (`src/app/page.tsx`) with hero section
- [ ] Create dashboard page skeleton (`src/app/dashboard/page.tsx`)
- [ ] Create voice tutor page skeleton (`src/app/voice-tutor/page.tsx`)
- [ ] Add navigation between pages
- [ ] Test protected routes work (redirect to sign-in if not logged in)

#### Hour 6-8: Dashboard UI
- [ ] Design dashboard layout (header, "Start Voice Tutor" button, sessions list)
- [ ] Create SessionCard component for displaying past sessions
- [ ] Add empty state for when no sessions exist
- [ ] Style with Tailwind (mobile-first)
- [ ] Test responsive design on mobile

**Deliverable:** Working authentication + basic UI structure

---

### Hour 8-16: Voice Integration ⏰ 8 hours

#### Hour 8-10: Vapi SDK Setup
- [ ] Install Vapi SDK: `npm install @vapi-ai/web`
- [ ] Get Vapi API key from dashboard.vapi.ai
- [ ] Add Vapi env vars to `.env.local`
- [ ] Create VoiceTutor component (`src/components/voice-tutor.tsx`)
- [ ] Initialize Vapi client
- [ ] Add start/stop button UI
- [ ] Test Vapi connection (basic initialization)

#### Hour 10-12: Voice Session Implementation
- [ ] Implement `startSession()` function with Vapi
- [ ] Implement `stopSession()` function
- [ ] Add microphone permission handling
- [ ] Add loading states (connecting, active, idle)
- [ ] Style active session UI (pulsing mic icon)
- [ ] Test voice input works
- [ ] Test AI responds

#### Hour 12-14: Transcript Display
- [ ] Listen to Vapi transcript events
- [ ] Store transcripts in component state
- [ ] Create TranscriptMessage component
- [ ] Display messages in chat-style UI (user right, AI left)
- [ ] Auto-scroll to newest message
- [ ] Add timestamps to messages
- [ ] Test real-time transcript updates

#### Hour 14-16: Polish & Edge Cases
- [ ] Add error handling (mic permission denied, connection failed)
- [ ] Add "thinking" indicator while AI responds
- [ ] Improve mobile voice UI
- [ ] Add haptic feedback on mobile (if supported)
- [ ] Test on actual mobile device
- [ ] Fix any UI bugs

**Deliverable:** Fully working voice interface with transcript display

---

### Hour 16-24: Integration & Polish ⏰ 8 hours

#### Hour 16-18: Backend Integration
- [ ] Connect to backend API for creating sessions
- [ ] Call `POST /api/sessions` when session starts
- [ ] Save session ID in component state
- [ ] Call `PATCH /api/sessions/[id]` when session ends
- [ ] Send transcripts to `POST /api/transcripts` endpoint
- [ ] Test full flow: start → talk → save → view on dashboard

#### Hour 18-20: Dashboard Completion
- [ ] Fetch sessions from `GET /api/sessions`
- [ ] Display sessions in SessionList component
- [ ] Show session date, duration, topic
- [ ] Make sessions clickable to view full transcript
- [ ] Add loading skeleton while fetching
- [ ] Test pagination if needed

#### Hour 20-22: Final Polish
- [ ] Add favicon and metadata
- [ ] Improve loading states across app
- [ ] Add error boundaries
- [ ] Test all flows end-to-end
- [ ] Fix responsive issues
- [ ] Add micro-interactions (hover states, animations)
- [ ] Optimize performance (lazy loading, memoization)

#### Hour 22-24: Deployment & Demo Prep
- [ ] Deploy to Vercel: `vercel --prod`
- [ ] Test production build locally: `npm run build && npm start`
- [ ] Verify all env vars in Vercel dashboard
- [ ] Test deployed site on mobile
- [ ] Create demo account
- [ ] Record backup demo video
- [ ] Practice demo 3 times

**Deliverable:** Production-ready app deployed on Vercel

---

## Backend Developer (@backend-dev)

### Hour 0-8: Database Setup ⏰ 8 hours

#### Hour 0-2: Supabase Setup
- [ ] Create Supabase account
- [ ] Create new project
- [ ] Copy connection details and API keys
- [ ] Add to `.env.local` (share with team)
- [ ] Test connection from Next.js
- [ ] Setup database helper file (`src/lib/supabase.ts`)

#### Hour 2-5: Schema Implementation
- [ ] Open Supabase SQL Editor
- [ ] Run schema from `supabase-schema.sql`:
  - [ ] Create `users` table
  - [ ] Create `sessions` table
  - [ ] Create `transcripts` table
  - [ ] Add indexes
- [ ] Enable Row Level Security (RLS)
- [ ] Create RLS policies for each table
- [ ] Test RLS with sample data

#### Hour 5-7: TypeScript Types & Helpers
- [ ] Create TypeScript interfaces (`src/types/index.ts`)
- [ ] Create database helper functions:
  - [ ] `getUserByClerkId()`
  - [ ] `createUser()`
  - [ ] `createSession()`
  - [ ] `endSession()`
  - [ ] `saveTranscript()`
  - [ ] `getUserSessions()`
- [ ] Test each helper function

#### Hour 7-8: Clerk Webhook
- [ ] Setup Clerk webhook endpoint (`src/app/api/webhooks/clerk/route.ts`)
- [ ] Handle `user.created` event
- [ ] Create user in Supabase when Clerk user created
- [ ] Test webhook with Clerk dashboard
- [ ] Verify webhook signature

**Deliverable:** Database schema + helper functions working

---

### Hour 8-16: API Routes ⏰ 8 hours

#### Hour 8-10: Sessions API
- [ ] Create `src/app/api/sessions/route.ts`
- [ ] Implement `POST /api/sessions` (create session)
  - [ ] Get user from Clerk auth
  - [ ] Create session in Supabase
  - [ ] Return session ID
- [ ] Implement `GET /api/sessions` (list user's sessions)
  - [ ] Get user sessions from Supabase
  - [ ] Include transcripts in response
- [ ] Test with Postman/curl

#### Hour 10-12: Session Management
- [ ] Create `src/app/api/sessions/[id]/route.ts`
- [ ] Implement `PATCH /api/sessions/[id]` (end session)
  - [ ] Calculate duration
  - [ ] Set `ended_at` timestamp
  - [ ] Extract topic from first user message
- [ ] Add error handling
- [ ] Test edge cases (invalid ID, unauthorized)

#### Hour 12-14: Transcripts API
- [ ] Create `src/app/api/transcripts/route.ts`
- [ ] Implement `POST /api/transcripts` (save transcript)
  - [ ] Validate session exists and belongs to user
  - [ ] Save speaker + message
  - [ ] Return saved transcript
- [ ] Implement batch save (array of messages)
- [ ] Add validation (max message length, speaker validation)
- [ ] Test with sample data

#### Hour 14-16: Testing & Documentation
- [ ] Test all endpoints with Postman
- [ ] Create API documentation file
- [ ] Add request/response examples
- [ ] Test error cases
- [ ] Add rate limiting (if time permits)
- [ ] Test concurrent requests

**Deliverable:** All API endpoints working and tested

---

### Hour 16-24: Monitoring & Optimization ⏰ 8 hours

#### Hour 16-18: Sentry Setup
- [ ] Create Sentry account
- [ ] Install Sentry SDK: `npm install @sentry/nextjs`
- [ ] Run Sentry wizard: `npx @sentry/wizard@latest -i nextjs`
- [ ] Add Sentry to API routes
- [ ] Test error reporting
- [ ] Setup alerts for critical errors

#### Hour 18-20: Optimization
- [ ] Add logging to all API routes
- [ ] Optimize database queries (use select only needed fields)
- [ ] Add database query caching
- [ ] Test query performance with large datasets
- [ ] Add request validation middleware
- [ ] Implement API rate limiting

#### Hour 20-22: Load Testing & Fixes
- [ ] Create test script with 100 sessions
- [ ] Insert sample data
- [ ] Test API performance under load
- [ ] Fix any bottlenecks
- [ ] Optimize slow queries
- [ ] Add database indexes if needed

#### Hour 22-24: Final Prep
- [ ] Review all API endpoints
- [ ] Document any known issues
- [ ] Create demo data for demo account
- [ ] Verify all environment variables are set
- [ ] Test production deployment
- [ ] Be ready to debug during demo

**Deliverable:** Production-ready backend with monitoring

---

## API/AI Developer (@ai-dev)

### Hour 0-8: Vapi Configuration ⏰ 8 hours

#### Hour 0-2: Vapi Account Setup
- [ ] Create account at vapi.ai
- [ ] Get API keys (public + private)
- [ ] Share keys with team for `.env.local`
- [ ] Explore Vapi dashboard
- [ ] Read Vapi documentation
- [ ] Test Vapi playground

#### Hour 2-5: AI Assistant Creation
- [ ] Create AI assistant in Vapi dashboard
- [ ] Configure LLM settings:
  - [ ] Model: GPT-4 (or GPT-3.5-turbo for cost)
  - [ ] Temperature: 0.7
  - [ ] Max tokens: 150
- [ ] Add system prompt from `AI_SYSTEM_PROMPT.md`
- [ ] Configure voice settings:
  - [ ] Provider: ElevenLabs
  - [ ] Voice: rachel (or similar friendly voice)
  - [ ] Stability: 0.5
  - [ ] Similarity boost: 0.75
- [ ] Set first message: "Hello! I'm your AI tutor..."
- [ ] Enable recording: true

#### Hour 5-7: Test & Tune
- [ ] Test assistant in Vapi playground
- [ ] Try demo questions:
  - [ ] "Explain blockchain like I'm 10"
  - [ ] "How does photosynthesis work?"
  - [ ] "What is gravity?"
- [ ] Tune prompt for better responses
- [ ] Adjust temperature/tokens if needed
- [ ] Test response quality and latency
- [ ] Ensure African examples are being used

#### Hour 7-8: Documentation
- [ ] Document assistant configuration
- [ ] Write integration guide for frontend
- [ ] Create troubleshooting guide
- [ ] Share Vapi assistant ID with frontend dev

**Deliverable:** Configured AI assistant with tuned prompts

---

### Hour 8-16: Integration & Optimization ⏰ 8 hours

#### Hour 8-10: Server-Side Integration
- [ ] Create Vapi server SDK helper (`src/lib/vapi.ts`)
- [ ] Install Vapi SDK: `npm install @vapi-ai/web`
- [ ] Create function to generate Vapi token
- [ ] Create API route: `src/app/api/vapi/token/route.ts`
- [ ] Test token generation
- [ ] Test token works with frontend

#### Hour 10-12: Advanced Configuration
- [ ] Implement dynamic assistant creation per session
- [ ] Add context from user profile to prompts
- [ ] Configure function calling (if needed)
- [ ] Add conversation history management
- [ ] Test multi-turn conversations
- [ ] Ensure AI remembers context within session

#### Hour 12-14: Voice Optimization
- [ ] Test different voice providers (ElevenLabs, Azure, Play.ht)
- [ ] Compare latency across providers
- [ ] Test different voices for clarity
- [ ] Optimize for fastest response time
- [ ] Test on slow network connection
- [ ] Add fallback providers if primary fails

#### Hour 14-16: Testing & QA
- [ ] Test 20+ different questions
- [ ] Verify African examples are used
- [ ] Test edge cases:
  - [ ] Very long questions
  - [ ] Unclear speech
  - [ ] Background noise
  - [ ] Multiple languages
- [ ] Measure response quality
- [ ] Tune system prompt based on results

**Deliverable:** Production-ready voice AI integration

---

### Hour 16-24: Polish & Demo Prep ⏰ 8 hours

#### Hour 16-18: Prompt Engineering
- [ ] Refine system prompt based on testing
- [ ] Add more African context examples
- [ ] Improve response conciseness
- [ ] Test tone (friendly, encouraging, patient)
- [ ] Add handling for off-topic questions
- [ ] Add safety guardrails

#### Hour 18-20: Error Handling
- [ ] Add fallback responses for API failures
- [ ] Handle network timeouts gracefully
- [ ] Add retry logic for transient errors
- [ ] Test degraded performance scenarios
- [ ] Add error logging
- [ ] Create user-friendly error messages

#### Hour 20-22: Demo Preparation
- [ ] Test demo flow 10+ times
- [ ] Prepare demo questions (3-5 options)
- [ ] Record backup demo audio
- [ ] Create demo account with sample sessions
- [ ] Pre-warm AI assistant (ensure fast first response)
- [ ] Test on presentation laptop/setup

#### Hour 22-24: Final Checks
- [ ] Review all AI responses for quality
- [ ] Test voice clarity on different devices
- [ ] Verify latency is acceptable (<2s)
- [ ] Final prompt tuning
- [ ] Practice demo with team
- [ ] Be ready for live demo

**Deliverable:** Polished AI experience + demo ready

---

## Team Coordination

### Sync Points
- **Hour 4**: Quick team sync (15 min) - Share progress, unblock issues
- **Hour 8**: First integration point - Frontend + Backend test connection
- **Hour 12**: Second sync (15 min) - Voice working end-to-end?
- **Hour 16**: Third sync (30 min) - Full integration testing
- **Hour 20**: Final sync (15 min) - Deployment check, demo prep
- **Hour 22**: Demo rehearsal (30 min) - Practice full demo

### Communication
- Use Slack/Discord for quick questions
- Share env vars in password manager
- Use GitHub for code (or single shared repo)
- Document blockers immediately
- Help each other if someone is stuck >30 min

### Emergency Pivots
If something breaks beyond repair:
- **Frontend:** Use static mock data instead of API
- **Backend:** Use localStorage instead of Supabase
- **AI/Voice:** Pre-record demo audio, simulate real-time

---

## Success Criteria

By end of 24 hours, we must have:
- ✅ Working authentication (Clerk)
- ✅ Voice conversation works (Vapi)
- ✅ Transcripts save (Supabase)
- ✅ Dashboard shows sessions
- ✅ Deployed to production (Vercel)
- ✅ Demo ready (tested 5+ times)

Nice-to-haves (cut if time runs out):
- Session topics auto-extraction
- Advanced error handling
- Analytics/metrics
- Dark mode
- Multiple subjects

---

## Tips for Success

1. **Start simple** - Get basic version working first
2. **Test early** - Don't wait until hour 23 to integrate
3. **Ask for help** - If stuck >30 min, flag it
4. **Cut features** - Better to have 3 things working than 10 half-done
5. **Document as you go** - Future you will thank present you
6. **Take breaks** - 5 min break every 2 hours
7. **Have fun** - This is a hackathon, enjoy it!

Good luck team! We've got this! 🚀
