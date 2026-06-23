// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:liquid_glass_bar/liquid_glass_bar.dart';

// class AppBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const AppBottomNav({
//     super.key,
//     required this._currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: pages[_currentIndex],
//       bottomNavigationBar: LiquidGlassBar(
//         items: const [
//           LiquidGlassBarItem(iconData: Icons.home, label: 'Home'),
//           LiquidGlassBarItem(iconData: Icons.search, label: 'Search'),
//           LiquidGlassBarItem(iconData: Icons.person, label: 'Profile'),
//         ],
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//       ),
//     );
//   }
// }
