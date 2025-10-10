import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite/enums.dart';
import '../../../../core/services/appwrite_service.dart';

/// Authentication service using Appwrite
class AuthService {
  final AppwriteService _appwriteService = AppwriteService();

  Account get _account => _appwriteService.account;

  /// Sign up a new user with email and password
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // First, check if there's an existing session and delete it
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (e) {
        // Ignore if no session exists
      }

      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Automatically sign in after registration
      try {
        await signInWithEmail(email: email, password: password);
      } catch (e) {
        // If auto-login fails, that's okay - user can login manually
        print('Auto-login after signup failed: $e');
      }

      return user;
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<Session> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // First, try to delete any existing session
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (e) {
        // Ignore if no session exists
      }

      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return session;
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  /// Sign in with Google OAuth2
  Future<void> signInWithGoogle() async {
    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.google,
        // Success URL after OAuth (deep link to your app)
        success: 'pennypal://oauth-success',
        // Failure URL after OAuth
        failure: 'pennypal://oauth-failure',
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }

  /// Sign in with Apple OAuth2
  Future<void> signInWithApple() async {
    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.apple,
        success: 'pennypal://oauth-success',
        failure: 'pennypal://oauth-failure',
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Apple: ${e.toString()}');
    }
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        // User not authenticated
        return null;
      }
      throw _handleAppwriteException(e);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// Send password recovery email
  Future<void> sendPasswordRecoveryEmail(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'pennypal://reset-password',
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to send recovery email: ${e.toString()}');
    }
  }

  /// Complete password recovery
  Future<void> completePasswordRecovery({
    required String userId,
    required String secret,
    required String password,
  }) async {
    try {
      await _account.updateRecovery(
        userId: userId,
        secret: secret,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  /// Update user name
  Future<User> updateName(String name) async {
    try {
      return await _account.updateName(name: name);
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to update name: ${e.toString()}');
    }
  }

  /// Update user email
  Future<User> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _account.updateEmail(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to update email: ${e.toString()}');
    }
  }

  /// Update user password
  Future<User> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      return await _account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to update password: ${e.toString()}');
    }
  }

  // ==================== OTP Authentication ====================

  /// Create phone OTP session
  /// Sends OTP code to the provided phone number
  Future<Token> createPhoneToken({
    required String phone,
  }) async {
    try {
      return await _account.createPhoneToken(
        userId: ID.unique(),
        phone: phone,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to send phone OTP: ${e.toString()}');
    }
  }

  /// Verify phone OTP and create session
  Future<Session> verifyPhoneToken({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.createSession(
        userId: userId,
        secret: secret,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to verify phone OTP: ${e.toString()}');
    }
  }

  /// Create email OTP session
  /// Sends OTP code to the provided email
  Future<Token> createEmailToken({
    required String email,
  }) async {
    try {
      return await _account.createEmailToken(
        userId: ID.unique(),
        email: email,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to send email OTP: ${e.toString()}');
    }
  }

  /// Verify email OTP and create session
  Future<Session> verifyEmailToken({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.createSession(
        userId: userId,
        secret: secret,
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to verify email OTP: ${e.toString()}');
    }
  }

  /// Create magic URL session (passwordless email login)
  Future<Token> createMagicURLSession({
    required String email,
  }) async {
    try {
      return await _account.createMagicURLToken(
        userId: ID.unique(),
        email: email,
        url: 'pennypal://auth/magic-url',
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to send magic link: ${e.toString()}');
    }
  }

  /// Handle Appwrite exceptions and return user-friendly messages
  String _handleAppwriteException(AppwriteException e) {
    print('Appwrite Error - Code: ${e.code}, Type: ${e.type}, Message: ${e.message}');
    
    switch (e.code) {
      case 401:
        return 'Invalid credentials. Please check your email and password.';
      case 409:
        return 'An account with this email already exists. Try logging in instead.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      case 400:
        if (e.message?.contains('password') ?? false) {
          return 'Password must be at least 8 characters long.';
        }
        return e.message ?? 'Invalid request. Please check your input.';
      default:
        return e.message ?? 'An unexpected error occurred. Please try again.';
    }
  }
}

