import 'package:flutter/material.dart';
import '../data/local/preferences_service.dart';
import '../data/services/background_service.dart';
import '../data/services/notification_service.dart';

/// Provider for managing daily reminder settings
class ReminderProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  final NotificationService _notificationService;

  bool _isEnabled = false;

  ReminderProvider({
    PreferencesService? prefsService,
    NotificationService? notificationService,
  }) : _prefsService = prefsService ?? PreferencesService(),
       _notificationService = notificationService ?? NotificationService();

  /// Whether daily reminder is enabled
  bool get isEnabled => _isEnabled;

  /// Initialize reminder state from preferences
  Future<void> loadReminder() async {
    _isEnabled = await _prefsService.getDailyReminderEnabled();

    // If enabled, ensure Workmanager task is registered
    if (_isEnabled) {
      await _scheduleReminder();
    }

    notifyListeners();
  }

  /// Set reminder state
  Future<void> setReminder(bool enabled) async {
    if (_isEnabled == enabled) return;

    _isEnabled = enabled;
    await _prefsService.setDailyReminderEnabled(enabled);

    if (enabled) {
      await _scheduleReminder();
    } else {
      await _cancelReminder();
    }

    notifyListeners();
  }

  Future<void> _scheduleReminder() async {
    // Request notification permissions first
    await _notificationService.requestPermissions();

    // Register Workmanager periodic task for random restaurant notification
    await BackgroundService.registerDailyReminder();
  }

  Future<void> _cancelReminder() async {
    // Cancel Workmanager task
    await BackgroundService.cancelDailyReminder();

    // Also cancel any pending notifications
    await _notificationService.cancelDailyReminder();
  }
}
