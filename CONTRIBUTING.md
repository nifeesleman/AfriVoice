# Contributing to AfriVoice

Thank you for your interest in contributing to AfriVoice! 🎓🌍

We're building a voice-first AI education platform to make learning accessible to millions of African students. Every contribution helps make education more accessible.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for everyone, regardless of:
- Experience level
- Gender identity and expression
- Sexual orientation
- Disability
- Personal appearance
- Body size
- Race or ethnicity
- Age
- Religion
- Nationality

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what's best for the community
- Showing empathy towards others

**Unacceptable behavior includes:**
- Harassment, trolling, or insulting comments
- Public or private harassment
- Publishing others' private information
- Other conduct inappropriate in a professional setting

---

## How Can I Contribute?

### 1. Reporting Bugs

**Before submitting a bug report:**
- Check existing issues to avoid duplicates
- Collect relevant information (OS, browser, steps to reproduce)

**Bug report should include:**
- Clear, descriptive title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Environment details

**Template:**
```markdown
**Bug Description**
A clear and concise description of the bug.

**To Reproduce**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment**
- OS: [e.g., Windows 10, macOS 13]
- Browser: [e.g., Chrome 118, Safari 16]
- Version: [e.g., 1.0.0]
```

### 2. Suggesting Features

**Before suggesting a feature:**
- Check if it aligns with project goals (education accessibility)
- Search existing feature requests

**Feature request should include:**
- Problem it solves
- Proposed solution
- Alternative solutions considered
- Impact on users (especially African students)

### 3. Code Contributions

**Good first issues:**
- Documentation improvements
- UI/UX enhancements
- Bug fixes
- Test coverage
- Accessibility improvements

**Areas we need help:**
- Local language support (Swahili, French, Yoruba, etc.)
- Offline mode implementation
- Mobile app development
- Voice quality improvements
- Educational content creation

---

## Development Setup

### Prerequisites

- Node.js 18+
- npm or yarn
- Git

### Initial Setup

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/AfriVoice.git
cd AfriVoice

# 3. Add upstream remote
git remote add upstream https://github.com/nifeesleman/AfriVoice.git

# 4. Install dependencies
npm install

# 5. Copy environment variables
cp .env.example .env.local

# 6. Get API keys (see TECHNICAL_GUIDE.md)
# - Clerk: https://clerk.com
# - Supabase: https://supabase.com
# - Vapi: https://vapi.ai

# 7. Run development server
npm run dev
```

### Keep Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream main into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

---

## Project Structure

```
afrivoice/
├── src/
│   ├── app/                 # Next.js app router pages
│   │   ├── (auth)/         # Authentication routes
│   │   ├── api/            # API routes
│   │   ├── dashboard/      # Dashboard page
│   │   └── voice-tutor/    # Voice tutor page
│   ├── components/         # React components
│   │   ├── ui/            # shadcn/ui components
│   │   └── ...            # Custom components
│   ├── lib/               # Utility functions
│   ├── types/             # TypeScript types
│   └── styles/            # Global styles
├── public/                # Static assets
├── docs/                  # Documentation
└── tests/                 # Test files (coming soon)
```

---

## Coding Standards

### TypeScript

```typescript
// ✅ Good: Use explicit types
interface SessionProps {
  id: string
  userId: string
  startedAt: Date
}

function createSession(props: SessionProps): Session {
  // ...
}

// ❌ Bad: Avoid 'any'
function createSession(props: any): any {
  // ...
}
```

### React Components

```typescript
// ✅ Good: Functional components with TypeScript
interface ButtonProps {
  onClick: () => void
  children: React.ReactNode
  variant?: 'primary' | 'secondary'
}

export function Button({ onClick, children, variant = 'primary' }: ButtonProps) {
  return (
    <button onClick={onClick} className={variant}>
      {children}
    </button>
  )
}

// ❌ Bad: Missing types
export function Button({ onClick, children }) {
  return <button onClick={onClick}>{children}</button>
}
```

### File Naming

- Components: `PascalCase.tsx` (e.g., `VoiceTutor.tsx`)
- Utilities: `camelCase.ts` (e.g., `formatDate.ts`)
- Types: `index.ts` or `types.ts`
- Styles: `kebab-case.css` (e.g., `voice-tutor.css`)

### Code Style

```bash
# Format code with Prettier
npm run format

# Lint with ESLint
npm run lint

# Type check
npm run type-check
```

**Rules:**
- Use 2 spaces for indentation
- Use single quotes for strings
- Add semicolons
- Max line length: 100 characters
- Use trailing commas in objects/arrays

---

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```bash
# Good commits
git commit -m "feat(voice): add microphone permission check"
git commit -m "fix(auth): resolve login redirect issue"
git commit -m "docs: update setup instructions in README"

# Bad commits
git commit -m "fixed stuff"
git commit -m "WIP"
git commit -m "asdfasdf"
```

### Detailed Example

```
feat(voice): add offline mode support

- Cache voice sessions locally
- Sync when connection restored
- Show offline indicator in UI

Closes #123
```

---

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Self-review of code completed
- [ ] Comments added for complex logic
- [ ] Documentation updated (if needed)
- [ ] No console.log statements left
- [ ] Tests added (when applicable)
- [ ] All tests pass
- [ ] No TypeScript errors

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Other (specify)

## Testing
How has this been tested?

## Screenshots
If UI changes, add screenshots

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No breaking changes
- [ ] Tests pass

## Related Issues
Closes #issue_number
```

### Review Process

1. **Automated Checks**: CI/CD runs tests and linting
2. **Code Review**: Maintainer reviews code
3. **Feedback**: Address review comments
4. **Approval**: Once approved, PR is merged

### After Merge

- Delete your branch
- Update your fork
- Celebrate! 🎉

---

## Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run specific test file
npm test -- VoiceTutor.test.tsx

# Check coverage
npm run test:coverage
```

### Writing Tests

```typescript
// Example test
import { render, screen, fireEvent } from '@testing-library/react'
import { VoiceTutor } from './VoiceTutor'

describe('VoiceTutor', () => {
  it('should start session when button clicked', async () => {
    render(<VoiceTutor />)
    
    const startButton = screen.getByRole('button', { name: /start/i })
    fireEvent.click(startButton)
    
    expect(await screen.findByText(/listening/i)).toBeInTheDocument()
  })
})
```

---

## Documentation

### Code Comments

```typescript
// ✅ Good: Explain WHY, not WHAT
// Using setTimeout to debounce voice input and avoid
// excessive API calls to Vapi (max 1 call per second)
const debouncedSave = setTimeout(() => saveTranscript(), 1000)

// ❌ Bad: Stating the obvious
// This function creates a session
function createSession() { ... }
```

### README Updates

When adding features:
- Update main README.md
- Update TECHNICAL_GUIDE.md if needed
- Add to CHANGELOG.md (if exists)

---

## Community

### Communication Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, general discussion
- **Twitter**: @AfriVoice (coming soon)

### Getting Help

Stuck? Here's how to get help:

1. **Check Documentation**: Read guides in the repo
2. **Search Issues**: Someone might have asked already
3. **Ask in Discussions**: Community can help
4. **Open an Issue**: For bugs or unclear docs

---

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Featured on our website (when live)
- Invited to contributor-only discussions

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Questions?

Have questions about contributing? Open a discussion or reach out to maintainers.

Thank you for making education more accessible! 🙏🌍

---

**Remember:** Every contribution, no matter how small, makes a difference. Whether it's fixing a typo, improving documentation, or adding a feature - you're helping millions of students access education.

Let's build something amazing together! 🚀
