# AfriVoice System Architecture

## High-Level Architecture

```
                                   USERS
                                     │
                                     │ HTTPS
                                     ▼
                            ┌────────────────────┐
                            │   Vercel (CDN)     │
                            │  Next.js Frontend  │
                            └────────┬───────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
            ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
            │    Clerk     │ │   Supabase   │ │     Vapi     │
            │    (Auth)    │ │     (DB)     │ │   (Voice)    │
            └──────────────┘ └──────────────┘ └──────┬───────┘
                                                      │
                                                      ▼
                                              ┌──────────────┐
                                              │   OpenAI     │
                                              │   GPT-4      │
                                              └──────────────┘
```

---

## Detailed Component Breakdown

### 1. Frontend Layer (Next.js 14)

```
┌─────────────────────────────────────────────────────────────┐
│                     Next.js App Router                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Landing     │  │   Sign In    │  │   Sign Up    │      │
│  │  Page (/)    │  │  /sign-in    │  │  /sign-up    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                              │
│  ┌──────────────┐  ┌──────────────────────────────────┐    │
│  │  Dashboard   │  │      Voice Tutor Page            │    │
│  │  /dashboard  │  │      /voice-tutor                 │    │
│  │              │  │                                   │    │
│  │ - Sessions   │  │  ┌─────────────────────────┐     │    │
│  │   List       │  │  │  Vapi Voice Component   │     │    │
│  │              │  │  │  - Mic Control          │     │    │
│  │ - Start      │  │  │  - Transcript Display   │     │    │
│  │   Button     │  │  │  - Session Management   │     │    │
│  │              │  │  └─────────────────────────┘     │    │
│  └──────────────┘  └──────────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Key Technologies:**
- React Server Components (RSC)
- Client Components for interactivity
- Tailwind CSS for styling
- shadcn/ui for UI components

---

### 2. API Layer (Next.js API Routes)

```
┌─────────────────────────────────────────────────────────────┐
│                    API Routes (/api/...)                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Sessions Management                                         │
│  ┌────────────────────────────────────────────┐             │
│  │ POST   /api/sessions         → Create      │             │
│  │ GET    /api/sessions         → List        │             │
│  │ PATCH  /api/sessions/[id]    → End         │             │
│  └────────────────────────────────────────────┘             │
│                                                              │
│  Transcripts Storage                                         │
│  ┌────────────────────────────────────────────┐             │
│  │ POST   /api/transcripts      → Save        │             │
│  │ GET    /api/transcripts/[id] → Retrieve    │             │
│  └────────────────────────────────────────────┘             │
│                                                              │
│  Authentication & Voice                                      │
│  ┌────────────────────────────────────────────┐             │
│  │ POST   /api/webhooks/clerk   → User Sync   │             │
│  │ GET    /api/vapi/token       → Auth Token  │             │
│  └────────────────────────────────────────────┘             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Authentication Flow:**
```
Request → Clerk Middleware → Check Auth → API Handler → Response
```

---

### 3. Authentication (Clerk)

```
┌─────────────────────────────────────────────────────────────┐
│                      Clerk Service                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  User Management                                             │
│  ┌──────────────────────────────────────┐                   │
│  │  - Sign Up / Sign In                 │                   │
│  │  - Session Management                │                   │
│  │  - JWT Token Generation              │                   │
│  │  - OAuth Providers (Google, etc.)    │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  Webhooks                                                    │
│  ┌──────────────────────────────────────┐                   │
│  │  user.created  → Sync to Supabase    │                   │
│  │  user.updated  → Update Supabase     │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**JWT Payload:**
```json
{
  "sub": "user_xxxxx",
  "email": "student@example.com",
  "email_verified": true,
  "exp": 1234567890
}
```

---

### 4. Database (Supabase)

```
┌─────────────────────────────────────────────────────────────┐
│                    Supabase PostgreSQL                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Tables                                                      │
│  ┌──────────────────────────────────────┐                   │
│  │  users                               │                   │
│  │  ├─ id                   (UUID, PK)  │                   │
│  │  ├─ clerk_id             (TEXT)      │                   │
│  │  ├─ email                (TEXT)      │                   │
│  │  └─ full_name            (TEXT)      │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  ┌──────────────────────────────────────┐                   │
│  │  sessions                            │                   │
│  │  ├─ id                   (UUID, PK)  │                   │
│  │  ├─ user_id              (UUID, FK)  │                   │
│  │  ├─ started_at           (TIMESTAMP) │                   │
│  │  ├─ ended_at             (TIMESTAMP) │                   │
│  │  ├─ duration_seconds     (INTEGER)   │                   │
│  │  └─ topic                (TEXT)      │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  ┌──────────────────────────────────────┐                   │
│  │  transcripts                         │                   │
│  │  ├─ id                   (UUID, PK)  │                   │
│  │  ├─ session_id           (UUID, FK)  │                   │
│  │  ├─ speaker              (TEXT)      │                   │
│  │  ├─ message              (TEXT)      │                   │
│  │  └─ timestamp            (TIMESTAMP) │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  Row Level Security (RLS)                                    │
│  ┌──────────────────────────────────────┐                   │
│  │  Users can only access their own:    │                   │
│  │  - user records                       │                   │
│  │  - sessions                           │                   │
│  │  - transcripts                        │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

