import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gurbani/providers/providers.dart';

import '../../core/theme/theme_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 120),
        child: Column(
          children: [
            // Appearance Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Appearance",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ThemeModeType>(
                      initialValue: currentTheme,
                      decoration: InputDecoration(
                        labelText: "Theme",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeModeType.light,
                          child: Text("☀️ Light Mode"),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeType.dark,
                          child: Text("🌙 Dark Mode"),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeType.sepia,
                          child: Text("📜 Sepia Mode"),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeType.gold,
                          child: Text("✨ Gold Mode"),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeType.khalsablue,
                          child: Text("💙 Khalsa Blue"),
                        ),
                        DropdownMenuItem(
                          value: ThemeModeType.kesri,
                          child: Text("🧡 Kesri Mode"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(themeProvider.notifier).setTheme(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reading Preferences Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          // color: Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Reading Preferences",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Font Size Control
                    const Text(
                      "Font Size",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (settings.fontSize > 12) {
                              settingsNotifier.setFontSize(
                                settings.fontSize - 1,
                              );
                            }
                          },
                        ),
                        Expanded(
                          child: Slider(
                            value: settings.fontSize,
                            min: 12,
                            max: 36,
                            divisions: 24,
                            // activeColor: Theme.of(context).primaryColor,
                            label: '${settings.fontSize.round()}px',
                            onChanged: (value) {
                              settingsNotifier.setFontSize(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            if (settings.fontSize < 36) {
                              settingsNotifier.setFontSize(
                                settings.fontSize + 1,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${settings.fontSize.round()}px',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            settingsNotifier.setFontSize(20);
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Translation Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.translate,
                              color: settings.showTranslation
                                  ? Colors.white70
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Show Translation",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: settings.showTranslation,
                          activeThumbColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            settingsNotifier.toggleTranslation();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Transliteration Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.abc,
                              color: settings.showTransliteration
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Show Transliteration",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: settings.showTransliteration,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            settingsNotifier.toggleTransliteration();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Auto-Scroll Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: settings.isAutoScrolling
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Auto-Scroll",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: settings.isAutoScrolling,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            settingsNotifier.toggleAutoScroll();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Scroll Speed Control (appears only if auto-scroll is enabled)
                    if (settings.isAutoScrolling) ...[
                      const SizedBox(height: 8),
                      const Text(
                        "Scroll Speed",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.speed),
                            onPressed: () {
                              if (settings.scrollSpeed > 0.5) {
                                settingsNotifier.setScrollSpeed(
                                  settings.scrollSpeed - 0.25,
                                );
                              }
                            },
                          ),
                          Expanded(
                            child: Slider(
                              value: settings.scrollSpeed,
                              min: 0.5,
                              max: 2.0,
                              divisions: 6,
                              activeColor: Theme.of(context).primaryColor,
                              label:
                                  '${settings.scrollSpeed.toStringAsFixed(1)}x',
                              onChanged: (value) {
                                settingsNotifier.setScrollSpeed(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.speed),
                            onPressed: () {
                              if (settings.scrollSpeed < 2.0) {
                                settingsNotifier.setScrollSpeed(
                                  settings.scrollSpeed + 0.25,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${settings.scrollSpeed.toStringAsFixed(1)}x',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              settingsNotifier.setScrollSpeed(1.0);
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "About",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.library_books),
                      title: const Text('Gurbani Sewa'),
                      subtitle: const Text('Version 1.0.0'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Made with Love'),
                      subtitle: const Text('For the Sikh Community'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share'),
                      subtitle: const Text('Share this app with others'),
                      onTap: () {
                        // Add share functionality
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text('Rate this app'),
                      subtitle: const Text('Rate us on Play Store'),
                      onTap: () {
                        // Add rating functionality
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reset Button
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      _showResetDialog(context, settingsNotifier);
                    },
                    icon: const Icon(
                      Icons.settings_backup_restore,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Reset All Settings',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsProvider notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.resetAllSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
