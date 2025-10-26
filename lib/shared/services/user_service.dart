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
  
  // Additional profile fields
  String? _username;
  int? _age;
  String? _profileDescription;
  String? _interests;
  String? _profilePicture;
  String? _profilePictureType; // 'unknown_user', 'finance_icon', 'uploaded_image'

  // Getters
  String get userName => _userName ?? 'User';
  String get userEmail => _userEmail ?? '';
  double get monthlyIncome => _monthlyIncome ?? 0.0;
  Map<String, double> get budgetCategories => Map.from(_budgetCategories);
  bool get isOnboardingCompleted => _onboardingCompleted;
  
  // Additional profile getters
  String get username => _username ?? '@${userName.toLowerCase().replaceAll(' ', '')}';
  int get age => _age ?? 25;
  String get profileDescription => _profileDescription ?? 'Financial enthusiast and budgeting expert!';
  String get interests => _interests ?? 'Budgeting, Investing, Saving';
  String get profilePicture => _profilePicture ?? 'unknown_user';
  String get profilePictureType => _profilePictureType ?? 'unknown_user';

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
    String? username,
    int? age,
    String? description,
    String? interests,
    String? profilePicture,
    String? profilePictureType,
  }) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (income != null) _monthlyIncome = income;
    if (username != null) _username = username;
    if (age != null) _age = age;
    if (description != null) _profileDescription = description;
    if (interests != null) _interests = interests;
    if (profilePicture != null) _profilePicture = profilePicture;
    if (profilePictureType != null) _profilePictureType = profilePictureType;
    
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
    _username = null;
    _age = null;
    _profileDescription = null;
    _interests = null;
    _profilePicture = null;
    _profilePictureType = null;
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
