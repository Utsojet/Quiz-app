import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Metadata helper for OpenTDB categories, providing appropriate icons,
/// pastel colors, and cleaned-up display names.
class CategoryHelper {
  CategoryHelper._();

  static IconData getIcon(String categoryName) {
    final lower = categoryName.toLowerCase();

    if (lower.contains('book')) return Icons.menu_book_rounded;
    if (lower.contains('film') || lower.contains('movie')) {
      return Icons.movie_creation_rounded;
    }
    if (lower.contains('music')) return Icons.music_note_rounded;
    if (lower.contains('musical') || lower.contains('theatre')) {
      return Icons.theater_comedy_rounded;
    }
    if (lower.contains('television') || lower.contains('tv')) {
      return Icons.tv_rounded;
    }
    if (lower.contains('video game')) return Icons.sports_esports_rounded;
    if (lower.contains('board game')) return Icons.casino_rounded;
    if (lower.contains('nature') || lower.contains('science')) {
      return Icons.science_rounded;
    }
    if (lower.contains('computer')) return Icons.computer_rounded;
    if (lower.contains('math')) return Icons.calculate_rounded;
    if (lower.contains('mythology')) return Icons.auto_awesome_rounded;
    if (lower.contains('sport')) return Icons.sports_soccer_rounded;
    if (lower.contains('geography')) return Icons.public_rounded;
    if (lower.contains('history')) return Icons.history_edu_rounded;
    if (lower.contains('politic')) return Icons.gavel_rounded;
    if (lower.contains('art')) return Icons.palette_rounded;
    if (lower.contains('celebrit')) return Icons.star_rounded;
    if (lower.contains('animal')) return Icons.pets_rounded;
    if (lower.contains('vehicle') || lower.contains('car')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('comic')) return Icons.menu_book_outlined;
    if (lower.contains('gadget')) return Icons.devices_other_rounded;
    if (lower.contains('anime') || lower.contains('manga')) {
      return Icons.animation_rounded;
    }
    if (lower.contains('cartoon')) return Icons.cruelty_free_rounded;
    if (lower.contains('general knowledge')) return Icons.lightbulb_rounded;

    return Icons.quiz_rounded;
  }

  static Color getBackgroundColor(String categoryName, int index) {
    final lower = categoryName.toLowerCase();

    if (lower.contains('general knowledge')) return AppColors.pastelBlue;
    if (lower.contains('book')) return AppColors.pastelGreen;
    if (lower.contains('history')) return AppColors.pastelYellow;
    if (lower.contains('nature') || lower.contains('science')) {
      return AppColors.pastelPurple;
    }
    if (lower.contains('art')) return AppColors.pastelPink;
    if (lower.contains('vehicle')) return AppColors.pastelOrange;
    if (lower.contains('sport')) return AppColors.pastelTeal;
    if (lower.contains('music')) return AppColors.pastelPink;
    if (lower.contains('computer')) return AppColors.pastelIndigo;
    if (lower.contains('geography')) return AppColors.pastelBlue;
    if (lower.contains('animal')) return AppColors.pastelGreen;

    // Fallback cycle through pastel colors based on index
    const palette = [
      AppColors.pastelBlue,
      AppColors.pastelGreen,
      AppColors.pastelYellow,
      AppColors.pastelPurple,
      AppColors.pastelPink,
      AppColors.pastelOrange,
      AppColors.pastelTeal,
      AppColors.pastelIndigo,
    ];
    return palette[index % palette.length];
  }

  static Color getIconColor(Color backgroundColor) {
    // Generate a deep complementary accent for the icon
    if (backgroundColor == AppColors.pastelBlue) return const Color(0xFF2563EB);
    if (backgroundColor == AppColors.pastelGreen) {
      return const Color(0xFF16A34A);
    }
    if (backgroundColor == AppColors.pastelYellow) {
      return const Color(0xFFD97706);
    }
    if (backgroundColor == AppColors.pastelPurple) {
      return const Color(0xFF7C3AED);
    }
    if (backgroundColor == AppColors.pastelPink) return const Color(0xFFE11D48);
    if (backgroundColor == AppColors.pastelOrange) {
      return const Color(0xFFEA580C);
    }
    if (backgroundColor == AppColors.pastelTeal) return const Color(0xFF0D9488);
    if (backgroundColor == AppColors.pastelIndigo) {
      return const Color(0xFF4F46E5);
    }
    return AppColors.primary;
  }

  /// Formats category name cleanly (e.g., "Entertainment: Books" -> "Books")
  static String formatName(String rawName) {
    if (rawName == 'Entertainment: Japanese Anime & Manga') {
      return 'Anime & Manga';
    }
    if (rawName == 'Entertainment: Cartoon & Animations') {
      return 'Cartoons';
    }
    if (rawName == 'Entertainment: Musicals & Theatres') {
      return 'Musicals & Theatre';
    }
    if (rawName == 'Entertainment: Video Games') {
      return 'Video Games';
    }
    if (rawName == 'Entertainment: Board Games') {
      return 'Board Games';
    }
    if (rawName.startsWith('Entertainment: ')) {
      return rawName.replaceFirst('Entertainment: ', '');
    }
    if (rawName.startsWith('Science: ')) {
      return rawName.replaceFirst('Science: ', '');
    }
    return rawName;
  }
}
