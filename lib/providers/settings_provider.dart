// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Keys
  static const String themeKey = 'theme_mode';
  static const String fontSizeKey = 'font_size';
  static const String showTranslationKey = 'show_translation';
  static const String showTransliterationKey = 'show_transliteration';
  static const String scrollSpeedKey = 'scroll_speed';
  static const String autoScrollKey = 'auto_scroll';
  
  // State
  ThemeMode _themeMode = ThemeMode.light;
  double _fontSize = 20.0;
  bool _showTranslation = false;
  bool _showTransliteration = false;
  double _scrollSpeed = 1.0;
  bool _isAutoScrolling = false;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  bool get showTranslation => _showTranslation;
  bool get showTransliteration => _showTransliteration;
  double get scrollSpeed => _scrollSpeed;
  bool get isAutoScrolling => _isAutoScrolling;
  
  // Initialize
  SettingsProvider() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeString = prefs.getString(themeKey);
    if (themeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.light,
      );
    }
    
    // Load font size
    _fontSize = prefs.getDouble(fontSizeKey) ?? 20.0;
    
    // Load toggles
    _showTranslation = prefs.getBool(showTranslationKey) ?? false;
    _showTransliteration = prefs.getBool(showTransliterationKey) ?? false;
    
    // Load scroll speed
    _scrollSpeed = prefs.getDouble(scrollSpeedKey) ?? 1.0;
    
    // Load auto-scroll
    _isAutoScrolling = prefs.getBool(autoScrollKey) ?? false;
    
    notifyListeners();
  }
  
  // Theme
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, mode.toString());
    notifyListeners();
  }
  
  // Font Size
  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(fontSizeKey, size);
    notifyListeners();
  }
  
  // Translation
  Future<void> toggleTranslation() async {
    _showTranslation = !_showTranslation;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(showTranslationKey, _showTranslation);
    notifyListeners();
  }
  
  // Transliteration
  Future<void> toggleTransliteration() async {
    _showTransliteration = !_showTransliteration;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(showTransliterationKey, _showTransliteration);
    notifyListeners();
  }
  
  // Scroll Speed
  Future<void> setScrollSpeed(double speed) async {
    _scrollSpeed = speed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(scrollSpeedKey, speed);
    notifyListeners();
  }
  
  // Auto-Scroll
  Future<void> toggleAutoScroll() async {
    _isAutoScrolling = !_isAutoScrolling;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoScrollKey, _isAutoScrolling);
    notifyListeners();
  }
  
  // Reset all settings
  Future<void> resetAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
    notifyListeners();
  }
}