import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle local persistence using SharedPreferences.
class StorageService {
  static const String _keyAmount = 'last_amount';
  static const String _keyDifficulty = 'last_difficulty';
  static const String _keyType = 'last_type';
  static const String _keyCategoryId = 'last_category_id';
  static const String _keyCategoryName = 'last_category_name';
  static const String _keyStudentName = 'student_name';

  /// Save quiz configuration to SharedPreferences
  static Future<void> saveQuizConfig({
    required int amount,
    required String difficulty,
    required String type,
    int? categoryId,
    String? categoryName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAmount, amount);
    await prefs.setString(_keyDifficulty, difficulty);
    await prefs.setString(_keyType, type);
    if (categoryId != null) {
      await prefs.setInt(_keyCategoryId, categoryId);
    }
    if (categoryName != null) {
      await prefs.setString(_keyCategoryName, categoryName);
    }
  }

  /// Load persisted quiz configuration
  static Future<Map<String, dynamic>> loadQuizConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'amount': prefs.getInt(_keyAmount) ?? 10,
      'difficulty': prefs.getString(_keyDifficulty) ?? 'Any Difficulty',
      'type': prefs.getString(_keyType) ?? 'Multiple Choice',
      'categoryId': prefs.getInt(_keyCategoryId),
      'categoryName': prefs.getString(_keyCategoryName),
    };
  }

  /// Save student name displayed on the Welcome screen
  static Future<void> saveStudentName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStudentName, name);
  }

  /// Load student name (defaults to 'Your_Name')
  static Future<String> loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStudentName) ?? 'Your_Name';
  }
}
