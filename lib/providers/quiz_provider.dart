import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Provider for managing quiz configuration, questions, timer, score,
/// answer evaluation, and quiz lifecycle.
class QuizProvider extends ChangeNotifier {
  final ApiService _apiService;

  // Configuration state
  int? _selectedCategoryId;
  String _selectedCategoryName = 'General Knowledge';
  int _amount = 10;
  String _difficulty = 'Any Difficulty';
  String _questionType = 'Multiple Choice';

  // Questions and Quiz state
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  bool _isLoading = false;
  String? _error;
  bool _isQuizFinished = false;

  // Timer state (30 seconds per question recommended)
  static const int questionDuration = 30;
  int _remainingSeconds = questionDuration;
  int _totalQuizTimeSeconds = 0;
  Timer? _timer;

  QuizProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    _loadPersistedConfig();
  }

  // Getters
  int? get selectedCategoryId => _selectedCategoryId;
  String get selectedCategoryName => _selectedCategoryName;
  int get amount => _amount;
  String get difficulty => _difficulty;
  String get questionType => _questionType;

  List<Question> get questions => List.unmodifiable(_questions);
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get hasAnswered => _hasAnswered;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isQuizFinished => _isQuizFinished;

  int get remainingSeconds => _remainingSeconds;
  int get totalQuizTimeSeconds => _totalQuizTimeSeconds;
  int get totalQuestions => _questions.length;

  Question? get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }

  double get progress {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  double get accuracyPercentage {
    if (_questions.isEmpty) return 0.0;
    return (_score / _questions.length) * 100;
  }

  /// Initialize and load saved configuration from SharedPreferences
  Future<void> _loadPersistedConfig() async {
    try {
      final config = await StorageService.loadQuizConfig();
      _amount = config['amount'] as int? ?? 10;
      _difficulty = config['difficulty'] as String? ?? 'Any Difficulty';
      _questionType = config['type'] as String? ?? 'Multiple Choice';
      if (config['categoryId'] != null) {
        _selectedCategoryId = config['categoryId'] as int;
      }
      if (config['categoryName'] != null) {
        _selectedCategoryName = config['categoryName'] as String;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved quiz config: $e');
    }
  }

  /// Update selected category
  void selectCategory(int id, String name) {
    _selectedCategoryId = id;
    _selectedCategoryName = name;
    notifyListeners();
  }

  /// Update quiz configuration parameters and persist
  void updateConfig({
    int? amount,
    String? difficulty,
    String? questionType,
  }) {
    if (amount != null) _amount = amount;
    if (difficulty != null) _difficulty = difficulty;
    if (questionType != null) _questionType = questionType;
    notifyListeners();

    // Persist to SharedPreferences
    StorageService.saveQuizConfig(
      amount: _amount,
      difficulty: _difficulty,
      type: _questionType,
      categoryId: _selectedCategoryId,
      categoryName: _selectedCategoryName,
    );
  }

  /// Start a new quiz by fetching questions with current configuration
  Future<bool> startQuiz() async {
    if (_selectedCategoryId == null) {
      _error = 'Please select a category first.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    // Persist configuration
    await StorageService.saveQuizConfig(
      amount: _amount,
      difficulty: _difficulty,
      type: _questionType,
      categoryId: _selectedCategoryId,
      categoryName: _selectedCategoryName,
    );

    try {
      final fetchedQuestions = await _apiService.fetchQuestions(
        amount: _amount,
        categoryId: _selectedCategoryId!,
        difficulty: _difficulty,
        type: _questionType,
      );

      _questions = fetchedQuestions;
      _currentQuestionIndex = 0;
      _score = 0;
      _totalQuizTimeSeconds = 0;
      _hasAnswered = false;
      _selectedAnswer = null;
      _isQuizFinished = false;
      _error = null;

      _startTimer();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start question countdown timer
  void _startTimer() {
    _cancelTimer();
    _remainingSeconds = questionDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalQuizTimeSeconds++;
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _onTimeout();
      }
    });
  }

  /// Handle timer reaching zero (timeout)
  void _onTimeout() {
    if (_hasAnswered) return;
    _cancelTimer();
    _hasAnswered = true;
    _selectedAnswer = ''; // Blank indicates timed out without selection
    notifyListeners();
  }

  /// User selects an answer option
  void selectAnswer(String answer) {
    if (_hasAnswered || currentQuestion == null) return;

    _cancelTimer();
    _hasAnswered = true;
    _selectedAnswer = answer;

    if (answer == currentQuestion!.correctAnswer) {
      _score++;
    }

    notifyListeners();
  }

  /// Advance to next question or complete quiz
  /// Returns true if next question loaded, false if quiz is finished.
  bool nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _hasAnswered = false;
      _selectedAnswer = null;
      _startTimer();
      notifyListeners();
      return true;
    } else {
      _cancelTimer();
      _isQuizFinished = true;
      notifyListeners();
      return false;
    }
  }

  /// Cancel running timer safely
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Public method to cancel timer (e.g., when exiting quiz)
  void stopTimer() {
    _cancelTimer();
  }

  /// Reset the quiz session while keeping preserved category & configuration
  void resetQuiz() {
    _cancelTimer();
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _totalQuizTimeSeconds = 0;
    _hasAnswered = false;
    _selectedAnswer = null;
    _isQuizFinished = false;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
