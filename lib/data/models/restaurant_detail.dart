import 'category.dart';
import 'customer_review.dart';
import 'menus.dart';

/// Restaurant detail model with full information
class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  const RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  /// Get the full image URL from pictureId
  String get pictureUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  /// Get large image URL for detail view
  String get largePictureUrl =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureId: json['pictureId'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList(),
      menus: Menus.fromJson(json['menus'] as Map<String, dynamic>),
      customerReviews: (json['customerReviews'] as List<dynamic>)
          .map((r) => CustomerReview.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
