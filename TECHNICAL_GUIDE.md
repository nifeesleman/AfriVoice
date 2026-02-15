# AfriVoice - Technical Implementation Guide

## Quick Setup (Do This First)

### 1. Create Accounts
- [ ] Clerk: https://clerk.com (Authentication)
- [ ] Supabase: https://supabase.com (Database)
- [ ] Vapi: https://vapi.ai (Voice AI)
- [ ] Vercel: https://vercel.com (Deployment)
- [ ] Sentry: https://sentry.io (Error tracking - optional)

### 2. Initialize Next.js Project

```bash
# Create Next.js app
npx create-next-app@latest afrivoice --typescript --tailwind --app --src-dir --import-alias "@/*"

cd afrivoice

# Install core dependencies
npm install @clerk/nextjs @supabase/supabase-js @vapi-ai/web

# Install UI dependencies
npm install @radix-ui/react-slot class-variance-authority clsx tailwind-merge lucide-react

# Install dev dependencies
npm install -D @types/node @types/react @types/react-dom
```

### 3. Setup Environment Variables

Create `.env.local`:

```bash
# Clerk (from https://dashboard.clerk.com)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard

# Supabase (from https://app.supabase.com)
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...

# Vapi (from https://dashboard.vapi.ai)
NEXT_PUBLIC_VAPI_PUBLIC_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
VAPI_PRIVATE_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Sentry (optional)
NEXT_PUBLIC_SENTRY_DSN=https://xxx@sentry.io/xxx
```

---

## Project Structure

```
afrivoice/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── sign-in/[[...sign-in]]/page.tsx
│   │   │   └── sign-up/[[...sign-up]]/page.tsx
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── voice-tutor/
│   │   │   └── page.tsx
│   │   ├── api/
│   │   │   ├── sessions/
│   │   │   │   ├── route.ts          # GET list, POST create
│   │   │   │   └── [id]/
│   │   │   │       └── route.ts      # PATCH end session
│   │   │   ├── transcripts/
│   │   │   │   └── route.ts          # POST save transcript
│   │   │   └── vapi/
│   │   │       └── token/route.ts    # GET Vapi auth token
│   │   ├── layout.tsx
│   │   └── page.tsx                  # Landing page
│   ├── components/
│   │   ├── ui/                       # shadcn components
│   │   ├── voice-tutor.tsx
│   │   ├── session-list.tsx
│   │   └── transcript-viewer.tsx
│   ├── lib/
│   │   ├── supabase.ts               # Supabase client
│   │   ├── clerk.ts                  # Clerk helpers
│   │   └── utils.ts                  # Utilities
│   └── types/
│       └── index.ts                  # TypeScript types
├── public/
├── .env.local
├── next.config.js
├── tailwind.config.js
└── package.json
```

---

## Code Snippets

### Supabase Client (`src/lib/supabase.ts`)

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Server-side client with service role (for API routes)
export const supabaseAdmin = createClient(
  supabaseUrl,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)
```

### TypeScript Types (`src/types/index.ts`)

```typescript
export interface User {
  id: string
  clerk_id: string
  email: string
  full_name: string | null
  created_at: string
}

export interface Session {
  id: string
  user_id: string
  started_at: string
  ended_at: string | null
  duration_seconds: number | null
  topic: string | null
  created_at: string
}

export interface Transcript {
  id: string
  session_id: string
  speaker: 'user' | 'ai'
  message: string
  timestamp: string
}

export interface SessionWithTranscripts extends Session {
  transcripts: Transcript[]
}
```

### Voice Tutor Component (`src/components/voice-tutor.tsx`)

```typescript
'use client'

import { useState, useEffect } from 'react'
import Vapi from '@vapi-ai/web'
import { Button } from '@/components/ui/button'
import { Mic, MicOff } from 'lucide-react'

const vapi = new Vapi(process.env.NEXT_PUBLIC_VAPI_PUBLIC_KEY!)

