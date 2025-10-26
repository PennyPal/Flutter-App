import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../shared/providers/settings_notifier.dart';
import '../../../core/theme/app_theme.dart';

Color _accentOnTextColor(String accentKey) {
  // white for purple/blue/red; black for green/orange
  switch (accentKey) {
    case 'purple':
    case 'blue':
    case 'red':
      return Colors.white;
    case 'green':
    case 'orange':
    default:
      return Colors.black;
  }
}

Color _lightenColor(Color color, [double amount = 0.2]) {
  final hsl = HSLColor.fromColor(color);
  final light = (hsl.lightness + amount).clamp(0.0, 1.0).toDouble();
  return hsl.withLightness(light).toColor();
}

Color _activeIconColor(Color primary, bool isDark) {
  return isDark ? _lightenColor(primary, 0.22) : primary;
}

/// Main layout with bottom navigation for the app
class MainLayout extends ConsumerWidget {
  const MainLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    // map accent to a real color
    Color primaryColor = AppTheme.theme.colorScheme.primary;
    switch (settings.accentColor) {
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

    // Determine brightness for in-app theme
    Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (settings.themeMode == 'dark') brightness = Brightness.dark;
    if (settings.themeMode == 'light') brightness = Brightness.light;

    final base = AppTheme.theme;
    final isDark = brightness == Brightness.dark;
    // Build an in-app color scheme that enforces white text for dark mode and
    // keeps accent->onAccent rules (purple/blue/red => white; green/orange => black).
    final inAppColorScheme = base.colorScheme.copyWith(
      primary: primaryColor,
      onPrimary: _accentOnTextColor(settings.accentColor),
      brightness: brightness,
  // For dark mode, force the main surfaces to the requested colors
  // (use surface/onSurface — background/onBackground are deprecated)
  surface: isDark ? const Color(0xFF3E2F33) : base.colorScheme.surface,
  // Force readable on* colors in dark mode
  onSurface: isDark ? Colors.white : base.colorScheme.onSurface,
      onSecondary: isDark ? Colors.white : base.colorScheme.onSecondary,
      onError: isDark ? Colors.white : base.colorScheme.onError,
    );

    final inAppTheme = base.copyWith(
      colorScheme: inAppColorScheme,
      // scaffold background mirrors background in dark mode
      scaffoldBackgroundColor: isDark ? const Color(0xFF0B1220) : AppColors.background,
      // Force card/dialog backgrounds to the dark surface for full coverage
      cardColor: isDark ? const Color(0xFF3E2F33) : base.cardColor,
      dialogTheme: base.dialogTheme.copyWith(backgroundColor: isDark ? const Color(0xFF3E2F33) : base.dialogTheme.backgroundColor),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: primaryColor,
        foregroundColor: inAppColorScheme.onPrimary,
      ),
    // Force all text to white in dark mode to improve readability across the app.
    textTheme: isDark ? base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white) : base.textTheme,
    // Ensure elevated surfaces on primary use the onPrimary color for labels
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: _accentOnTextColor(settings.accentColor),
      ),
    ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: primaryColor, side: BorderSide(color: primaryColor)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: base.colorScheme.surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: base.colorScheme.onSurface,
      ),
      chipTheme: base.chipTheme.copyWith(
  // Replace withOpacity (deprecated) with withAlpha for precision
  selectedColor: primaryColor.withAlpha((0.2 * 255).round()),
        // Ensure chip label contrast on selected chips (e.g., purple) is white in dark mode
        secondaryLabelStyle: base.chipTheme.secondaryLabelStyle?.copyWith(color: isDark ? Colors.white : primaryColor),
        labelStyle: base.chipTheme.labelStyle?.copyWith(color: isDark ? Colors.white : base.chipTheme.labelStyle?.color),
      ),
      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(color: primaryColor),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return isDark ? Colors.white : base.colorScheme.onSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor.withAlpha((0.3 * 255).round());
          return isDark ? Colors.white.withAlpha((0.12 * 255).round()) : base.colorScheme.surfaceContainerHighest;
        }),
      ),
      checkboxTheme: base.checkboxTheme.copyWith(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(AppTheme.radiusMd), borderSide: BorderSide(color: primaryColor, width: 2)),
      ),
    );

    return Theme(
      data: inAppTheme,
      child: Scaffold(
        body: child,
        bottomNavigationBar: const _BottomNavBar(),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'Home 🏠',
                isActive: location == RouteNames.home,
                onTap: () => context.go(RouteNames.home),
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Money 💰',
                isActive: location.startsWith(RouteNames.transactions),
                onTap: () => context.go(RouteNames.transactions),
              ),
              _NavItem(
                icon: Icons.pie_chart_outline,
                activeIcon: Icons.pie_chart,
                label: 'Budgets 📊',
                isActive: location.startsWith(RouteNames.budgets),
                onTap: () => context.go(RouteNames.budgets),
              ),
              _NavItem(
                icon: Icons.monetization_on_outlined,
                activeIcon: Icons.monetization_on,
                label: 'Penny 🐷',
                isActive: location.startsWith(RouteNames.chat),
                onTap: () => context.go(RouteNames.chat),
              ),
              _NavItem(
                icon: Icons.school_outlined,
                activeIcon: Icons.school,
                label: 'Learn 📚',
                isActive: location.startsWith(RouteNames.learn),
                onTap: () => context.go(RouteNames.learn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

  final primary = theme.colorScheme.primary;
  final onSurface = theme.colorScheme.onSurface;
  final isDark = theme.brightness == Brightness.dark;
  final activeColor = _activeIconColor(primary, isDark);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive ? primary.withAlpha((0.08 * 255).round()) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? activeColor : onSurface,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isActive ? activeColor : onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
