// bani_list_screen.dart (updated with navigation)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bani_detail_screen.dart';

class BaniListScreen extends StatefulWidget {
  const BaniListScreen({super.key});

  @override
  State<BaniListScreen> createState() => _BaniListScreenState();
}

class _BaniListScreenState extends State<BaniListScreen> {
  List<Bani> banis = [];
  List<Bani> filteredBanis = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchBanis();
  }

  Future<void> fetchBanis() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.banidb.com/v2/banis'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          banis = data.map((json) => Bani.fromJson(json)).toList();
          filteredBanis = banis;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load banis');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading banis: $e')),
        );
      }
    }
  }

  void filterBanis(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    final filtered = banis.where((bani) {
      final matchesSearch = bani.gurmukhiUni
          .toLowerCase()
          .contains(searchQuery.toLowerCase()) ||
          bani.transliteration
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          (bani.transliterations['english']?.toLowerCase() ?? '')
              .contains(searchQuery.toLowerCase());

      if (selectedFilter == 'All') return matchesSearch;
      
      // Add category filtering logic here
      // For example, you might have a categories field or map
      return matchesSearch;
    }).toList();

    setState(() {
      filteredBanis = filtered;
    });
  }

  // Navigation method - similar to Next.js router.push()
  void navigateToBaniDetail(Bani bani) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaniDetailScreen(
          baniId: bani.id.toString(),
          baniToken: bani.token,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (Navigator.of(context).canPop())
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      const Text(
                        "Banis",
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),
                Text(
                  "Sacred prayers and daily Nitnem",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: filterBanis,
                  decoration: InputDecoration(
                    hintText: "Search Bani...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip("All", selectedFilter == "All", () {
                        setState(() {
                          selectedFilter = "All";
                          applyFilters();
                        });
                      }),
                      _chip("Nitnem", selectedFilter == "Nitnem", () {
                        setState(() {
                          selectedFilter = "Nitnem";
                          applyFilters();
                        });
                      }),
                      _chip("Morning", selectedFilter == "Morning", () {
                        setState(() {
                          selectedFilter = "Morning";
                          applyFilters();
                        });
                      }),
                      _chip("Evening", selectedFilter == "Evening", () {
                        setState(() {
                          selectedFilter = "Evening";
                          applyFilters();
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                itemCount: filteredBanis.isEmpty ? 1 : filteredBanis.length,
                itemBuilder: (context, index) {
                  if (filteredBanis.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: const Center(
                        child: Text(
                          'No Banis found',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  final bani = filteredBanis[index];

                  return GestureDetector(
                    onTap: () => navigateToBaniDetail(bani),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(18),
                        leading: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4AF37), Color(0xFFC99800)],
                            ),
                          ),
                          child: const Icon(Icons.menu_book, color: Colors.black),
                        ),
                        title: Text(
                          bani.gurmukhiUni,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "${bani.transliterations['english'] ?? bani.transliteration} • ${bani.token}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded),
                          onPressed: () => navigateToBaniDetail(bani),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Chip(
          label: Text(text),
          backgroundColor: selected ? const Color(0xFFD4AF37) : null,
          side: BorderSide(
            color: selected ? const Color(0xFFD4AF37) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

class Bani {
  final int id;
  final String token;
  final String gurmukhi;
  final String gurmukhiUni;
  final String transliteration;
  final Map<String, String> transliterations;
  final String updated;

  Bani({
    required this.id,
    required this.token,
    required this.gurmukhi,
    required this.gurmukhiUni,
    required this.transliteration,
    required this.transliterations,
    required this.updated,
  });

  factory Bani.fromJson(Map<String, dynamic> json) {
    return Bani(
      id: json['ID'] as int,
      token: json['token'] as String,
      gurmukhi: json['gurmukhi'] as String,
      gurmukhiUni: json['gurmukhiUni'] as String,
      transliteration: json['transliteration'] as String,
      transliterations: Map<String, String>.from(
        json['transliterations'] as Map<String, dynamic>,
      ),
      updated: json['updated'] as String,
    );
  }
}