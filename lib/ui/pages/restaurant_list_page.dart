import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant.dart';
import '../../providers/restaurant_list_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/result_state.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RestaurantListProvider>().fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<RestaurantListProvider>().fetchRestaurants(),
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'NyamNyam',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Welcome Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Text(
                  'Let\'s find your\nfavorite food!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Restaurant List
            Consumer<RestaurantListProvider>(
              builder: (_, provider, child) {
                return switch (provider.state) {
                  ResultStateNone() => const SliverFillRemaining(
                    child: Center(child: Text('Press refresh')),
                  ),
                  ResultStateLoading() => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  ResultStateSuccess<List<Restaurant>>(:final data) =>
                    _buildSliverList(data),
                  ResultStateError(:final message) => SliverFillRemaining(
                    child: _buildErrorState(message),
                  ),
                };
              },
            ),
            // Bottom padding for scrolling
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverList(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.no_food_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              const Text('No restaurants found'),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final restaurant = restaurants[index];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () => context.push(
            '/detail/${restaurant.id}?name=${Uri.encodeComponent(restaurant.name)}',
          ),
        );
      }, childCount: restaurants.length),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<RestaurantListProvider>().fetchRestaurants(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
