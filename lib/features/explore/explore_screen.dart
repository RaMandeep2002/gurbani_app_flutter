import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          120,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Explore",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Discover Gurbani, Banis & Shabads",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            // SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Search Gurbani...",
                prefixIcon:
                    const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // FEATURED CARD
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFF8B6F00),
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    "Featured Bani",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "ਜਪੁਜੀ ਸਾਹਿਬ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "The Song of the Soul",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.4,
              children: [
                _categoryCard(
                  context,
                  "Nitnem",
                  Icons.menu_book,
                ),
                _categoryCard(
                  context,
                  "Shabads",
                  Icons.library_music,
                ),
                _categoryCard(
                  context,
                  "Favorites",
                  Icons.favorite,
                ),
                _categoryCard(
                  context,
                  "Sehaj Path",
                  Icons.auto_stories,
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              "Popular Banis",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            ...[
              "Japji Sahib",
              "Jaap Sahib",
              "Anand Sahib",
              "Rehras Sahib",
              "Kirtan Sohila",
            ].map(
              (bani) => Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  color: Theme.of(context)
                      .cardColor,
                  border: Border.all(
                    color: isDark
                        ? Colors.white10
                        : Colors.black12,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(
                            0xFFD4AF37,
                          ),
                          Color(
                            0xFFC99800,
                          ),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(bani),
                  subtitle:
                      const Text("Daily Prayer"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Searches",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                Chip(
                  label: Text("Japji Sahib"),
                ),
                Chip(
                  label: Text("Sukhmani Sahib"),
                ),
                Chip(
                  label: Text("Waheguru"),
                ),
                Chip(
                  label: Text("Anand Sahib"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _categoryCard(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color: Theme.of(context)
            .cardColor,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 34,
            color: const Color(
              0xFFD4AF37,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}