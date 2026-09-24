import 'package:flutter/foundation.dart' hide Category;
import '../models/category_model.dart';
import '../services/api_service.dart';

/// Provider for managing and caching OpenTDB categories during the app session.
class CategoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  CategoryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  /// Fetch categories from OpenTDB API, caching results for the session
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    // If categories already loaded and not forced to refresh, return cached
    if (_categories.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _apiService.fetchCategories();
      _categories = fetched;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retry fetching categories upon failure
  Future<void> retry() async {
    await fetchCategories(forceRefresh: true);
  }
}
