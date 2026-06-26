import 'package:flutter/material.dart';

import '../bani/bani_list_screen.dart';
import '../explore/explore_screen.dart';
import '../sehaj_path/sehaj_path_screen.dart';
import '../settings/settings_screen.dart';
import '../../shared/widgets/app_bottom_nav.dart';
import '../hukamnama/hukamnamaa_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final screens = const [
    HomeContent(),
    BaniListScreen(),
    ExploreScreen(),
    SehajPathScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: AppBottomNav(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF9C5700);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // HEADER
            // Row(
            //   mainAxisAlignment:
            //       MainAxisAlignment.spaceBetween,
            //   children: [
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(Icons.menu),
            //     ),
            //     const Text(
            //       "Gurbani Sewa",
            //       style: TextStyle(
            //         fontSize: 22,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.settings_outlined,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 30),

            Text(
              "ਵਾਹਿਗੁਰੂ ਜੀ ਕਾ ਖਾਲਸਾ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                height: 1.5,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w500,
                // color: getAccentColor(),
                fontFamily: "GurbaniAkhar",
              ),
            ),
            Text(
              "ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫ਼ਤਿਹ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                height: 1.5,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w500,
                // color: getAccentColor(),
                fontFamily: "GurbaniAkhar",
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "May your soul find tranquility in the Divine Word today.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // HUKAMNAMA CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withOpacity(.25)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Daily Hukamnama",
                        style: TextStyle(
                          color: primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.auto_awesome, color: primary),
                    ],
                  ),

                  // const SizedBox(height: 30),

                  // Text(
                  //   "ਸੰਤਹੁ ਮਨੁ ਸਮਾਲਹੁ ॥",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 24, color: primary),
                  // ),
                  const SizedBox(height: 16),

                  Text(
                    "Today's divine order from Sri Darbar Sahib",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HukmnamaScreen(),
                              ),
                            );
                          },
                          child: const Text("Read More"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // DAILY NITNEM
            Row(
              children: [
                const Text(
                  "Daily Nitnem",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BaniListScreen(),
                      ),
                    );
                  },
                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.1),
                    const Color(0xFFC99800).withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Japji Sahib",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.play_arrow, color: const Color(0xFFD4AF37)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text("The Song of the Soul"),
                  const SizedBox(height: 18),
                  LinearProgressIndicator(
                    value: 0.4,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(20),
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFD4AF37),
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       '40%',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //     Text(
                  //       'Listen',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Progress",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: primary, width: 3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "12",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Text(
                      "You've maintained your Nitnem for 12 consecutive days.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BANNER
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HukmnamaScreen(),
                  ),
                );
              },
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/images/golden_temple.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Daily Sangat Wisdom",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
