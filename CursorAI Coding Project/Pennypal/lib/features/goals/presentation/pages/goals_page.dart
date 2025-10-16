import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// Goals page
class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add goal
            },
            icon: Icon(
              Icons.add,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.track_changes,
              size: 64,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 16),
            Text(
              'Goals Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
