import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// Quests and rewards page
class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quests & Rewards'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: AppColors.onSurfaceDark,
            ),
            SizedBox(height: 16),
            Text(
              'Quests Page',
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
