import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_review.dart';
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

/// API Service for Dicoding Restaurant API
class ApiService {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch list of all restaurants
  Future<List<Restaurant>> getRestaurantList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/list'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] == true) {
        throw Exception(data['message'] ?? 'Failed to load restaurants');
      }

      final restaurants = (data['restaurants'] as List<dynamic>)
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();

      return restaurants;
    } else {
      throw Exception('Failed to load restaurants: ${response.statusCode}');
    }
  }

  /// Fetch restaurant detail by ID
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] == true) {
        throw Exception(data['message'] ?? 'Failed to load restaurant detail');
      }

      return RestaurantDetail.fromJson(
        data['restaurant'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load restaurant detail: ${response.statusCode}',
      );
    }
  }

  /// Search restaurants by query
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/search').replace(queryParameters: {'q': query}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] == true) {
        throw Exception(data['message'] ?? 'Failed to search restaurants');
      }

      final restaurants = (data['restaurants'] as List<dynamic>)
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();

      return restaurants;
    } else {
      throw Exception('Failed to search restaurants: ${response.statusCode}');
    }
  }

  /// Add a review to a restaurant
  Future<List<CustomerReview>> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': restaurantId, 'name': name, 'review': review}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] == true) {
        throw Exception(data['message'] ?? 'Failed to add review');
      }

      final reviews = (data['customerReviews'] as List<dynamic>)
          .map((r) => CustomerReview.fromJson(r as Map<String, dynamic>))
          .toList();

      return reviews;
    } else {
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }
}
