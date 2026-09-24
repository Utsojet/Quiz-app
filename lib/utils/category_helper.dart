import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'app_colors.dart';

/// Metadata helper for OpenTDB categories, providing 3D illustrated assets,
/// pastel colors, and cleaned-up display names matching the Figma design.
class CategoryHelper {
  CategoryHelper._();

  /// Maps category names to 3D clay-render illustration assets
  static String? getAssetImage(String categoryName) {
    final lower = categoryName.toLowerCase();

    if (lower.contains('general knowledge')) {
      return 'assets/images/categories/general_knowledge.jpg';
    }
    if (lower.contains('book')) {
      return 'assets/images/categories/books.jpg';
    }
    if (lower.contains('history')) {
      return 'assets/images/categories/history.jpg';
    }
    if (lower.contains('nature') || lower.contains('science')) {
      return 'assets/images/categories/science.jpg';
    }
    if (lower.contains('art')) {
      return 'assets/images/categories/art.jpg';
    }
    if (lower.contains('vehicle') || lower.contains('car')) {
      return 'assets/images/categories/vehicles.jpg';
    }
    if (lower.contains('film') || lower.contains('movie')) {
      return 'assets/images/categories/film.jpg';
    }
    if (lower.contains('music')) {
      return 'assets/images/categories/music.jpg';
    }
    if (lower.contains('video game')) {
      return 'assets/images/categories/video_games.jpg';
    }
    if (lower.contains('board game')) {
      return 'assets/images/categories/board_games.jpg';
    }
    if (lower.contains('sport')) {
      return 'assets/images/categories/sports.jpg';
    }
    if (lower.contains('computer')) {
      return 'assets/images/categories/computers.jpg';
    }

    return null;
  }

  /// Sorts categories so that the 6 featured categories from Figma Frame 1
  /// appear first in exact order, followed by other categories.
  static List<Category> sortCategoriesForDisplay(List<Category> categories) {
    final priority = [
      'general knowledge',
      'book',
      'history',
      'science & nature',
      'art',
      'vehicle',
      'film',
      'music',
      'video game',
      'board game',
      'computer',
      'sport',
    ];

    final sorted = List<Category>.from(categories);
    sorted.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();

      int aIndex = priority.indexWhere((p) => aName.contains(p));
      int bIndex = priority.indexWhere((p) => bName.contains(p));

      if (aIndex == -1) aIndex = 999;
      if (bIndex == -1) bIndex = 999;

      if (aIndex != bIndex) {
        return aIndex.compareTo(bIndex);
      }
      return a.id.compareTo(b.id);
    });
    return sorted;
  }

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

    if (lower.contains('general knowledge')) return const Color(0xFFD4E4FC);
    if (lower.contains('book')) return const Color(0xFFCEF7D2);
    if (lower.contains('history')) return const Color(0xFFFEF7B6);
    if (lower.contains('nature') || lower.contains('science')) {
      return const Color(0xFFF2D0F8);
    }
    if (lower.contains('art')) return const Color(0xFFFFCAD0);
    if (lower.contains('vehicle') || lower.contains('car')) {
      return const Color(0xFFFFE0BA);
    }
    if (lower.contains('film') || lower.contains('movie')) {
      return const Color(0xFFFEF7B6);
    }
    if (lower.contains('music')) return const Color(0xFFFFCAD0);
    if (lower.contains('video game')) return const Color(0xFFCEF5ED);
    if (lower.contains('board game')) return const Color(0xFFD6E4FF);
    if (lower.contains('sport')) return const Color(0xFFD2F7D6);
    if (lower.contains('computer')) return const Color(0xFFE4D8F8);
    if (lower.contains('geography')) return const Color(0xFFD4E4FC);
    if (lower.contains('animal')) return const Color(0xFFCEF7D2);

    // Fallback cycle through pastel colors based on index
    const palette = [
      Color(0xFFD4E4FC),
      Color(0xFFCEF7D2),
      Color(0xFFFEF7B6),
      Color(0xFFF2D0F8),
      Color(0xFFFFCAD0),
      Color(0xFFFFE0BA),
      Color(0xFFCEF5ED),
      Color(0xFFE4D8F8),
    ];
    return palette[index % palette.length];
  }

  static Color getIconColor(Color backgroundColor) {
    // Generate a deep complementary accent for the icon
    if (backgroundColor == const Color(0xFFD4E4FC) ||
        backgroundColor == AppColors.pastelBlue) {
      return const Color(0xFF2563EB);
    }
    if (backgroundColor == const Color(0xFFCEF7D2) ||
        backgroundColor == AppColors.pastelGreen) {
      return const Color(0xFF16A34A);
    }
    if (backgroundColor == const Color(0xFFFEF7B6) ||
        backgroundColor == AppColors.pastelYellow) {
      return const Color(0xFFD97706);
    }
    if (backgroundColor == const Color(0xFFF2D0F8) ||
        backgroundColor == AppColors.pastelPurple) {
      return const Color(0xFF7C3AED);
    }
    if (backgroundColor == const Color(0xFFFFCAD0) ||
        backgroundColor == AppColors.pastelPink) {
      return const Color(0xFFE11D48);
    }
    if (backgroundColor == const Color(0xFFFFE0BA) ||
        backgroundColor == AppColors.pastelOrange) {
      return const Color(0xFFEA580C);
    }
    if (backgroundColor == const Color(0xFFCEF5ED) ||
        backgroundColor == AppColors.pastelTeal) {
      return const Color(0xFF0D9488);
    }
    if (backgroundColor == const Color(0xFFE4D8F8) ||
        backgroundColor == AppColors.pastelIndigo) {
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
