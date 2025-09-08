/// Global application constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'PennyPal';
  static const String appDescription = 'A gamified personal finance app that makes budgeting fun';
  static const String appVersion = '1.0.0';

  // Database
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxTransactions = 'transactions_box';
  static const String hiveBoxBudgets = 'budgets_box';
  static const String hiveBoxGoals = 'goals_box';
  static const String hiveBoxCategories = 'categories_box';
  static const String hiveBoxSettings = 'settings_box';

  // SharedPreferences Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyCurrency = 'currency';
  static const String keyLanguage = 'language';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Gamification
  static const int xpPerTransaction = 10;
  static const int xpPerBudgetCreated = 50;
  static const int xpPerGoalCompleted = 100;
  static const int xpPerLessonCompleted = 25;
  static const int xpPerQuestCompleted = 75;
  static const int xpPerStreakDay = 5;

  // XP thresholds for leveling up
  static const List<int> levelThresholds = [
    0,     // Level 1
    100,   // Level 2
    250,   // Level 3
    500,   // Level 4
    1000,  // Level 5
    2000,  // Level 6
    3500,  // Level 7
    5500,  // Level 8
    8000,  // Level 9
    12000, // Level 10
  ];

  // Budget
  static const double defaultBudgetAmount = 1000.0;
  static const int maxBudgetCategories = 20;

  // Transactions
  static const int transactionsPerPage = 50;
  static const int maxTransactionHistory = 365; // days

  // Goals
  static const double minGoalAmount = 10.0;
  static const double maxGoalAmount = 1000000.0;
  static const int maxActiveGoals = 10;

  // API
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration syncInterval = Duration(minutes: 15);

  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxDescriptionLength = 500;
  static const int maxTransactionNoteLength = 200;

  // Currency formatting
  static const String defaultCurrency = 'USD';
  static const String defaultCurrencySymbol = '\$';
  static const int defaultDecimalPlaces = 2;

  // Default categories
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'id': 'food',
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': '#F59E0B',
      'type': 'expense',
    },
    {
      'id': 'transport',
      'name': 'Transportation',
      'icon': 'directions_car',
      'color': '#3B82F6',
      'type': 'expense',
    },
    {
      'id': 'entertainment',
      'name': 'Entertainment',
      'icon': 'movie',
      'color': '#8B5CF6',
      'type': 'expense',
    },
    {
      'id': 'shopping',
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': '#EC4899',
      'type': 'expense',
    },
    {
      'id': 'bills',
      'name': 'Bills & Utilities',
      'icon': 'receipt_long',
      'color': '#EF4444',
      'type': 'expense',
    },
    {
      'id': 'health',
      'name': 'Healthcare',
      'icon': 'local_hospital',
      'color': '#10B981',
      'type': 'expense',
    },
    {
      'id': 'education',
      'name': 'Education',
      'icon': 'school',
      'color': '#06B6D4',
      'type': 'expense',
    },
    {
      'id': 'salary',
      'name': 'Salary',
      'icon': 'work',
      'color': '#22C55E',
      'type': 'income',
    },
    {
      'id': 'freelance',
      'name': 'Freelance',
      'icon': 'laptop',
      'color': '#84CC16',
      'type': 'income',
    },
    {
      'id': 'investment',
      'name': 'Investment',
      'icon': 'trending_up',
      'color': '#059669',
      'type': 'income',
    },
  ];

  // Achievement IDs
  static const String achievementFirstTransaction = 'first_transaction';
  static const String achievementFirstBudget = 'first_budget';
  static const String achievementFirstGoal = 'first_goal';
  static const String achievementWeekStreak = 'week_streak';
  static const String achievementMonthStreak = 'month_streak';
  static const String achievementBudgetMaster = 'budget_master';
  static const String achievementGoalAchiever = 'goal_achiever';
  static const String achievementLearner = 'learner';

  // Error messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Please check your internet connection.';
  static const String errorAuth = 'Authentication failed. Please sign in again.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorNotFound = 'The requested resource was not found.';
}
