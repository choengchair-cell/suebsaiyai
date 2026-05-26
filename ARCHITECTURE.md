# สืบสายใย — System Architecture

**Version:** 1.0.0  
**Platform:** Flutter Web + Firebase  
**Architecture Style:** Domain-Driven Design + Clean Architecture  

---

## 1. SYSTEM ARCHITECTURE

```
┌──────────────────────────────────────────────────────────────────┐
│                    PUBLIC INTERNET                                │
│                                                                  │
│   Browser ──► Firebase Hosting (Flutter Web WASM/JS)            │
└──────────────────────────┬───────────────────────────────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────────┐
│                 FLUTTER WEB APPLICATION                           │
│                                                                  │
│  Presentation Layer (GoRouter + Shell Layouts)                   │
│  ├── PublicShell  (home, explore, story-detail, search)          │
│  ├── AuthShell    (login, register)                              │
│  └── ProtectedShell (dashboard, editor, review, admin)          │
│                           │                                      │
│  Application Layer (Riverpod StateNotifiers + Providers)         │
│  ├── AuthNotifier                                                │
│  ├── StoryEditorNotifier                                         │
│  ├── StoryListNotifier                                           │
│  └── AiAssistNotifier  ◄── AUGMENTATION ONLY                    │
│                           │                                      │
│  Domain Layer (Pure Dart Entities + Repository Interfaces)       │
│  ├── Entities: User, Story, StoryVersion, Review, Media, etc.   │
│  └── Repositories: abstract contracts, no Firebase imports       │
│                           │                                      │
│  Data Layer (Firebase Implementations)                           │
│  ├── Firestore datasources + models                             │
│  ├── Firebase Auth datasource                                   │
│  ├── Firebase Storage datasource                                │
│  └── Claude AI datasource  ◄── Output stored as AiArtifact     │
└──────────────────────────┬───────────────────────────────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────────┐
│                      FIREBASE BACKEND                             │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Firebase Auth │  │  Firestore   │  │  Firebase Storage    │  │
│  │              │  │              │  │                      │  │
│  │ UID + Claims │  │ stories/     │  │ stories/{id}/images  │  │
│  │              │  │ users/       │  │ stories/{id}/audio   │  │
│  └──────────────┘  │ story_vers/  │  │ stories/{id}/video   │  │
│                    │ reviews/     │  │ users/{id}/avatar    │  │
│                    │ media/       │  └──────────────────────┘  │
│                    │ ai_artifacts/│                              │
│                    │ districts/   │                              │
│                    │ taxonomies/  │                              │
│                    │ audit_log/   │                              │
│                    └──────────────┘                              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. DOMAIN MODEL

### Core Entities

| Entity | Responsibility | Lifecycle | Owner |
|--------|---------------|-----------|-------|
| **User** | Identity, role, district membership | Created at registration, never deleted | Firebase Auth |
| **Story** | Primary knowledge artifact | draft→published→archived | Author (field user) |
| **StoryVersion** | Immutable snapshot on each save | Append-only | System |
| **Review** | Human decision record | Created by reviewer, finalized once | Teacher/Committee |
| **District** | Geographic+admin boundary | Managed by admin | Admin |
| **Media** | Binary attachments for stories | Uploaded, optionally archived | Author |
| **AiArtifact** | AI-generated augmentation | Written by AI service only, validated by human | AI service |
| **Taxonomy** | Classification vocabulary | Committee-managed | Committee |
| **CulturalTerm** | Community glossary | Teacher-created, committee-approved | Teacher |

### Governance Rules
- AI output **cannot** overwrite Story.content
- AI output **cannot** change Story.status
- AiArtifacts are **immutable** after creation
- Story.status transitions are **enforced by Firestore Security Rules**
- Audit log is **write-once** via Cloud Functions

---

## 3. STORY LIFECYCLE

```
[Author]          [Teacher]          [Committee]        [Admin]
   │                  │                    │                │
   ▼                  │                    │                │
draft ──submit──► submitted               │                │
                      │                    │                │
                 teacher_review ──────────►│               │
                      │         accept     │                │
                      │◄── reject          │                │
                      │                committee_review     │
                      │                    │ approve        │
                      │                    ▼                │
                      │                 approved            │
                      │                    │ publish        │
                      │                    ▼                │
                      │                 published ─────────►│
                      │                                 archive
                      │                                     │
                      │                                  archived
