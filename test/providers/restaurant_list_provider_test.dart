import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/data/models/restaurant.dart';
import 'package:nyamnyam/data/services/api_service.dart';
import 'package:nyamnyam/providers/restaurant_list_provider.dart';
import 'package:nyamnyam/utils/result_state.dart';

/// Mock ApiService for testing
class MockApiService extends ApiService {
  final bool shouldFail;
  final List<Restaurant> mockRestaurants;

  MockApiService({
    this.shouldFail = false,
    List<Restaurant>? restaurants,
  }) : mockRestaurants = restaurants ??
            [
              Restaurant(
                id: '1',
                name: 'Test Restaurant 1',
                description: 'Description 1',
                pictureId: 'pic1',
                city: 'City 1',
                rating: 4.5,
              ),
              Restaurant(
                id: '2',
                name: 'Test Restaurant 2',
                description: 'Description 2',
                pictureId: 'pic2',
                city: 'City 2',
                rating: 4.0,
              ),
            ];

  @override
  Future<List<Restaurant>> getRestaurantList() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (shouldFail) {
      throw Exception('Network error: Failed to fetch restaurants');
    }

    return mockRestaurants;
  }
}

void main() {
  group('RestaurantListProvider', () {
    // Test 1: Initial state should be ResultStateNone
    test('should have initial state as ResultStateNone', () {
      final provider = RestaurantListProvider(
        apiService: MockApiService(),
      );

      expect(provider.state, isA<ResultStateNone>());
    });

    // Test 2: Should return restaurant list on successful API call
    test('should return restaurant list when API call succeeds', () async {
      final mockService = MockApiService(shouldFail: false);
      final provider = RestaurantListProvider(apiService: mockService);

      // Fetch restaurants
      await provider.fetchRestaurants();

      // Verify state is Success with data
      expect(provider.state, isA<ResultStateSuccess<List<Restaurant>>>());
      final successState = provider.state as ResultStateSuccess<List<Restaurant>>;
      expect(successState.data.length, 2);
      expect(successState.data[0].name, 'Test Restaurant 1');
      expect(successState.data[1].name, 'Test Restaurant 2');
    });

    // Test 3: Should return error when API call fails
    test('should return error when API call fails', () async {
      final mockService = MockApiService(shouldFail: true);
      final provider = RestaurantListProvider(apiService: mockService);

      // Fetch restaurants (will fail)
      await provider.fetchRestaurants();

      // Verify state is Error
      expect(provider.state, isA<ResultStateError>());
      final errorState = provider.state as ResultStateError;
      expect(errorState.message, contains('Network error'));
    });

    // Test 4: Should show loading state during fetch
    test('should transition through loading state during fetch', () async {
      final mockService = MockApiService(shouldFail: false);
      final provider = RestaurantListProvider(apiService: mockService);

      // Track state changes
      final states = <ResultState<List<Restaurant>>>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      // Fetch restaurants
      await provider.fetchRestaurants();

      // Verify loading state was reached
      expect(states.length, 2);
      expect(states[0], isA<ResultStateLoading>());
      expect(states[1], isA<ResultStateSuccess<List<Restaurant>>>());
    });

    // Test 5: Should handle empty restaurant list
    test('should handle empty restaurant list from API', () async {
      final mockService = MockApiService(
        shouldFail: false,
        restaurants: [], // Empty list
      );
      final provider = RestaurantListProvider(apiService: mockService);

      await provider.fetchRestaurants();

      expect(provider.state, isA<ResultStateSuccess<List<Restaurant>>>());
      final successState = provider.state as ResultStateSuccess<List<Restaurant>>;
      expect(successState.data.isEmpty, true);
    });
  });
}
