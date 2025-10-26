import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';

/// Service for managing user gamification data (levels, XP, badges, etc.)
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  // User progress data (in real app, would be stored in database)
  int _totalXP = 0;
  int _currentLevel = 1;
  int _activeDays = 0;
  int _quizzesCompleted = 0;
  List<String> _earnedBadges = [];
  DateTime? _lastActiveDate;
  int _currentStreak = 0;
  int _longestStreak = 0;

  // Getters
  int get totalXP => _totalXP;
  int get currentLevel => _currentLevel;
  int get activeDays => _activeDays;
  int get quizzesCompleted => _quizzesCompleted;
  List<String> get earnedBadges => List.from(_earnedBadges);
  int get badgesEarned => _earnedBadges.length;
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;

  // Calculate level based on XP
  int _calculateLevel(int xp) {
    for (int i = AppConstants.levelThresholds.length - 1; i >= 0; i--) {
      if (xp >= AppConstants.levelThresholds[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  // Add XP and check for level up
  void addXP(int amount, {String? source}) {
    _totalXP += amount;
    final newLevel = _calculateLevel(_totalXP);
    
    if (newLevel > _currentLevel) {
      _currentLevel = newLevel;
      _earnBadge('level_${_currentLevel}');
      if (kDebugMode) {
        print('Level up! Now level $_currentLevel');
      }
    }
    
    if (kDebugMode) {
      print('Added $amount XP (source: $source). Total: $_totalXP');
    }
  }

  // Complete a quiz
  void completeQuiz({required int score, required String quizId}) {
    _quizzesCompleted++;
    addXP(AppConstants.xpPerLessonCompleted, source: 'quiz_completion');
    
    // Earn badge for perfect score
    if (score >= 90) {
      _earnBadge('perfect_quiz');
    }
    
    // Earn badge for completing multiple quizzes
    if (_quizzesCompleted == 5) {
      _earnBadge('quiz_master');
    }
    
    if (kDebugMode) {
      print('Quiz completed! Score: $score, Total quizzes: $_quizzesCompleted');
    }
  }

  // Record daily activity
  void recordDailyActivity() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    // Check if this is a new day
    if (_lastActiveDate == null || 
        DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day) != todayDate) {
      
      _activeDays++;
      
      // Update streak
      if (_lastActiveDate == null || 
          todayDate.difference(DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day)).inDays == 1) {
        _currentStreak++;
        if (_currentStreak > _longestStreak) {
          _longestStreak = _currentStreak;
        }
      } else {
        _currentStreak = 1;
      }
      
      _lastActiveDate = today;
      addXP(AppConstants.xpPerStreakDay, source: 'daily_activity');
      
      // Earn streak badges
      if (_currentStreak == 7) {
        _earnBadge('week_streak');
      } else if (_currentStreak == 30) {
        _earnBadge('month_streak');
      }
      
      if (kDebugMode) {
        print('Daily activity recorded. Active days: $_activeDays, Streak: $_currentStreak');
      }
    }
  }

  // Complete a transaction
  void completeTransaction({required double amount, required String category}) {
    addXP(AppConstants.xpPerTransaction, source: 'transaction');
    
    // Earn badge for first transaction
    if (_totalXP == AppConstants.xpPerTransaction) {
      _earnBadge('first_transaction');
    }
    
    // Earn badge for large transaction
    if (amount >= 1000) {
      _earnBadge('big_spender');
    }
  }

  // Complete a budget
  void completeBudget() {
    addXP(AppConstants.xpPerBudgetCreated, source: 'budget_creation');
    _earnBadge('budget_master');
  }

  // Complete a goal
  void completeGoal({required double amount}) {
    addXP(AppConstants.xpPerGoalCompleted, source: 'goal_completion');
    _earnBadge('goal_achiever');
    
    // Earn badge for large goal
    if (amount >= 10000) {
      _earnBadge('big_saver');
    }
  }

  // Complete a quest
  void completeQuest({required String questId}) {
    addXP(AppConstants.xpPerQuestCompleted, source: 'quest_completion');
    _earnBadge('quest_completer');
  }

  // Earn a badge
  void _earnBadge(String badgeId) {
    if (!_earnedBadges.contains(badgeId)) {
      _earnedBadges.add(badgeId);
      if (kDebugMode) {
        print('Badge earned: $badgeId');
      }
    }
  }

  // Reset all data (for testing)
  void resetData() {
    _totalXP = 0;
    _currentLevel = 1;
    _activeDays = 0;
    _quizzesCompleted = 0;
    _earnedBadges.clear();
    _lastActiveDate = null;
    _currentStreak = 0;
    _longestStreak = 0;
    
    if (kDebugMode) {
      print('Gamification data reset');
    }
  }

  // Initialize with some sample data for demo
  void initializeWithSampleData() {
    _totalXP = 1200; // Level 5
    _currentLevel = 5;
    _activeDays = 30;
    _quizzesCompleted = 7;
    _earnedBadges = ['first_transaction', 'level_5', 'quiz_master'];
    _currentStreak = 5;
    _longestStreak = 15;
    _lastActiveDate = DateTime.now().subtract(const Duration(days: 1));
    
    if (kDebugMode) {
      print('Initialized with sample data: Level $_currentLevel, $_activeDays active days');
    }
  }

  // Get progress to next level
  Map<String, int> getLevelProgress() {
    if (_currentLevel >= AppConstants.levelThresholds.length) {
      return {'current': _totalXP, 'next': _totalXP, 'progress': 100};
    }
    
    final currentThreshold = AppConstants.levelThresholds[_currentLevel - 1];
    final nextThreshold = AppConstants.levelThresholds[_currentLevel];
    final progress = ((_totalXP - currentThreshold) / (nextThreshold - currentThreshold) * 100).round();
    
    return {
      'current': _totalXP - currentThreshold,
      'next': nextThreshold - currentThreshold,
      'progress': progress,
    };
  }
}
