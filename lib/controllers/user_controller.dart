import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum UserLoadState { initial, loading, loaded, error }

class UserController extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  List<UserModel> _users = [];
  UserLoadState _state = UserLoadState.initial;
  String _errorMessage = '';

  List<UserModel> get users => _users;
  UserLoadState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == UserLoadState.loading;
  bool get hasError => _state == UserLoadState.error;
  bool get hasData => _state == UserLoadState.loaded;

  Future<void> fetchUsers() async {
    if (_state == UserLoadState.loaded) return;

    _state = UserLoadState.loading;
    notifyListeners();

    try {
      _users = await _apiService.getUsers(limit: 20);
      _state = UserLoadState.loaded;
    } catch (e) {
      _state = UserLoadState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    _state = UserLoadState.initial;
    await fetchUsers();
  }
}
