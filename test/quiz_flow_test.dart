import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:quizzical/providers/quiz_provider.dart';
import 'package:quizzical/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock ApiService for unit tests
class MockApiService extends ApiService {
  final List<Question> dummyQuestions;

  MockApiService(this.dummyQuestions);

  @override
  Future<List<Question>> fetchQuestions({
    required int amount,
    required int categoryId,
    String? difficulty,
    required String type,
  }) async {
    return dummyQuestions;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizProvider Flow & Scoring Tests', () {
    late List<Question> testQuestions;
    late QuizProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      testQuestions = [
        Question(
          type: 'multiple',
          difficulty: 'easy',
          category: 'General Knowledge',
          question: 'What is 2 + 2?',
          correctAnswer: '4',
          incorrectAnswers: ['3', '5', '6'],
        ),
        Question(
          type: 'boolean',
          difficulty: 'easy',
          category: 'General Knowledge',
          question: 'Is Dart developed by Google?',
          correctAnswer: 'True',
          incorrectAnswers: ['False'],
        ),
      ];

      provider = QuizProvider(apiService: MockApiService(testQuestions));
    });

    test('Initial state before quiz start', () {
      expect(provider.score, 0);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.hasAnswered, isFalse);
      expect(provider.selectedAnswer, isNull);
      expect(provider.isQuizFinished, isFalse);
    });

    test('Quiz start and question loading', () async {
      provider.selectCategory(9, 'General Knowledge');
      final started = await provider.startQuiz();

      expect(started, isTrue);
      expect(provider.totalQuestions, 2);
      expect(provider.currentQuestion?.question, 'What is 2 + 2?');
      expect(provider.progress, 0.5);
    });

    test('Selecting correct answer increments score', () async {
      provider.selectCategory(9, 'General Knowledge');
      await provider.startQuiz();

      provider.selectAnswer('4'); // Correct

      expect(provider.score, 1);
      expect(provider.hasAnswered, isTrue);
      expect(provider.selectedAnswer, '4');
    });

    test('Selecting incorrect answer leaves score unchanged', () async {
      provider.selectCategory(9, 'General Knowledge');
      await provider.startQuiz();

      provider.selectAnswer('3'); // Incorrect

      expect(provider.score, 0);
      expect(provider.hasAnswered, isTrue);
      expect(provider.selectedAnswer, '3');
    });

    test('Full quiz completion calculates correct accuracy', () async {
      provider.selectCategory(9, 'General Knowledge');
      await provider.startQuiz();

      // Question 1: Answer correct
      provider.selectAnswer('4');
      expect(provider.score, 1);

      // Advance to Question 2
      final hasMore = provider.nextQuestion();
      expect(hasMore, isTrue);
      expect(provider.currentQuestionIndex, 1);
      expect(provider.hasAnswered, isFalse);

      // Question 2: Answer correct
      provider.selectAnswer('True');
      expect(provider.score, 2);

      // Advance again -> finishes
      final finished = provider.nextQuestion();
      expect(finished, isFalse);
      expect(provider.isQuizFinished, isTrue);
      expect(provider.accuracyPercentage, 100.0);
    });

    test('Resetting quiz restores initial state', () async {
      provider.selectCategory(9, 'General Knowledge');
      await provider.startQuiz();
      provider.selectAnswer('4');
      provider.resetQuiz();

      expect(provider.score, 0);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.totalQuestions, 0);
      expect(provider.hasAnswered, isFalse);
    });
  });
}
