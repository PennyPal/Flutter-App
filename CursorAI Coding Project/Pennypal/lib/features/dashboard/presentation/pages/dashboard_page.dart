import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/services/user_service.dart';

/// Main dashboard/home page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserService().getGreetingMessage(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Show notifications
                        },
                        icon: const Icon(Icons.notifications_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: AppTheme.sm),
                      IconButton(
                        onPressed: () {
                          context.go(RouteNames.settings);
                        },
                        icon: const Icon(Icons.settings_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.xxl),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl.x),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onBackground.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppTheme.sm),
                    Text(
                      '\$12,450.00', // TODO: Get from provider
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppTheme.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _BalanceItem(
                            label: 'Income',
                            amount: '\$5,200.00',
                            icon: Icons.trending_up,
                            color: AppColors.success,
                          ),
                        ),
                        Expanded(
                          child: _BalanceItem(
                            label: 'Expenses',
                            amount: '\$3,450.00',
                            icon: Icons.trending_down,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Add Transaction',
                      icon: Icons.add,
                      onTap: () => context.go(RouteNames.transactionAdd),
                    ),
                  ),
                  const SizedBox(width: AppTheme.lg),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'View Budgets',
                      icon: Icons.pie_chart_outline,
                      onTap: () => context.go(RouteNames.budgets),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Recent transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.transactions),
                    child: const Text('See All'),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.lg),
              
              // Transaction list
              ..._buildRecentTransactions(),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Budget progress
              Text(
                'Budget Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              
              const SizedBox(height: AppTheme.lg),
              
              _BudgetProgressCard(),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Goals section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Goals Progress',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.goals),
                    child: const Text('View All'),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.lg),
              
              _GoalProgressCard(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecentTransactions() {
    // TODO: Get from provider
    final transactions = [
      {'title': 'Grocery Shopping', 'amount': '-\$85.50', 'category': 'Food', 'icon': Icons.shopping_cart},
      {'title': 'Salary Deposit', 'amount': '+\$2,500.00', 'category': 'Income', 'icon': Icons.work},
      {'title': 'Coffee Shop', 'amount': '-\$12.00', 'category': 'Food', 'icon': Icons.local_cafe},
    ];
    
    return transactions.map((transaction) => _TransactionTile(
      title: transaction['title'] as String,
      amount: transaction['amount'] as String,
      category: transaction['category'] as String,
      icon: transaction['icon'] as IconData,
    )).toList();
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppTheme.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onBackground.withOpacity(0.8),
              ),
            ),
            Text(
              amount,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.title,
    required this.amount,
    required this.category,
    required this.icon,
  });

  final String title;
  final String amount;
  final String category;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = amount.startsWith('+');
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackground,
                  ),
                ),
                Text(
                  category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isIncome ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: AppTheme.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$2,100 / \$3,000',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSecondary,
                ),
              ),
              Text(
                '70%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
          ),
        ],
      ),
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vacation Fund',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: AppTheme.xs),
                Text(
                  '\$1,250 / \$2,000',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.sm),
                LinearProgressIndicator(
                  value: 0.625,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                ),
              ],
            ),
          ),
          Text(
            '62%',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
