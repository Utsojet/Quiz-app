import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/answer_button.dart';
import '../widgets/progress_header.dart';
import 'result_screen.dart';

/// Screen 4: Quiz Screen (Matches Figma Screenshots 4 & 5)
/// Displays one question at a time, animated progress bar, countdown timer,
/// shuffled options, correct/incorrect instant feedback, and Next button.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizProvider? _quizProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quizProvider = Provider.of<QuizProvider>(context, listen: false);
  }

  @override
  void dispose() {
    if (_quizProvider != null && !_quizProvider!.isQuizFinished) {
      _quizProvider!.stopTimer();
    }
    super.dispose();
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final quizProvider = context.read<QuizProvider>();
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Exit Quiz?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your current progress will be lost. Are you sure you want to exit?',
          style: TextStyle(fontSize: 15, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      quizProvider.resetQuiz();
      return true;
    }
    return false;
  }

  void _handleNext(BuildContext context) {
    final quizProvider = context.read<QuizProvider>();
    final hasMore = quizProvider.nextQuestion();

    if (!hasMore) {
      // Completed all questions -> Navigate to Results Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<QuizProvider>(
            builder: (context, provider, child) {
              final Question? question = provider.currentQuestion;

              if (question == null) {
                return const Center(
                  child: Text(
                    'No questions available.',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // Top Progress Header (Counter, Timer, Exit Button, Progress Bar)
                    ProgressHeader(
                      currentQuestion: provider.currentQuestionIndex + 1,
                      totalQuestions: provider.totalQuestions,
                      remainingSeconds: provider.remainingSeconds,
                      onExit: () async {
                        final shouldExit = await _showExitConfirmation(context);
                        if (shouldExit && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Scrollable Question & Options area
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Question Card matching Screenshot 4 & 5
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 26,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                question.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Answer Options List
                            ...question.options.map((option) {
                              final isSelected =
                                  provider.selectedAnswer == option;
                              final isCorrect =
                                  option == question.correctAnswer;

                              return AnswerButton(
                                text: option,
                                isSelected: isSelected,
                                isCorrect: isCorrect,
                                hasAnswered: provider.hasAnswered,
                                onTap: () => provider.selectAnswer(option),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Next Button at bottom (Enabled once user has answered or timed out)
                    ElevatedButton(
                      onPressed: provider.hasAnswered
                          ? () => _handleNext(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: Text(
                        provider.currentQuestionIndex ==
                                provider.totalQuestions - 1
                            ? 'Finish'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
