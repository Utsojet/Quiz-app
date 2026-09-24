import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:quizzical/providers/category_provider.dart';
import 'package:quizzical/providers/quiz_provider.dart';
import 'package:quizzical/screens/welcome_screen.dart';
import 'package:quizzical/services/api_service.dart';
import 'package:quizzical/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Complete mock service simulating OpenTDB
class CompleteMockApiService extends ApiService {
  @override
  Future<List<Category>> fetchCategories() async {
    return [
      const Category(id: 9, name: 'General Knowledge'),
      const Category(id: 10, name: 'Entertainment: Books'),
      const Category(id: 23, name: 'History'),
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
        question:
            'In what year did the United States host the FIFA World Cup for the first time?',
        correctAnswer: '1994',
        incorrectAnswers: ['1986', '2000', '2007'],
      ),
      Question(
        type: 'boolean',
        difficulty: 'easy',
        category: 'General Knowledge',
        question: 'Is the sky blue on a clear sunny day?',
        correctAnswer: 'True',
        incorrectAnswers: ['False'],
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Navigation & State Flow Test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'student_name': 'Exam_Student',
      'last_amount': 2,
    });

    final mockApi = CompleteMockApiService();
    final categoryProvider = CategoryProvider(apiService: mockApi);
    final quizProvider = QuizProvider(apiService: mockApi);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>.value(
              value: categoryProvider),
          ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const WelcomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Welcome Screen
    expect(find.text('Quizzical'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
    expect(find.text('Exam_Student'), findsOneWidget);

    // Tap "GET STARTED" -> Navigates to CategoryScreen
    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();

    // 2. Verify Category Screen
    expect(find.text('choose a category to focus on:'), findsOneWidget);
    expect(find.text('General Knowledge'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);

    // Tap "General Knowledge" category
    await tester.tap(find.text('General Knowledge'));
    await tester.pumpAndSettle();

    // 3. Verify Quiz Configuration Screen
    expect(find.text('Configuration'), findsOneWidget);
    expect(find.text('Number of Questions'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);

    // Scroll to and tap "START" -> Fetches questions & navigates to QuizScreen
    await tester.ensureVisible(find.text('START'));
    await tester.tap(find.text('START'));
    await tester.pumpAndSettle();

    // 4. Verify Quiz Screen - Question 1
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('EXIT'), findsOneWidget);
    expect(find.text('1994'), findsOneWidget);

    // Select the correct answer: 1994
    await tester.ensureVisible(find.text('1994'));
    await tester.tap(find.text('1994'));
    await tester.pumpAndSettle();

    // Verify answer is marked and score incremented
    expect(quizProvider.score, 1);
    expect(quizProvider.hasAnswered, isTrue);

    // Tap "Next" -> Advance to Question 2
    expect(find.text('Next'), findsOneWidget);
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // 5. Verify Quiz Screen - Question 2
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('True'), findsOneWidget);
    expect(find.text('False'), findsOneWidget);

    // Select correct answer: True
    await tester.ensureVisible(find.text('True'));
    await tester.tap(find.text('True'));
    await tester.pumpAndSettle();

    expect(quizProvider.score, 2);
    expect(find.text('Finish'), findsOneWidget);

    // Tap "Finish" -> Navigates to ResultScreen
    await tester.ensureVisible(find.text('Finish'));
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    // 6. Verify Results Screen (100% Score -> Congratulation)
    expect(find.text('Congratulation'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('PLAY AGAIN'), findsOneWidget);

    // Tap "PLAY AGAIN" -> Resets quiz and returns to CategoryScreen
    await tester.ensureVisible(find.text('PLAY AGAIN'));
    await tester.tap(find.text('PLAY AGAIN'));
    await tester.pumpAndSettle();

    expect(find.text('choose a category to focus on:'), findsOneWidget);
    expect(quizProvider.score, 0);
    expect(quizProvider.currentQuestionIndex, 0);
  });
}
