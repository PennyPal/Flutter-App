# Quick Start Guide for PennyPal

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Set Up Appwrite (Backend)

1. **Create Appwrite Account**
   - Go to https://cloud.appwrite.io/
   - Sign up (it's free!)
   - Create a new project named "PennyPal"

2. **Get Your Project ID**
   - In Appwrite dashboard → Settings
   - Copy your **Project ID**

3. **Enable Authentication**
   - Go to Auth section
   - Enable "Email/Password"
   - Enable "Google OAuth2" (follow the wizard)

4. **Update App Config**
   - Open `lib/core/config/app_config.dart`
   - Replace `'YOUR_PROJECT_ID_HERE'` with your actual project ID

### Step 3: Set Up Perplexity API (AI Chat)

1. **Get API Key**
   - Visit https://www.perplexity.ai/
   - Sign up and request API access
   - Copy your API key

2. **Update App Config**
   - Open `lib/core/config/app_config.dart`
   - Replace `'YOUR_PERPLEXITY_API_KEY_HERE'` with your actual API key

### Step 4: Run the App!

```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome
```

## ✅ What's Working Now

### Authentication (via Appwrite)
- ✅ Email/Password sign up and login
- ✅ Google OAuth sign in
- ✅ Apple OAuth sign in
- ✅ Password recovery
- ✅ Secure session management

### AI Financial Advisor (via Perplexity)
- ✅ Real-time financial advice
- ✅ Current market information
- ✅ Cited sources for facts
- ✅ Context-aware responses

## 🎯 Testing the Features

### Test Authentication
1. Open the app
2. Click "Sign Up"
3. Enter email, password, and name
4. Try signing in with the account
5. Try "Continue with Google" for OAuth

### Test AI Chat
1. Log in to the app
2. Navigate to the Chat tab
3. Ask a financial question like:
   - "How should I budget my income?"
   - "What's the 50/30/20 rule?"
   - "How do I start investing?"
4. Get intelligent responses with real-time data!

## 🔧 Alternative: Using Environment Variables

Instead of hardcoding API keys, you can use environment variables:

```bash
flutter run \
  --dart-define=APPWRITE_PROJECT_ID=your_project_id \
  --dart-define=PERPLEXITY_API_KEY=your_api_key
```

## ⚠️ Important Notes

1. **Never commit your API keys** to Git
2. The `.gitignore` is already configured to protect your keys
3. For production, use proper secrets management
4. Keep your Flutter SDK updated: `flutter upgrade`

## 🐛 Troubleshooting

### "Invalid Project ID" Error
- Double-check your Appwrite project ID
- Make sure you're using the correct endpoint

### "API Key Not Configured" Error
- Verify your Perplexity API key is correctly set
- Check for typos in the configuration

### OAuth Not Working
- Configure deep links (see SETUP_GUIDE.md)
- Verify OAuth credentials in Appwrite

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Need More Help?

Check out the detailed [SETUP_GUIDE.md](./SETUP_GUIDE.md) for:
- Deep linking configuration
- Production deployment
- Security best practices
- Advanced configuration

## 🎉 You're All Set!

Your PennyPal app now has:
- Professional backend authentication with Appwrite
- Intelligent AI chat with Perplexity
- Google OAuth support
- Secure user management

Start building amazing financial features! 🚀

