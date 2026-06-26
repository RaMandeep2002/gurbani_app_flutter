// lib/screens/explore_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurbani/models/bani_model.dart';
import 'package:gurbani/services/bani_api_service.dart';
import 'package:gurbani/shared/widgets/verse_card.dart';
import 'package:gurbani/data/writers_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BaniApiService _apiService = BaniApiService();

  // State variables
  String _query = '';
  bool _showKeyboard = false;
  String _matchType = 'Romanized Gurmukhi (English)';
  String _writer = 'All Writers';
  String _source = 'All sources';
  int _currentPage = 1;

  // API response
  List<BaniVerse> _results = [];
  ResultsInfo? _resultsInfo;
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  // Quick links data
  final List<QuickLink> _quickLinks = const [
    QuickLink(
      title: 'Nitnem Path',
      description: 'Read all daily Nitnem Banis',
      icon: Icons.menu_book,
      route: '/read',
    ),
    QuickLink(
      title: 'Sikh Gurus',
      description: 'Browse all 10 Gurus and their teachings',
      icon: Icons.people,
      route: '/explore/sikh-gurus',
    ),
    QuickLink(
      title: 'Panj Pyare',
      description: 'Browse the beloved five',
      icon: Icons.people_outline,
      route: '/explore/panj-pyare',
    ),
    QuickLink(
      title: 'Chaar Sahibzade',
      description: 'The four beloved sons',
      icon: Icons.family_restroom,
      route: '/explore/chaar-sahibzade',
    ),
  ];

  // Category cards data
  // final List<CategoryCard> _categories = const [
  //   CategoryCard(
  //     title: 'By Word',
  //     description: 'Browse by word',
  //     icon: Icons.music_note,
  //     count: 31,
  //   ),
  //   CategoryCard(
  //     title: 'By Writers',
  //     description: 'Browse by Writers',
  //     icon: Icons.person,
  //     count: 36,
  //   ),
  //   CategoryCard(
  //     title: 'By Banni',
  //     description: 'Daily prayers and compositions',
  //     icon: Icons.book,
  //     count: 40,
  //   ),
  // ];

  // Debounce timer
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
      _currentPage = 1;
    });
    _debounceSearch();
  }

  void _debounceSearch() {
    _debounceTimer?.cancel();
    if (_query.trim().length > 2) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _performSearch();
      });
    } else {
      setState(() {
        _results = [];
        _resultsInfo = null;
        _hasSearched = false;
        _error = null;
      });
    }
  }

  void _performSearch() async {
    if (_query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
    });

    try {
      // Auto-detect Gurmukhi
      final isGurmukhi = RegExp(r'[\u0A00-\u0A7F]').hasMatch(_query);

      final matchTypeMap = {
        'First letter each word from start (Gurmukhi)': 0,
        'First letter each word anywhere (Gurmukhi)': 1,
        'Full Word (Gurmukhi)': 2,
        'Full Word Translation (English)': 3,
        'Romanized Gurmukhi (English)': 4,
      };

      final searchType = matchTypeMap[_matchType] ?? (isGurmukhi ? 2 : 4);

      // Get writer ID
      int? writerId;
      if (_writer != 'All Writers') {
        final foundWriter = WriterData.rows.firstWhere(
          (w) => w.writerEnglish == _writer,
          orElse: () => WriterDataRow(writerId: 0, writerEnglish: ''),
        );
        if (foundWriter.writerId != 0) {
          writerId = foundWriter.writerId;
        }
      }

      // Get source ID
      final sourceMap = {
        'All sources': 'all',
        'Guru Granth Sahib Ji': 'G',
        'Dasam Granth Sahib': 'D',
        'Bhai Gurdas Ji Vaaran': 'B',
        'Amrit Keertan': 'A',
        'Bhai Gurdas Singh Ji Vaaran': 'S',
        'Bhai Nand Lal Ji Vaaran': 'N',
        'Rehatnamas & Panthic Sources': 'R',
      };

      final sourceId = sourceMap[_source] ?? 'all';

      final response = await _apiService.searchGurbaniAdvanced(
        query: _query,
        searchType: searchType,
        source: sourceId,
        writerId: writerId,
        page: _currentPage,
        resultsPerPage: 30,
      );

      setState(() {
        _results = response.verses;
        _resultsInfo = response.resultsInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _results = [];
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE2BF80);
    final primaryText = isDark ? Colors.white : const Color(0xFF1A2B4A);
    final secondaryText = isDark ? Colors.grey[300] : const Color(0xFF1A2B4A);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover the wisdom of Gurbani',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    _buildSearchBar(primaryBg, primaryText),

          

                    const SizedBox(height: 16),

                    // Filters
                    _buildFilters(primaryBg, primaryText),

                    const SizedBox(height: 16),

                      _buildResults(primaryText, isDark),
                    // Content Area
                    // if (_query.trim().length > 2) ...[
                    // ] else ...[
                    //   // _buildCategories(primaryBg, primaryText),
                    //   const SizedBox(height: 16),
                    //   _buildQuickLinks(primaryBg, primaryText),
                    // ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────────────────────────────────

  Widget _buildSearchBar(Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        // color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Search Gurbani...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filters ──────────────────────────────────────────────────────────────────

  Widget _buildFilters(Color bgColor, Color textColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterDropdown(
            label: 'Match',
            value: _matchType,
            options: const [
              'First letter each word from start (Gurmukhi)',
              'First letter each word anywhere (Gurmukhi)',
              'Full Word (Gurmukhi)',
              'Full Word Translation (English)',
              'Romanized Gurmukhi (English)',
            ],
            onChanged: (value) {
              setState(() {
                _matchType = value;
                _currentPage = 1;
              });
              _debounceSearch();
            },
          ),
          const SizedBox(width: 8),
          _FilterDropdown(
            label: 'Writer',
            value: _writer,
            options: [
              'All Writers',
              ...WriterData.rows.map((w) => w.writerEnglish).toSet(),
            ],
            onChanged: (value) {
              setState(() {
                _writer = value;
                _currentPage = 1;
              });
              _debounceSearch();
            },
          ),
          const SizedBox(width: 8),
          _FilterDropdown(
            label: 'Source',
            value: _source,
            options: const [
              'All sources',
              'Guru Granth Sahib Ji',
              'Dasam Granth Sahib',
              'Bhai Gurdas Ji Vaaran',
              'Amrit Keertan',
              'Bhai Gurdas Singh Ji Vaaran',
              'Bhai Nand Lal Ji Vaaran',
              'Rehatnamas & Panthic Sources',
            ],
            onChanged: (value) {
              setState(() {
                _source = value;
                _currentPage = 1;
              });
              _debounceSearch();
            },
          ),
        ],
      ),
    );
  }

  // ── Results ─────────────────────────────────────────────────────────────────

  Widget _buildResults(Color textColor, bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC1974A)),
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: Colors.red.shade400),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty && _hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.search_off, color: Colors.grey.shade400, size: 48),
              const SizedBox(height: 16),
              Text(
                'No results found for "$_query".',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result count
        Text(
          'Search Results (${_resultsInfo?.totalResults ?? _results.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),

        // Pagination - Top
        if (_resultsInfo?.pages != null) ...[
          _buildPagination(textColor),
          const SizedBox(height: 16),
        ],

        // Results list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return VerseCard(
              verse: _results[index],
              backgroundColor: isDark ? null : const Color(0xFFE2BF80),
            );
          },
        ),

        const SizedBox(height: 16),

        // Pagination - Bottom
        if (_resultsInfo?.pages != null) ...[
          _buildPagination(textColor),
        ],
      ],
    );
  }

  // ── Pagination ──────────────────────────────────────────────────────────────

  Widget _buildPagination(Color textColor) {
    final pages = _resultsInfo!.pages!;
    final totalPages = pages.totalPages ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        _PaginationButton(
          label: 'Previous',
          onPressed: pages.page > 1
              ? () {
                  setState(() {
                    _currentPage = pages.page - 1;
                  });
                  _performSearch();
                }
              : null,
          textColor: textColor,
        ),

        const SizedBox(width: 16),

        Text(
          'Page ${pages.page} of $totalPages',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),

        const SizedBox(width: 16),

        // Next button
        _PaginationButton(
          label: 'Next',
          onPressed: pages.nextPage != null
              ? () {
                  setState(() {
                    _currentPage = pages.page + 1;
                  });
                  _performSearch();
                }
              : null,
          textColor: textColor,
        ),
      ],
    );
  }

  // ── Categories ──────────────────────────────────────────────────────────────

  // Widget _buildCategories(Color bgColor, Color textColor) {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3,
  //       childAspectRatio: 1.2,
  //       crossAxisSpacing: 12,
  //       mainAxisSpacing: 12,
  //     ),
  //     itemCount: _categories.length,
  //     itemBuilder: (context, index) {
  //       final category = _categories[index];
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: bgColor,
  //           borderRadius: BorderRadius.circular(16),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 8,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: const BoxDecoration(
  //                 color: Color(0xFFC1974A),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 category.icon,
  //                 color: textColor,
  //                 size: 24,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               category.title,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: textColor,
  //               ),
  //             ),
  //             const SizedBox(height: 2),
  //             Text(
  //               category.description,
  //               style: TextStyle(
  //                 fontSize: 11,
  //                 color: textColor.withOpacity(0.7),
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // ── Quick Links ─────────────────────────────────────────────────────────────

  Widget _buildQuickLinks(Color bgColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _quickLinks.length,
          itemBuilder: (context, index) {
            final link = _quickLinks[index];
            return GestureDetector(
              onTap: () {
                // Navigate to link.route
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigate to ${link.title}'),
                    backgroundColor: const Color(0xFFC1974A),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          link.icon,
                          color: textColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            link.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE2BF80);
    final textColor = isDark ? Colors.white : const Color(0xFF1A2B4A);

    return Container(
      height: 48, // Increased height
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor,
            size: 26,
          ),
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: bgColor,
          isDense: false,
          elevation: 4,
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: SizedBox(
                width: 160,
                child: Text(
                  option,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color textColor;

  const _PaginationButton({
    required this.label,
    this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A2B4A),
        foregroundColor: const Color(0xFFE2BF80),
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(80, 36),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

class QuickLink {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const QuickLink({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}

// class CategoryCard {
//   final String title;
//   final String description;
//   final IconData icon;
//   final int count;

//   const CategoryCard({
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.count,
//   });
// }