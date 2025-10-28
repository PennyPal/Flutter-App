import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

/// A widget that shows confetti celebration effect
class ConfettiCelebration extends StatefulWidget {
  const ConfettiCelebration({
    super.key,
    required this.duration,
    required this.colors,
  });

  /// Duration of the confetti animation (in milliseconds)
  final int duration;

  /// Colors for the confetti
  final List<Color> colors;

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(milliseconds: widget.duration));
    // Play confetti immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirection: 3.14 / 2, // Blast upwards
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.1,
        colors: widget.colors,
      ),
    );
  }
}

/// Predefined confetti celebration configurations
class ConfettiConfigs {
  /// Level up celebration
  static List<Color> levelUp = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  /// Achievement celebration
  static List<Color> achievement = [
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  /// Goal completion celebration
  static List<Color> goalComplete = [
    Colors.green,
    Colors.lightGreen,
    Colors.teal,
  ];

  /// Badge celebration
  static List<Color> badge = [
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.blueAccent,
  ];
}

