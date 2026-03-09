# BGMI Tournament Hosting Platform

A production-ready Flutter application for hosting BGMI tournaments with wallet, leaderboard, admin panel, and responsive multi-platform support.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Dart SDK ≥3.0.0
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

```bash
# Clone the repo
cd bgmi_tournament

# Install dependencies
flutter pub get

# Run code generation (for Freezed models if extended later)
# flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Platform-Specific

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Desktop (macOS/Linux)
flutter run -d macos
flutter run -d linux
```

## 🏗 Architecture

```
lib/
├── core/                     # Shared infrastructure
│   ├── config/               # Environment config (dev/prod)
│   ├── constants/            # Colors, constants
│   ├── models/               # Data models (User, Tournament, Wallet, etc.)
│   ├── network/              # Dio client, interceptors, error handling
│   ├── services/             # Notification, secure storage
│   ├── theme/                # Dark + Light themes
│   └── utils/                # Responsive helpers, validators
│
├── features/                 # Feature modules (Clean Architecture)
│   ├── auth/                 # Login, Register, OTP
│   ├── tournament/           # Home, Tournament Detail, Join flow
│   ├── wallet/               # Balance, Add Money, Withdraw
│   ├── leaderboard/          # Rankings with podium
│   ├── profile/              # User profile, KYC, settings
│   └── admin/                # Dashboard, Tournament CRUD, Screenshots, Withdrawals, KYC
│
├── shared/                   # Reusable widgets
│   └── widgets/              # AppButton, AppCard, LoadingShimmer, EmptyState, AdaptiveScaffold
│
├── app_router.dart           # GoRouter config with role-based routing
└── main.dart                 # Entry point
```

Each feature follows: `data/ → domain/ → presentation/`

## 🔐 Environment Config

Set the environment in `main.dart`:

```dart
EnvConfig.init(Environment.dev);   // Development
EnvConfig.init(Environment.prod);  // Production
```

API base URLs are configured in `core/config/env_config.dart`.

## 📱 Responsive Design

| Device   | Navigation       |
|----------|------------------|
| Mobile   | Bottom nav bar   |
| Tablet   | Sidebar rail     |
| Desktop  | Extended sidebar |

Uses `LayoutBuilder` and `MediaQuery` — no fixed widths.

## 👤 User Features

- **Tournament browsing** with search + filters
- **Tournament join flow** with wallet balance check
- **Room ID** reveal (paid players only)
- **Wallet** — add money (Razorpay-ready), view transactions, request withdrawal
- **Leaderboard** with top-3 podium visualization
- **Profile** with KYC status, match history, theme toggle

## 🛠 Admin Features

- **Analytics dashboard** with stats grid, activity feed, quick actions
- **Tournament management** — create, edit, set room ID/password
- **Screenshot review** — approve/reject with manual score entry
- **Withdrawal management** — approve/reject pending requests
- **KYC verification** — review uploaded documents

## 🔒 Security

- JWT token storage via `flutter_secure_storage`
- Role-based routing (User vs Admin)
- Wallet balance validation before tournament join
- Input validation on all forms
- Duplicate registration prevention

## 🎨 Theming

- Full **dark + light** theme support
- Premium design with gradients, glassmorphism-inspired cards
- Typography: Poppins + Inter from Google Fonts
- Smooth animations and micro-interactions

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation + deep linking |
| `dio` | HTTP client |
| `flutter_secure_storage` | Token storage |
| `image_picker` + `image_compress` | Screenshot upload |
| `cached_network_image` | Image caching |
| `shimmer` | Loading skeletons |
| `intl` | Date formatting |
| `firebase_messaging` | Push notifications |

## 📝 License

MIT — Built by WeSquare
