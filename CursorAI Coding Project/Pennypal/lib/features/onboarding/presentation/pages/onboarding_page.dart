import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/services/user_service.dart';

/// Onboarding flow with multiple screens
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // User setup data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final Map<String, double> _budgetCategories = {
    'Food & Dining': 0,
    'Transportation': 0,
    'Entertainment': 0,
    'Shopping': 0,
    'Bills & Utilities': 0,
    'Healthcare': 0,
  };

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
    // New setup pages
    OnboardingContent(
      title: 'Let\'s Get Personal',
      description: 'Tell us a bit about yourself to personalize your experience.',
      icon: Icons.person,
      color: AppColors.success,
    ),
    OnboardingContent(
      title: 'Monthly Income',
      description: 'Help us understand your financial situation.',
      icon: Icons.attach_money,
      color: AppColors.info,
    ),
    OnboardingContent(
      title: 'Set Your Budgets',
      description: 'Create spending limits for different categories.',
      icon: Icons.pie_chart_outline,
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill name from registration if available
    _nameController.text = UserService().userName;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    // Validate setup pages before proceeding
    if (_currentPage == 4) { // Name setup page
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your name'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else if (_currentPage == 5) { // Income setup page
      if (_incomeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your monthly income'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    
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
    // Save user setup data to UserService
    UserService().completeOnboarding(
      name: _nameController.text.trim(),
      income: double.tryParse(_incomeController.text) ?? 0.0,
      budgets: _budgetCategories,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome ${_nameController.text}! Your account is set up.'),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Navigate to home dashboard - user is now fully set up
    context.go(RouteNames.home);
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
                  
                  // Show different content for setup pages
                  if (index >= 4) { // Setup pages start at index 4
                    return _buildSetupPage(page, index);
                  }
                  
                  // Regular intro pages
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
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

  Widget _buildSetupPage(OnboardingContent page, int index) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        children: [
          // Icon and title section
          Container(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: page.color,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    page.icon,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppTheme.lg),
                Text(
                  page.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.sm),
                Text(
                  page.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Setup content based on page index
          Expanded(
            child: _buildSetupContent(index),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupContent(int index) {
    switch (index) {
      case 4: // Name setup
        return _buildNameSetup();
      case 5: // Income setup
        return _buildIncomeSetup();
      case 6: // Budget setup
        return _buildBudgetSetup();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNameSetup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
          ),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.onBackground),
                decoration: const InputDecoration(
                  labelText: 'What should we call you?',
                  labelStyle: TextStyle(color: AppColors.onSurface),
                  hintText: 'Enter your first name',
                  hintStyle: TextStyle(color: AppColors.onSurface),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.sm),
              Text(
                'This name will appear throughout the app',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeSetup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
          ),
          child: Column(
            children: [
              TextField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.onBackground),
                decoration: const InputDecoration(
                  labelText: 'Monthly Income',
                  labelStyle: TextStyle(color: AppColors.onSurface),
                  hintText: '0.00',
                  hintStyle: TextStyle(color: AppColors.onSurface),
                  prefixText: '\$ ',
                  prefixStyle: TextStyle(color: AppColors.onBackground),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.sm),
              Text(
                'This helps us suggest appropriate budgets',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSetup() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set monthly spending limits:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.lg),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _budgetCategories.keys.length,
                  itemBuilder: (context, index) {
                    final category = _budgetCategories.keys.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.sm),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onBackground,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.sm),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.onBackground),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                prefixStyle: TextStyle(color: AppColors.onBackground),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.sm,
                                  vertical: AppTheme.xs,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _budgetCategories[category] = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppTheme.sm),
              Text(
                'You can always adjust these later',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
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
