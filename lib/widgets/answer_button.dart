import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Interactive answer option card for quiz questions.
/// Supports neutral, correct, incorrect, and disabled states (Matches Figma Screenshots 4 & 5).
class AnswerButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card background and border colors based on quiz answer state
    Color backgroundColor = AppColors.answerNeutralBg;
    Color borderColor = const Color(0xFFF1F5F9);
    Color textColor = AppColors.textPrimary;
    Widget trailingIndicator = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
    );

    if (hasAnswered) {
      if (isSelected && isCorrect) {
        // User picked this and it is CORRECT
        backgroundColor = AppColors.answerCorrectBg;
        borderColor = AppColors.answerCorrectBorder;
        textColor = AppColors.answerCorrectText;
        trailingIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.answerCorrectIcon,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      } else if (isSelected && !isCorrect) {
        // User picked this and it is INCORRECT
        backgroundColor = AppColors.answerIncorrectBg;
        borderColor = AppColors.answerIncorrectBorder;
        textColor = AppColors.answerIncorrectText;
        trailingIndicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.answerIncorrectIcon,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 16, color: Colors.white),
        );
      } else if (!isSelected && isCorrect) {
        // This is the correct answer revealed when user was wrong or timed out
        backgroundColor = AppColors.answerCorrectBg.withValues(alpha: 0.6);
        borderColor = AppColors.answerCorrectBorder;
        textColor = AppColors.answerCorrectText;
        trailingIndicator = Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.answerCorrectIcon.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                trailingIndicator,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
