import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

/// Custom exception to hold user-friendly API error descriptions
class ApiException implements Exception {
  final String message;
  final int? responseCode;

  ApiException(this.message, {this.responseCode});

  @override
  String toString() => message;
}

/// Service to communicate with Open Trivia Database (OpenTDB) APIs.
class ApiService {
  static const String _baseUrl = 'opentdb.com';
  static const Duration _timeout = Duration(seconds: 15);

  /// Fetch all trivia categories from OpenTDB
  Future<List<Category>> fetchCategories() async {
    try {
      final uri = Uri.https(_baseUrl, '/api_category.php');
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final categoriesJson = data['trivia_categories'] as List<dynamic>?;

        if (categoriesJson != null && categoriesJson.isNotEmpty) {
          return categoriesJson
              .map((item) => Category.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw ApiException('No categories received from server.');
        }
      } else {
        throw ApiException(
            'Server responded with error status ${response.statusCode}.');
      }
    } on SocketException {
      throw ApiException(
          'No internet connection. Please check your network and try again.');
    } on TimeoutException {
      throw ApiException('Connection timed out. Please try again.');
    } on FormatException {
      throw ApiException('Malformed response format received from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to load categories: ${e.toString()}');
    }
  }

  /// Fetch quiz questions matching the given configuration
  Future<List<Question>> fetchQuestions({
    required int amount,
    required int categoryId,
    String? difficulty,
    required String type,
  }) async {
    try {
      // Build query parameters safely
      final queryParams = <String, String>{
        'amount': amount.toString(),
        'category': categoryId.toString(),
      };

      // If difficulty is specified and NOT "any", map it to lowercase (easy, medium, hard)
      // Otherwise, omit the difficulty query parameter completely as required
      if (difficulty != null) {
        final diffLower = difficulty.toLowerCase().trim();
        if (diffLower.contains('easy')) {
          queryParams['difficulty'] = 'easy';
        } else if (diffLower.contains('medium')) {
          queryParams['difficulty'] = 'medium';
        } else if (diffLower.contains('hard')) {
          queryParams['difficulty'] = 'hard';
        }
      }

      // Map question type parameter
      final typeLower = type.toLowerCase().trim();
      if (typeLower.contains('boolean') || typeLower.contains('true')) {
        queryParams['type'] = 'boolean';
      } else {
        queryParams['type'] = 'multiple';
      }

      final uri = Uri.https(_baseUrl, '/api.php', queryParams);
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final responseCode = data['response_code'] as int? ?? 0;

        switch (responseCode) {
          case 0:
            // Success
            final results = data['results'] as List<dynamic>?;
            if (results == null || results.isEmpty) {
              throw ApiException(
                'No questions are available for this configuration.',
                responseCode: 0,
              );
            }
            return results
                .map((item) => Question.fromJson(item as Map<String, dynamic>))
                .toList();

          case 1:
            throw ApiException(
              'Not enough questions available for this configuration. Try reducing the number of questions or choosing "Any Difficulty".',
              responseCode: 1,
            );

          case 2:
            throw ApiException(
              'Invalid quiz parameters provided. Please adjust your configuration.',
              responseCode: 2,
            );

          case 3:
          case 4:
            throw ApiException(
              'Session error occurred with trivia server. Please retry.',
              responseCode: responseCode,
            );

          case 5:
            throw ApiException(
              'Rate limit exceeded. OpenTDB requires a 5-second interval between requests. Please wait a moment and try again.',
              responseCode: 5,
            );

          default:
            throw ApiException(
              'Unable to load questions (Error code $responseCode). Please try a different category or difficulty.',
              responseCode: responseCode,
            );
        }
      } else {
        throw ApiException(
            'Server responded with status code ${response.statusCode}.');
      }
    } on SocketException {
      throw ApiException(
          'No internet connection. Please verify your network and retry.');
    } on TimeoutException {
      throw ApiException('Request timed out while contacting OpenTDB.');
    } on FormatException {
      throw ApiException('Malformed response received from OpenTDB.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to load questions: ${e.toString()}');
    }
  }
}
