import 'package:flutter/material.dart';
import '../data/data.dart';
import '../utils/result_state.dart';

/// Provider for managing restaurant list state
class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantListProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  ResultState<List<Restaurant>> _state = const ResultStateNone();

  /// Current state of restaurant list
  ResultState<List<Restaurant>> get state => _state;

  /// Fetch restaurant list from API
  Future<void> fetchRestaurants() async {
    _state = const ResultStateLoading();
    notifyListeners();

    try {
      final restaurants = await _apiService.getRestaurantList();
      _state = ResultStateSuccess(restaurants);
    } catch (e) {
      _state = ResultStateError(e.toString());
    }

    notifyListeners();
  }
}
