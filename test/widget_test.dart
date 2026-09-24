import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/main.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Data Model Tests', () {
    test('Category.fromJson parses properly and decodes entities', () {
      final json = {
        'id': 10,
        'name': 'Entertainment: Books &amp; Comics',
      };
      final category = Category.fromJson(json);

      expect(category.id, 10);
      expect(category.name, 'Entertainment: Books & Comics');
    });

    test('Question.fromJson parses and decodes HTML entities correctly', () {
      final json = {
        'type': 'multiple',
        'difficulty': 'easy',
        'category': 'General Knowledge',
        'question': 'What is &quot;HTML&quot; short for?',
        'correct_answer': 'HyperText &amp; Markup',
        'incorrect_answers': [
          'HighText',
          'HyperTab &amp; Link',
          'None of &#039;em',
        ],
      };

      final question = Question.fromJson(json);

      expect(question.question, 'What is "HTML" short for?');
      expect(question.correctAnswer, 'HyperText & Markup');
      expect(question.incorrectAnswers, [
        'HighText',
        'HyperTab & Link',
        "None of 'em",
      ]);
      expect(question.options.length, 4);
      expect(question.options.contains('HyperText & Markup'), isTrue);
    });

    test('Question boolean type generates True and False options', () {
      final json = {
        'type': 'boolean',
        'difficulty': 'easy',
        'category': 'General Knowledge',
        'question': 'Is the sky blue?',
        'correct_answer': 'True',
        'incorrect_answers': ['False'],
      };

      final question = Question.fromJson(json);

      expect(question.options, ['True', 'False']);
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('Welcome screen renders properly with title and CTA button',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'student_name': 'Your_Name'});
      await tester.pumpWidget(const QuizzicalApp());
      await tester.pumpAndSettle();

      expect(find.text('Quizzical'), findsOneWidget);
      expect(find.text('GET STARTED'), findsOneWidget);
    });
  });
}
