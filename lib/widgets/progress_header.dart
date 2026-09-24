import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Top quiz header containing question counter, countdown timer, exit button,
/// and animated progress bar (Matches Figma Screenshots 4 & 5).
class ProgressHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int remainingSeconds;
  final VoidCallback onExit;

  const ProgressHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.remainingSeconds,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0 ? currentQuestion / totalQuestions : 0.0;
    final isTimerLow = remainingSeconds <= 5;

    return Column(
      children: [
        // Top Counter, Timer Badge, and Exit Action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Question Counter (e.g. 7/10)
              Text(
                '$currentQuestion/$totalQuestions',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),

              // Countdown Timer Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTimerLow
                      ? const Color(0xFFFEE2E2)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isTimerLow
                        ? const Color(0xFFEF4444)
                        : AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: isTimerLow
                          ? const Color(0xFFDC2626)
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${remainingSeconds}s',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isTimerLow
                            ? const Color(0xFFDC2626)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // EXIT button matching screenshot: "EXIT ➔"
              InkWell(
                onTap: onExit,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'EXIT',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0080FF)),
          ),
        ),
      ],
    );
  }
}
