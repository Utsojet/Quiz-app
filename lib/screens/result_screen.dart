import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/illustrations.dart';
import 'category_screen.dart';

/// Screen 5: Results Screen (Matches Figma Screenshots 6 & 7)
/// Dynamically displays Congratulations (>=70%) or Keep Trying! (<70%)
/// with percentage badge, score, quiz time, and PLAY AGAIN CTA.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final score = quizProvider.score;
    final total = quizProvider.totalQuestions;
    final accuracy = total > 0 ? (score / total) * 100 : 0.0;
    final isHighScore = accuracy >= 70.0;
    final timeFormatted = _formatTime(quizProvider.totalQuizTimeSeconds);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // On system back, reset and go to category screen
        quizProvider.resetQuiz();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CategoryScreen()),
          (route) => route.isFirst,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 16),
                          child: Column(
                            children: [
                              const Spacer(flex: 1),

                              // Visual State Illustration (Party Popper or Keep Trying)
                              if (isHighScore)
                                const PartyPopperIllustration(size: 210)
                              else
                                const KeepTryingIllustration(size: 190),

                              const SizedBox(height: 20),

                        // Title matching Screenshot 6 / 7
                        Text(
                          isHighScore ? 'Congratulation' : 'Keep Trying!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Percentage Score Badge (Screenshot 6: Green pill, Screenshot 7: Red pill)
                        Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isHighScore
                                ? const Color(0xFF86EFAC).withValues(alpha: 0.9)
                                : const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (isHighScore
                                        ? const Color(0xFF86EFAC)
                                        : const Color(0xFFEF4444))
                                    .withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${accuracy.round()}%',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: isHighScore
                                    ? const Color(0xFF065F46)
                                    : Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Descriptive message matching screenshots
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            isHighScore
                                ? "You've got a great foundation. Ready to try a different category?"
                                : "Dont give up! Practice makes perfect. Try again to improve your score",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Performance Summary Card (Score, Accuracy, Time)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Score', '$score/$total'),
                              Container(
                                width: 1,
                                height: 32,
                                color: const Color(0xFFE2E8F0),
                              ),
                              _buildStatItem(
                                  'Accuracy', '${accuracy.toStringAsFixed(1)}%'),
                              Container(
                                width: 1,
                                height: 32,
                                color: const Color(0xFFE2E8F0),
                              ),
                              _buildStatItem('Time', timeFormatted),
                            ],
                          ),
                        ),

                        const Spacer(flex: 2),

                        // PLAY AGAIN CTA Button
                        ElevatedButton(
                          onPressed: () {
                            quizProvider.resetQuiz();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CategoryScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: const Text(
                            'PLAY AGAIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
            },
          ),
        ),
      ),
    ),
  ),
);
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
