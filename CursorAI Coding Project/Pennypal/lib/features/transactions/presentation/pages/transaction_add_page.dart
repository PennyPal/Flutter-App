import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/color_scheme.dart';

/// Add/Edit transaction page
class TransactionAddPage extends StatelessWidget {
  const TransactionAddPage({
    super.key,
    this.transactionId,
  });

  final String? transactionId;

  @override
  Widget build(BuildContext context) {
    final isEditing = transactionId != null;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.close,
            color: AppColors.onSurfaceDark,
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 64,
              color: AppColors.onSurfaceDark,
            ),
            SizedBox(height: 16),
            Text(
              'Add Transaction',
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
