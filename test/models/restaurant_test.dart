import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/data/models/restaurant.dart';

void main() {
  group('Restaurant Model', () {
    // Test Restaurant JSON parsing
    test('should correctly parse Restaurant from JSON', () {
      final json = {
        'id': 'test-1',
        'name': 'Test Restaurant',
        'description': 'Test Description',
        'pictureId': 'pic1',
        'city': 'Test City',
        'rating': 4.5,
      };

      final restaurant = Restaurant.fromJson(json);

      expect(restaurant.id, 'test-1');
      expect(restaurant.name, 'Test Restaurant');
      expect(restaurant.description, 'Test Description');
      expect(restaurant.pictureId, 'pic1');
      expect(restaurant.city, 'Test City');
      expect(restaurant.rating, 4.5);
    });

    // Test Restaurant image URL generation
    test('should generate correct image URLs', () {
      final restaurant = Restaurant(
        id: 'test-1',
        name: 'Test Restaurant',
        description: 'Test Description',
        pictureId: 'test-pic-id',
        city: 'Test City',
        rating: 4.5,
      );

      expect(
        restaurant.smallPictureUrl,
        'https://restaurant-api.dicoding.dev/images/small/test-pic-id',
      );
      expect(
        restaurant.pictureUrl,
        'https://restaurant-api.dicoding.dev/images/medium/test-pic-id',
      );
      expect(
        restaurant.largePictureUrl,
        'https://restaurant-api.dicoding.dev/images/large/test-pic-id',
      );
    });

    // Test Restaurant with integer rating (should convert to double)
    test('should handle rating as integer from JSON', () {
      final json = {
        'id': 'test-2',
        'name': 'Test Restaurant 2',
        'description': 'Description',
        'pictureId': 'pic2',
        'city': 'City',
        'rating': 4, // integer instead of double
      };

      final restaurant = Restaurant.fromJson(json);

      expect(restaurant.rating, 4.0);
    });
  });
}
