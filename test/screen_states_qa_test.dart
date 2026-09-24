import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:quizzical/providers/category_provider.dart';
import 'package:quizzical/providers/quiz_provider.dart';
import 'package:quizzical/screens/category_screen.dart';
import 'package:quizzical/screens/quiz_config_screen.dart';
import 'package:quizzical/screens/quiz_screen.dart';
import 'package:quizzical/screens/result_screen.dart';
import 'package:quizzical/screens/welcome_screen.dart';
import 'package:quizzical/services/api_service.dart';
import 'package:quizzical/utils/app_theme.dart';
import 'package:quizzical/widgets/illustrations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApi extends ApiService {
  @override
  Future<List<Category>> fetchCategories() async {
    return [
      const Category(id: 9, name: 'General Knowledge'),
      const Category(id: 10, name: 'Entertainment: Books'),
    ];
  }

  @override
  Future<List<Question>> fetchQuestions({
    required int amount,
    required int categoryId,
    String? difficulty,
    required String type,
  }) async {
    return [
      Question(
        type: 'multiple',
        difficulty: 'easy',
        category: 'General Knowledge',
        question: 'What is the capital of France?',
        correctAnswer: 'Paris',
        incorrectAnswers: ['London', 'Berlin', 'Rome'],
      ),
      Question(
        type: 'multiple',
        difficulty: 'easy',
        category: 'General Knowledge',
        question: 'What is 5 + 5?',
        correctAnswer: '10',
        incorrectAnswers: ['8', '9', '11'],
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'student_name': 'QA_Tester',
      'last_amount': 5,
      'last_difficulty': 'Easy',
      'last_type': 'Multiple Choice',
      'last_category_id': 9,
      'last_category_name': 'General Knowledge',
    });
  });

  group('Screen 1: Welcome Screen QA Tests', () {
    testWidgets('Renders all welcome elements and personalizes student name',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const WelcomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quizzical'), findsOneWidget);
      expect(find.text('QA_Tester'), findsOneWidget);
      expect(find.text('Test your knowledge with fun trivia!'), findsOneWidget);
      expect(find.text('GET STARTED'), findsOneWidget);
      expect(find.byType(WelcomeHeroIllustration), findsOneWidget);

      // Tap student name to edit
      await tester.tap(find.text('QA_Tester'));
      await tester.pumpAndSettle();

      expect(find.text('Personalize Name'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Alice_Wonder');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Alice_Wonder'), findsOneWidget);
    });
  });

  group('Screen 2: Category Selection QA Tests', () {
    testWidgets('Displays categories and selects item', (tester) async {
      final mockApi = MockApi();
      final catProvider = CategoryProvider(apiService: mockApi);
      final quizProvider = QuizProvider(apiService: mockApi);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: catProvider),
            ChangeNotifierProvider.value(value: quizProvider),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const CategoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quizzical'), findsOneWidget);
      expect(find.text('choose a category to focus on:'), findsOneWidget);
      expect(find.text('General Knowledge'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);

      await tester.tap(find.text('Books'));
      await tester.pumpAndSettle();

      expect(quizProvider.selectedCategoryId, 10);
      expect(quizProvider.selectedCategoryName, 'Entertainment: Books');
    });
  });

  group('Screen 3: Quiz Configuration QA Tests', () {
    testWidgets('Displays sliders, dropdowns, and category header',
        (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizConfigScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Configuration'), findsOneWidget);
      expect(find.text('General Knowledge'), findsOneWidget);
      expect(find.text('Number of Questions'), findsOneWidget);
      expect(find.text('Difficulty Level'), findsOneWidget);
      expect(find.text('Question Type'), findsOneWidget);
      expect(find.text('START'), findsOneWidget);
    });
  });

  group('Screens 4, 5, 6: Quiz Screen States QA Tests', () {
    testWidgets('Screen 4: Quiz — Unanswered state', (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');
      await quizProvider.startQuiz();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Question counter and timer badge
      expect(find.text('1/2'), findsOneWidget);
      expect(find.text('EXIT'), findsOneWidget);
      expect(find.text('30s'), findsOneWidget);

      // Question text
      expect(find.text('What is the capital of France?'), findsOneWidget);

      // Options rendered
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);

      // Next button disabled before answering
      final nextButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('Screen 5: Quiz — Correct answer state highlights green with checkmark',
        (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');
      await quizProvider.startQuiz();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pick correct answer: Paris
      await tester.tap(find.text('Paris'));
      await tester.pumpAndSettle();

      expect(quizProvider.score, 1);
      expect(quizProvider.hasAnswered, isTrue);

      // Check checkmark icon appears
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Next button is now enabled
      final nextButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets(
        'Screen 6: Quiz — Incorrect answer state highlights red cross & reveals green checkmark',
        (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');
      await quizProvider.startQuiz();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pick incorrect answer: London
      await tester.tap(find.text('London'));
      await tester.pumpAndSettle();

      // Score not incremented
      expect(quizProvider.score, 0);
      expect(quizProvider.hasAnswered, isTrue);

      // Shows red cross for incorrect selection AND green check for revealed correct answer
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('Screens 7 & 8: Results Screen States QA Tests', () {
    testWidgets('Screen 7: Results — Good score (>= 70%) shows Congratulation & PartyPopper',
        (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');
      await quizProvider.startQuiz();

      // Answer both correctly -> 100%
      quizProvider.selectAnswer('Paris');
      quizProvider.nextQuestion();
      quizProvider.selectAnswer('10');
      quizProvider.nextQuestion();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResultScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Congratulation'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
      expect(find.byType(PartyPopperIllustration), findsOneWidget);
      expect(
        find.text(
            "You've got a great foundation. Ready to try a different category?"),
        findsOneWidget,
      );
      expect(find.text('PLAY AGAIN'), findsOneWidget);
    });

    testWidgets('Screen 8: Results — Low score (< 70%) shows Keep Trying! & Practice icon',
        (tester) async {
      final mockApi = MockApi();
      final quizProvider = QuizProvider(apiService: mockApi);
      quizProvider.selectCategory(9, 'General Knowledge');
      await quizProvider.startQuiz();

      // Answer both incorrectly -> 0%
      quizProvider.selectAnswer('Berlin');
      quizProvider.nextQuestion();
      quizProvider.selectAnswer('8');
      quizProvider.nextQuestion();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: quizProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResultScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Keep Trying!'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
      expect(find.text('0/2'), findsOneWidget);
      expect(find.byType(KeepTryingIllustration), findsOneWidget);
      expect(
        find.text(
            "Dont give up! Practice makes perfect. Try again to improve your score"),
        findsOneWidget,
      );
      expect(find.text('PLAY AGAIN'), findsOneWidget);
    });
  });
}
