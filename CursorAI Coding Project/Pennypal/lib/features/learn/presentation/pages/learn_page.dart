import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// Learning page
class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learn'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Search lessons
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 64,
              color: AppColors.onSurface,
            ),
            SizedBox(height: 16),
            Text(
              'Learn Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
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
