import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/illustrations.dart';
import 'quiz_screen.dart';

/// Screen 3: Quiz Configuration (Matches Figma Screenshot 3)
/// Allows user to select amount of questions (1-50 slider), difficulty level,
/// and question type (Multiple Choice / True-False), with SharedPreferences persistence.
class QuizConfigScreen extends StatelessWidget {
  const QuizConfigScreen({super.key});

  static const List<String> _difficultyOptions = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard',
  ];

  static const List<String> _typeOptions = [
    'Multiple Choice',
    'True / False',
  ];

  void _handleStart(BuildContext context) async {
    final quizProvider = context.read<QuizProvider>();
    final success = await quizProvider.startQuiz();

    if (!context.mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    } else {
      // Show user-friendly error dialog with Retry option
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Unable to Start Quiz',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            quizProvider.error ??
                'No questions are available for this configuration. Please try adjusting your parameters.',
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Adjust Settings'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _handleStart(context);
              },
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Settings Illustration
                  const Center(
                    child: ConfigHeroIllustration(size: 160),
                  ),
                  const SizedBox(height: 16),

                  // Header Titles matching Screenshot 3
                  const Text(
                    'Quizzical',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Configuration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.selectedCategoryName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Section 1: Number of Questions (1-50 Slider)
                  const Text(
                    'Number of Questions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select 1–50',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${provider.amount}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.sliderActive,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.amount.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    onChanged: (val) {
                      provider.updateConfig(amount: val.round());
                    },
                  ),
                  const SizedBox(height: 18),

                  // Section 2: Difficulty Level Dropdown
                  const Text(
                    'Difficulty Level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _difficultyOptions.contains(provider.difficulty)
                            ? provider.difficulty
                            : _difficultyOptions.first,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                        items: _difficultyOptions.map((diff) {
                          return DropdownMenuItem<String>(
                            value: diff,
                            child: Text(
                              diff,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newDiff) {
                          if (newDiff != null) {
                            provider.updateConfig(difficulty: newDiff);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 3: Question Type Dropdown
                  const Text(
                    'Question Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _typeOptions.contains(provider.questionType)
                            ? provider.questionType
                            : _typeOptions.first,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                        items: _typeOptions.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newType) {
                          if (newType != null) {
                            provider.updateConfig(questionType: newType);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // START Button (Matches Screenshot 3 styling)
                  OutlinedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () => _handleStart(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          )
                        : const Text(
                            'START',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
