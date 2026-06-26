// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';
import 'package:gurbani/features/explore/search_screen.dart';
// import 'package:gurbani/services/bani_api_service.dart';
import 'package:gurbani/features/bani/bani_list_screen.dart';
import 'package:gurbani/features/bani/bani_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // final BaniApiService _apiService = BaniApiService();
  bool _isLoadingData = true;

  // Popular Banis with IDs
  final List<PopularBani> _popularBanis = const [
    PopularBani(
      id: 2,
      name: "Japji Sahib",
      subtitle: "Daily Prayer",
      token: "Japji Sahib",
    ),
    PopularBani(
      id: 4,
      name: "Jaap Sahib",
      subtitle: "Daily Prayer",
      token: "Jaap Sahib",
    ),
    PopularBani(
      id: 10,
      name: "Anand Sahib",
      subtitle: "Daily Prayer",
      token: "Anand Sahib",
    ),
    PopularBani(
      id: 21,
      name: "Rehras Sahib",
      subtitle: "Evening Prayer",
      token: "Rehras Sahib",
    ),
    PopularBani(
      id: 23,
      name: "Kirtan Sohila",
      subtitle: "Night Prayer",
      token: "Kirtan Sohila",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingData = true);
    try {
      setState(() {
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                    // Search Bar with Navigation
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFD4AF37),
                            width: 2,
                          ),
                        ),
                        child: const TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "Search Gurbani...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Categories Section
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 280,
                      child: GridView.count(
                        shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.4,
                        children: [
                          _categoryCard(context, "Nitnem", Icons.menu_book, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BaniListScreen(),
                              ),
                            );
                          }),
                          _categoryCard(
                            context,
                            "Shabads",
                            Icons.library_music,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BaniListScreen(),
                                ),
                              );
                            },
                          ),
                          _categoryCard(
                            context,
                            "Favorites",
                            Icons.favorite,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BaniListScreen(),
                                ),
                              );
                            },
                          ),
                          _categoryCard(context, "Writers", Icons.person, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BaniListScreen(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Popular Banis
                    const Text(
                      "Popular Banis",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ..._popularBanis.map(
                      (bani) => GestureDetector(
                        onTap: () => _navigateToBaniDetail(bani),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD4AF37),
                                    Color(0xFFC99800),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.menu_book,
                                color: Colors.black,
                              ),
                            ),
                            title: Text(bani.name),
                            subtitle: Text(bani.subtitle),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: const Color(0xFFD4AF37)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ✅ Navigate to Bani Detail Screen with ID
  void _navigateToBaniDetail(PopularBani bani) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BaniDetailScreen(baniId: bani.id.toString(), baniToken: bani.token),
      ),
    );
  }

  // void _searchCategory(String query) async {
  //   try {
  //     final results = await _apiService.searchGurbani(query);

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Found ${results.length} results for "$query"'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error searching: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }
}

// Popular Bani Model
class PopularBani {
  final int id;
  final String name;
  final String subtitle;
  final String token;

  const PopularBani({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.token,
  });
}
