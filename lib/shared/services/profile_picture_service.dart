import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Service for managing profile pictures
class ProfilePictureService {
  static final ProfilePictureService _instance = ProfilePictureService._internal();
  factory ProfilePictureService() => _instance;
  ProfilePictureService._internal();

  // Finance-related profile picture options
  static const List<Map<String, dynamic>> financeProfilePictures = [
    {
      'id': 'piggy_bank',
      'name': 'Piggy Bank',
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFF22C55E),
    },
    {
      'id': 'money_bag',
      'name': 'Money Bag',
      'icon': Icons.savings,
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 'coins',
      'name': 'Coins',
      'icon': Icons.monetization_on,
      'color': Color(0xFFF59E0B),
    },
    {
      'id': 'credit_card',
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'color': Color(0xFF3B82F6),
    },
    {
      'id': 'chart',
      'name': 'Growth Chart',
      'icon': Icons.trending_up,
      'color': Color(0xFF10B981),
    },
    {
      'id': 'calculator',
      'name': 'Calculator',
      'icon': Icons.calculate,
      'color': Color(0xFF8B5CF6),
    },
    {
      'id': 'receipt',
      'name': 'Receipt',
      'icon': Icons.receipt_long,
      'color': Color(0xFF6B7280),
    },
    {
      'id': 'diamond',
      'name': 'Diamond',
      'icon': Icons.diamond,
      'color': Color(0xFFEC4899),
    },
    {
      'id': 'shield',
      'name': 'Security Shield',
      'icon': Icons.security,
      'color': Color(0xFFEF4444),
    },
    {
      'id': 'target',
      'name': 'Target Goal',
      'icon': Icons.gps_fixed,
      'color': Color(0xFF06B6D4),
    },
  ];

  // User's uploaded images (in real app, would be stored in database)
  final Map<String, List<String>> _userUploadedImages = {};

  // Get all available profile picture options
  List<Map<String, dynamic>> getAllProfilePictures() {
    return List.from(financeProfilePictures);
  }

  // Get user's uploaded images
  List<String> getUserUploadedImages(String userId) {
    return _userUploadedImages[userId] ?? [];
  }

  // Add uploaded image for user
  void addUserImage(String userId, String imagePath) {
    _userUploadedImages[userId] ??= [];
    _userUploadedImages[userId]!.add(imagePath);
    
    if (kDebugMode) {
      print('Added image for user $userId: $imagePath');
    }
  }

  // Remove uploaded image for user
  void removeUserImage(String userId, String imagePath) {
    _userUploadedImages[userId]?.remove(imagePath);
    
    if (kDebugMode) {
      print('Removed image for user $userId: $imagePath');
    }
  }

  // Get profile picture widget based on type and value
  Widget getProfilePictureWidget({
    required String type,
    required String value,
    double size = 60,
  }) {
    if (type == 'unknown_user') {
      return Icon(
        Icons.person,
        size: size,
        color: Colors.grey,
      );
    } else if (type == 'finance_icon') {
      final picture = financeProfilePictures.firstWhere(
        (pic) => pic['id'] == value,
        orElse: () => financeProfilePictures.first,
      );
      return Icon(
        picture['icon'] as IconData,
        size: size,
        color: picture['color'] as Color,
      );
    } else if (type == 'uploaded_image') {
      return ClipOval(
        child: Image.file(
          File(value),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: size,
              color: Colors.grey,
            );
          },
        ),
      );
    }
    
    // Default fallback
    return Icon(
      Icons.person,
      size: size,
      color: Colors.grey,
    );
  }

  // Check if file exists
  bool fileExists(String path) {
    try {
      return File(path).existsSync();
    } catch (e) {
      return false;
    }
  }

  // Clean up invalid image paths
  void cleanupInvalidImages(String userId) {
    final images = _userUploadedImages[userId];
    if (images != null) {
      images.removeWhere((path) => !fileExists(path));
    }
  }
}
