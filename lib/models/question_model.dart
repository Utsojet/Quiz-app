import 'package:html_unescape/html_unescape.dart';

final HtmlUnescape _unescape = HtmlUnescape();

/// Represents a quiz question from OpenTDB.
class Question {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  // Cached shuffled options to ensure order remains stable across widget rebuilds
  late final List<String> options;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    List<String>? options,
  }) {
    if (options != null) {
      this.options = options;
    } else {
      if (type == 'boolean') {
        // Standard boolean order: True, False
        this.options = ['True', 'False'];
      } else {
        // Multiple choice: combine correct and incorrect, then shuffle
        final allAnswers = [correctAnswer, ...incorrectAnswers];
        allAnswers.shuffle();
        this.options = List.unmodifiable(allAnswers);
      }
    }
  }

  /// Factory constructor to parse Question from OpenTDB API JSON,
  /// with automatic HTML entity decoding.
  factory Question.fromJson(Map<String, dynamic> json) {
    final rawIncorrect = json['incorrect_answers'] as List<dynamic>? ?? [];
    final decodedIncorrect = rawIncorrect
        .map((item) => _unescape.convert(item.toString()))
        .toList();

    return Question(
      type: json['type'] as String? ?? 'multiple',
      difficulty: json['difficulty'] as String? ?? 'easy',
      category: _unescape.convert(json['category'] as String? ?? ''),
      question: _unescape.convert(json['question'] as String? ?? ''),
      correctAnswer: _unescape.convert(json['correct_answer'] as String? ?? ''),
      incorrectAnswers: decodedIncorrect,
    );
  }

  /// Converts Question to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
    };
  }

  @override
  String toString() =>
      'Question(question: $question, correct: $correctAnswer, type: $type)';
}
