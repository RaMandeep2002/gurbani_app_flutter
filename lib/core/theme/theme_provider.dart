import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType {
  light,
  dark,
  sepia,
  gold,
  khalsablue,
  kesri
}

class ThemeNotifier extends StateNotifier<ThemeModeType> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeModeType.dark) {
    // Load saved theme on initialization
    _loadSavedTheme();
  }

  // Load theme from SharedPreferences
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        // Convert string to enum
        final themeType = _stringToThemeEnum(savedTheme);
        if (themeType != null) {
          state = themeType;
        }
      }
    } catch (e) {
      // If loading fails, keep default theme
      print('Error loading theme: $e');
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme(ThemeModeType theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme.name);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  // Convert string to enum
  ThemeModeType? _stringToThemeEnum(String value) {
    try {
      return ThemeModeType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeModeType.dark,
      );
    } catch (e) {
      return null;
    }
  }

  void toggleTheme() {
    final themes = ThemeModeType.values;
    final currentIndex = themes.indexOf(state);
    final nextIndex = (currentIndex + 1) % themes.length;
    final newTheme = themes[nextIndex];
    
    state = newTheme;
    _saveTheme(newTheme); // Save the new theme
  }

  void setTheme(ThemeModeType theme) {
    state = theme;
    _saveTheme(theme); // Save the new theme
  }

  // Optional: Reset to default
  Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
    state = ThemeModeType.dark;
  }

  // Optional: Get saved theme without changing current state
  Future<ThemeModeType?> getSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      return _stringToThemeEnum(savedTheme ?? '');
    } catch (e) {
      return null;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeType>(
  (ref) => ThemeNotifier(),
);