### 5. Voice AI (Vapi)

```
┌─────────────────────────────────────────────────────────────┐
│                        Vapi Platform                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Voice Pipeline                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                                                       │   │
│  │  User Voice → STT → LLM → TTS → User Audio           │   │
│  │                ↓      ↓     ↓                         │   │
│  │            Deepgram  GPT-4  ElevenLabs                │   │
│  │                                                       │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  Configuration                                               │
│  ┌──────────────────────────────────────┐                   │
│  │  Model: GPT-4                        │                   │
│  │  Temperature: 0.7                    │                   │
│  │  Max Tokens: 150                     │                   │
│  │  Voice: rachel (ElevenLabs)          │                   │
│  │  Stability: 0.5                      │                   │
│  │  System Prompt: [AI_SYSTEM_PROMPT]  │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
│  Real-time Events                                            │
│  ┌──────────────────────────────────────┐                   │
│  │  - call.started                      │                   │
│  │  - transcript.update                 │                   │
│  │  - message.received                  │                   │
│  │  - call.ended                        │                   │
│  └──────────────────────────────────────┘                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagrams

### 1. User Authentication Flow

```
┌──────────┐
│  User    │
└────┬─────┘
     │
     │ 1. Click "Sign Up"
     ▼
┌──────────────┐
│  Next.js App │
└────┬─────────┘
     │
     │ 2. Redirect to Clerk
     ▼
┌──────────────┐
│    Clerk     │
└────┬─────────┘
     │
     │ 3. User enters credentials
     │ 4. Clerk validates
     │
     │ 5. Webhook: user.created
     ▼
┌──────────────┐
│ Next.js API  │
│ /api/webhooks│
│   /clerk     │
└────┬─────────┘
     │
     │ 6. Create user in Supabase
     ▼
┌──────────────┐
│  Supabase DB │
└────┬─────────┘
     │
     │ 7. Return JWT token
     ▼
┌──────────────┐
│    User      │
│ (Logged In)  │
└──────────────┘
```

---

### 2. Voice Session Flow

```
┌──────────┐
│  User    │
└────┬─────┘
     │
     │ 1. Click "Start Voice Tutor"
     ▼
┌──────────────────┐
│  Voice Component │
└────┬─────────────┘
     │
     │ 2. POST /api/sessions (create)
     ▼
┌──────────────┐
│  Supabase DB │────────┐
└──────────────┘        │ 3. Return session_id
                        ▼
                ┌──────────────────┐
                │  Voice Component │
                └────┬─────────────┘
                     │
                     │ 4. Initialize Vapi
                     ▼
                ┌──────────────┐
                │     Vapi     │
                └────┬─────────┘
                     │
                     │ 5. User speaks
                     │ 6. Vapi transcribes (STT)
                     ▼
                ┌──────────────┐
                │   OpenAI     │
                │   GPT-4      │
                └────┬─────────┘
                     │
                     │ 7. Generate response
                     ▼
                ┌──────────────┐
                │  ElevenLabs  │
                │    (TTS)     │
                └────┬─────────┘
                     │
                     │ 8. Audio response
                     ▼
                ┌──────────────────┐
                │  Voice Component │────────┐
                └──────────────────┘        │
                                            │ 9. Display transcript
                                            │ 10. Save to DB
                                            ▼
                                    ┌──────────────┐
                                    │  Supabase DB │
                                    │ (transcripts)│
                                    └──────────────┘
```

---

### 3. Session Review Flow

```
┌──────────┐
│  User    │
└────┬─────┘
     │
     │ 1. Navigate to /dashboard
     ▼
┌──────────────────┐
│  Dashboard Page  │
└────┬─────────────┘
     │
     │ 2. GET /api/sessions
     ▼
┌──────────────┐
│  Next.js API │
└────┬─────────┘
     │
     │ 3. Query user's sessions
     ▼
┌──────────────┐
│  Supabase DB │
└────┬─────────┘
     │
     │ 4. Return sessions + transcripts
     ▼