```

**Who can edit at each stage:**
- `draft` → author only
- `submitted` → author can recall; teacher can accept/reject
- `teacher_review` → teacher can transition; author can recall
- `committee_review` → committee only
- `approved` → committee can publish or return
- `published` → read-only; admin can archive
- `archived` → read-only; admin can unarchive

---

## 4. FIRESTORE SCHEMA

### users/{uid}
```json
{
  "uid": "string",
  "email": "string",
  "displayName": "string",
  "role": "field|teacher|committee|admin",
  "districtId": "string",
  "avatarUrl": "string?",
  "bio": "string?",
  "isActive": true,
  "createdAt": "Timestamp"
}
```

### stories/{storyId}
```json
{
  "title": "string",
  "content": "string",
  "authorId": "string",
  "authorName": "string",
  "districtId": "string",
  "status": "draft|submitted|teacher_review|committee_review|approved|published|archived",
  "tags": ["string"],
  "taxonomyIds": ["string"],
  "culturalTermIds": ["string"],
  "mediaIds": ["string"],
  "coverImageUrl": "string?",
  "summary": "string?",
  "currentVersionId": "string?",
  "viewCount": 0,
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp",
  "publishedAt": "Timestamp?"
}
```

### story_versions/{versionId}
```json
{
  "storyId": "string",
  "title": "string",
  "content": "string",
  "versionNumber": 1,
  "createdBy": "string",
  "changeNote": "string?",
  "snapshotStatus": "string",
  "createdAt": "Timestamp"
}
```

### ai_artifacts/{artifactId}
```json
{
  "storyId": "string",
  "type": "summary|tags|keywords|searchIndex|recommendation",
  "content": "dynamic",
  "modelVersion": "claude-opus-4-7",
  "isHumanValidated": false,
  "validatedBy": "string?",
  "validatedAt": "Timestamp?",
  "confidence": 0.0,
  "createdAt": "Timestamp"
}
```

---

## 5. FIREBASE SECURITY MODEL

### Roles & Permissions Matrix

| Action | field | teacher | committee | admin |
|--------|-------|---------|-----------|-------|
| Read published stories | ✓ | ✓ | ✓ | ✓ |
| Create story | ✓ | ✓ | ✓ | ✓ |
| Edit own draft | ✓ | ✓ | ✓ | ✓ |
| Review (teacher_review) | ✗ | ✓ | ✓ | ✓ |
| Review (committee_review) | ✗ | ✗ | ✓ | ✓ |
| Publish story | ✗ | ✗ | ✓ | ✓ |
| Manage users | ✗ | ✗ | ✗ | ✓ |
| Write AI artifacts | ✗ | ✗ | ✗ | Cloud Fn |
| Write audit log | ✗ | ✗ | ✗ | Cloud Fn |

---

## 6. FLUTTER LAYER STRUCTURE

```
lib/
├── core/                    # Zero business logic. Pure infrastructure.
│   ├── config/              # AppConfig, environment, FirebaseOptions
│   ├── constants/           # Route, Firestore, App constants
│   ├── errors/              # Failure types, AppException
│   ├── extensions/          # Dart type extensions
│   ├── theme/               # Material 3 theme, colors, typography
│   └── utils/               # DateFormatter, Validators
│
├── domain/                  # Pure Dart. Zero Flutter/Firebase imports.
│   ├── entities/            # Equatable value objects
│   ├── enums/               # UserRole, StoryStatus, MediaType, etc.
│   └── repositories/        # Abstract interfaces (contracts)
│
├── data/                    # Firebase implementations.
│   ├── datasources/remote/  # Direct Firebase/API calls
│   ├── models/              # Firestore ↔ Entity mappers
│   └── repositories/        # Concrete repository implementations
│
├── application/             # Riverpod StateNotifiers + Providers.
│   ├── providers/           # Firebase, Datasource, Repository providers
│   ├── auth/                # AuthNotifier, AuthState
│   ├── story/               # StoryListNotifier, StoryEditorNotifier
│   ├── district/            # DistrictProviders
│   └── ai/                  # AiAssistNotifier (augmentation only)
│
├── presentation/            # Routing + Shell layouts.
│   ├── router/              # GoRouter config with guards
│   └── shell/               # AppShell (responsive SideNav/BottomNav)
│
└── features/                # Feature-first UI organization.
    ├── auth/                # Login, Register pages
    ├── home/                # HomePage (discovery)
    ├── story/               # List, Detail, Create, Edit pages + widgets
    ├── dashboard/           # Personal dashboard
    ├── review/              # Review queue (teacher/committee)
    ├── search/              # Full-text search
    ├── admin/               # User/district/taxonomy management
    ├── media/               # Upload, gallery
    └── ai_assist/           # AI suggestion panel
```

### Dependency Direction (strict)
```
features → application → domain ← data
presentation → application → domain ← data
core (no dependencies on other layers)
```

---

## 7. AI ARCHITECTURE

AI is positioned strictly as an **Augmentation Layer**:

```
Story (human-authored)
      │
      ▼
AI Service (Claude API)
      │
      ▼  generates:
