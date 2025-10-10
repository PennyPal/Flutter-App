# 🚀 PennyPal Quick Reference Card

## ⚡ Super Quick Setup (10 Minutes Total)

### 1. Appwrite Setup (5 min)
```
1. Go to: https://cloud.appwrite.io/
2. Sign up → Create Project → Name it "PennyPal"
3. Settings → Copy Project ID
4. Auth → Enable Email/Password + Google OAuth
```

### 2. Perplexity API (3 min)
```
1. Go to: https://www.perplexity.ai/
2. Sign up → Get API Key
3. Copy API Key
```

### 3. Configure App (2 min)
```dart
// Edit: lib/core/config/app_config.dart
static const String appwriteProjectId = 'PASTE_PROJECT_ID_HERE';
static const String perplexityApiKey = 'PASTE_API_KEY_HERE';
```

### 4. Run! 
```bash
flutter run
```

---

## 📱 Test Features Immediately

### Test Authentication
1. Open app → Click "Sign Up"
2. Enter: email, password, name
3. Click "Create Account"
4. ✅ Should navigate to onboarding

### Test Google Sign In
1. Login page → "Continue with Google"
2. Select Google account
3. ✅ Should sign in successfully

### Test AI Chat
1. Navigate to Chat tab
2. Type: "How do I start budgeting?"
3. ✅ Should get detailed response with tips

---

## 🔧 Common Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Clean build
flutter clean

# Check for errors
flutter analyze

# Run tests
flutter test
```

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `lib/core/config/app_config.dart` | **PUT API KEYS HERE** |
| `lib/features/auth/data/services/auth_service.dart` | Auth logic |
| `lib/features/chat/data/services/perplexity_service.dart` | AI chat logic |
| `QUICKSTART.md` | Detailed setup guide |
| `SETUP_GUIDE.md` | Complete documentation |

---

## 🆘 Quick Fixes

### OAuth Not Working?
```
Check: ios/Runner/Info.plist has pennypal:// scheme
Check: android/app/src/main/AndroidManifest.xml has intent-filter
```

### API Errors?
```
1. Verify API keys are correct (no typos!)
2. Check network connection
3. Restart app: flutter clean && flutter run
```

### Build Errors?
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

---

## 🎯 What Works Now

✅ Email/Password Sign Up
✅ Email/Password Sign In  
✅ Google OAuth Sign In
✅ Apple OAuth Sign In (iOS/macOS)
✅ Password Recovery
✅ AI Financial Advice Chat
✅ Real-time Market Data
✅ Session Management

---

## 📚 Documentation Files

| File | When to Use |
|------|-------------|
| `QUICK_REFERENCE.md` | **This file!** Quick lookups |
| `QUICKSTART.md` | First time setup |
| `SETUP_GUIDE.md` | Detailed configuration |
| `IMPLEMENTATION_COMPLETE.md` | Full feature list |
| `CHANGES.md` | What changed |
| `README.md` | Project overview |

---

## 🔑 API Key Locations

### Appwrite Project ID
```
Dashboard → Settings → Project ID
```

### Google OAuth Credentials
```
Appwrite → Auth → OAuth2 → Google
Follow wizard to connect Google Cloud Console
```

### Perplexity API Key
```
Perplexity.ai → Account → API Settings
```

---

## 💻 Environment Variables (Alternative Method)

Instead of editing `app_config.dart`, use:

```bash
flutter run \
  --dart-define=APPWRITE_PROJECT_ID=your_id \
  --dart-define=PERPLEXITY_API_KEY=your_key
```

Or create `config.json`:
```json
{
  "APPWRITE_PROJECT_ID": "your_id",
  "PERPLEXITY_API_KEY": "your_key"
}
```

Then run:
```bash
flutter run --dart-define-from-file=config.json
```

---

## 🐛 Error Messages Explained

| Error | Fix |
|-------|-----|
| "Invalid credentials" | Check email/password |
| "API key not configured" | Add API key to app_config.dart |
| "Invalid Project ID" | Verify Appwrite project ID |
| "Network error" | Check internet connection |
| "OAuth failed" | Configure deep links |

---

## 🎨 App Structure

```
lib/
├── core/
│   ├── config/app_config.dart    ← API KEYS HERE
│   └── services/appwrite_service.dart
├── features/
│   ├── auth/
│   │   └── data/services/auth_service.dart
│   ├── chat/
│   │   └── data/services/perplexity_service.dart
│   └── [other features]/
```

---

## ⚡ Pro Tips

1. **Use environment variables** for production
2. **Never commit API keys** to Git (already protected)
3. **Test OAuth** on real device (not just simulator)
4. **Check Appwrite logs** for auth issues
5. **Keep dependencies updated**: `flutter pub upgrade`

---

## 📞 Need Help?

1. Read `QUICKSTART.md` for step-by-step guide
2. Check `SETUP_GUIDE.md` for detailed docs
3. Review error messages carefully
4. Test with sample data first
5. Verify API keys are active

---

## ✅ Quick Health Check

Run this to verify everything:

```bash
# 1. Dependencies installed?
flutter pub get

# 2. No errors?
flutter analyze

# 3. Can build?
flutter build apk --debug

# 4. Can run?
flutter run
```

If all pass → You're good to go! 🎉

---

## 🔄 Update Checklist

When updating the app:

- [ ] Run `flutter pub get`
- [ ] Run `flutter clean` if issues
- [ ] Test authentication flows
- [ ] Test AI chat
- [ ] Check for breaking changes
- [ ] Update documentation if needed

---

**Keep this file handy for quick reference!** 📌

For detailed information, see:
- `QUICKSTART.md` - Step-by-step setup
- `SETUP_GUIDE.md` - Complete guide
- `IMPLEMENTATION_COMPLETE.md` - What's done

---

**Version:** 1.0.0  
**Last Updated:** 2025  
**Status:** ✅ Ready for Development

