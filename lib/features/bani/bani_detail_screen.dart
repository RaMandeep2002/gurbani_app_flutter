// bani_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:gurbani/core/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BaniDetailScreen extends StatefulWidget {
  final String baniId;
  final String baniToken;

  const BaniDetailScreen({
    super.key,
    required this.baniId,
    required this.baniToken,
  });

  @override
  State<BaniDetailScreen> createState() => _BaniDetailScreenState();
}

class _BaniDetailScreenState extends State<BaniDetailScreen> {
  Map<String, dynamic>? baniData;
  bool isLoading = true;
  bool hasError = false;
  final ScrollController _scrollController = ScrollController();

  // Two independent toggles instead of one overloaded flag:
  // - showTranslation: English/Hindi meaning
  // - showTransliteration: Roman-script reading aid
  bool showTranslation = false;
  bool showTransliteration = false;

  // Font size and scroll speed controls
  double fontSize = 20.0;
  double scrollSpeed = 1.0; // Multiplier for scroll speed

  // Auto-scroll controls
  bool isAutoScrolling = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    fetchBaniDetails();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBaniDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.banidb.com/v2/banis/${widget.baniId}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          baniData = json.decode(response.body) as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bani details (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bani details: $e')),
        );
      }
    }
  }

  /// Safely reads [key] from [map] as a String, regardless of whether the
  /// API actually sent a String, an int, a double, or null.
  String? _readString(Map<String, dynamic>? map, String key) {
    final dynamic value = map?[key];
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  void _startAutoScroll() {
    if (_scrollTimer != null) return;

    _scrollTimer = Timer.periodic(
      Duration(milliseconds: (50 / scrollSpeed).round()),
      (timer) {
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          final currentScroll = _scrollController.position.pixels;

          // Stop if reached the end
          if (currentScroll >= maxScroll - 10) {
            _stopAutoScroll();
            return;
          }

          // Scroll down by a small amount
          _scrollController.animateTo(
            currentScroll + (2.0 * scrollSpeed),
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      },
    );

    setState(() {
      isAutoScrolling = true;
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
    setState(() {
      isAutoScrolling = false;
    });
  }

  void _toggleAutoScroll() {
    if (isAutoScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Auto-Scroll Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_filled,
                            color: isAutoScrolling
                                ? const Color(0xFFD4AF37)
                                : Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Auto-Scroll',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isAutoScrolling,
                        activeColor: const Color(0xFFD4AF37),
                        onChanged: (value) {
                          setStateBottomSheet(() {
                            if (value) {
                              _startAutoScroll();
                            } else {
                              _stopAutoScroll();
                            }
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Scroll Speed Control (affects auto-scroll)
                  const Text(
                    'Scroll Speed',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.speed),
                        onPressed: () {
                          setStateBottomSheet(() {
                            if (scrollSpeed > 0.5) {
                              scrollSpeed -= 0.25;
                              // Restart auto-scroll with new speed if running
                              if (isAutoScrolling) {
                                _stopAutoScroll();
                                _startAutoScroll();
                              }
                            }
                          });
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: scrollSpeed,
                          min: 0.5,
                          max: 2.0,
                          divisions: 6,
                          activeColor: const Color(0xFFD4AF37),
                          label: '${scrollSpeed.toStringAsFixed(1)}x',
                          onChanged: (value) {
                            setStateBottomSheet(() {
                              scrollSpeed = value;
                              // Restart auto-scroll with new speed if running
                              if (isAutoScrolling) {
                                _stopAutoScroll();
                                _startAutoScroll();
                              }
                            });
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.speed),
                        onPressed: () {
                          setStateBottomSheet(() {
                            if (scrollSpeed < 2.0) {
                              scrollSpeed += 0.25;
                              // Restart auto-scroll with new speed if running
                              if (isAutoScrolling) {
                                _stopAutoScroll();
                                _startAutoScroll();
                              }
                            }
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${scrollSpeed.toStringAsFixed(1)}x',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateBottomSheet(() {
                            scrollSpeed = 1.0;
                            if (isAutoScrolling) {
                              _stopAutoScroll();
                              _startAutoScroll();
                            }
                          });
                          setState(() {});
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Font Size Control
                  const Text(
                    'Font Size',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setStateBottomSheet(() {
                            if (fontSize > 12) {
                              fontSize -= 1;
                            }
                          });
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: fontSize,
                          min: 12,
                          max: 36,
                          divisions: 24,
                          activeColor: const Color(0xFFD4AF37),
                          label: fontSize.round().toString(),
                          onChanged: (value) {
                            setStateBottomSheet(() {
                              fontSize = value;
                            });
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setStateBottomSheet(() {
                            if (fontSize < 36) {
                              fontSize += 1;
                            }
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${fontSize.round()}px',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateBottomSheet(() {
                            fontSize = 20;
                          });
                          setState(() {});
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Auto-scroll indicator
                  if (isAutoScrolling)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFD4AF37),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Auto-scroll is active. Tap the play/pause button to control.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baniInfo = baniData?['baniInfo'] as Map<String, dynamic>?;
    final verses = baniData?['verses'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _readString(baniInfo, 'unicode') ?? widget.baniToken,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Play/Pause button for auto-scroll
          IconButton(
            tooltip: isAutoScrolling ? 'Pause' : 'Play',
            icon: Icon(
              isAutoScrolling ? Icons.pause : Icons.play_arrow,
              color: isAutoScrolling
                  ? const Color(0xFFD4AF37)
                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
            ),
            onPressed: _toggleAutoScroll,
          ),
          // Translation toggle
          IconButton(
            tooltip: showTranslation ? 'Hide translation' : 'Show translation',
            icon: Icon(
              Icons.translate,
              color: showTranslation
                  ? const Color(0xFFD4AF37)
                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
            ),
            onPressed: () {
              setState(() {
                showTranslation = !showTranslation;
              });
            },
          ),
          // Transliteration toggle
          IconButton(
            tooltip: showTransliteration
                ? 'Hide transliteration'
                : 'Show transliteration',
            icon: Icon(
              Icons.abc,
              color: showTransliteration
                  ? const Color(0xFFD4AF37)
                  : (isDark ? Colors.grey[500] : Colors.grey[400]),
            ),
            onPressed: () {
              setState(() {
                showTransliteration = !showTransliteration;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSettingsBottomSheet,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.settings, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildBody(verses, isDark),
    );
  }

  Widget _buildBody(List<dynamic> verses, bool isDark) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.grey[500]),
            const SizedBox(height: 12),
            const Text('Could not load this bani.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchBaniDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (verses.isEmpty) {
      return const Center(child: Text('No verses available'));
    }

    return RefreshIndicator(
      onRefresh: fetchBaniDetails,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        itemCount: verses.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildVerseCard(verses[index], isDark);
        },
      ),
    );
  }

  Widget _buildVerseCard(dynamic verseData, bool isDark) {
    final verse = verseData['verse'] as Map<String, dynamic>?;
    final verseVerse = verse?['verse'] as Map<String, dynamic>?;

    // Gurmukhi text — always shown, this is the core content.
    // Path: verse.verse.verse.unicode
    final String gurmukhi = _readString(verseVerse, 'unicode') ?? '';

    // Transliteration (Roman script). Path: verse.transliteration.english
    final transliteration = verse?['transliteration'] as Map<String, dynamic>?;
    final String englishTranslit =
        _readString(transliteration, 'english') ?? '';

    // Translation. Path: verse.verse.translation.en.{bdb|ms|ssk}
    String translation = '';
    final translations = verse?['translation'] as Map<String, dynamic>?;

    if (translations != null) {
      final enTranslations = translations['en'] as Map<String, dynamic>?;
      if (enTranslations != null) {
        translation =
            _readString(enTranslations, 'bdb') ??
            _readString(enTranslations, 'ms') ??
            _readString(enTranslations, 'ssk') ??
            '';
      }
      if (translation.isEmpty) {
        final hiTranslations = translations['hi'] as Map<String, dynamic>?;
        if (hiTranslations != null) {
          translation =
              _readString(hiTranslations, 'bdb') ??
              _readString(hiTranslations, 'ss') ??
              '';
        }
      }
    }

    final bool showTranslit = showTransliteration && englishTranslit.isNotEmpty;
    final bool showTrans = showTranslation && translation.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gurmukhi text — always visible
          Text(
            gurmukhi,
            textAlign: TextAlign.center,
            style: AppTheme.gurmukhiText(
              fontSize: fontSize, // Your dynamic size
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          // Transliteration — shown once, controlled by its own toggle
          if (showTranslit) ...[
            const SizedBox(height: 8),
            Text(
              englishTranslit,
              textAlign: TextAlign.center,
              style: AppTheme.interText(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          // Translation — controlled by the translate toggle
          if (showTrans) ...[
            const SizedBox(height: 12),
            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
            const SizedBox(height: 8),
            Text(
              translation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize * 0.7,
                height: 1.5,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
