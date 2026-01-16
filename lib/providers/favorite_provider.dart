import 'package:flutter/material.dart';
import '../data/local/database_helper.dart';
import '../data/models/restaurant.dart';

/// Provider for managing favorite restaurants state
class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper;

  FavoriteProvider({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper();

  List<Restaurant> _favorites = [];
  bool _isLoading = false;
  String? _error;

  /// List of favorite restaurants
  List<Restaurant> get favorites => _favorites;

  /// Whether favorites are being loaded
  bool get isLoading => _isLoading;

  /// Error message if any
  String? get error => _error;

  /// Load all favorites from database
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favorites = await _databaseHelper.getFavorites();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if restaurant is in favorites
  Future<bool> isFavorite(String id) async {
    return await _databaseHelper.isFavorite(id);
  }

  /// Add restaurant to favorites
  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await _databaseHelper.addFavorite(restaurant);
      _favorites.add(restaurant);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Remove restaurant from favorites
  Future<void> removeFavorite(String id) async {
    try {
      await _databaseHelper.removeFavorite(id);
      _favorites.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(Restaurant restaurant) async {
    final isFav = await isFavorite(restaurant.id);
    if (isFav) {
      await removeFavorite(restaurant.id);
      return false;
    } else {
      await addFavorite(restaurant);
      return true;
    }
  }
}
