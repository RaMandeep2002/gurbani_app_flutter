import 'dart:ui';
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_rounded, "Home"),
    (Icons.menu_book_rounded, "Banis"),
    (Icons.search_rounded, "Explore"),
    (Icons.auto_stories_rounded, "Path"),
    (Icons.settings_rounded, "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 25,
            ), // Reduced blur for clarity
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isDark
                    ? Colors.white.withOpacity(0.08) // More transparent
                    : Colors.white.withOpacity(0.30), // More transparent
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.12) // Subtle border
                      : Colors.white.withOpacity(0.20), // Subtle border
                  width: 1.2, // Thinner border
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 0, // No spread for liquid glass
                    color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
                  ),
                  // Inner shadow for depth (liquid glass effect)
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: -2,
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.15),
                    offset: Offset(0, -1), // Light from top
                  ),
                ],
                // Gradient overlay for glass effect
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                          Colors.white.withOpacity(0.08),
                        ]
                      : [
                          Colors.white.withOpacity(0.40),
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.50),
                        ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _items.length,
                  (index) => _NavItem(
                    icon: _items[index].$1,
                    label: _items[index].$2,
                    selected: currentIndex == index,
                    onTap: () => onTap(index),
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFE8C55A)],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? Colors.black
                  : isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? Colors.black
                    : isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
