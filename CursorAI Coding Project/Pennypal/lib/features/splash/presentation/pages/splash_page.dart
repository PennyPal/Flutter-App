import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/services/settings_service.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';

/// Splash screen with app logo and loading animation
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _controller.forward();

    // Navigate to next screen after animation using a cancellable Timer
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;
      final auth = AuthService();
      try {
        final isAuth = await auth.isAuthenticated();
        if (isAuth) {
          // load per-user settings and go to home
          final user = await auth.getCurrentUser();
          final userKey = user?.email ?? '';
          if (userKey.isNotEmpty) {
            await SettingsService().loadForUser(userKey);
          }
          if (mounted) context.go(RouteNames.home); // main shell home route
        } else {
          if (mounted) context.go('/welcome');
        }
      } catch (e) {
        if (mounted) context.go('/welcome');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pig Mascot
                      Image.asset(
                        'assets/images/pennypal_logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 32),
                      
                      // App Name
                      Text(
                        'PENNY PAL',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Tagline
                      Text(
                        'Your financial friend',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
