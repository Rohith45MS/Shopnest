import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

enum ProductLoadState { initial, loading, loaded, error }

class ProductController extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  ProductLoadState _state = ProductLoadState.initial;
  String _errorMessage = '';
  int? _selectedCategoryId;
  String _searchQuery = '';
  bool _isLoadingMore = false;
  int _offset = 0;
  bool _hasMore = true;

  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get allProducts => _allProducts;
  ProductLoadState get state => _state;
  String get errorMessage => _errorMessage;
  int? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  bool get isLoading => _state == ProductLoadState.loading;
  bool get hasError => _state == ProductLoadState.error;
  bool get hasData => _state == ProductLoadState.loaded;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _offset = 0;
      _hasMore = true;
      _allProducts = [];
    }

    if (_state != ProductLoadState.loaded || refresh) {
      _state = ProductLoadState.loading;
      notifyListeners();
    }

    try {
      final products = await _apiService.getProducts(
        offset: _offset,
        limit: 20,
        categoryId: _selectedCategoryId,
      );

      if (refresh) _allProducts = [];
      _allProducts.addAll(products);
      _offset += products.length;
      _hasMore = products.length == 20;

      _applyFilters();
      _state = ProductLoadState.loaded;
    } catch (e) {
      _state = ProductLoadState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final products = await _apiService.getProducts(
        offset: _offset,
        limit: 20,
        categoryId: _selectedCategoryId,
      );

      _allProducts.addAll(products);
      _offset += products.length;
      _hasMore = products.length == 20;
      _applyFilters();
    } catch (_) {}

    _isLoadingMore = false;
    notifyListeners();
  }

  void filterByCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    _offset = 0;
    _hasMore = true;
    _allProducts = [];
    fetchProducts();
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts =
          _allProducts.where((p) {
            return p.title.toLowerCase().contains(_searchQuery) ||
                p.description.toLowerCase().contains(_searchQuery) ||
                p.category.name.toLowerCase().contains(_searchQuery);
          }).toList();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
}
