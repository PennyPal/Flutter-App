import 'package:flutter/material.dart';
import 'dart:math';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../enhanced_methods.dart';

/// Comprehensive Learning page with financial education content
class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  
  // Track completed lessons
  final Set<String> _completedLessons = {};
  final Set<String> _bookmarkedLessons = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Financial Education'),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSearchDialog(context),
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface,
            indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Featured'),
            Tab(text: 'Courses'),
            Tab(text: 'Tools'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FeaturedTab(),
          _CoursesTab(),
          _ToolsTab(),
          _ProgressTab(),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Lessons'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for topics...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement search functionality
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

class _FeaturedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _WelcomeSection(),

          SizedBox(height: AppTheme.lg),

          // Featured Course
          _FeaturedCourseCard(),

          SizedBox(height: AppTheme.xl),

          // Quick Actions
          _QuickActionsGrid(),

          SizedBox(height: AppTheme.xl),

          // Today's Tip
          _TodaysTipCard(),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
  gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha((0.85 * 255).round())]),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
                    const Icon(
                Icons.lightbulb,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: AppTheme.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue Learning',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      'Build your financial knowledge step by step',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withAlpha((0.9 * 255).round()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.lg),
          Row(
            children: [
              _StatCard(
                label: 'Lessons Completed',
                value: '12',
                icon: Icons.check_circle,
              ),
              const SizedBox(width: AppTheme.md),
              _StatCard(
                label: 'Study Streak',
                value: '5 days',
                icon: Icons.local_fire_department,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withAlpha((0.2 * 255).round()),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withAlpha((0.8 * 255).round()),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () => LearnPageMethods.startDetailedCourse(context, {
        'title': 'Investment Basics',
        'color': AppColors.success,
        'icon': Icons.trending_up,
        'lessons': 8,
        'duration': '2 hours',
        'rating': 4.9,
      }),
      borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
      child: Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Course',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Smart Investing 101',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.sm,
                  vertical: AppTheme.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: Text(
                  'NEW',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          Text(
            'Learn how to build wealth through smart investment strategies. Perfect for beginners who want to start investing.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Start course
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                  ),
                  child: const Text('Start Course'),
                ),
              ),
              const SizedBox(width: AppTheme.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '4.9 ⭐',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '8 lessons',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = [
      {
        'title': 'Budget Calculator',
        'icon': Icons.calculate,
        'color': AppColors.primary,
        'description': 'Plan your monthly budget'
      },
      {
        'title': 'Debt Tracker',
        'icon': Icons.trending_down,
        'color': AppColors.error,
        'description': 'Track debt payments'
      },
      {
        'title': 'Savings Goal',
        'icon': Icons.savings,
        'color': AppColors.success,
        'description': 'Set and track goals'
      },
      {
        'title': 'Investment Calculator',
        'icon': Icons.show_chart,
        'color': AppColors.info,
        'description': 'Calculate returns'
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
        ),
        const SizedBox(height: AppTheme.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: AppTheme.md,
            mainAxisSpacing: AppTheme.md,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _QuickActionCard(
              title: action['title'] as String,
              icon: action['icon'] as IconData,
              color: action['color'] as Color,
              description: action['description'] as String,
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to tool
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          border: Border.all(
            color: color.withAlpha((0.2 * 255).round()),
            width: 1,
          ),
          boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withAlpha((0.1 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.md),
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.xs),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaysTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
          color: AppColors.info.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: AppColors.info.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: AppColors.info,
                size: 24,
              ),
              const SizedBox(width: AppTheme.sm),
              Text(
                'Today\'s Financial Tip',
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          Text(
            'The 50/30/20 rule: Allocate 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.md),
          TextButton(
            onPressed: () {
              // TODO: Learn more about this tip
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}

class _CoursesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        'title': 'Personal Budgeting Mastery',
        'description': 'Learn to create and stick to a budget that works for you',
        'lessons': 8,
        'duration': '2 hours',
        'difficulty': 'Beginner',
        'rating': 4.8,
        'color': AppColors.primary,
        'icon': Icons.account_balance_wallet,
      },
      {
        'title': 'Investment Fundamentals',
        'description': 'Understand stocks, bonds, and building a portfolio',
        'lessons': 12,
        'duration': '3 hours',
        'difficulty': 'Intermediate',
        'rating': 4.9,
        'color': AppColors.success,
        'icon': Icons.trending_up,
      },
      {
        'title': 'Debt Management Strategies',
        'description': 'Effective ways to pay down debt and improve credit',
        'lessons': 6,
        'duration': '1.5 hours',
        'difficulty': 'Beginner',
        'rating': 4.7,
        'color': AppColors.warning,
        'icon': Icons.credit_card,
      },
      {
        'title': 'Retirement Planning',
        'description': 'Plan for a secure financial future',
        'lessons': 10,
        'duration': '2.5 hours',
        'difficulty': 'Advanced',
        'rating': 4.8,
        'color': AppColors.info,
        'icon': Icons.elderly,
      },
      {
        'title': 'Tax Optimization',
        'description': 'Maximize deductions and minimize tax burden',
        'lessons': 7,
        'duration': '2 hours',
        'difficulty': 'Intermediate',
        'rating': 4.6,
        'color': AppColors.error,
        'icon': Icons.receipt_long,
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.lg),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _CourseCard(course: course);
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.lg),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.sm),
                decoration: BoxDecoration(
                  color: (course['color'] as Color).withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: Icon(
                  course['icon'] as IconData,
                  color: course['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                    ),
                    Text(
                      course['description'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          Row(
            children: [
              _CourseInfo(
                icon: Icons.play_circle_outline,
                text: '${course['lessons']} lessons',
              ),
              const SizedBox(width: AppTheme.md),
              _CourseInfo(
                icon: Icons.schedule,
                text: course['duration'] as String,
              ),
              const SizedBox(width: AppTheme.md),
              _CourseInfo(
                icon: Icons.signal_cellular_alt,
                text: course['difficulty'] as String,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          Row(
            children: [
              Text(
                '${course['rating']} ⭐',
                style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => LearnPageMethods.startDetailedCourse(context, course),
                style: ElevatedButton.styleFrom(
                  backgroundColor: course['color'] as Color,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Start Course'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseInfo extends StatelessWidget {
  const _CourseInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.onSurface,
        ),
        const SizedBox(width: AppTheme.xs),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ToolsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Calculators & Tools',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          _QuickActionsGrid(),
          const SizedBox(height: AppTheme.xl),
          _AdvancedToolsSection(),
        ],
      ),
    );
  }
}

class _AdvancedToolsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tools = [
      {
        'title': 'Compound Interest Calculator',
        'description': 'See how your money grows over time',
        'icon': Icons.trending_up,
        'color': AppColors.success,
      },
      {
        'title': 'Loan Payment Calculator',
        'description': 'Calculate monthly payments and interest',
        'icon': Icons.home,
        'color': AppColors.warning,
      },
      {
        'title': 'Retirement Planner',
        'description': 'Plan for your golden years',
        'icon': Icons.elderly,
        'color': AppColors.info,
      },
      {
        'title': 'Tax Estimator',
        'description': 'Estimate your tax liability',
        'icon': Icons.receipt,
        'color': AppColors.error,
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Tools',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.lg),
        ...tools.map((tool) => _ToolTile(tool: tool)),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});

  final Map<String, dynamic> tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.sm),
          decoration: BoxDecoration(
            color: (tool['color'] as Color).withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
          ),
          child: Icon(
            tool['icon'] as IconData,
            color: tool['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          tool['title'] as String,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          tool['description'] as String,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.colorScheme.onSurface,
        ),
        onTap: () => LearnPageMethods.openTool(context, tool['title'] as String),
      ),
    );
  }
}

class _ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressOverview(),
          const SizedBox(height: AppTheme.xl),
          _CompletedCoursesSection(),
          const SizedBox(height: AppTheme.xl),
          _AchievementsSection(),
        ],
      ),
    );
  }
}

class _ProgressOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Learning Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.lg),
          Row(
            children: [
              Expanded(
                child: _ProgressCard(
                  title: 'Courses Completed',
                  value: '3/12',
                  percentage: 0.25,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppTheme.md),
              Expanded(
                child: _ProgressCard(
                  title: 'Study Hours',
                  value: '15.5',
                  percentage: 1.0,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.value,
    required this.percentage,
    required this.color,
  });

  final String title;
  final String value;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
  color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.xs),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppTheme.sm),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}

class _CompletedCoursesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCourses = [
      {'title': 'Personal Budgeting Mastery', 'completedAt': '2 days ago', 'rating': 4.8},
      {'title': 'Emergency Fund Planning', 'completedAt': '1 week ago', 'rating': 4.9},
      {'title': 'Credit Score Basics', 'completedAt': '2 weeks ago', 'rating': 4.7},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed Courses',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.lg),
        ...completedCourses.map((course) => _CompletedCourseCard(course: course)),
      ],
    );
  }
}

