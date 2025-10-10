# 📱 OTP Authentication Setup Guide

## Overview
PennyPal now supports passwordless authentication using OTP (One-Time Password) for both phone numbers and email addresses!

## ✅ What's Been Added

### 1. **Phone OTP Authentication**
- Send OTP codes to phone numbers
- Verify 6-digit codes
- Automatic session creation

### 2. **Email OTP Authentication**
- Send OTP codes to email addresses
- Verify 6-digit codes
- Automatic session creation

### 3. **New UI Screens**
- **OTP Login Page** - Choose between phone or email OTP
- **OTP Verification Page** - Enter and verify 6-digit codes
- Auto-focus and auto-submit functionality

### 4. **Updated AuthService**
- `createPhoneToken(phone)` - Send OTP to phone
- `verifyPhoneToken(userId, secret)` - Verify phone OTP
- `createEmailToken(email)` - Send OTP to email
- `verifyEmailToken(userId, secret)` - Verify email OTP
- `createMagicURLSession(email)` - Send magic link (bonus!)

## 🚀 How to Use

### For Users:
1. **Open the app** and go to the login screen
2. **Click "Login with OTP"** button
3. **Choose** Phone or Email tab
4. **Enter** your phone number (with country code) or email
5. **Click "Send OTP"**
6. **Enter the 6-digit code** you receive
7. **Auto-login** when code is verified!

### Phone Number Format:
- Must include country code
- Example: `+1234567890` (US number)
- Example: `+447911123456` (UK number)

### Email Format:
- Standard email format
- Example: `user@example.com`

## 🎨 Features

### OTP Login Page
- **Tabbed Interface** - Easy switching between phone and email
- **Input Validation** - Ensures correct format before sending
- **Loading States** - Visual feedback during API calls
- **Error Handling** - Clear error messages

### OTP Verification Page
- **6-Digit Input** - Individual boxes for each digit
- **Auto-Focus** - Automatically moves to next box
- **Auto-Submit** - Verifies when all digits are entered
- **Resend Code** - Easy resend with loading state
- **Back Navigation** - Return to previous screen

## 🔧 Appwrite Configuration

### Enable Phone Auth:
1. Go to **Appwrite Console** → Your Project
2. Navigate to **Auth** → **Settings**
3. Enable **Phone Authentication**
4. Configure **SMS Provider** (Twilio, MSG91, etc.)
5. Add your SMS provider credentials

### Enable Email OTP:
1. Go to **Appwrite Console** → Your Project
2. Navigate to **Auth** → **Settings**
3. Enable **Email OTP**
4. Configure **SMTP Settings** or use Appwrite's default

### SMS Providers Supported:
- Twilio
- MSG91
- Textmagic
- Telesign
- Vonage

## 📝 Code Examples

### Send Phone OTP:
```dart
final authService = AuthService();
final token = await authService.createPhoneToken(
  phone: '+1234567890',
);
// Navigate to verification page with token.userId
```

### Verify Phone OTP:
```dart
final session = await authService.verifyPhoneToken(
  userId: 'user_id_from_token',
  secret: '123456', // 6-digit code
);
// User is now logged in!
```

### Send Email OTP:
```dart
final token = await authService.createEmailToken(
  email: 'user@example.com',
);
// Navigate to verification page with token.userId
```

### Verify Email OTP:
```dart
final session = await authService.verifyEmailToken(
  userId: 'user_id_from_token',
  secret: '123456', // 6-digit code
);
// User is now logged in!
```

## 🎯 User Flow

```
Login Page
    ↓
Click "Login with OTP"
    ↓
OTP Login Page (Choose Phone/Email)
    ↓
Enter Phone/Email → Send OTP
    ↓
OTP Verification Page
    ↓
Enter 6-Digit Code → Auto-Verify
    ↓
Dashboard (Logged In!)
```

## 🔐 Security Features

1. **6-Digit Codes** - Secure and user-friendly
2. **Time-Limited** - Codes expire after a set time
3. **Single Use** - Each code can only be used once
4. **Rate Limiting** - Prevents spam/abuse
5. **Secure Transport** - All API calls over HTTPS

## 🎨 UI/UX Features

- **Modern Design** - Clean, intuitive interface
- **Responsive** - Works on all screen sizes
- **Accessibility** - Keyboard navigation support
- **Error Handling** - Clear, helpful error messages
- **Loading States** - Visual feedback for all actions

## 📱 Testing

### Test Phone OTP (Development):
1. Use a real phone number or Appwrite test numbers
2. Check your SMS for the code
3. Enter the code in the app

### Test Email OTP (Development):
1. Use a real email address
2. Check your inbox for the code
3. Enter the code in the app

## 🚨 Important Notes

1. **SMS Costs**: Phone OTP requires an SMS provider and may incur costs
2. **Email Setup**: Email OTP requires proper SMTP configuration
3. **Testing**: Use test credentials during development
4. **Production**: Configure production SMS/Email providers before launch

## 🎉 Benefits

### For Users:
- ✅ **No Password to Remember** - Just use your phone/email
- ✅ **Quick Login** - Faster than typing passwords
- ✅ **Secure** - OTP codes are time-limited and single-use
- ✅ **Convenient** - No password reset needed

### For Developers:
- ✅ **Easy Integration** - Built-in Appwrite support
- ✅ **Secure by Default** - Appwrite handles security
- ✅ **Flexible** - Support both phone and email
- ✅ **Scalable** - Works for any number of users

## 📚 Next Steps

1. **Configure Appwrite** - Set up SMS and Email providers
2. **Test Thoroughly** - Try both phone and email OTP
3. **Monitor Usage** - Track OTP send/verify rates
4. **Optimize Costs** - Choose cost-effective SMS providers
5. **User Education** - Help users understand OTP login

## 🔗 Related Files

- `lib/features/auth/data/services/auth_service.dart` - OTP methods
- `lib/features/auth/presentation/pages/otp_login_page.dart` - Login UI
- `lib/features/auth/presentation/pages/otp_verification_page.dart` - Verification UI
- `lib/features/auth/presentation/pages/login_page.dart` - Main login (with OTP button)

## 💡 Tips

1. **Country Codes**: Always include country code for phone numbers
2. **Testing**: Use your own phone/email during development
3. **Error Messages**: Provide clear guidance when OTP fails
4. **Resend**: Allow users to resend codes easily
5. **Timeout**: Show countdown timer for code expiry (optional enhancement)

---

**Your PennyPal app now has modern, secure, passwordless authentication! 🎉**

