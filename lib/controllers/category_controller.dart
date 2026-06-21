import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

enum CategoryLoadState { initial, loading, loaded, error }

class CategoryController extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  List<CategoryModel> _categories = [];
  CategoryLoadState _state = CategoryLoadState.initial;
  String _errorMessage = '';

  List<CategoryModel> get categories => _categories;
  CategoryLoadState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == CategoryLoadState.loading;
  bool get hasError => _state == CategoryLoadState.error;
  bool get hasData => _state == CategoryLoadState.loaded;

  Future<void> fetchCategories() async {
    if (_state == CategoryLoadState.loaded) return;

    _state = CategoryLoadState.loading;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      _state = CategoryLoadState.loaded;
    } catch (e) {
      _state = CategoryLoadState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    _state = CategoryLoadState.initial;
    await fetchCategories();
  }
}
