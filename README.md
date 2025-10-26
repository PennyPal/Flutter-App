# 💰 PennyPal

A gamified personal finance app that makes budgeting fun! Track expenses, set goals, learn about finance, and get AI-powered financial advice.

## ✨ Features

### 🔐 Authentication
- Email/Password authentication
- Google OAuth2 sign-in
- Apple OAuth2 sign-in
- Secure password recovery
- Session management

### 🤖 AI Financial Advisor
- Powered by **Perplexity AI**
- Real-time financial advice with current market data
- Cited sources for factual information
- Context-aware responses tailored to personal finance

### 📊 Financial Management
- Budget tracking and planning
- Expense categorization
- Savings goals
- Financial education content
- Interactive learning modules
- Progress tracking and achievements

### 🎮 Gamification
- Quest system for financial goals
- Achievement badges
- Study streaks
- Progress visualization

## 🚀 Quick Start

See [QUICKSTART.md](./QUICKSTART.md) for a 5-minute setup guide!

### Prerequisites
- Flutter SDK (>=3.24.0)
- Dart SDK (>=3.5.0)
- Appwrite account (free)
- Perplexity API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Pennypal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Appwrite**
   - Create account at https://cloud.appwrite.io/
   - Create new project
   - Enable Email/Password and OAuth2 authentication
   - Copy your Project ID

4. **Configure Perplexity API**
   - Get API key from https://www.perplexity.ai/
   - Update configuration

5. **Update configuration**
   - Edit `lib/core/config/app_config.dart`
   - Add your Appwrite Project ID
   - Add your Perplexity API key

6. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Tech Stack

### Backend & Authentication
- **Appwrite** - Backend-as-a-Service
  - User authentication
  - OAuth2 integration
  - Database (optional)
  - Real-time capabilities

### AI & Intelligence
- **Perplexity AI** - Advanced AI for financial advice
  - Real-time information access
  - Factual accuracy with citations
  - Current market data integration

### Frontend
- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management
- **Go Router** - Navigation
- **Hive** - Local storage
- **FL Chart** - Data visualization
- **Lottie** - Animations

### Code Quality
- **Freezed** - Immutable data classes
- **Sentry** - Error tracking
- **Flutter Lints** - Code analysis

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── router/          # Navigation setup
│   ├── services/        # Core services (Appwrite)
│   └── theme/           # App theming
├── features/
│   ├── auth/            # Authentication
│   │   ├── data/        # Auth services
│   │   └── presentation/# Login/Register UI
│   ├── chat/            # AI Chat advisor
│   │   ├── data/        # Perplexity service
│   │   └── presentation/# Chat UI
│   ├── dashboard/       # Main dashboard
│   ├── budgets/         # Budget management
│   ├── goals/           # Financial goals
│   ├── learn/           # Financial education
│   ├── transactions/    # Transaction tracking
│   └── profile/         # User profile
└── shared/              # Shared widgets & services
```

## 🔧 Configuration

### Option 1: Direct Configuration
Edit `lib/core/config/app_config.dart`:
```dart
static const String appwriteProjectId = 'your_project_id';
static const String perplexityApiKey = 'your_api_key';
```

### Option 2: Environment Variables
```bash
flutter run \
  --dart-define=APPWRITE_PROJECT_ID=your_id \
  --dart-define=PERPLEXITY_API_KEY=your_key
```

### Option 3: Configuration File
Copy `config.json.example` to `config.json` and fill in your values:
```bash
flutter run --dart-define-from-file=config.json
```

## 📖 Documentation

- [Quick Start Guide](./QUICKSTART.md) - Get up and running in 5 minutes
- [Setup Guide](./SETUP_GUIDE.md) - Detailed configuration instructions
- [Context Document](./CONTEXT.md) - Project architecture and decisions

## 🔒 Security

- API keys are not committed to version control
- `.gitignore` configured to protect sensitive data
- Appwrite handles authentication securely
- HTTPS/TLS for all API communications
- OAuth2 for social login

## 🎯 Why Appwrite + Perplexity?

### Appwrite Benefits
✅ Free tier with generous limits
✅ Built-in authentication (Email, OAuth2, Phone)
✅ Easy to set up and use
✅ Self-hosted option available
✅ Real-time database capabilities
✅ Excellent Flutter SDK

### Perplexity AI Benefits
✅ Real-time information access
✅ Factual accuracy with citations
✅ Better for financial advice than standard LLMs
✅ Current market data and economic trends
✅ Professional-grade responses

## 🛠️ Development

### Run in development mode
```bash
flutter run
```

### Run tests
```bash
flutter test
```

### Build for production
```bash
# iOS
flutter build ios

# Android
flutter build apk

# Web
flutter build web
```

## 🐛 Troubleshooting

### Common Issues

**OAuth not working?**
- Configure deep links (see SETUP_GUIDE.md)
- Verify OAuth credentials in Appwrite

**API errors?**
- Check your API keys are correctly configured
- Verify network connectivity

**Build errors?**
```bash
flutter clean
flutter pub get
flutter run
```

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues and questions:
- Check the [SETUP_GUIDE.md](./SETUP_GUIDE.md)
- Review [QUICKSTART.md](./QUICKSTART.md)
- Open an issue on GitHub

## 🎉 Acknowledgments

- **Appwrite** for excellent backend services
- **Perplexity AI** for intelligent financial advice
- **Flutter** team for the amazing framework
- All contributors and users of PennyPal

---

Made with ❤️ for better financial literacy
