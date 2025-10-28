import 'package:flutter/material.dart';
import '../models/challenge.dart';

/// Service to manage financial challenges
class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  
  late final List<Challenge> _availableChallenges;
  final List<Challenge> _activeChallenges = [];
  final List<Challenge> _completedChallenges = [];

  ChallengeService._internal() {
    _availableChallenges = _createChallenges();
  }

  List<Challenge> _createChallenges() {
    return [
      // Spending Challenges
      Challenge(
        id: 'no_spend_week',
        title: 'No-Spend Week',
        description: 'Don\'t spend money on non-essentials for 7 days',
        type: ChallengeType.spending,
        category: ChallengeCategory.beginner,
        icon: Icons.shopping_bag_outlined,
        color: Colors.blue,
        targetValue: 7,
        durationDays: 7,
        xpReward: 100,
        badgeId: 'no_spender',
      ),
      Challenge(
        id: 'coffee_fast',
        title: 'Coffee Fast',
        description: 'Skip buying coffee for a week and save',
        type: ChallengeType.spending,
        category: ChallengeCategory.beginner,
        icon: Icons.local_cafe_outlined,
        color: Colors.brown,
        targetValue: 7,
        durationDays: 7,
        xpReward: 75,
      ),
      Challenge(
        id: 'frugal_month',
        title: 'Frugal February',
        description: 'Cut spending by 20% this month',
        type: ChallengeType.spending,
        category: ChallengeCategory.intermediate,
        icon: Icons.account_balance_wallet_outlined,
        color: Colors.green,
        targetValue: 20,
        durationDays: 30,
        xpReward: 250,
      ),

      // Saving Challenges
      Challenge(
        id: 'save_100',
        title: 'Save \$100',
        description: 'Save \$100 in one month',
        type: ChallengeType.saving,
        category: ChallengeCategory.beginner,
        icon: Icons.savings_outlined,
        color: Colors.green,
        targetValue: 100,
        durationDays: 30,
        xpReward: 150,
        badgeId: 'saver_starter',
      ),
      Challenge(
        id: 'save_500',
        title: 'Save \$500',
        description: 'Reach \$500 in savings',
        type: ChallengeType.saving,
        category: ChallengeCategory.intermediate,
        icon: Icons.attach_money_outlined,
        color: Colors.green,
        targetValue: 500,
        durationDays: 90,
        xpReward: 300,
      ),
      Challenge(
        id: 'emergency_fund',
        title: 'Emergency Fund',
        description: 'Build \$1000 emergency fund',
        type: ChallengeType.saving,
        category: ChallengeCategory.advanced,
        icon: Icons.shield_outlined,
        color: Colors.amber,
        targetValue: 1000,
        durationDays: 180,
        xpReward: 500,
      ),

      // Budgeting Challenges
      Challenge(
        id: 'track_expenses',
        title: 'Track Every Expense',
        description: 'Log every expense for 30 days',
        type: ChallengeType.budgeting,
        category: ChallengeCategory.beginner,
        icon: Icons.receipt_long_outlined,
        color: Colors.purple,
        targetValue: 30,
        durationDays: 30,
        xpReward: 200,
      ),
      Challenge(
        id: 'under_budget',
        title: 'Stay Under Budget',
        description: 'Stay within budget for a whole month',
        type: ChallengeType.budgeting,
        category: ChallengeCategory.intermediate,
        icon: Icons.trending_down_outlined,
        color: Colors.teal,
        targetValue: 30,
        durationDays: 30,
        xpReward: 250,
      ),

      // Earning Challenges
      Challenge(
        id: 'side_hustle',
        title: 'Start Side Hustle',
        description: 'Make your first \$50 from a side hustle',
        type: ChallengeType.earning,
        category: ChallengeCategory.intermediate,
        icon: Icons.work_outline,
        color: Colors.orange,
        targetValue: 50,
        durationDays: 90,
        xpReward: 300,
      ),
      Challenge(
        id: 'save_50_percent',
        title: '50/50 Rule',
        description: 'Save 50% of any money you earn',
        type: ChallengeType.saving,
        category: ChallengeCategory.intermediate,
        icon: Icons.percent_outlined,
        color: Colors.blue,
        targetValue: 50,
        durationDays: 60,
        xpReward: 200,
      ),
      Challenge(
        id: 'investment_starter',
        title: 'Investment Starter',
        description: 'Invest your first \$100',
        type: ChallengeType.investing,
        category: ChallengeCategory.advanced,
        icon: Icons.trending_up_outlined,
        color: Colors.green,
        targetValue: 100,
        durationDays: 90,
        xpReward: 400,
      ),
      Challenge(
        id: 'debt_free',
        title: 'Pay Off Debt',
        description: 'Pay off \$500 in debt',
        type: ChallengeType.saving,
        category: ChallengeCategory.advanced,
        icon: Icons.check_circle_outline,
        color: Colors.red,
        targetValue: 500,
        durationDays: 120,
        xpReward: 500,
      ),
    ];
  }

  List<Challenge> getAvailableChallenges() {
    return _availableChallenges.where((c) => c.canJoin).toList();
  }

  List<Challenge> getActiveChallenges() {
    return _activeChallenges.where((c) => c.isActive && !c.isExpired).toList();
  }

  List<Challenge> getCompletedChallenges() {
    return _completedChallenges;
  }

  Challenge? getChallenge(String id) {
    try {
      return _availableChallenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  void joinChallenge(String challengeId) {
    final challenge = getChallenge(challengeId);
    if (challenge == null || !challenge.canJoin) return;

    final updatedChallenge = challenge.copyWith();
    updatedChallenge.joinChallenge();
    
    _activeChallenges.add(updatedChallenge);
  }

  void completeChallenge(String challengeId) {
    try {
      final index = _activeChallenges.indexWhere(
        (c) => c.id == challengeId,
      );
      
      if (index != -1) {
        final challenge = _activeChallenges[index];
        challenge.completeChallenge();
        
        _completedChallenges.add(challenge);
        _activeChallenges.removeAt(index);
      }
    } catch (e) {
      print('Error completing challenge: $e');
    }
  }

  void cancelChallenge(String challengeId) {
    try {
      final challenge = _activeChallenges.firstWhere(
        (c) => c.id == challengeId,
      );
      challenge.cancelChallenge();
      _activeChallenges.remove(challenge);
    } catch (e) {
      print('Error canceling challenge: $e');
    }
  }

  void updateChallengeProgress(String challengeId, double amount) {
    try {
      final challenge = _activeChallenges.firstWhere(
        (c) => c.id == challengeId,
      );
      challenge.currentProgress += amount;
      
      if (challenge.currentProgress >= challenge.targetValue) {
        completeChallenge(challengeId);
      }
    } catch (e) {
      print('Error updating challenge progress: $e');
    }
  }

  List<Challenge> getChallengesByCategory(ChallengeCategory category) {
    return _availableChallenges
        .where((c) => c.category == category)
        .toList();
  }

  List<Challenge> getChallengesByType(ChallengeType type) {
    return _availableChallenges.where((c) => c.type == type).toList();
  }

  int getTotalXpFromChallenges() {
    return _completedChallenges.fold<int>(
      0,
      (sum, c) => sum + c.xpReward,
    );
  }
}