AiArtifact (summary, tags, search index)
      │
      ▼  stored separately, NEVER overwrites Story
Human Validator reviews → marks isHumanValidated = true
      │
      ▼  used for:
Search Enhancement + Discovery + Recommendation
```

**Claude integration rules:**
1. AI is called **after** a story is saved, never inline during edit
2. AI output goes into `ai_artifacts` collection, **not** `stories`
3. `AiArtifact.content` is **immutable** once created
4. Human validation flag (`isHumanValidated`) required before surfacing in public UI
5. Prompt templates are versioned; model version stored with each artifact
6. Retry with exponential backoff (3 retries, 2s/4s/8s)
7. API key never committed — loaded via `--dart-define`

---

## 8. STATE MANAGEMENT

```
Firebase Auth Stream
      │
      ▼
AuthNotifier (StateNotifier)
  → AuthState: Initial | Loading | Authenticated(user) | Unauthenticated | Error

Story Streams (Firestore)
      │
      ▼
StoryListNotifier (StateNotifier)
  → StoryListState: Initial | Loading | Loaded(stories) | Error

UI Actions
      │
      ▼
StoryEditorNotifier (StateNotifier)
  → StoryEditorState: mode, isSaving, isDirty, story, error/success
```

**Provider naming conventions:**
- `*Provider` → `Provider<T>` (singleton dependency)
- `*NotifierProvider` → `StateNotifierProvider` (stateful)
- `*StreamProvider` → `StreamProvider` (real-time)
- `*FutureProvider` → `FutureProvider` (one-shot async)
- `.autoDispose` → always for screen-scoped providers

---

## 9. DEPLOYMENT ENVIRONMENTS

| Env | Firebase Project | Branch | Purpose |
|-----|----------------|--------|---------|
| development | suebsaiyai-dev | feature/* | Local development |
| staging | suebsaiyai-staging | claude/* | Integration testing |
| production | suebsaiyai-prod | main | Live system |

**Build commands:**
```bash
# Development
flutter run -d chrome --dart-define=CLAUDE_API_KEY=$CLAUDE_KEY

# Staging
flutter build web --dart-define=CLAUDE_API_KEY=$CLAUDE_KEY --dart-define=ENV=staging
firebase hosting:channel:deploy staging --project suebsaiyai-staging

# Production
flutter build web --wasm --dart-define=CLAUDE_API_KEY=$CLAUDE_KEY --dart-define=ENV=production
firebase deploy --only hosting --project suebsaiyai-prod
```

---

## 10. CRITICAL ANTI-PATTERNS (NEVER DO)

1. **Never** put AI generation inside `stories` collection
2. **Never** let AI output auto-publish or auto-approve
3. **Never** store API keys in source code or Firestore
4. **Never** call Firebase directly from widgets — always go through repositories
5. **Never** use `setState` for shared/cross-widget state — use Riverpod
6. **Never** use `context.read()` inside `build()` — use `ref.watch()` or `ref.listen()`
7. **Never** mix business logic into widget `build()` methods
8. **Never** skip the version snapshot on story updates
9. **Never** allow `committee_review→published` to bypass `approved` state
10. **Never** expose `ai_artifacts` as authoritative — they are supplementary

---

## 11. MVP IMPLEMENTATION ROADMAP

### Phase 1 — Core Infrastructure (Weeks 1–2)
- [ ] Firebase project setup (dev/staging/prod)
- [ ] FlutterFire CLI + firebase_options.dart generation
- [ ] Authentication (email/password)
- [ ] User creation with role assignment
- [ ] District seed data

### Phase 2 — Story Lifecycle (Weeks 3–4)
- [ ] Story creation (draft)
- [ ] Story editor with auto-save
- [ ] Submit for review workflow
- [ ] Teacher review UI
- [ ] Committee review + publish UI

### Phase 3 — Discovery (Weeks 5–6)
- [ ] Public story list + search
- [ ] District-based browsing
- [ ] Tags + taxonomy filtering
- [ ] Cultural terms glossary

### Phase 4 — AI Augmentation (Week 7)
- [ ] Summary generation (on submit)
- [ ] Auto-tagging suggestions
- [ ] Human validation UI for AI artifacts
- [ ] Search index enhancement

### Phase 5 — Media (Week 8)
- [ ] Image upload + compression
- [ ] Audio recording + upload
- [ ] Media gallery per story

### Phase 6 — Admin Tools (Week 9)
- [ ] User role management
- [ ] District management
- [ ] Taxonomy management
- [ ] Audit log viewer

### Phase 7 — Production Hardening (Week 10)
- [ ] Firebase Security Rules testing (emulator)
- [ ] Performance optimization
- [ ] Error monitoring
- [ ] CI/CD pipeline
