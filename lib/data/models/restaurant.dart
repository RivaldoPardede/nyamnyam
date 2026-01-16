/// Restaurant model for list view (simpler data)
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  /// Get the full image URL from pictureId
  String get pictureUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';

  /// Get small image URL for thumbnails
  String get smallPictureUrl =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';

  /// Get large image URL for detail view
  String get largePictureUrl =>
      'https://restaurant-api.dicoding.dev/images/large/$pictureId';

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureId: json['pictureId'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

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

/// Category model
class Category {
  final String name;

  const Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] as String);
  }
}

/// Menus model containing foods and drinks
class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  const Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List<dynamic>)
          .map((f) => MenuItem.fromJson(f as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((d) => MenuItem.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Menu item model
class MenuItem {
  final String name;

  const MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] as String);
  }
}

/// Customer review model
class CustomerReview {
  final String name;
  final String review;
  final String date;

  const CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] as String,
      review: json['review'] as String,
      date: json['date'] as String,
    );
  }
}
