import 'package:flutter/material.dart';

/// PennyPal color system following the design specifications
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF4F46E5); // Indigo - Primary actions
  static const Color secondary = Color(0xFF22C55E); // Green - Success/Money
  static const Color accent = Color(0xFFF59E0B); // Amber - Highlights/Rewards

  // Dark Theme Background Hierarchy
  static const Color background = Color(0xFF0F1222); // Main background
  static const Color surface = Color(0xFF171A2B); // Cards/containers
  static const Color surfaceVariant = Color(0xFF1C2336); // Elevated cards

  // Text & Content
  static const Color onPrimary = Color(0xFFF8FAFC); // Primary text
  static const Color onSecondary = Color(0xFFCBD5E1); // Secondary text
  static const Color onSurface = Color(0xFF94A3B8); // Disabled/placeholder

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Positive transactions
  static const Color warning = Color(0xFFF59E0B); // Budget warnings
  static const Color error = Color(0xFFEF4444); // Errors/overspending
  static const Color info = Color(0xFF3B82F6); // Information states

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFD97706)],
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

  /// Create a ColorScheme for the app
  static ColorScheme get colorScheme => const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        onSurface: onPrimary,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSecondary,
        error: error,
        onError: onPrimary,
        outline: onSurface,
        outlineVariant: Color(0xFF475569),
        inverseSurface: onPrimary,
        onInverseSurface: surface,
        inversePrimary: Color(0xFF312E81),
      );
}
