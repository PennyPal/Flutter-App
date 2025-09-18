import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// Budgets page
class BudgetsPage extends StatelessWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add budget
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.onSurfaceDark,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 64,
              color: AppColors.onSurfaceDark,
            ),
            SizedBox(height: 16),
            Text(
              'Budgets Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(
                color: AppColors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
