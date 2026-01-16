import 'package:flutter/material.dart';
import '../data/local/preferences_service.dart';

/// Provider for managing app theme mode with persistence
class ThemeProvider extends ChangeNotifier {
  final PreferencesService _prefsService;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeProvider({PreferencesService? prefsService})
    : _prefsService = prefsService ?? PreferencesService();

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether provider is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize theme from preferences
  Future<void> loadTheme() async {
    final modeIndex = await _prefsService.getThemeMode();
    _themeMode = ThemeMode.values[modeIndex];
    _isInitialized = true;
    notifyListeners();
  }

  /// Whether dark mode is active (for display purposes)
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _prefsService.setThemeMode(_themeMode.index);
    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefsService.setThemeMode(mode.index);
    notifyListeners();
  }
}
