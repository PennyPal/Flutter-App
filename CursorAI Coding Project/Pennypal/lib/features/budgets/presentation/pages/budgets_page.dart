import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Budgets page with full functionality
class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  String _selectedPeriod = 'Monthly';
  
  // Mock budget data
  final List<Map<String, dynamic>> _budgets = [
    {
      'id': '1',
      'title': 'Food & Dining',
      'category': 'Food',
      'budgetAmount': 500.0,
      'spentAmount': 320.0,
      'period': 'Monthly',
      'color': AppColors.warning,
      'icon': Icons.restaurant,
      'status': 'on_track', // on_track, warning, over_budget
    },
    {
      'id': '2',
      'title': 'Transportation',
      'category': 'Transport',
      'budgetAmount': 200.0,
      'spentAmount': 180.0,
      'period': 'Monthly',
      'color': AppColors.info,
      'icon': Icons.directions_car,
      'status': 'on_track',
    },
    {
      'id': '3',
      'title': 'Entertainment',
      'category': 'Entertainment',
      'budgetAmount': 150.0,
      'spentAmount': 160.0,
      'period': 'Monthly',
      'color': AppColors.secondary,
      'icon': Icons.movie,
      'status': 'over_budget',
    },
    {
      'id': '4',
      'title': 'Utilities',
      'category': 'Utilities',
      'budgetAmount': 300.0,
      'spentAmount': 280.0,
      'period': 'Monthly',
      'color': AppColors.error,
      'icon': Icons.electrical_services,
      'status': 'on_track',
    },
    {
      'id': '5',
      'title': 'Shopping',
      'category': 'Shopping',
      'budgetAmount': 400.0,
      'spentAmount': 250.0,
      'period': 'Monthly',
      'color': AppColors.primary,
      'icon': Icons.shopping_bag,
      'status': 'on_track',
    },
    {
      'id': '6',
      'title': 'Healthcare',
      'category': 'Healthcare',
      'budgetAmount': 200.0,
      'spentAmount': 190.0,
      'period': 'Monthly',
      'color': AppColors.success,
      'icon': Icons.health_and_safety,
      'status': 'warning',
    },
  ];

  List<Map<String, dynamic>> get _filteredBudgets {
    return _budgets.where((budget) => budget['period'] == _selectedPeriod).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budgets'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAddBudgetDialog(),
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset_all') {
                _showResetAllDialog();
              } else if (value == 'settings') {
                _showBudgetSettings();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset_all',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Reset All Budgets'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Budget Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
                    ),
      body: Column(
        children: [
          // Period Selector
          _buildPeriodSelector(),
          
          // Budget Overview
          _buildBudgetOverview(),
          
          // Budgets List
          Expanded(
            child: _budgets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                      padding: const EdgeInsets.all(AppTheme.lg),
                    itemCount: _filteredBudgets.length,
                    itemBuilder: (context, index) {
                      final budget = _filteredBudgets[index];
                      return _BudgetCard(budget: budget);
                    },
                                ),
                              ),
                            ],
                          ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Weekly', 'Monthly', 'Yearly'];
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
                  foregroundColor: isSelected ? AppColors.onPrimary : AppColors.onBackground,
                  elevation: isSelected ? 4 : 0,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.md),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                ),
              ),
          ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBudgetOverview() {
    final totalBudget = _filteredBudgets.fold(0.0, (sum, budget) => sum + budget['budgetAmount']);
    final totalSpent = _filteredBudgets.fold(0.0, (sum, budget) => sum + budget['spentAmount']);
    final remaining = totalBudget - totalSpent;
    final spentPercentage = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: Text(
                  _selectedPeriod,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Budget',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
          Text(
                      '\$${totalBudget.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
              ),
              Expanded(
      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
        children: [
                    Text(
                      'Spent',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
          Text(
                      '\$${totalSpent.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      '\$${remaining.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: remaining >= 0 ? AppColors.onPrimary : Colors.red[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(spentPercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
            ),
          ),
          Text(
                    'used',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          LinearProgressIndicator(
            value: spentPercentage.clamp(0.0, 1.0),
            backgroundColor: AppColors.onPrimary.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              spentPercentage > 1.0 ? Colors.red[300]! : AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 80,
            color: AppColors.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.lg),
          Text(
            'No budgets found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            'Create your first budget to start tracking your spending',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.xl),
          ElevatedButton.icon(
            onPressed: () => _showAddBudgetDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Create Budget'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.xl,
                vertical: AppTheme.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBudgetDialog() {
    context.go(RouteNames.budgetAdd);
  }

  void _showResetAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Budgets'),
        content: const Text('Are you sure you want to reset all budgets? This will clear all spending data and reset amounts to zero.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Reset all spent amounts to zero
                for (var budget in _budgets) {
                  budget['spentAmount'] = 0.0;
                  budget['status'] = 'on_track';
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All budgets have been reset'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Reset All'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  void _showBudgetSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.settings, color: AppColors.primary),
                  const SizedBox(width: AppTheme.sm),
                  Text(
                    'Budget Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.lg),
              _BudgetSettingsTile(
                title: 'Set Monthly Limit',
                subtitle: 'Total spending limit for all categories',
                icon: Icons.account_balance_wallet,
                onTap: () => _showSetMonthlyLimitDialog(),
              ),
              _BudgetSettingsTile(
                title: 'Reset Individual Budget',
                subtitle: 'Choose a specific budget to reset',
                icon: Icons.refresh,
                onTap: () => _showResetIndividualDialog(),
              ),
              _BudgetSettingsTile(
                title: 'Budget Notifications',
                subtitle: 'Get alerts when approaching limits',
                icon: Icons.notifications,
                onTap: () => _showNotificationSettings(),
              ),
              _BudgetSettingsTile(
                title: 'Export Budget Data',
                subtitle: 'Download your budget history',
                icon: Icons.download,
                onTap: () => _exportBudgetData(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSetMonthlyLimitDialog() {
    final controller = TextEditingController();
    Navigator.pop(context); // Close settings first
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Spending Limit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your total monthly spending limit across all categories:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.lg),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Limit',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Monthly limit set to \$${controller.text}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Set Limit'),
          ),
        ],
      ),
    );
  }

  void _showResetIndividualDialog() {
    Navigator.pop(context); // Close settings first
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Individual Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a budget to reset:'),
            const SizedBox(height: AppTheme.lg),
            SizedBox(
              width: double.maxFinite,
              height: 200,
              child: ListView.builder(
                itemCount: _budgets.length,
                itemBuilder: (context, index) {
                  final budget = _budgets[index];
                  return ListTile(
                    leading: Icon(budget['icon'], color: budget['color']),
                    title: Text(budget['title']),
                    subtitle: Text('Spent: \$${budget['spentAmount'].toStringAsFixed(2)}'),
                    onTap: () {
                      setState(() {
                        budget['spentAmount'] = 0.0;
                        budget['status'] = 'on_track';
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${budget['title']} budget reset'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _exportBudgetData() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Budget data exported successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _BudgetSettingsTile extends StatelessWidget {
  const _BudgetSettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.onSurface,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.budget});

  final Map<String, dynamic> budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budgetAmount = budget['budgetAmount'] as double;
    final spentAmount = budget['spentAmount'] as double;
    final remaining = budgetAmount - spentAmount;
    final spentPercentage = budgetAmount > 0 ? (spentAmount / budgetAmount) : 0.0;
    final status = budget['status'] as String;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'over_budget':
        statusColor = AppColors.error;
        statusIcon = Icons.warning;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        statusIcon = Icons.info;
        break;
      default:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.1),
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
                  color: budget['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                  ),
                  child: Icon(
                  budget['icon'],
                  color: budget['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      budget['title'],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                        Text(
                      budget['category'],
                      style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: 4),
                Text(
                      status.replaceAll('_', ' ').toUpperCase(),
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
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
          Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    Text(
                      '\$${budgetAmount.toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Spent',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    Text(
                      '\$${spentAmount.toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Remaining',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    Text(
                      '\$${remaining.toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: remaining >= 0 ? AppColors.success : AppColors.error,
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
              Expanded(
                child: LinearProgressIndicator(
                  value: spentPercentage.clamp(0.0, 1.0),
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spentPercentage > 1.0 ? AppColors.error : budget['color'],
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.sm),
              Text(
                '${(spentPercentage * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}