import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/services/challenge_service.dart';
import '../../../../shared/models/challenge.dart';

/// Challenges page for financial challenges
class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ChallengeService _challengeService = ChallengeService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges 🏆', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AvailableChallengesTab(),
          _ActiveChallengesTab(),
          _CompletedChallengesTab(),
        ],
      ),
    );
  }
}

class _AvailableChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challengeService = ChallengeService();
    final availableChallenges = challengeService.getAvailableChallenges();

    if (availableChallenges.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
            SizedBox(height: AppTheme.lg),
            Text(
              'All challenges completed!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppTheme.sm),
            Text(
              'Check back for new challenges',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.lg),
      itemCount: availableChallenges.length,
      itemBuilder: (context, index) {
        final challenge = availableChallenges[index];
        return _ChallengeCard(challenge: challenge, canJoin: true);
      },
    );
  }
}

class _ActiveChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challengeService = ChallengeService();
    final activeChallenges = challengeService.getActiveChallenges();

    if (activeChallenges.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
            SizedBox(height: AppTheme.lg),
            Text(
              'No Active Challenges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppTheme.sm),
            Text(
              'Start a challenge to track your progress',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.lg),
      itemCount: activeChallenges.length,
      itemBuilder: (context, index) {
        final challenge = activeChallenges[index];
        return _ChallengeCard(challenge: challenge, canJoin: false, showProgress: true);
      },
    );
  }
}

class _CompletedChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challengeService = ChallengeService();
    final completedChallenges = challengeService.getCompletedChallenges();

    if (completedChallenges.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration_outlined, size: 64, color: Colors.amber),
            SizedBox(height: AppTheme.lg),
            Text(
              'No Completed Challenges Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppTheme.sm),
            Text(
              'Complete challenges to see them here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.lg),
      itemCount: completedChallenges.length,
      itemBuilder: (context, index) {
        final challenge = completedChallenges[index];
        return _ChallengeCard(challenge: challenge, canJoin: false, showProgress: false);
      },
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final bool canJoin;
  final bool showProgress;

  const _ChallengeCard({
    required this.challenge,
    this.canJoin = false,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      child: InkWell(
        onTap: canJoin
            ? () {
                ChallengeService().joinChallenge(challenge.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Started: ${challenge.title} 🎯'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.md),
                    decoration: BoxDecoration(
                      color: challenge.color.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                    ),
                    child: Icon(challenge.icon, color: challenge.color, size: 32),
                  ),
                  const SizedBox(width: AppTheme.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (canJoin)
                    Icon(Icons.play_circle_outline, color: challenge.color, size: 32)
                  else if (challenge.isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                ],
              ),
              const SizedBox(height: AppTheme.sm),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.schedule,
                    text: '${challenge.durationDays} days',
                  ),
                  const SizedBox(width: AppTheme.md),
                  _InfoChip(
                    icon: Icons.stars,
                    text: '${challenge.xpReward} XP',
                  ),
                  const SizedBox(width: AppTheme.md),
                  _InfoChip(
                    icon: _getDifficultyIcon(challenge.category),
                    text: _getDifficultyText(challenge.category),
                  ),
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: AppTheme.sm),
                LinearProgressIndicator(
                  value: challenge.progressPercentage.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(challenge.progressPercentage * 100).toStringAsFixed(0)}% complete',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDifficultyIcon(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.beginner:
        return Icons.arrow_upward;
      case ChallengeCategory.intermediate:
        return Icons.trending_up;
      case ChallengeCategory.advanced:
        return Icons.arrow_upward_outlined;
    }
  }

  String _getDifficultyText(ChallengeCategory category) {
    switch (category) {
      case ChallengeCategory.beginner:
        return 'Beginner';
      case ChallengeCategory.intermediate:
        return 'Intermediate';
      case ChallengeCategory.advanced:
        return 'Advanced';
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}