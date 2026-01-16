import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/customer_review.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/restaurant.dart';
import '../../data/models/restaurant_detail.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/restaurant_detail_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/result_state.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
        widget.restaurantId,
      );
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (_, provider, child) {
          return switch (provider.state) {
            ResultStateNone() => _buildLoadingState(),
            ResultStateLoading() => _buildLoadingState(),
            ResultStateSuccess<RestaurantDetail>(:final data) =>
              _buildSuccessState(data),
            ResultStateError(:final message) => _buildErrorState(message),
          };
        },
      ),
      floatingActionButton:
          _buildFloatingFavoriteButton(), // FAB for favorite action
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSuccessState(RestaurantDetail restaurant) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(restaurant),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info
                Text(
                  restaurant.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${restaurant.city} • ${restaurant.address}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats Row (Rating, Categories)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.star.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.star.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: AppColors.star,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toString(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFB07B00), // Darker amber
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ...restaurant.categories.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(c.name),
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(color: theme.dividerColor),
                            visualDensity: VisualDensity.compact,
                            labelStyle: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'About',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Menus
                _buildSectionTitle(theme, 'Foods', Icons.restaurant_menu),
                const SizedBox(height: 12),
                _buildHorizontalMenu(
                  theme,
                  restaurant.menus.foods,
                  Icons.lunch_dining,
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, 'Drinks', Icons.local_bar),
                const SizedBox(height: 12),
                _buildHorizontalMenu(
                  theme,
                  restaurant.menus.drinks,
                  Icons.local_drink,
                ),
                const SizedBox(height: 32),

                // Reviews
                _buildSectionTitle(theme, 'Reviews', Icons.comment),
                const SizedBox(height: 16),
                _buildAddReviewForm(),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurant.customerReviews.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _buildReviewTile(
                    theme,
                    restaurant.customerReviews[index],
                  ),
                ),
                const SizedBox(height: 80), // Fab space
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(RestaurantDetail restaurant) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: const IconThemeData(
        color: Colors.white,
        shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'restaurant-image-${restaurant.id}',
              child: Image.network(
                restaurant.largePictureUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stack) =>
                    Container(color: Colors.grey),
              ),
            ),
            // Gradient Overlay for text readability (scrim)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black54,
                  ],
                  stops: [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFavoriteButton() {
    return Consumer<RestaurantDetailProvider>(
      builder: (_, provider, child) {
        final data = provider.state is ResultStateSuccess<RestaurantDetail>
            ? (provider.state as ResultStateSuccess<RestaurantDetail>).data
            : null;

        if (data == null) return const SizedBox.shrink();

        // Check favorite status using Consumer to watch favorites list
        return Consumer<FavoriteProvider>(
          builder: (_, favoriteProvider, child) {
            final isFavorite = favoriteProvider.favorites.any((r) => r.id == data.id);
            return FloatingActionButton.extended(
              onPressed: () async {
                final restaurant = Restaurant(
                  id: data.id,
                  name: data.name,
                  description: data.description,
                  pictureId: data.pictureId,
                  city: data.city,
                  rating: data.rating,
                );
                final newStatus = await context
                    .read<FavoriteProvider>()
                    .toggleFavorite(restaurant);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        newStatus
                            ? 'Added to favorites'
                            : 'Removed from favorites',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              label: Text(isFavorite ? 'Saved' : 'Save'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalMenu(
    ThemeData theme,
    List<MenuItem> items,
    IconData placeholderIcon,
  ) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  placeholderIcon,
                  size: 28,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    items[index].name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewTile(ThemeData theme, CustomerReview review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  review.name.isNotEmpty ? review.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      review.date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.review, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildAddReviewForm() {
    return Consumer<RestaurantDetailProvider>(
      builder: (_, provider, child) {
        final isSubmitting = provider.isSubmittingReview;

        return Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: 'Write a review...',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              maxLines: 2,
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () {
                        if (_nameController.text.isNotEmpty &&
                            _reviewController.text.isNotEmpty) {
                          context
                              .read<RestaurantDetailProvider>()
                              .addReview(
                                restaurantId: widget.restaurantId,
                                name: _nameController.text,
                                review: _reviewController.text,
                              )
                              .then((success) {
                                if (success && mounted) {
                                  _nameController.clear();
                                  _reviewController.clear();
                                }
                              });
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Post Review'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(child: Text(message));
  }
}
