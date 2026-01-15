import 'package:flutter/material.dart';
import 'utils/theme.dart';

void main() {
  runApp(const NyamNyamApp());
}

class NyamNyamApp extends StatelessWidget {
  const NyamNyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NyamNyam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PlaceholderHomePage(),
    );
  }
}

/// Temporary placeholder - will be replaced with RestaurantListPage
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('NyamNyam'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to NyamNyam!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Restaurant discovery app',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore),
              label: const Text('Explore Restaurants'),
            ),
          ],
        ),
      ),
    );
  }
}
