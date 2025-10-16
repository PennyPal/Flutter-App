import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Service for managing user settings and preferences
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Theme settings
  String _themeMode = 'light'; // 'light', 'dark', 'system'
  String _accentColor = 'purple'; // 'purple', 'blue', 'green', 'red', 'orange'
  
  // Visibility settings
  bool _profileVisibility = true;
  bool _activityVisibility = true;
  bool _achievementVisibility = true;
  
  // Location settings
  bool _locationEnabled = false;
  bool _locationBasedFeatures = false;
  
  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _transactionAlerts = true;
  bool _budgetAlerts = true;
  bool _goalAlerts = true;
  String _notificationFrequency = 'immediate'; // 'immediate', 'daily', 'weekly'
  
  // Advanced settings
  bool _dataExportEnabled = true;
  bool _analyticsEnabled = true;
  String _accountStatus = 'active'; // 'active', 'deactivated', 'deleted'

  // Getters
  String get themeMode => _themeMode;
  String get accentColor => _accentColor;
  bool get profileVisibility => _profileVisibility;
  bool get activityVisibility => _activityVisibility;
  bool get achievementVisibility => _achievementVisibility;
  bool get locationEnabled => _locationEnabled;
  bool get locationBasedFeatures => _locationBasedFeatures;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get transactionAlerts => _transactionAlerts;
  bool get budgetAlerts => _budgetAlerts;
  bool get goalAlerts => _goalAlerts;
  String get notificationFrequency => _notificationFrequency;
  bool get dataExportEnabled => _dataExportEnabled;
  bool get analyticsEnabled => _analyticsEnabled;
  String get accountStatus => _accountStatus;

  // Theme settings
  void updateThemeSettings({
    String? themeMode,
    String? accentColor,
  }) {
    if (themeMode != null) _themeMode = themeMode;
    if (accentColor != null) _accentColor = accentColor;
    
    if (kDebugMode) {
      print('Theme settings updated: $_themeMode, $_accentColor');
    }
  }

  // Visibility settings
  void updateVisibilitySettings({
    bool? profileVisibility,
    bool? activityVisibility,
    bool? achievementVisibility,
  }) {
    if (profileVisibility != null) _profileVisibility = profileVisibility;
    if (activityVisibility != null) _activityVisibility = activityVisibility;
    if (achievementVisibility != null) _achievementVisibility = achievementVisibility;
    
    if (kDebugMode) {
      print('Visibility settings updated: profile=$_profileVisibility, activity=$_activityVisibility, achievement=$_achievementVisibility');
    }
  }

  // Location settings
  void updateLocationSettings({
    bool? locationEnabled,
    bool? locationBasedFeatures,
  }) {
    if (locationEnabled != null) _locationEnabled = locationEnabled;
    if (locationBasedFeatures != null) _locationBasedFeatures = locationBasedFeatures;
    
    if (kDebugMode) {
      print('Location settings updated: enabled=$_locationEnabled, features=$_locationBasedFeatures');
    }
  }

  // Notification settings
  void updateNotificationSettings({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? transactionAlerts,
    bool? budgetAlerts,
    bool? goalAlerts,
    String? notificationFrequency,
  }) {
    if (pushNotifications != null) _pushNotifications = pushNotifications;
    if (emailNotifications != null) _emailNotifications = emailNotifications;
    if (transactionAlerts != null) _transactionAlerts = transactionAlerts;
    if (budgetAlerts != null) _budgetAlerts = budgetAlerts;
    if (goalAlerts != null) _goalAlerts = goalAlerts;
    if (notificationFrequency != null) _notificationFrequency = notificationFrequency;
    
    if (kDebugMode) {
      print('Notification settings updated: push=$_pushNotifications, email=$_emailNotifications, frequency=$_notificationFrequency');
    }
  }

  // Advanced settings
  void updateAdvancedSettings({
    bool? dataExportEnabled,
    bool? analyticsEnabled,
    String? accountStatus,
  }) {
    if (dataExportEnabled != null) _dataExportEnabled = dataExportEnabled;
    if (analyticsEnabled != null) _analyticsEnabled = analyticsEnabled;
    if (accountStatus != null) _accountStatus = accountStatus;
    
    if (kDebugMode) {
      print('Advanced settings updated: export=$_dataExportEnabled, analytics=$_analyticsEnabled, status=$_accountStatus');
    }
  }

  // Reset all settings to defaults
  void resetToDefaults() {
    _themeMode = 'light';
    _accentColor = 'purple';
    _profileVisibility = true;
    _activityVisibility = true;
    _achievementVisibility = true;
    _locationEnabled = false;
    _locationBasedFeatures = false;
    _pushNotifications = true;
    _emailNotifications = true;
    _transactionAlerts = true;
    _budgetAlerts = true;
    _goalAlerts = true;
    _notificationFrequency = 'immediate';
    _dataExportEnabled = true;
    _analyticsEnabled = true;
    _accountStatus = 'active';
    
    if (kDebugMode) {
      print('Settings reset to defaults');
    }
  }

  // Get all settings as a map (for database storage)
  Map<String, dynamic> getAllSettings() {
    return {
      'themeMode': _themeMode,
      'accentColor': _accentColor,
      'profileVisibility': _profileVisibility,
      'activityVisibility': _activityVisibility,
      'achievementVisibility': _achievementVisibility,
      'locationEnabled': _locationEnabled,
      'locationBasedFeatures': _locationBasedFeatures,
      'pushNotifications': _pushNotifications,
      'emailNotifications': _emailNotifications,
      'transactionAlerts': _transactionAlerts,
      'budgetAlerts': _budgetAlerts,
      'goalAlerts': _goalAlerts,
      'notificationFrequency': _notificationFrequency,
      'dataExportEnabled': _dataExportEnabled,
      'analyticsEnabled': _analyticsEnabled,
      'accountStatus': _accountStatus,
    };
  }

  /// Persist current settings for a given user id into Hive
  Future<void> saveForUser(String userId) async {
    try {
      final box = await Hive.openBox(AppConstants.hiveBoxSettings);
      await box.put(userId, getAllSettings());
      if (kDebugMode) print('Settings saved for user $userId');
      await box.close();
    } catch (e) {
      if (kDebugMode) print('Failed to save settings for $userId: $e');
    }
  }

  /// Load persisted settings for a given user id into memory
  Future<void> loadForUser(String userId) async {
    try {
      final box = await Hive.openBox(AppConstants.hiveBoxSettings);
      final data = box.get(userId) as Map<String, dynamic>?;
      if (data != null) loadSettings(Map<String, dynamic>.from(data));
      if (kDebugMode) print('Settings loaded for user $userId');
      await box.close();
    } catch (e) {
      if (kDebugMode) print('Failed to load settings for $userId: $e');
    }
  }

  // Load settings from a map (from database)
  void loadSettings(Map<String, dynamic> settings) {
    _themeMode = settings['themeMode'] ?? 'light';
    _accentColor = settings['accentColor'] ?? 'purple';
    _profileVisibility = settings['profileVisibility'] ?? true;
    _activityVisibility = settings['activityVisibility'] ?? true;
    _achievementVisibility = settings['achievementVisibility'] ?? true;
    _locationEnabled = settings['locationEnabled'] ?? false;
    _locationBasedFeatures = settings['locationBasedFeatures'] ?? false;
    _pushNotifications = settings['pushNotifications'] ?? true;
    _emailNotifications = settings['emailNotifications'] ?? true;
    _transactionAlerts = settings['transactionAlerts'] ?? true;
    _budgetAlerts = settings['budgetAlerts'] ?? true;
    _goalAlerts = settings['goalAlerts'] ?? true;
    _notificationFrequency = settings['notificationFrequency'] ?? 'immediate';
    _dataExportEnabled = settings['dataExportEnabled'] ?? true;
    _analyticsEnabled = settings['analyticsEnabled'] ?? true;
    _accountStatus = settings['accountStatus'] ?? 'active';
    
    if (kDebugMode) {
      print('Settings loaded from storage');
    }
  }
}
