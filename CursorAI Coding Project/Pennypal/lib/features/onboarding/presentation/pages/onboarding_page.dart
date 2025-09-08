import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Onboarding flow with multiple screens
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Welcome to PennyPal',
      description: 'Your personal finance companion that makes budgeting fun and rewarding.',
      icon: Icons.account_balance_wallet,
      color: AppColors.primary,
    ),
    OnboardingContent(
      title: 'Track Every Penny',
      description: 'Easily log transactions, categorize spending, and see where your money goes.',
      icon: Icons.receipt_long,
      color: AppColors.accent,
    ),
    OnboardingContent(
      title: 'Smart Budgeting',
      description: 'Set budgets for different categories and get alerts when you\'re close to limits.',
      icon: Icons.pie_chart,
      color: AppColors.secondary,
    ),
    OnboardingContent(
      title: 'Level Up Your Finances',
      description: 'Earn XP, unlock achievements, and complete quests as you build better money habits.',
      icon: Icons.emoji_events,
      color: AppColors.warning,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppTheme.normal,
        curve: AppTheme.standardCurve,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // TODO: Mark onboarding as completed in SharedPreferences
    context.go(RouteNames.login);
  }

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
        child: Column(
          children: [
            // Header with skip button
            Padding(
              padding: const EdgeInsets.all(AppTheme.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppTheme.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: page.color,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: page.color.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppTheme.xxxl),

                        // Title
                        Text(
                          page.title,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.lg),

                        // Description
                        Text(
                          page.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurface,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Padding(
              padding: const EdgeInsets.all(AppTheme.xxl),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.xxl),

                  // Continue/Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class OnboardingContent {
  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
