// lib/providers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider();
});