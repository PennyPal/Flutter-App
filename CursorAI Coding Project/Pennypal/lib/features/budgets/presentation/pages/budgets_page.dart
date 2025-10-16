import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Compact, clean Budgets page implementation
class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  String _selectedPeriod = 'Monthly';

  final List<Map<String, dynamic>> _budgets = [
    {
      'id': '1',
      'title': 'Food & Dining',
      'budgetAmount': 500.0,
      'spentAmount': 320.0,
      'period': 'Monthly',
      'color': AppColors.warning,
      'icon': Icons.restaurant,
      'status': 'on_track',
    },
    {
      'id': '2',
      'title': 'Transport',
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
      'budgetAmount': 150.0,
      'spentAmount': 160.0,
      'period': 'Monthly',
      'color': AppColors.secondary,
      'icon': Icons.movie,
      'status': 'over_budget',
    },
  ];

  List<Map<String, dynamic>> get _filteredBudgets => _budgets.where((b) => b['period'] == _selectedPeriod).toList();

  void _goToAdd() => context.go(RouteNames.budgetAdd);

  void _resetAll() {
    setState(() {
      for (var b in _budgets) {
        b['spentAmount'] = 0.0;
        b['status'] = 'on_track';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All budgets reset'), backgroundColor: AppColors.success));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalBudget = _filteredBudgets.fold<double>(0.0, (s, b) => s + (b['budgetAmount'] as num).toDouble());
    final totalSpent = _filteredBudgets.fold<double>(0.0, (s, b) => s + (b['spentAmount'] as num).toDouble());
  final spentPct = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Budgets'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(onPressed: _goToAdd, icon: const Icon(Icons.add)),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'reset') _resetAll();
            },
            itemBuilder: (_) => const [PopupMenuItem(value: 'reset', child: Text('Reset All'))],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Row(children: ['Weekly', 'Monthly', 'Yearly'].map((p) {
              final sel = _selectedPeriod == p;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedPeriod = p),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sel ? theme.colorScheme.primary : theme.colorScheme.surface,
                      foregroundColor: sel ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    ),
                    child: Text(p, style: TextStyle(fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
                  ),
                ),
              );
            }).toList()),
          ),

          // overview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.lg),
              decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(AppTheme.radiusLg.x)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Overview', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
                  Text(_selectedPeriod, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary))
                ]),
                const SizedBox(height: AppTheme.md),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Total', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary.withAlpha((0.9 * 255).round()))), Text('\$${totalBudget.toStringAsFixed(0)}', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary))])),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('Spent', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary.withAlpha((0.9 * 255).round()))), Text('\$${totalSpent.toStringAsFixed(0)}', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary))])),
                ]),
                const SizedBox(height: AppTheme.md),
                LinearProgressIndicator(value: spentPct.clamp(0.0, 1.0), backgroundColor: theme.colorScheme.onPrimary.withAlpha((0.2 * 255).round()), valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary)),
              ]),
            ),
          ),

          const SizedBox(height: AppTheme.lg),

          // list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.lg),
              itemCount: _filteredBudgets.length,
              itemBuilder: (ctx, i) => _BudgetCard(budget: _filteredBudgets[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.budget});

  final Map<String, dynamic> budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budgetAmount = (budget['budgetAmount'] as num).toDouble();
    final spent = (budget['spentAmount'] as num).toDouble();
    final pct = budgetAmount > 0 ? (spent / budgetAmount) : 0.0;
    final color = budget['color'] as Color? ?? theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(AppTheme.radiusMd.x)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withAlpha((0.1 * 255).round()), borderRadius: BorderRadius.circular(AppTheme.radiusSm.x)), child: Icon(budget['icon'] as IconData, color: color)),
          const SizedBox(width: AppTheme.md),
          Expanded(child: Text(budget['title'] as String, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600))),
          Text('${(pct * 100).toInt()}%', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface))
        ]),
        const SizedBox(height: AppTheme.md),
        Row(children: [
          Expanded(child: Text('\$${budgetAmount.toStringAsFixed(0)}', style: theme.textTheme.titleMedium)),
    Expanded(child: Text('\$${spent.toStringAsFixed(0)}', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface))),
    Expanded(child: Text('\$${(budgetAmount - spent).toStringAsFixed(0)}', style: theme.textTheme.titleMedium?.copyWith(color: (budgetAmount - spent) >= 0 ? AppColors.success : AppColors.error))),
        ]),
        const SizedBox(height: AppTheme.md),
  LinearProgressIndicator(value: pct.clamp(0.0, 1.0), backgroundColor: theme.colorScheme.onSurface.withAlpha((0.05 * 255).round()), valueColor: AlwaysStoppedAnimation(color)),
      ]),
    );
  }
}
