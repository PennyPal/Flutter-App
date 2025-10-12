/// Route name constants for the app
class RouteNames {
  RouteNames._();

  // Auth & Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Main App
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Transactions
  static const String transactions = '/transactions';
  static const String transactionAdd = '/transactions/add';
  static const String transactionEdit = '/transactions/edit';
  static const String transactionDetails = '/transactions/details';

  // Budgets
  static const String budgets = '/budgets';
  static const String budgetAdd = '/budgets/add';
  static const String budgetEdit = '/budgets/edit';
  static const String budgetDetails = '/budgets/details';

  // Goals
  static const String goals = '/goals';
  static const String goalAdd = '/goals/add';
  static const String goalEdit = '/goals/edit';
  static const String goalDetails = '/goals/details';

  // Learning
  static const String learn = '/learn';
  static const String lesson = '/learn/lesson';
  static const String quiz = '/learn/quiz';

  // Chat & AI
  static const String chat = '/chat';

  // Quests & Rewards
  static const String quests = '/quests';
  static const String achievements = '/achievements';
  static const String rewards = '/rewards';

  // Profile & Settings
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String about = '/settings/about';
  static const String appwriteTest = '/settings/appwrite-test';

  // Categories
  static const String categories = '/categories';
  static const String categoryAdd = '/categories/add';
  static const String categoryEdit = '/categories/edit';

  // Reports & Analytics
  static const String reports = '/reports';
  static const String analytics = '/analytics';
}
