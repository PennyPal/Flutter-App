# 🚀 PennyPal Complete Setup Guide

Welcome to PennyPal! This guide will walk you through setting up your financial management app with Appwrite backend and Perplexity AI.

---

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Appwrite Backend Setup](#appwrite-backend-setup)
3. [Authentication Configuration](#authentication-configuration)
4. [Perplexity AI Setup](#perplexity-ai-setup)
5. [Running the App](#running-the-app)
6. [Testing Features](#testing-features)
7. [Troubleshooting](#troubleshooting)

---

## ✅ Prerequisites

Before you begin, ensure you have:
- ✅ Flutter SDK installed (3.0.0 or higher)
- ✅ Android Studio or Xcode installed
- ✅ An Android emulator or iOS simulator set up
- ✅ Internet connection for API access

---

## 🔧 Appwrite Backend Setup

### Step 1: Create Appwrite Account

1. **Go to Appwrite Cloud**
   - Visit: [https://cloud.appwrite.io/](https://cloud.appwrite.io/)
   - Click **"Sign Up"** or **"Get Started"**

2. **Create Your Account**
   - Sign up with email or GitHub
   - Verify your email address

3. **Create a New Project**
   - Click **"Create Project"**
   - Name it: **"PennyPal"**
   - Choose your preferred region (e.g., San Francisco)

### Step 2: Get Your Project Credentials

1. **Copy Project ID**
   - In your project dashboard, look for **Project ID**
   - It should look like: `68e749bf003cf9cf5cca`
   - **Save this** - you'll need it!

2. **Note Your Endpoint**
   - Your endpoint will be something like:
   - `https://cloud.appwrite.io/v1` (default)
   - Or region-specific: `https://sfo.cloud.appwrite.io/v1`

### Step 3: Update App Configuration

Your app is already configured with the demo project:
```dart
// lib/core/config/app_config.dart
Project ID: 68e749bf003cf9cf5cca
Endpoint: https://sfo.cloud.appwrite.io/v1
```

**To use your own project**, update these values in:
`lib/core/config/app_config.dart`

```dart
static const String appwriteEndpoint = 'YOUR_ENDPOINT';
static const String appwriteProjectId = 'YOUR_PROJECT_ID';
```

---

## 🔐 Authentication Configuration

PennyPal supports **5 authentication methods**:
1. Email/Password
2. Google OAuth
3. Apple OAuth
4. Phone OTP
5. Email OTP

### Method 1: Email/Password (Already Enabled!)

✅ **No additional setup needed** - works out of the box!

### Method 2: Google OAuth Setup

1. **Go to Google Cloud Console**
   - Visit: [https://console.cloud.google.com/](https://console.cloud.google.com/)
   - Create a new project or select existing

2. **Enable Google+ API**
   - Go to **APIs & Services** → **Library**
   - Search for "Google+ API"
   - Click **Enable**

3. **Create OAuth Credentials**
   - Go to **APIs & Services** → **Credentials**
   - Click **Create Credentials** → **OAuth 2.0 Client ID**
   - Choose **Web application**
   - Add authorized redirect URIs:
     ```
     https://cloud.appwrite.io/v1/account/sessions/oauth2/callback/google/console
     https://cloud.appwrite.io/v1/account/sessions/oauth2/callback/google/mobile
     ```

4. **Configure in Appwrite**
   - Go to your Appwrite project → **Auth** → **Settings**
   - Scroll to **OAuth2 Providers**
   - Click **Google**
   - Enter your **Client ID** and **Client Secret**
   - Add success URL: `pennypal://oauth-success`
   - Add failure URL: `pennypal://oauth-failure`
   - Click **Update**

### Method 3: Apple OAuth Setup

1. **Go to Apple Developer Console**
   - Visit: [https://developer.apple.com/](https://developer.apple.com/)
   - Sign in with your Apple Developer account

2. **Create Service ID**
   - Go to **Certificates, Identifiers & Profiles**
   - Click **Identifiers** → **+** (Add)
   - Select **Services IDs**
   - Register a new Service ID

3. **Configure Sign in with Apple**
   - Enable **Sign in with Apple**
   - Add redirect URIs from Appwrite

4. **Configure in Appwrite**
   - Go to your Appwrite project → **Auth** → **Settings**
   - Scroll to **OAuth2 Providers**
   - Click **Apple**
   - Enter your credentials
   - Click **Update**

### Method 4: Phone OTP Setup

1. **Enable Phone Authentication in Appwrite**
   - Go to **Auth** → **Settings**
   - Enable **Phone Authentication**

2. **Choose SMS Provider**
   Appwrite supports:
   - **Twilio** (Recommended for US)
   - **MSG91** (Good for India)
   - **Textmagic**
   - **Telesign**
   - **Vonage**

3. **Configure SMS Provider (Example: Twilio)**
   
   a. **Create Twilio Account**
      - Go to [https://www.twilio.com/](https://www.twilio.com/)
      - Sign up for free trial
   
   b. **Get Credentials**
      - Copy your **Account SID**
      - Copy your **Auth Token**
      - Get a **Phone Number** from Twilio
   
   c. **Add to Appwrite**
      - In Appwrite → **Auth** → **Settings**
      - Scroll to **Phone Provider**
      - Select **Twilio**
      - Enter Account SID, Auth Token, and Phone Number
      - Click **Update**

4. **Test Phone OTP**
   - Use format: `+[country code][number]`
   - Example: `+12345678900` (US)
   - Example: `+447911123456` (UK)

### Method 5: Email OTP Setup

1. **Enable Email OTP in Appwrite**
   - Go to **Auth** → **Settings**
   - Enable **Email OTP**

2. **Configure SMTP (Optional)**
   - Appwrite has default email service
   - For custom emails, configure SMTP:
     - Go to **Settings** → **SMTP**
     - Enter your SMTP server details
     - Test the connection

3. **Email OTP is Ready!**
   - Users can now login with email OTP
   - No password required!

---

## 🤖 Perplexity AI Setup

### Step 1: Get Perplexity API Key

1. **Visit Perplexity**
   - Go to: [https://www.perplexity.ai/](https://www.perplexity.ai/)
   - Sign up or log in

2. **Access API**
   - Navigate to **Settings** or **API** section
   - Or contact Perplexity for API access
   - Generate an API key

3. **Save Your Key**
   - Copy the API key
   - Keep it secure!

### Step 2: Configure in App

Update `lib/core/config/app_config.dart`:

```dart
static const String perplexityApiKey = 'pplx-YOUR_API_KEY_HERE';
```

Or use environment variable:
```bash
flutter run --dart-define=PERPLEXITY_API_KEY=pplx-your_key
```

### Step 3: Verify Configuration

The AI chat will automatically use Perplexity for:
- Financial advice
- Budget recommendations
- Investment guidance
- Real-time market information

---

## 🏃 Running the App

### Step 1: Install Dependencies

```bash
cd "/Users/rouler4wd/CursorAI Coding Project/Pennypal"
flutter pub get
```

### Step 2: Start an Emulator

**For Android:**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch Medium_Phone_API_36.0
```

**For iOS:**
```bash
# Open simulator
open -a Simulator
```

### Step 3: Run the App

**Basic run:**
```bash
flutter run
```

**With specific device:**
```bash
flutter run -d emulator-5554  # Android
flutter run -d ios            # iOS
```

**With environment variables:**
```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

flutter run -d emulator-5554
```

### Step 4: Clean Build (If Issues)

```bash
flutter clean
flutter pub get
flutter run
```

---

## 🧪 Testing Features

### 1. Test Email/Password Authentication

1. **Open the app**
2. Click **"Sign Up"**
3. Enter:
   - Name: Your name
   - Email: your@email.com
   - Password: (min 8 characters)
4. Complete onboarding
5. You're in!

### 2. Test OTP Authentication

#### Phone OTP:
1. Click **"Login with OTP"**
2. Select **"Phone"** tab
3. Enter phone with country code: `+1234567890`
4. Click **"Send OTP"**
5. Check your SMS for the 6-digit code
6. Enter code → Auto-login!

#### Email OTP:
1. Click **"Login with OTP"**
2. Select **"Email"** tab
3. Enter your email
4. Click **"Send OTP"**
5. Check your inbox for the 6-digit code
6. Enter code → Auto-login!

### 3. Test Google OAuth

1. Click **"Continue with Google"**
2. Select your Google account
3. Grant permissions
4. Redirected back to app → Logged in!

### 4. Test Apple OAuth

1. Click **"Continue with Apple"**
2. Authenticate with Face ID/Touch ID
3. Choose email sharing option
4. Redirected back to app → Logged in!

### 5. Test AI Chat

1. Navigate to **Chat** tab
2. Ask a financial question:
   - "How should I budget my income?"
   - "What's a good savings rate?"
   - "Explain compound interest"
3. Get AI-powered advice!

---

## 🎨 App Features Overview

### Authentication Options:
- ✅ **Email/Password** - Traditional login
- ✅ **Google OAuth** - One-click Google login
- ✅ **Apple OAuth** - One-click Apple login
- ✅ **Phone OTP** - Passwordless SMS login
- ✅ **Email OTP** - Passwordless email login

### Core Features:
- 📊 **Dashboard** - Financial overview
- 💰 **Transactions** - Track income/expenses
- 🎯 **Budgets** - Set and monitor budgets
- 🏆 **Goals** - Savings goals tracking
- 📚 **Learn** - Financial education
- 💬 **AI Chat** - Financial advisor powered by Perplexity
- 🎮 **Quests** - Gamified financial challenges
- 👤 **Profile** - User settings and preferences

---

## 🔧 Advanced Configuration

### Deep Linking Setup

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>com.pennypal.app</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>pennypal</string>
    </array>
  </dict>
</array>
```

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<activity android:name=".MainActivity">
    <!-- Existing intent filters -->
    
    <!-- Add this for OAuth -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="pennypal" android:host="oauth-success" />
        <data android:scheme="pennypal" android:host="oauth-failure" />
    </intent-filter>
    
    <!-- Add this for magic URL -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="pennypal" android:host="auth" />
    </intent-filter>
</activity>
```

### Database Setup (Optional)

If you want to store additional user data:

1. **Create Database**
   - In Appwrite → **Databases**
   - Click **"Create Database"**
   - Name: `pennypal_db`

2. **Create Collections**
   - **users** - User profiles
   - **transactions** - Financial transactions
   - **budgets** - Budget data
   - **goals** - Savings goals

3. **Set Permissions**
   - Read: User
   - Write: User
   - Update: User
   - Delete: User

---

## 🐛 Troubleshooting

### Android Build Issues

**Problem**: `flutter_web_auth_2` build errors

**Solution**:
```bash
# Upgrade Flutter
flutter upgrade

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**If still failing**:
- Ensure Java is installed: `java -version`
- Set JAVA_HOME: `export JAVA_HOME=/opt/homebrew/opt/openjdk@17`
- Update Android SDK: `flutter doctor --android-licenses`

### OAuth Not Working

**Problem**: OAuth redirect fails

**Solutions**:
1. **Check Deep Links**
   - Verify `AndroidManifest.xml` has intent filters
   - Verify `Info.plist` has URL schemes

2. **Check Appwrite Console**
   - OAuth providers are enabled
   - Redirect URLs match: `pennypal://oauth-success`
   - Client ID and Secret are correct

3. **Check OAuth Provider**
   - Redirect URIs are added in Google/Apple console
   - App is in production mode (not testing)

### Phone OTP Not Working

**Problem**: SMS not received

**Solutions**:
1. **Check Phone Format**
   - Must include country code: `+1234567890`
   - No spaces or special characters

2. **Check SMS Provider**
   - Twilio account is active
   - Phone number is verified
   - Credits are available

3. **Check Appwrite**
   - Phone auth is enabled
   - SMS provider credentials are correct

### Email OTP Not Working

**Problem**: Email not received

**Solutions**:
1. **Check Email Format**
   - Valid email address
   - No typos

2. **Check Spam Folder**
   - OTP emails might be in spam

3. **Check SMTP**
   - SMTP is configured (or use Appwrite default)
   - Email service is active

### Perplexity API Errors

**Problem**: AI chat not working

**Solutions**:
1. **Check API Key**
   - Key is correct in `app_config.dart`
   - Key hasn't expired
   - Account has credits

2. **Check Network**
   - Internet connection is active
   - No firewall blocking API calls

3. **Check Logs**
   - Look for error messages in console
   - Verify API endpoint is correct

---

## 📱 Quick Start Commands

### Full Setup from Scratch:

```bash
# 1. Navigate to project
cd "/Users/rouler4wd/CursorAI Coding Project/Pennypal"

# 2. Install dependencies
flutter pub get

# 3. Start emulator (Android)
flutter emulators --launch Medium_Phone_API_36.0

# 4. Run app (wait 15 seconds for emulator to start)
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
flutter run -d emulator-5554
```

### Quick Run (If Already Set Up):

```bash
flutter run
```

---

## 🎯 Testing Checklist

### Authentication Testing:

- [ ] **Email/Password Sign Up**
  - Create new account
  - Verify email validation
  - Check password requirements

- [ ] **Email/Password Login**
  - Login with created account
  - Test "Forgot Password"
  - Verify error messages

- [ ] **Phone OTP**
  - Click "Login with OTP"
  - Enter phone number with country code
  - Receive SMS
  - Enter 6-digit code
  - Verify auto-login

- [ ] **Email OTP**
  - Click "Login with OTP"
  - Switch to Email tab
  - Enter email
  - Check inbox for code
  - Enter code and verify

- [ ] **Google OAuth**
  - Click "Continue with Google"
  - Select Google account
  - Verify redirect back to app

- [ ] **Apple OAuth**
  - Click "Continue with Apple"
  - Authenticate
  - Verify redirect back to app

### App Features Testing:

- [ ] **Dashboard**
  - View financial overview
  - Check widgets load correctly

- [ ] **Transactions**
  - Add new transaction
  - View transaction list
  - Edit transaction
  - Delete transaction

- [ ] **Budgets**
  - Create budget
  - View budget progress
  - Edit budget

- [ ] **Goals**
  - Set savings goal
  - Track progress
  - Mark as complete

- [ ] **AI Chat**
  - Ask financial question
  - Verify response quality
  - Test multiple questions

- [ ] **Profile**
  - View profile
  - Update settings
  - Logout

---

## 🔒 Security Best Practices

### 1. API Keys
```bash
# NEVER commit these to Git:
- Appwrite Project ID (if private)
- Perplexity API Key
- OAuth Client Secrets
- SMS Provider Credentials
```

### 2. Use Environment Variables
```bash
# Create .env file (already in .gitignore)
APPWRITE_PROJECT_ID=your_id
PERPLEXITY_API_KEY=your_key

# Run with:
flutter run --dart-define-from-file=.env
```

### 3. Production Checklist
- [ ] Remove `setSelfSigned(status: true)` from AppwriteService
- [ ] Use production Appwrite endpoint
- [ ] Enable rate limiting in Appwrite
- [ ] Set up proper error tracking
- [ ] Add analytics (optional)
- [ ] Test on real devices
- [ ] Review and update permissions

---

## 📊 Current Configuration

Your app is currently configured with:

### Appwrite:
```
Project ID: 68e749bf003cf9cf5cca
Endpoint: https://sfo.cloud.appwrite.io/v1
Database: pennypal_db
```

### Authentication Methods:
- ✅ Email/Password (Enabled)
- ✅ Google OAuth (Needs console setup)
- ✅ Apple OAuth (Needs console setup)
- ✅ Phone OTP (Needs SMS provider)
- ✅ Email OTP (Enabled with Appwrite default)

### AI Integration:
- ✅ Perplexity API (Needs API key)
- ✅ Financial advisor prompts configured
- ✅ Real-time information access

---

## 🚀 Next Steps

### Immediate (Required):
1. ✅ **App is running** - Already done!
2. 🔧 **Add your Perplexity API key** - For AI chat
3. 🔧 **Test email/password auth** - Works out of the box

### Short Term (Recommended):
4. 🔧 **Set up Google OAuth** - Better user experience
5. 🔧 **Configure Phone OTP** - Modern authentication
6. 🔧 **Test all features** - Ensure everything works

### Long Term (Optional):
7. 🔧 **Set up Apple OAuth** - For iOS users
8. 🔧 **Configure custom SMTP** - Branded emails
9. 🔧 **Add database collections** - Store user data
10. 🔧 **Deploy to production** - Launch your app!

---

## 📚 Additional Resources

### Documentation:
- **Appwrite Docs**: [https://appwrite.io/docs](https://appwrite.io/docs)
- **Flutter Docs**: [https://flutter.dev/docs](https://flutter.dev/docs)
- **Perplexity API**: Contact Perplexity for docs

### Support:
- **Appwrite Discord**: [https://appwrite.io/discord](https://appwrite.io/discord)
- **Flutter Community**: [https://flutter.dev/community](https://flutter.dev/community)

### Related Files:
- `OTP_SETUP_GUIDE.md` - Detailed OTP setup
- `QUICKSTART.md` - Quick reference
- `QUICK_REFERENCE.md` - Command reference

---

## 💡 Pro Tips

1. **Development Mode**
   - Use demo Appwrite project for testing
   - Test with your own phone/email
   - Monitor Appwrite console for activity

2. **Testing OTP**
   - Use real phone numbers during development
   - Check SMS delivery times
   - Test resend functionality

3. **OAuth Testing**
   - Test on real devices for best results
   - Emulators may have OAuth limitations
   - Use test Google/Apple accounts

4. **AI Chat**
   - Start with simple questions
   - Provide context for better answers
   - Monitor API usage and costs

5. **Performance**
   - Test on slower devices
   - Monitor memory usage
   - Optimize images and assets

---

## ✅ Setup Verification

Use this checklist to verify everything is working:

### Backend:
- [ ] Appwrite project created
- [ ] Project ID configured in app
- [ ] Can create account
- [ ] Can login with email/password

### Authentication:
- [ ] Email/Password works
- [ ] Phone OTP sends SMS
- [ ] Email OTP sends email
- [ ] Google OAuth redirects correctly
- [ ] Apple OAuth redirects correctly

### AI Features:
- [ ] Perplexity API key configured
- [ ] Chat sends messages
- [ ] Receives AI responses
- [ ] Responses are relevant

### App Features:
- [ ] Dashboard loads
- [ ] Can add transactions
- [ ] Can create budgets
- [ ] Can set goals
- [ ] Navigation works
- [ ] All screens accessible

---

## 🎉 You're All Set!

Your PennyPal app is now fully configured with:
- 🔐 **5 Authentication Methods**
- 🤖 **AI-Powered Financial Advisor**
- 📱 **Modern, Beautiful UI**
- 🚀 **Production-Ready Backend**

**Need help?** Check the troubleshooting section or reach out to the Appwrite/Flutter communities!

Happy coding! 💰📱✨
