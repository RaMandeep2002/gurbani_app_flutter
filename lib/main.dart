import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gurbani/features/home/splash_screen.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Shared Preferences
    await SharedPreferences.getInstance();
    debugPrint('SharedPreferences initialized successfully');
  } catch (e) {
    debugPrint('Error initializing SharedPreferences: $e');
  }

  runApp(const ProviderScope(child: GurbaniApp()));
}

class GurbaniApp extends ConsumerWidget {
  const GurbaniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    ThemeData theme;

    switch (currentTheme) {
      case ThemeModeType.light:
        theme = AppTheme.lightTheme();
        break;

      case ThemeModeType.dark:
        theme = AppTheme.darkTheme();
        break;

      case ThemeModeType.sepia:
        theme = AppTheme.sepiaTheme();
        break;

      case ThemeModeType.gold:
        theme = AppTheme.goldTheme();
        break;
      case ThemeModeType.khalsablue:
        theme = AppTheme.khalsaBlueTheme();
        break;
      case ThemeModeType.kesri:
        theme = AppTheme.kesriTheme();
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gurbani Sewa',
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
