import 'package:flutter/material.dart';
import '../data/data.dart';
import '../utils/result_state.dart';

/// Provider for managing restaurant detail state
class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  ResultState<RestaurantDetail> _state = const ResultStateNone();

  /// Current state of restaurant detail
  ResultState<RestaurantDetail> get state => _state;

  /// Fetch restaurant detail by ID
  Future<void> fetchRestaurantDetail(String id) async {
    _state = const ResultStateLoading();
    notifyListeners();

    try {
      final detail = await _apiService.getRestaurantDetail(id);
      _state = ResultStateSuccess(detail);
    } catch (e) {
      _state = ResultStateError(e.toString());
    }

    notifyListeners();
  }

  /// Reset state to none (useful when navigating back)
  void reset() {
    _state = const ResultStateNone();
    notifyListeners();
  }
}
