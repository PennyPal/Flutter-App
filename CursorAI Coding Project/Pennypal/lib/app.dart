import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'shared/providers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main application widget
class PennyPalApp extends ConsumerWidget {
  const PennyPalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsNotifierProvider);

    // Build a ThemeData based on current settings so theme changes immediately
    final themeMode = settings.themeMode;
    final accent = settings.accentColor;

    final base = AppTheme.theme;

    // map accent to a real color
    Color primaryColor = base.colorScheme.primary;
    switch (accent) {
      case 'blue':
        primaryColor = const Color(0xFF3B82F6);
        break;
      case 'green':
        primaryColor = const Color(0xFF10B981);
        break;
      case 'red':
        primaryColor = const Color(0xFFEF4444);
        break;
      case 'orange':
        primaryColor = const Color(0xFFF59E0B);
        break;
      case 'purple':
      default:
        primaryColor = const Color(0xFF6B2C91);
        break;
    }

    final dynamicTheme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
      ),
    );

    // Build a dark theme variant from the base and apply primaryColor mapping
    final darkBase = AppTheme.theme.copyWith(
      colorScheme: AppTheme.theme.colorScheme.copyWith(brightness: Brightness.dark, primary: primaryColor),
    );

    ThemeMode appThemeMode = ThemeMode.system;
    if (themeMode == 'dark') appThemeMode = ThemeMode.dark;
    if (themeMode == 'light') appThemeMode = ThemeMode.light;

    return MaterialApp.router(
      title: 'PennyPal',
      debugShowCheckedModeBanner: false,
      theme: dynamicTheme,
      darkTheme: darkBase,
      themeMode: appThemeMode,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
