import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/lesson.dart';
import '../../../../shared/services/gamification_service.dart';
import '../../../../shared/widgets/confetti_celebration.dart';

class LessonViewerPage extends StatefulWidget {
  final Lesson lesson;

  const LessonViewerPage({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonViewerPage> createState() => _LessonViewerPageState();
}

class _LessonViewerPageState extends State<LessonViewerPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showQuiz = false;
  int _selectedAnswerIndex = -1;
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  int _correctAnswers = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleQuizAnswer(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
    });
  }

  void _submitAnswer() {
    final currentQuestion = widget.lesson.quizQuestions[_currentQuestionIndex];
    final isCorrect = _selectedAnswerIndex == currentQuestion.correctAnswerIndex;
    
    if (isCorrect) {
      setState(() {
        _correctAnswers++;
      });
    }
    
    // Show explanation with confetti if correct
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        children: [
          AlertDialog(
            title: Text(
              isCorrect
                  ? 'Correct! 🎉'
                  : 'Not quite',
              style: TextStyle(
                color: isCorrect
                    ? AppColors.success
                    : AppColors.error,
              ),
            ),
            content: Text(currentQuestion.explanation),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  
                  if (_currentQuestionIndex < widget.lesson.quizQuestions.length - 1) {
                    setState(() {
                      _currentQuestionIndex++;
                      _selectedAnswerIndex = -1;
                    });
                  } else {
                    setState(() {
                      _quizCompleted = true;
                    });
                    
                    // Award XP for completing lesson
                    final gamificationService = GamificationService();
                    gamificationService.completeQuiz(
                      score: (_correctAnswers / widget.lesson.quizQuestions.length * 100).round(),
                      quizId: widget.lesson.id,
                    );
                  }
                },
                child: const Text('Continue'),
              ),
            ],
          ),
          if (isCorrect)
            const ConfettiCelebration(
              duration: 2000,
              colors: [
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        actions: [
          Icon(
            widget.lesson.icon,
            color: widget.lesson.color,
          ),
          const SizedBox(width: AppTheme.md),
        ],
      ),
      body: _quizCompleted
          ? _buildCompletionScreen()
          : _showQuiz
              ? _buildQuizScreen()
              : _buildContentScreen(),
    );
  }

  Widget _buildContentScreen() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.xl),
                  decoration: BoxDecoration(
                    color: widget.lesson.color.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
                    border: Border.all(
                      color: widget.lesson.color.withAlpha((0.3 * 255).round()),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        widget.lesson.icon,
                        size: 48,
                        color: widget.lesson.color,
                      ).animate().scale(duration: 600.ms),
                      const SizedBox(height: AppTheme.md),
                      Text(
                        widget.lesson.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.lesson.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.sm),
                      Text(
                        widget.lesson.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

                const SizedBox(height: AppTheme.xl),

                // Lesson Info
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.schedule,
                      text: '${widget.lesson.duration} min',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppTheme.md),
                    _InfoChip(
                      icon: Icons.school,
                      text: widget.lesson.difficulty,
                      color: AppColors.info,
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).then(delay: 200.ms),

                const SizedBox(height: AppTheme.xl),

                // Lesson Content
                Container(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                  ),
                  child: Text(
                    widget.lesson.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).then(delay: 400.ms),

                const SizedBox(height: AppTheme.xxl),
              ],
            ),
          ),
        ),

        // Bottom Button
        Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withAlpha((0.1 * 255).round()),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showQuiz = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.lesson.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.quiz, size: 24),
                    SizedBox(width: AppTheme.sm),
                    Text(
                      'Take Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizScreen() {
    final theme = Theme.of(context);
    final currentQuestion = widget.lesson.quizQuestions[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Text(
            'Question ${_currentQuestionIndex + 1} of ${widget.lesson.quizQuestions.length}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.sm),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.lesson.quizQuestions.length,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(widget.lesson.color),
          ),

          const SizedBox(height: AppTheme.xl),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.xl),
            decoration: BoxDecoration(
              color: widget.lesson.color.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
            ),
            child: Text(
              currentQuestion.question,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

          const SizedBox(height: AppTheme.xl),

          // Options
          ...currentQuestion.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswerIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.md),
              child: InkWell(
                onTap: () => _handleQuizAnswer(index),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.lg),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.lesson.color.withAlpha((0.2 * 255).round())
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                    border: Border.all(
                      color: isSelected
                          ? widget.lesson.color
                          : theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? widget.lesson.color
                                : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),
                            width: 2,
                          ),
                          color: isSelected ? widget.lesson.color : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: AppTheme.md),
                      Expanded(
                        child: Text(
                          option,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2).then(delay: 100.ms * index);
          }),

          const SizedBox(height: AppTheme.xxl),

          // Submit Button
          ElevatedButton(
            onPressed: _selectedAnswerIndex >= 0 ? _submitAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.lesson.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              ),
            ),
            child: const Text(
              'Submit Answer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).then(delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final theme = Theme.of(context);
    final score = (_correctAnswers / widget.lesson.quizQuestions.length * 100).round();

    return Stack(
      children: [
        // Confetti Effect
        const Align(
          alignment: Alignment.topCenter,
          child: ConfettiCelebration(
            duration: 3000,
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.orange,
            ],
          ),
        ),
        // Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppTheme.xxl),

          // Success Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha((0.2 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration,
              size: 64,
              color: AppColors.success,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: AppTheme.xl),

          // Completion Message
          Text(
            'Lesson Complete!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms).then(delay: 300.ms),

          const SizedBox(height: AppTheme.md),

          Text(
            'Great job! You scored $score%',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms).then(delay: 500.ms),

          const SizedBox(height: AppTheme.xxl),

          // Stats
          Container(
            padding: const EdgeInsets.all(AppTheme.xl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
            ),
            child: Column(
              children: [
                _StatRow(
                  label: 'Questions Answered',
                  value: '${widget.lesson.quizQuestions.length}',
                ),
                const SizedBox(height: AppTheme.md),
                _StatRow(
                  label: 'Correct Answers',
                  value: '$_correctAnswers',
                  valueColor: AppColors.success,
                ),
                const SizedBox(height: AppTheme.md),
                _StatRow(
                  label: 'Score',
                  value: '$score%',
                  valueColor: AppColors.success,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).then(delay: 700.ms),

          const SizedBox(height: AppTheme.xxl),

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.lesson.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                ),
              ),
              child: const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).then(delay: 900.ms),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.md,
        vertical: AppTheme.sm,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg.x),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppTheme.xs),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

