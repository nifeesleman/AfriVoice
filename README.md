# AfriVoice 🎓🎤

**A voice-first AI tutor for students in Africa. No typing. Just talk and learn.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Next.js](https://img.shields.io/badge/Next.js-14-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue)](https://www.typescriptlang.org/)

---

## 🌍 The Problem

Over 60% of African students struggle with traditional textbook learning:
- 📚 Textbooks are expensive
- 🐌 Internet is too slow for video learning
- 📖 Millions have low literacy rates
- ⌨️ Typing on mobile is difficult

**But everyone can talk and listen.**

---

## 💡 The Solution

AfriVoice is a **voice-first AI education platform** that makes learning accessible through natural conversation.

- 🎤 **Voice Interface**: Just talk to learn - no typing, no reading
- 🤖 **AI Tutor**: Get instant answers to any question
- 🌍 **African Context**: Uses examples students actually understand
- 📱 **Mobile-First**: Works on cheap phones with slow internet
- 💾 **Saves Progress**: Review transcripts of every learning session

---

## ✨ Features

### MVP (24-Hour Hackathon Build)
- ✅ User authentication (Clerk)
- ✅ Voice conversations with AI tutor (Vapi)
- ✅ Real-time transcript display
- ✅ Save and review past sessions (Supabase)
- ✅ Mobile-responsive design (Tailwind + shadcn/ui)

### Roadmap
- [ ] Subject categories (Math, Science, History, etc.)
- [ ] Progress tracking and achievements
- [ ] WhatsApp integration
- [ ] Local language support (Swahili, French, etc.)
- [ ] Teacher dashboard
- [ ] Offline mode

---

## 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Next.js 14** | Frontend + API routes (App Router) |
| **TypeScript** | Type safety |
| **Clerk** | Authentication |
| **Supabase** | PostgreSQL database |
| **Vapi** | Voice AI (STT + LLM + TTS) |
| **Tailwind CSS** | Styling |
| **shadcn/ui** | UI components |
| **Sentry** | Error tracking |
| **Vercel** | Deployment |

---

## 📁 Project Documentation

This repository includes comprehensive guides for the 24-hour hackathon:

| Document | Description |
|----------|-------------|
| **[HACKATHON_PLAN.md](./HACKATHON_PLAN.md)** | Complete execution plan including MVP features, architecture, and strategy |
| **[TECHNICAL_GUIDE.md](./TECHNICAL_GUIDE.md)** | Setup instructions, code snippets, and implementation details |
| **[TASK_BREAKDOWN.md](./TASK_BREAKDOWN.md)** | Hour-by-hour tasks for each of the 3 developers |
| **[DEMO_SCRIPT.md](./DEMO_SCRIPT.md)** | 2-minute demo script and presentation guide |
| **[AI_SYSTEM_PROMPT.md](./AI_SYSTEM_PROMPT.md)** | AI tutor personality and teaching style |
| **[supabase-schema.sql](./supabase-schema.sql)** | Database schema with RLS policies |

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- npm or yarn
- Accounts: Clerk, Supabase, Vapi, Vercel

### Installation

```bash
# Clone the repository
git clone https://github.com/nifeesleman/AfriVoice.git
cd AfriVoice

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env.local
# Edit .env.local with your API keys

# Run development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Environment Variables

```bash
# Clerk
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Vapi
NEXT_PUBLIC_VAPI_PUBLIC_KEY=xxx
VAPI_PRIVATE_KEY=xxx

# Sentry (optional)
NEXT_PUBLIC_SENTRY_DSN=https://xxx@sentry.io/xxx
```

See **[TECHNICAL_GUIDE.md](./TECHNICAL_GUIDE.md)** for detailed setup instructions.

---

## 🎯 How It Works

1. **Sign Up/Login** → User authenticates via Clerk
2. **Start Voice Tutor** → Initialize Vapi voice session
3. **Talk to AI** → User asks question by voice
4. **AI Responds** → AI answers using African examples
5. **Save Transcript** → Conversation saved to Supabase
6. **Review Sessions** → View past learning on dashboard

```
┌─────────────┐
│   Student   │
└──────┬──────┘
       │ Voice
       ▼
┌─────────────┐      ┌──────────┐      ┌──────────┐
│   Next.js   │─────▶│  Vapi    │─────▶│   AI     │
│  (Frontend) │      │ (Voice)  │      │  (GPT-4) │
└──────┬──────┘      └──────────┘      └──────────┘
       │
       ▼
┌─────────────┐      ┌──────────┐
│  Supabase   │◀─────│  Clerk   │
│    (DB)     │      │  (Auth)  │
└─────────────┘      └──────────┘
```

---

## 📊 Database Schema

```sql
users
├── id (UUID)
├── clerk_id (TEXT)
├── email (TEXT)
└── full_name (TEXT)

sessions
├── id (UUID)
├── user_id (UUID) → users.id
├── started_at (TIMESTAMP)
├── ended_at (TIMESTAMP)
├── duration_seconds (INT)
└── topic (TEXT)

transcripts
├── id (UUID)
├── session_id (UUID) → sessions.id
├── speaker (TEXT) → 'user' | 'ai'
├── message (TEXT)
└── timestamp (TIMESTAMP)
```

See **[supabase-schema.sql](./supabase-schema.sql)** for complete schema with RLS policies.

---

## 🎤 Demo

### Two-Minute Pitch

> "Many students in Africa struggle with reading and typing. We built AfriVoice - a voice-first AI tutor. You just talk to it like a teacher. No text, no complexity. Just learning through conversation."

**Live Demo:**
1. Login → Dashboard
2. Click "Start Voice Tutor"
3. Ask: "Explain blockchain like I'm 10"
4. AI responds with African examples
5. View saved transcript

See **[DEMO_SCRIPT.md](./DEMO_SCRIPT.md)** for complete presentation guide.

---

## 👥 Team Roles (24-Hour Hackathon)

### Frontend Developer
- Next.js app setup
- Clerk authentication
- Voice UI with Vapi SDK
- Dashboard and session views

### Backend Developer
- Supabase schema and RLS
- API routes (sessions, transcripts)
- Clerk webhook integration
- Sentry error tracking

### API/AI Developer
- Vapi assistant configuration
- AI system prompt engineering
- Voice optimization
- Demo preparation

See **[TASK_BREAKDOWN.md](./TASK_BREAKDOWN.md)** for hour-by-hour tasks.

---

## 🎯 Success Metrics

For judges and users:
1. **Simplicity**: Can anyone use it in <10 seconds?
2. **Voice Quality**: Is the AI clear and natural?
3. **Educational Value**: Does it actually help learning?
4. **Mobile Experience**: Works on cheap phones?
5. **Impact Potential**: Can this scale to millions?

---

## 🗺 Roadmap

### Phase 1: MVP (24 hours) ✅
- Basic voice conversations
- User authentication
- Session saving

### Phase 2: Pilot (1 month)
- Subject categories
- 5-school pilot in Kenya
- Teacher dashboards
- Analytics

### Phase 3: Scale (3 months)
- WhatsApp integration
- Local languages (Swahili, French)
- Offline mode
- 100+ schools

### Phase 4: Expansion (6 months)
- Nigeria, Ghana, South Africa
- Mobile apps (iOS/Android)
- SMS fallback
- Government partnerships

---

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines (coming soon).

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with ❤️ for African students who deserve accessible education.

Special thanks to:
- Students who inspired this project
- Teachers fighting for education access
- The African tech community

---

## 📞 Contact

- **GitHub**: [@nifeesleman](https://github.com/nifeesleman)
- **Project**: [AfriVoice](https://github.com/nifeesleman/AfriVoice)

---

## 🌟 Show Your Support

If you believe in making education accessible through voice, give this project a ⭐️!

---

**AfriVoice: Learn by talking. Teach by listening.** 🎓🌍