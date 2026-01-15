import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/restaurant_list_provider.dart';
import 'ui/pages/restaurant_list_page.dart';
import 'utils/theme.dart';

void main() {
  runApp(const NyamNyamApp());
}

class NyamNyamApp extends StatelessWidget {
  const NyamNyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'NyamNyam',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const RestaurantListPage(),
      ),
    );
  }
}
