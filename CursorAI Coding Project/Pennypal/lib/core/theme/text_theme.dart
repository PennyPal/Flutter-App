import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_scheme.dart';

/// Typography system for PennyPal using Inter font
class AppTextTheme {
  AppTextTheme._();

  /// Base text style with Inter font
  static TextStyle get _baseTextStyle => GoogleFonts.inter(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w400,
      );

  /// Material 3 text theme adapted for PennyPal
  static TextTheme get textTheme => TextTheme(
        // Display styles
        displayLarge: _baseTextStyle.copyWith(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: _baseTextStyle.copyWith(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
        ),
        displaySmall: _baseTextStyle.copyWith(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),

        // Headline styles
        headlineLarge: _baseTextStyle.copyWith(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineMedium: _baseTextStyle.copyWith(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        headlineSmall: _baseTextStyle.copyWith(
          fontSize: 18,
          height: 24 / 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),

        // Title styles
        titleLarge: _baseTextStyle.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        titleMedium: _baseTextStyle.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        titleSmall: _baseTextStyle.copyWith(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),

        // Body styles
        bodyLarge: _baseTextStyle.copyWith(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        bodyMedium: _baseTextStyle.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: _baseTextStyle.copyWith(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),

        // Label styles
        labelLarge: _baseTextStyle.copyWith(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: _baseTextStyle.copyWith(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: _baseTextStyle.copyWith(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );

  /// Custom text styles for specific use cases
  static TextStyle get currencyLarge => _baseTextStyle.copyWith(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.success,
      );

  static TextStyle get currencyMedium => _baseTextStyle.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.success,
      );

  static TextStyle get currencySmall => _baseTextStyle.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.success,
      );

  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.onPrimary,
      );

  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.onSecondary,
      );

  static TextStyle get overline => _baseTextStyle.copyWith(
        fontSize: 10,
        height: 16 / 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: AppColors.onSurface,
      );
}
