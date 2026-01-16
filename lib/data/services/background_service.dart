import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

/// Background Service for Workmanager tasks
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'dailyReminderTask') {
      await _showRandomRestaurantNotification();
    }
    return Future.value(true);
  });
}

/// Fetch random restaurant from API and show notification
Future<void> _showRandomRestaurantNotification() async {
  try {
    // Fetch restaurant list from API
    final response = await http.get(
      Uri.parse('https://restaurant-api.dicoding.dev/list'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final restaurants = data['restaurants'] as List<dynamic>;

      if (restaurants.isNotEmpty) {
        // Pick a random restaurant
        final random = Random();
        final restaurant = restaurants[random.nextInt(restaurants.length)];
        final name = restaurant['name'] as String;
        final city = restaurant['city'] as String;
        final rating = restaurant['rating'];

        // Show notification
        await _showNotification(
          title: '🍽️ Lunch Time!',
          body: 'Try $name in $city today! ⭐ $rating',
        );
      }
    }
  } catch (e) {
    // Fallback notification if API fails
    await _showNotification(
      title: '🍽️ Lunch Time!',
      body: 'Time for lunch! Explore restaurants in NyamNyam.',
    );
  }
}

/// Show local notification
Future<void> _showNotification({
  required String title,
  required String body,
}) async {
  final plugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await plugin.initialize(settings);

  const androidDetails = AndroidNotificationDetails(
    'daily_reminder',
    'Daily Reminder',
    channelDescription: 'Daily lunch reminder with random restaurant',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

  await plugin.show(0, title, body, details);
}

/// Helper class for background service initialization
class BackgroundService {
  static const String taskName = 'dailyReminderTask';

  /// Initialize Workmanager
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  /// Register daily reminder task
  static Future<void> registerDailyReminder() async {
    // Calculate initial delay to 11:00 AM
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final initialDelay = scheduledTime.difference(now);

    await Workmanager().registerPeriodicTask(
      taskName,
      taskName,
      initialDelay: initialDelay,
      frequency: const Duration(hours: 24),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Cancel daily reminder task
  static Future<void> cancelDailyReminder() async {
    await Workmanager().cancelByUniqueName(taskName);
  }
}
