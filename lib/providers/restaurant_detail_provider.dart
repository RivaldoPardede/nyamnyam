import 'package:flutter/material.dart';
import '../data/data.dart';
import '../utils/result_state.dart';

/// Provider for managing restaurant detail state
class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  ResultState<RestaurantDetail> _state = const ResultStateNone();
  bool _isSubmittingReview = false;
  String? _reviewError;

  /// Current state of restaurant detail
  ResultState<RestaurantDetail> get state => _state;

  /// Whether a review is being submitted
  bool get isSubmittingReview => _isSubmittingReview;

  /// Error message when review submission fails
  String? get reviewError => _reviewError;

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

  /// Add a review to the restaurant
  Future<bool> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _isSubmittingReview = true;
    _reviewError = null;
    notifyListeners();

    try {
      final updatedReviews = await _apiService.addReview(
        restaurantId: restaurantId,
        name: name,
        review: review,
      );

      // Update the current state with new reviews
      if (_state is ResultStateSuccess<RestaurantDetail>) {
        final currentDetail =
            (_state as ResultStateSuccess<RestaurantDetail>).data;
        final updatedDetail = RestaurantDetail(
          id: currentDetail.id,
          name: currentDetail.name,
          description: currentDetail.description,
          pictureId: currentDetail.pictureId,
          city: currentDetail.city,
          address: currentDetail.address,
          rating: currentDetail.rating,
          categories: currentDetail.categories,
          menus: currentDetail.menus,
          customerReviews: updatedReviews,
        );
        _state = ResultStateSuccess(updatedDetail);
      }

      _isSubmittingReview = false;
      notifyListeners();
      return true;
    } catch (e) {
      _reviewError = e.toString();
      _isSubmittingReview = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear review error
  void clearReviewError() {
    _reviewError = null;
    notifyListeners();
  }

  /// Reset state to none (useful when navigating back)
  void reset() {
    _state = const ResultStateNone();
    _isSubmittingReview = false;
    _reviewError = null;
    notifyListeners();
  }
}
