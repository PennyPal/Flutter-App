import 'package:flutter/material.dart';

/// PennyPal color system following the Figma design specifications
class AppColors {
  AppColors._();

  // Primary Brand Colors - Pink/Peach Theme from Figma
  static const Color primary = Color(0xFF22C55E); // Green - Primary actions & buttons
  static const Color secondary = Color(0xFFFF6B9D); // Pink - Secondary accents
  static const Color accent = Color(0xFFFFC0CB); // Light pink - Highlights

  // Light Theme Background Hierarchy (matching Figma)
  static const Color background = Color(0xFFFDF2F8); // Light pink background
  static const Color surface = Color(0xFFFFFFFF); // White cards/containers
  static const Color surfaceVariant = Color(0xFFFCE7F3); // Light pink elevated cards

  // Text & Content (dark text on light background)
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color onSecondary = Color(0xFF374151); // Dark gray text
  static const Color onSurface = Color(0xFF6B7280); // Medium gray text
  static const Color onSurfaceDark = Color(0xFF9D174D); // Dark pink/magenta for better contrast

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Positive transactions
  static const Color warning = Color(0xFFF59E0B); // Budget warnings
  static const Color error = Color(0xFFEF4444); // Errors/overspending
  static const Color info = Color(0xFF3B82F6); // Information states

  // Gradient Colors - Soft pink/green theme
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFFDF2F8), Color(0xFFFCE7F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, surfaceVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category Colors for better visualization
  static const List<Color> categoryColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFFF97316), // Orange
    Color(0xFFEC4899), // Pink
  ];

  /// Get color for specific category by ID
  static Color getCategoryColor(String categoryId) {
    final hash = categoryId.hashCode;
    return categoryColors[hash.abs() % categoryColors.length];
  }

  /// Create a ColorScheme for the app - Light theme to match Figma
  static ColorScheme get colorScheme => const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        onSurface: onSecondary,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurface,
        error: error,
        onError: onPrimary,
        outline: onSurface,
        outlineVariant: Color(0xFFD1D5DB),
        inverseSurface: onSecondary,
        onInverseSurface: surface,
        inversePrimary: Color(0xFFDCFCE7),
        brightness: Brightness.light,
      );
}