export default function VoiceTutor() {
  const [isSessionActive, setIsSessionActive] = useState(false)
  const [transcripts, setTranscripts] = useState<Array<{speaker: string, message: string}>>([])

  useEffect(() => {
    // Listen to Vapi events
    vapi.on('message', (message) => {
      if (message.type === 'transcript') {
        setTranscripts(prev => [...prev, {
          speaker: message.role,
          message: message.transcript
        }])
      }
    })

    vapi.on('call-end', () => {
      setIsSessionActive(false)
    })

    return () => {
      vapi.stop()
    }
  }, [])

  const startSession = async () => {
    try {
      await vapi.start({
        model: {
          provider: 'openai',
          model: 'gpt-4',
          messages: [{
            role: 'system',
            content: 'You are an enthusiastic AI tutor...' // Use AI_SYSTEM_PROMPT.md
          }]
        },
        voice: {
          provider: '11labs',
          voiceId: 'rachel'
        }
      })
      setIsSessionActive(true)
    } catch (error) {
      console.error('Failed to start session:', error)
    }
  }

  const stopSession = () => {
    vapi.stop()
    setIsSessionActive(false)
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-4">
      <div className="w-full max-w-2xl">
        <h1 className="text-4xl font-bold text-center mb-8">Voice Tutor</h1>
        
        <div className="flex justify-center mb-8">
          {!isSessionActive ? (
            <Button
              onClick={startSession}
              size="lg"
              className="h-32 w-32 rounded-full"
            >
              <Mic className="h-12 w-12" />
            </Button>
          ) : (
            <Button
              onClick={stopSession}
              size="lg"
              variant="destructive"
              className="h-32 w-32 rounded-full animate-pulse"
            >
              <MicOff className="h-12 w-12" />
            </Button>
          )}
        </div>

        <div className="bg-white rounded-lg shadow p-6 max-h-96 overflow-y-auto">
          {transcripts.length === 0 ? (
            <p className="text-center text-gray-500">
              Click the microphone to start learning
            </p>
          ) : (
            transcripts.map((t, i) => (
              <div key={i} className={`mb-4 ${t.speaker === 'user' ? 'text-right' : 'text-left'}`}>
                <div className={`inline-block p-3 rounded-lg ${
                  t.speaker === 'user' ? 'bg-blue-500 text-white' : 'bg-gray-200'
                }`}>
                  <p className="text-sm font-semibold mb-1">
                    {t.speaker === 'user' ? 'You' : 'AI Tutor'}
                  </p>
                  <p>{t.message}</p>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  )
}
```

### API Route - Create Session (`src/app/api/sessions/route.ts`)

```typescript
import { NextResponse } from 'next/server'
import { auth } from '@clerk/nextjs'
import { supabaseAdmin } from '@/lib/supabase'

export async function POST() {
  try {
    const { userId } = auth()
    if (!userId) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    // Get user from database
    const { data: user } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('clerk_id', userId)
      .single()

    if (!user) {
      return NextResponse.json({ error: 'User not found' }, { status: 404 })
    }

    // Create new session
    const { data: session, error } = await supabaseAdmin
      .from('sessions')
      .insert({
        user_id: user.id,
        started_at: new Date().toISOString()
      })
      .select()
      .single()

    if (error) throw error

    return NextResponse.json(session)
  } catch (error) {
    console.error('Error creating session:', error)
    return NextResponse.json(
      { error: 'Failed to create session' },
      { status: 500 }
    )
  }
}

export async function GET() {
  try {
    const { userId } = auth()
    if (!userId) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const { data: user } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('clerk_id', userId)
      .single()

    if (!user) {
      return NextResponse.json({ error: 'User not found' }, { status: 404 })
    }

    const { data: sessions, error } = await supabaseAdmin
      .from('sessions')
      .select('*, transcripts(*)')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })

    if (error) throw error

    return NextResponse.json(sessions)
  } catch (error) {
    console.error('Error fetching sessions:', error)
    return NextResponse.json(
      { error: 'Failed to fetch sessions' },
      { status: 500 }
    )
  }
}
```

---

## Deployment Checklist

### Vercel Deployment

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

### Environment Variables in Vercel
1. Go to Vercel dashboard → Settings → Environment Variables
2. Add all variables from `.env.local`
3. Redeploy

---

## Testing Checklist

- [ ] User can sign up with email
- [ ] User can log in
- [ ] Dashboard shows "Start Voice Tutor" button
- [ ] Clicking button activates microphone
- [ ] Speaking generates transcript
- [ ] AI responds with voice
- [ ] Transcript displays in real-time
- [ ] Session saves to database
- [ ] Past sessions appear on dashboard
- [ ] Works on mobile device
- [ ] Audio quality is clear
- [ ] Response latency < 2 seconds

---

## Common Issues & Solutions

### Issue: Vapi not connecting
**Solution:** Check API key is correct and starts with correct prefix

### Issue: Supabase RLS blocking queries
**Solution:** Make sure Clerk JWT is being passed correctly

### Issue: No audio output
**Solution:** Check browser permissions for microphone/audio

### Issue: Deploy fails
**Solution:** Check all environment variables are set in Vercel

---

## Performance Optimization

1. **Lazy load Vapi SDK**
```typescript
import dynamic from 'next/dynamic'
const VoiceTutor = dynamic(() => import('@/components/voice-tutor'), { ssr: false })
```

2. **Optimize database queries**
- Use indexes
- Limit results with pagination
- Only fetch needed fields

3. **Cache static data**
```typescript
export const revalidate = 3600 // 1 hour
```

---

## Security Best Practices

1. ✅ Always validate user authentication in API routes
2. ✅ Use Supabase RLS for data isolation
3. ✅ Never expose service role keys to client
4. ✅ Sanitize user inputs
5. ✅ Use HTTPS only (automatic on Vercel)
6. ✅ Rate limit API endpoints
7. ✅ Log security events to Sentry

---

## Resources

- **Next.js Docs**: https://nextjs.org/docs
- **Clerk Docs**: https://clerk.com/docs
- **Supabase Docs**: https://supabase.com/docs
- **Vapi Docs**: https://docs.vapi.ai
- **Tailwind Docs**: https://tailwindcss.com/docs
- **shadcn/ui**: https://ui.shadcn.com

---

## Support During Hackathon

If stuck:
1. Check documentation (links above)
2. Search error message on Google
3. Ask in team chat
4. Pivot to next task if blocked >30 minutes

Good luck! 🚀
