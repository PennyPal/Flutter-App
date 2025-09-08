import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Welcome page matching Figma design
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.xxl),
            child: Column(
              children: [
                const Spacer(),
                
                // Pig Mascot
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.savings,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: AppTheme.xxl),
                
                // Welcome Back text
                Text(
                  'Welcome Back!',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(),
                
                // Action buttons
                Column(
                  children: [
                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go(RouteNames.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.lg),
                    
                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go(RouteNames.register),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.onSecondary,
                          side: BorderSide(color: AppColors.onSecondary, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppTheme.lg),
                    
                    // Guest mode button
                    TextButton(
                      onPressed: () => context.go(RouteNames.home),
                      child: Text(
                        'Continue as Guest',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