┌──────────────────┐
│  Dashboard Page  │
│                  │
│  Session List:   │
│  ┌────────────┐  │
│  │ Session 1  │  │
│  │ - Topic    │  │
│  │ - Duration │  │
│  │ - Date     │  │
│  └────────────┘  │
│                  │
│  Click to view → │
│  ┌────────────┐  │
│  │ Transcript │  │
│  │ User: ...  │  │
│  │ AI: ...    │  │
│  └────────────┘  │
└──────────────────┘
```

---

## Security Architecture

### 1. Authentication & Authorization

```
┌─────────────────────────────────────────┐
│           Request Flow                  │
├─────────────────────────────────────────┤
│                                         │
│  Client Request                         │
│       ↓                                 │
│  Clerk Middleware                       │
│   - Verify JWT                          │
│   - Check session validity              │
│   - Attach user context                 │
│       ↓                                 │
│  API Route Handler                      │
│   - Extract user ID                     │
│   - Validate permissions                │
│       ↓                                 │
│  Supabase Query                         │
│   - RLS enforces data isolation         │
│   - Only user's own data accessible     │
│       ↓                                 │
│  Response                               │
│                                         │
└─────────────────────────────────────────┘
```

### 2. Data Security

**Encryption in Transit:**
- All API calls over HTTPS
- TLS 1.3 encryption
- Secure WebSocket for Vapi

**Encryption at Rest:**
- Supabase encrypts all data at rest
- Database backups encrypted

**RLS Policies:**
```sql
-- Example: Users can only read their own sessions
CREATE POLICY "Users view own sessions"
  ON sessions FOR SELECT
  USING (user_id IN (
    SELECT id FROM users 
    WHERE clerk_id = auth.jwt() ->> 'sub'
  ));
```

---

## Scalability Architecture

### Horizontal Scaling

```
                    ┌────────────┐
                    │   Vercel   │
                    │ Edge Network│
                    └──────┬─────┘
                           │
                    Load Balancing
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Region 1   │   │   Region 2   │   │   Region 3   │
│   (Americas) │   │    (Europe)  │   │    (Asia)    │
└──────────────┘   └──────────────┘   └──────────────┘
```

**Auto-scaling:**
- Vercel: Automatic based on traffic
- Supabase: Connection pooling (PgBouncer)
- Vapi: Managed infrastructure

---

## Performance Optimization

### 1. Frontend
- **Code Splitting**: Automatic with Next.js
- **Image Optimization**: Next.js Image component
- **Lazy Loading**: Dynamic imports for heavy components
- **Caching**: Static page generation where possible

### 2. API
- **Database Indexing**: On frequently queried columns
- **Connection Pooling**: Supabase PgBouncer
- **Response Caching**: Stale-while-revalidate strategy
- **Query Optimization**: Select only needed fields

### 3. Voice
- **Audio Compression**: Optimized codec
- **Streaming**: Real-time audio streaming
- **CDN Delivery**: Voice assets via CDN
- **Low Latency**: WebSocket for real-time communication

---

## Monitoring & Observability

```
┌─────────────────────────────────────────────────────────┐
│                    Monitoring Stack                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │    Sentry    │  │    Vercel    │  │   Supabase   │  │
│  │              │  │   Analytics  │  │   Insights   │  │
│  │ - Errors     │  │              │  │              │  │
│  │ - Performance│  │ - Page views │  │ - DB queries │  │
│  │ - Alerts     │  │ - Load times │  │ - Slow logs  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Key Metrics:**
- Response time (API routes)
- Voice latency (Vapi)
- Error rates
- User engagement
- Database performance

---

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│            GitHub Repository             │
└────────────────┬────────────────────────┘
                 │
                 │ Git push
                 ▼
┌─────────────────────────────────────────┐
│         Vercel CI/CD Pipeline            │
│                                          │
│  1. Build Next.js app                    │
│  2. Run TypeScript checks                │
│  3. Bundle optimization                  │
│  4. Deploy to Edge Network               │
│                                          │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│          Production Environment          │
│                                          │
│  - Automatic HTTPS                       │
│  - Global CDN                            │
│  - DDoS protection                       │
│  - Auto-scaling                          │
│                                          │
└─────────────────────────────────────────┘
```

---

## Disaster Recovery

### Backup Strategy
- **Database**: Automatic daily backups (Supabase)
- **Code**: Version control (GitHub)
- **Secrets**: Encrypted vault (Vercel)

### Recovery Time Objectives (RTO)
- Frontend: < 5 minutes (redeploy)
- Database: < 15 minutes (restore from backup)
- Full system: < 30 minutes

---

## Technology Decisions

| Decision | Rationale |
|----------|-----------|
| **Next.js** | Full-stack framework, excellent DX, Vercel integration |
| **Clerk** | Managed auth, webhooks, easy setup (vs. custom auth) |
| **Supabase** | PostgreSQL + RLS + real-time (vs. Firebase, MongoDB) |
| **Vapi** | All-in-one voice AI (vs. building custom STT+LLM+TTS) |
| **Vercel** | Best Next.js hosting, automatic scaling |
| **TypeScript** | Type safety, better DX, fewer bugs |

---

This architecture is designed to be:
- ✅ **Simple**: Easy to understand and maintain
- ✅ **Scalable**: Can handle millions of users
- ✅ **Secure**: Multiple layers of security
- ✅ **Fast**: Optimized for low latency
- ✅ **Reliable**: Built on proven platforms
