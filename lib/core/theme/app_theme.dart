import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_scheme.dart';
import 'text_theme.dart';

/// Main theme configuration for PennyPal
class AppTheme {
  AppTheme._();

  /// Spacing constants following 4px base unit
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  /// Border radius constants
  static const Radius radiusSm = Radius.circular(8.0);
  static const Radius radiusMd = Radius.circular(12.0);
  static const Radius radiusLg = Radius.circular(16.0);
  static const Radius radiusXl = Radius.circular(20.0);
  static const Radius radius2xl = Radius.circular(24.0);

  /// Animation durations and curves
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve emphasizedCurve = Curves.easeOutCubic;

  /// Main app theme
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
  colorScheme: AppColors.colorScheme.copyWith(background: AppColors.background),
  textTheme: AppTextTheme.textTheme,
  scaffoldBackgroundColor: AppColors.background,
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: AppTextTheme.textTheme.titleLarge,
        ),

        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.surface,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radiusMd),
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: xl,
              vertical: md,
            ),
            textStyle: AppTextTheme.button,
            minimumSize: const Size(88, 48),
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: xl,
              vertical: md,
            ),
            textStyle: AppTextTheme.button,
            minimumSize: const Size(88, 48),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: lg,
              vertical: sm,
            ),
            textStyle: AppTextTheme.button,
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(radiusMd),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(radiusMd),
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(radiusMd),
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: lg,
            vertical: md,
          ),
          hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.onSurface,
          ),
          labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.onSecondary,
          ),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurface,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          disabledColor: AppColors.onSurface.withValues(alpha: 0.1),
          labelStyle: AppTextTheme.textTheme.labelMedium,
          secondaryLabelStyle: AppTextTheme.textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: md, vertical: xs),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radiusSm),
          ),
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
          linearTrackColor: AppColors.surfaceVariant,
          circularTrackColor: AppColors.surfaceVariant,
        ),

        // Snack Bar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceVariant,
          contentTextStyle: AppTextTheme.textTheme.bodyMedium,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radiusMd),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radiusXl),
          ),
          titleTextStyle: AppTextTheme.textTheme.headlineSmall,
          contentTextStyle: AppTextTheme.textTheme.bodyMedium,
        ),

        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: radiusXl,
            ),
          ),
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: AppColors.onSurface.withValues(alpha: 0.1),
          thickness: 1,
          space: 1,
        ),

        // List Tile Theme
        listTileTheme: ListTileThemeData(
          tileColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: lg,
            vertical: xs,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radiusMd),
          ),
          titleTextStyle: AppTextTheme.textTheme.bodyLarge,
          subtitleTextStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.onSecondary,
          ),
        ),

        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return AppColors.onSurface;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.3);
            }
            return AppColors.surfaceVariant;
          }),
        ),

        // Checkbox Theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.onPrimary),
          side: const BorderSide(color: AppColors.onSurface, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),

        // Material 3 components
        extensions: const <ThemeExtension<dynamic>>[
          _AppThemeExtension(
            primaryGradient: AppColors.primaryGradient,
            pinkGradient: AppColors.pinkGradient,
            cardGradient: AppColors.cardGradient,
          ),
        ],
      );
}

/// Custom theme extension for additional properties
@immutable
class _AppThemeExtension extends ThemeExtension<_AppThemeExtension> {
  const _AppThemeExtension({
    required this.primaryGradient,
    required this.pinkGradient,
    required this.cardGradient,
  });

  final LinearGradient primaryGradient;
  final LinearGradient pinkGradient;
  final LinearGradient cardGradient;

  @override
  _AppThemeExtension copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? pinkGradient,
    LinearGradient? cardGradient,
  }) {
    return _AppThemeExtension(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      pinkGradient: pinkGradient ?? this.pinkGradient,
      cardGradient: cardGradient ?? this.cardGradient,
    );
  }

  @override
  _AppThemeExtension lerp(_AppThemeExtension? other, double t) {
    if (other is! _AppThemeExtension) {
      return this;
    }
    return _AppThemeExtension(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      pinkGradient: LinearGradient.lerp(pinkGradient, other.pinkGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
    );
  }
}