class _CompletedCourseCard extends StatelessWidget {
  const _CompletedCourseCard({required this.course});

  final Map<String, dynamic> course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: AppColors.success.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.sm),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Completed ${course['completedAt']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${course['rating']} ⭐',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = [
      {'title': 'First Course Complete', 'description': 'Completed your first course', 'icon': Icons.school, 'earned': true},
      {'title': 'Study Streak', 'description': 'Studied 5 days in a row', 'icon': Icons.local_fire_department, 'earned': true},
      {'title': 'Knowledge Seeker', 'description': 'Complete 5 courses', 'icon': Icons.library_books, 'earned': false},
      {'title': 'Financial Guru', 'description': 'Complete all beginner courses', 'icon': Icons.emoji_events, 'earned': false},
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: AppTheme.md,
            mainAxisSpacing: AppTheme.md,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return _AchievementCard(achievement: achievement);
          },
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final Map<String, dynamic> achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEarned = achievement['earned'] as bool;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
  color: isEarned ? AppColors.warning.withAlpha((0.1 * 255).round()) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: isEarned ? AppColors.warning.withAlpha((0.3 * 255).round()) : theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement['icon'] as IconData,
            color: isEarned ? AppColors.warning : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
            size: 32,
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            achievement['title'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isEarned ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.xs),
          Text(
            achievement['description'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isEarned ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}