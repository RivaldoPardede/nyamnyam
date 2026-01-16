import 'package:flutter/material.dart';
import '../data/local/preferences_service.dart';

/// Provider for managing app theme mode with persistence
class ThemeProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider({PreferencesService? prefsService})
    : _prefsService = prefsService ?? PreferencesService();

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Initialize theme from preferences
  Future<void> loadTheme() async {
    final modeIndex = await _prefsService.getThemeMode();
    _themeMode = ThemeMode.values[modeIndex];
    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsService.setThemeMode(mode.index);
    notifyListeners();
  }
}
