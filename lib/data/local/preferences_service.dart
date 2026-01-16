import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences using SharedPreferences
class PreferencesService {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDailyReminder = 'daily_reminder';

  SharedPreferences? _prefs;

  /// Initialize preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Save theme mode (0=system, 1=light, 2=dark)
  Future<void> setThemeMode(int mode) async {
    final p = await prefs;
    await p.setInt(_keyThemeMode, mode);
  }

  /// Get theme mode (0=system, 1=light, 2=dark)
  Future<int> getThemeMode() async {
    final p = await prefs;
    return p.getInt(_keyThemeMode) ?? 0;
  }

  /// Save daily reminder enabled state
  Future<void> setDailyReminderEnabled(bool enabled) async {
    final p = await prefs;
    await p.setBool(_keyDailyReminder, enabled);
  }

  /// Get daily reminder enabled state
  Future<bool> getDailyReminderEnabled() async {
    final p = await prefs;
    return p.getBool(_keyDailyReminder) ?? false;
  }
}
