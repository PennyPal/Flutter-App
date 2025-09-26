import 'package:flutter/foundation.dart';

/// Simple user service for managing user data
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // User data storage (in real app, would be SharedPreferences/Secure Storage)
  String? _userName;
  String? _userEmail;
  double? _monthlyIncome;
  Map<String, double> _budgetCategories = {};
  bool _onboardingCompleted = false;

  // Getters
  String get userName => _userName ?? 'User';
  String get userEmail => _userEmail ?? '';
  double get monthlyIncome => _monthlyIncome ?? 0.0;
  Map<String, double> get budgetCategories => Map.from(_budgetCategories);
  bool get isOnboardingCompleted => _onboardingCompleted;

  // Check if user has completed setup
  bool get isUserSetupComplete => 
      _userName != null && 
      _monthlyIncome != null && 
      _onboardingCompleted;

  // Save user data from onboarding
  void completeOnboarding({
    required String name,
    required double income,
    required Map<String, double> budgets,
  }) {
    _userName = name;
    _monthlyIncome = income;
    _budgetCategories = Map.from(budgets);
    _onboardingCompleted = true;
    
    if (kDebugMode) {
      print('User onboarding completed: $_userName, \$$income/month');
    }
  }

  // Update user profile
  void updateProfile({
    String? name,
    String? email,
    double? income,
  }) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (income != null) _monthlyIncome = income;
    
    if (kDebugMode) {
      print('Profile updated: $_userName');
    }
  }

  // Set initial registration data
  void setRegistrationData({
    required String name,
    required String email,
  }) {
    _userName = name;
    _userEmail = email;
    
    if (kDebugMode) {
      print('Registration data set: $_userName, $_userEmail');
    }
  }

  // Reset all user data (for testing/logout)
  void clearUserData() {
    _userName = null;
    _userEmail = null;
    _monthlyIncome = null;
    _budgetCategories.clear();
    _onboardingCompleted = false;
  }

  // Get greeting message based on time of day
  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 
        ? 'Good morning' 
        : hour < 17 
            ? 'Good afternoon' 
            : 'Good evening';
    return '$greeting, $userName! 👋';
  }
}
