import 'package:flutter/material.dart';
import '../data/models/restaurant.dart';
import '../data/services/api_service.dart';
import '../utils/result_state.dart';

/// Provider for managing restaurant search state
class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantSearchProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  ResultState<List<Restaurant>> _state = const ResultStateNone();
  String _query = '';

  /// Current state of search results
  ResultState<List<Restaurant>> get state => _state;

  /// Current search query
  String get query => _query;

  /// Search restaurants by query
  Future<void> searchRestaurants(String query) async {
    _query = query;

    // If query is empty, reset to none state
    if (query.trim().isEmpty) {
      _state = const ResultStateNone();
      notifyListeners();
      return;
    }

    _state = const ResultStateLoading();
    notifyListeners();

    try {
      final restaurants = await _apiService.searchRestaurants(query);
      _state = ResultStateSuccess(restaurants);
    } catch (e) {
      _state = ResultStateError(e.toString());
    }

    notifyListeners();
  }

  /// Clear search and reset state
  void clearSearch() {
    _query = '';
    _state = const ResultStateNone();
    notifyListeners();
  }
}
