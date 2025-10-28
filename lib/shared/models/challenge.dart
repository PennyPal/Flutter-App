import 'package:flutter/material.dart';

/// Model for financial challenges
class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final ChallengeCategory category;
  final IconData icon;
  final Color color;
  final double targetValue;
  final int durationDays;
  DateTime? startDate;
  DateTime? endDate;
  double currentProgress;
  bool isActive;
  bool isCompleted;
  DateTime? completedAt;
  final int xpReward;
  final String? badgeId;
  final String? powerUpId;
  final Map<String, dynamic> metadata;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.icon,
    required this.color,
    required this.targetValue,
    required this.durationDays,
    this.startDate,
    this.endDate,
    this.currentProgress = 0,
    this.isActive = false,
    this.isCompleted = false,
    this.completedAt,
    required this.xpReward,
    this.badgeId,
    this.powerUpId,
    this.metadata = const {},
  });

  bool get canJoin => !isActive && !isCompleted;
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    ChallengeCategory? category,
    IconData? icon,
    Color? color,
    double? targetValue,
    int? durationDays,
    DateTime? startDate,
    DateTime? endDate,
    double? currentProgress,
    bool? isActive,
    bool? isCompleted,
    DateTime? completedAt,
    int? xpReward,
    String? badgeId,
    String? powerUpId,
    Map<String, dynamic>? metadata,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      targetValue: targetValue ?? this.targetValue,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentProgress: currentProgress ?? this.currentProgress,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      xpReward: xpReward ?? this.xpReward,
      badgeId: badgeId ?? this.badgeId,
      powerUpId: powerUpId ?? this.powerUpId,
      metadata: metadata ?? this.metadata,
    );
  }

  void joinChallenge() {
    final now = DateTime.now();
    startDate = now;
    endDate = now.add(Duration(days: durationDays));
    isActive = true;
    currentProgress = 0;
  }

  void completeChallenge() {
    isActive = false;
    isCompleted = true;
    completedAt = DateTime.now();
    endDate = null;
  }

  void cancelChallenge() {
    isActive = false;
    startDate = null;
    endDate = null;
    currentProgress = 0;
  }

  double get progressPercentage => currentProgress / targetValue;
}

enum ChallengeType {
  spending,
  saving,
  budgeting,
  earning,
  investing,
}

enum ChallengeCategory {
  beginner,
  intermediate,
  advanced,
}