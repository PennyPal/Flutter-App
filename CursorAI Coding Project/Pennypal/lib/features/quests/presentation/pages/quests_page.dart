import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Quests and rewards page with gamification features
class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quests & Rewards'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with points
            _HeaderSection(),
            
            const SizedBox(height: AppTheme.xl),
            
            // Daily Quests
            Text(
              'Daily Quests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            
            const SizedBox(height: AppTheme.lg),
            
            _DailyQuestsList(),
            
            const SizedBox(height: AppTheme.xl),
            
            // Weekly Challenges
            Text(
              'Weekly Challenges',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            
            const SizedBox(height: AppTheme.lg),
            
            _WeeklyChallengesList(),
            
            const SizedBox(height: AppTheme.xl),
            
            // Achievements
            Text(
              'Achievements',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            
            const SizedBox(height: AppTheme.lg),
            
            _AchievementsGrid(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.md),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.onPrimary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Points',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.9),
                  ),
                ),
                Text(
                  '2,450',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  'Level 5 • 450 points to next level',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.md, vertical: AppTheme.sm),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
            ),
            child: Text(
              'Level 5',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyQuestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quests = [
      {'title': 'Log a transaction', 'points': 50, 'completed': true, 'icon': Icons.add_circle},
      {'title': 'Check your budget', 'points': 30, 'completed': true, 'icon': Icons.account_balance_wallet},
      {'title': 'Set a savings goal', 'points': 100, 'completed': false, 'icon': Icons.savings},
      {'title': 'Complete a lesson', 'points': 75, 'completed': false, 'icon': Icons.school},
    ];
    
    return Column(
      children: quests.map((quest) => _QuestTile(
        title: quest['title'] as String,
        points: quest['points'] as int,
        completed: quest['completed'] as bool,
        icon: quest['icon'] as IconData,
      )).toList(),
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({
    required this.title,
    required this.points,
    required this.completed,
    required this.icon,
  });

  final String title;
  final int points;
  final bool completed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: completed ? AppColors.success.withOpacity(0.3) : AppColors.onSurface.withOpacity(0.2),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.sm),
            decoration: BoxDecoration(
              color: completed ? AppColors.success.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
            ),
            child: Icon(
              completed ? Icons.check_circle : icon,
              color: completed ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackground,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: AppTheme.xs),
                Text(
                  '+$points points',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: completed ? AppColors.success : AppColors.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (completed)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            )
          else
            ElevatedButton(
              onPressed: () {
                // TODO: Complete quest
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.md, vertical: AppTheme.sm),
              ),
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}

class _WeeklyChallengesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'title': 'Save \$100 this week', 'reward': '500 points', 'progress': 0.6, 'icon': Icons.savings},
      {'title': 'Complete 5 transactions', 'reward': '300 points', 'progress': 0.8, 'icon': Icons.receipt},
      {'title': 'Learn 3 new concepts', 'reward': '400 points', 'progress': 0.3, 'icon': Icons.school},
    ];
    
    return Column(
      children: challenges.map((challenge) => _ChallengeTile(
        title: challenge['title'] as String,
        reward: challenge['reward'] as String,
        progress: challenge['progress'] as double,
        icon: challenge['icon'] as IconData,
      )).toList(),
    );
  }
}

class _ChallengeTile extends StatelessWidget {
  const _ChallengeTile({
    required this.title,
    required this.reward,
    required this.progress,
    required this.icon,
  });

  final String title;
  final String reward;
  final double progress;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.md),
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
                    const SizedBox(height: AppTheme.xs),
                    Text(
                      reward,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.md),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final achievements = [
      {'title': 'First Transaction', 'description': 'Log your first transaction', 'unlocked': true, 'icon': Icons.add_circle},
      {'title': 'Budget Master', 'description': 'Create 5 budgets', 'unlocked': true, 'icon': Icons.account_balance_wallet},
      {'title': 'Saver', 'description': 'Save \$1000', 'unlocked': false, 'icon': Icons.savings},
      {'title': 'Learner', 'description': 'Complete 10 lessons', 'unlocked': false, 'icon': Icons.school},
      {'title': 'Goal Setter', 'description': 'Set 3 financial goals', 'unlocked': true, 'icon': Icons.flag},
      {'title': 'Streak Master', 'description': 'Use app for 30 days', 'unlocked': false, 'icon': Icons.local_fire_department},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppTheme.md,
        mainAxisSpacing: AppTheme.md,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _AchievementCard(
          title: achievement['title'] as String,
          description: achievement['description'] as String,
          unlocked: achievement['unlocked'] as bool,
          icon: achievement['icon'] as IconData,
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.title,
    required this.description,
    required this.unlocked,
    required this.icon,
  });

  final String title;
  final String description;
  final bool unlocked;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.surface : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        border: Border.all(
          color: unlocked ? AppColors.success.withOpacity(0.3) : AppColors.onSurface.withOpacity(0.2),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.md),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.success.withOpacity(0.1) : AppColors.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            child: Icon(
              unlocked ? icon : Icons.lock,
              color: unlocked ? AppColors.success : AppColors.onSurface,
              size: 32,
            ),
          ),
          const SizedBox(height: AppTheme.md),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: unlocked ? AppColors.onBackground : AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: unlocked ? AppColors.onSecondary : AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (unlocked) ...[
            const SizedBox(height: AppTheme.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
              ),
              child: Text(
                'UNLOCKED',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}