import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import '../services/user_service.dart';

/// Lightweight settings model used by Riverpod to allow immediate UI updates
class SettingsModel {
  final String themeMode;
  final String accentColor;

  SettingsModel({required this.themeMode, required this.accentColor});

  SettingsModel copyWith({String? themeMode, String? accentColor}) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsService _service = SettingsService();

  SettingsNotifier()
      : super(SettingsModel(themeMode: SettingsService().themeMode, accentColor: SettingsService().accentColor));

  void updateThemeMode(String mode) {
    _service.updateThemeSettings(themeMode: mode);
    state = state.copyWith(themeMode: mode);
    // persist for current user (use email if available else username)
    final userKey = UserService().userEmail.isNotEmpty ? UserService().userEmail : UserService().username;
    _service.saveForUser(userKey);
  }

  void updateAccentColor(String color) {
    _service.updateThemeSettings(accentColor: color);
    state = state.copyWith(accentColor: color);
    final userKey = UserService().userEmail.isNotEmpty ? UserService().userEmail : UserService().username;
    _service.saveForUser(userKey);
  }
}

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  return SettingsNotifier();
});
