import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/auth_service.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../../shared/providers/settings_notifier.dart';
import '../../../../shared/services/user_service.dart';
import '../../../../shared/services/gamification_service.dart';
import 'otp_login_page.dart';

/// Login page with email/password authentication
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // After successful sign-in, load per-user settings and update notifier
      try {
        final user = await _authService.getCurrentUser();
        final userKey = (user != null && (user.email?.isNotEmpty == true))
            ? user.email!
            : _emailController.text.trim();
        await SettingsService().loadForUser(userKey);
        // Update notifier using public API to persist and notify
        final themeMode = SettingsService().themeMode;
        final accent = SettingsService().accentColor;
        ref.read(settingsNotifierProvider.notifier).updateThemeMode(themeMode);
        ref.read(settingsNotifierProvider.notifier).updateAccentColor(accent);
      } catch (_) {
        // Non-fatal: if settings can't be loaded, continue to app
      }

      if (mounted) {
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
      // Attempt to load settings for the authenticated user
      try {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          final userKey = user.email ?? UserService().username;
          await SettingsService().loadForUser(userKey);
          final themeMode = SettingsService().themeMode;
          final accent = SettingsService().accentColor;
          ref.read(settingsNotifierProvider.notifier).updateThemeMode(themeMode);
          ref.read(settingsNotifierProvider.notifier).updateAccentColor(accent);
        }
      } catch (_) {}

      if (mounted) {
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithApple();
      // Attempt to load settings for the authenticated user
      try {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          final userKey = user.email ?? UserService().username;
          await SettingsService().loadForUser(userKey);
          final themeMode = SettingsService().themeMode;
          final accent = SettingsService().accentColor;
          ref.read(settingsNotifierProvider.notifier).updateThemeMode(themeMode);
          ref.read(settingsNotifierProvider.notifier).updateAccentColor(accent);
        }
      } catch (_) {}

      if (mounted) {
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      await _authService.sendPasswordRecoveryEmail(_emailController.text.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password recovery email sent! Check your inbox.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _goToOTPLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OTPLoginPage(),
      ),
    );
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Directly set up test user
      final userService = UserService();
      userService.completeOnboarding(
        name: 'Test User',
        income: 500.0,
        budgets: {},
      );
      
      // Initialize gamification
      final gamificationService = GamificationService();
      gamificationService.initializeWithSampleData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test login successful!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test login failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => context.go('/welcome'),
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              hoverColor: const Color(0xFFF3E8F2), // Darker pink for hover
              shape: const CircleBorder(),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradient,
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // Logo and title
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/pennypal_logo.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: AppTheme.sm),
                      Text(
                        'Sign In',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSecondary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.sm),
                      Text(
                        'Welcome back to PennyPal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppTheme.md),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text('Forgot Password?'),
                  ),
                ),
                
                const SizedBox(height: AppTheme.lg),
                
                // sign in button (fixed green, unaffected by user-selected accent)
                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary,
                            ),
                          ),
                        )
                      : const Text('sign in'),
                ),
                
                const SizedBox(height: AppTheme.lg),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
                      child: Text(
                        'or',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: AppTheme.lg),
                
                // Social login buttons
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continue with Google'),
                ),
                
                const SizedBox(height: AppTheme.md),
                
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithApple,
                  icon: const Icon(Icons.apple, size: 24),
                  label: const Text('Continue with Apple'),
                ),
                
                const SizedBox(height: AppTheme.xl),
                
                // OTP Login
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _goToOTPLogin,
                  icon: const Icon(Icons.sms_outlined, size: 24),
                  label: const Text('Login with OTP'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
                
                const SizedBox(height: AppTheme.xl),
                
                // Test Login Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testLogin,
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text('Test Login (Dev Only)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                
                const SizedBox(height: AppTheme.xxxl),
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(RouteNames.register);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
