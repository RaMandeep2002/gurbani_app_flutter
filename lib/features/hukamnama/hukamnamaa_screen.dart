import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class HukmnamaScreen extends StatefulWidget {
  const HukmnamaScreen({super.key});

  @override
  State<HukmnamaScreen> createState() => _HukmnamaScreenState();
}

class _HukmnamaScreenState extends State<HukmnamaScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> verses = [];
  Map<String, dynamic>? hukamnamaData;

  // Variables to store API data
  String raag = '';
  String ang = '';
  String author = '';
  String shabadId = '';
  String date = '';
  String nanakshahiDate = '';

  // Auto-scroll variables
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrolling = false;
  bool _isPaused = false;
  int _currentIndex = 0;
  double _scrollSpeed = 1.0; // Speed multiplier

  @override
  void initState() {
    super.initState();
    fetchHukamnama();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchHukamnama() async {
    try {
      final url = 'https://api.gurbaninow.com/v2/hukamnama/today';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hukamnama'] != null && data['hukamnama'].isNotEmpty) {
          debugPrint('Hukamnama Info: ${data['hukamnamainfo']}');

          setState(() {
            hukamnamaData = data;
            verses = data['hukamnama'] ?? [];

            final info = data['hukamnamainfo'] ?? {};

            // Extract Raag, Ang, and other metadata from API response
            raag =
                info['raag']?['unicode'] ??
                info['raag']?['english'] ??
                'Unknown';
            ang = info['pageno']?.toString() ?? 'Unknown';
            author =
                info['writer']?['unicode'] ??
                info['writer']?['english'] ??
                'Unknown';
            shabadId = (info['shabadid'] as List<dynamic>?)?.join(', ') ?? '';

            final dateinfoReglar = data['date']?["gregorian"];

            if (dateinfoReglar != null) {
              date =
                  '${dateinfoReglar['date']} ${dateinfoReglar['month']}, ${dateinfoReglar['year']}';
            }

            final dateInfo = data['date']?['nanakshahi']?['punjabi'];
            if (dateInfo != null) {
              nanakshahiDate =
                  '${dateInfo['date']} ${dateInfo['month']}, ${dateInfo['year']}';
            }

            isLoading = false;
          });

          // Start auto-scroll after data is loaded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startAutoScroll();
          });
        } else {
          setState(() {
            errorMessage = 'No Hukamnama found for today.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load Hukamnama: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Auto-scroll methods
  void _startAutoScroll() {
    if (verses.isEmpty) return;

    _isAutoScrolling = true;
    _isPaused = false;
    // _scrollToNextVerse();
  }

  void _stopAutoScroll() {
    _isAutoScrolling = false;
    _scrollController.removeListener(_scrollListener);
  }

  void _pauseAutoScroll() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeAutoScroll() {
    setState(() {
      _isPaused = false;
    });
    _scrollToNextVerse();
  }

  void _scrollToNextVerse() {
    if (!_isAutoScrolling || _isPaused || verses.isEmpty) return;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double currentScroll = _scrollController.position.pixels;
    final double maxScroll = _scrollController.position.maxScrollExtent;

    // Calculate next position
    double nextPosition = currentScroll + screenHeight * 0.6;

    // If reached the end, loop back to start
    if (nextPosition >= maxScroll - 100) {
      nextPosition = 0;
      _currentIndex = 0;
    }

    // Animate to next position
    _scrollController
        .animateTo(
          nextPosition,
          duration: Duration(milliseconds: (1500 / _scrollSpeed).toInt()),
          curve: Curves.easeInOut,
        )
        .then((_) {
          // Update current index based on scroll position
          _updateCurrentIndex();

          // Schedule next scroll
          if (_isAutoScrolling && !_isPaused) {
            Future.delayed(
              Duration(milliseconds: (3000 / _scrollSpeed).toInt()),
              () {
                if (mounted && !_isPaused) {
                  _scrollToNextVerse();
                }
              },
            );
          }
        });
  }

  void _updateCurrentIndex() {
    final double position = _scrollController.position.pixels;
    final double itemHeight = 200.0;
    final int newIndex = (position / itemHeight).floor();
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex.clamp(0, verses.length - 1);
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.isScrollingNotifier.value) {
      // User manually scrolled - pause auto-scroll temporarily
      if (_isAutoScrolling && !_isPaused) {
        _pauseAutoScroll();
        // Resume after 5 seconds of inactivity
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _isAutoScrolling) {
            _resumeAutoScroll();
          }
        });
      }
    }
  }

  // Gurbani Normalization
  String normalizeGurbani(String text) {
    if (text.isEmpty) return text;

    String normalized = text;

    // remove hidden chars
    normalized = normalized.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');

    // yakash normalization
    normalized = normalized.replaceAll('\u0A4D\u0A2F', '\u0A3F\u0A06');

    // tippi ordering
    normalized = normalized.replaceAll('\u0A70\u0A42', '\u0A42\u0A70');
    normalized = normalized.replaceAll('\u0A70\u0A3F', '\u0A3F\u0A70');
    normalized = normalized.replaceAll('\u0A02\u0A3F', '\u0A3F\u0A02');

    // addak ordering
    normalized = normalized.replaceAll('\u0A71\u0A41', '\u0A41\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A42', '\u0A42\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A3E', '\u0A3E\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A47', '\u0A47\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A48', '\u0A48\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A4B', '\u0A4B\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A4C', '\u0A4C\u0A71');
    normalized = normalized.replaceAll('\u0A71\u0A3F', '\u0A3F\u0A71');

    // pairin rara
    normalized = normalized.replaceAll(
      '\u0A71\u0A4D\u0A30\u0A41',
      '\u0A4D\u0A30\u0A41\u0A71',
    );
    normalized = normalized.replaceAll(
      '\u0A71\u0A4D\u0A30\u0A42',
      '\u0A4D\u0A30\u0A42\u0A71',
    );

    // remove duplicates
    normalized = normalized.replaceAllMapped(
      RegExp(r'(\u0A71)\1+'),
      (match) => match.group(1)!,
    );
    normalized = normalized.replaceAllMapped(
      RegExp(r'(\u0A70)\1+'),
      (match) => match.group(1)!,
    );
    normalized = normalized.replaceAllMapped(
      RegExp(r'(\u0A02)\1+'),
      (match) => match.group(1)!,
    );

    return normalized;
  }

  // Decorative Ornament Widget
  Widget _buildOrnament() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                theme.colorScheme.primary,
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '❀',
          style: TextStyle(fontSize: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                theme.colorScheme.primary,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Header Section
  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Ornament
          Text(
            '✦ ✦ ✦',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),

          // Main Title
          Text(
            'ੴ',
            style: TextStyle(
              fontSize: 32,
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily Hukamnama',
            style: TextStyle(
              fontSize: 26,
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
              // letterSpacing: 6,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 5),
              ],
            ),
          ),
          const SizedBox(height: 4),

          Text(
            normalizeGurbani('ਗੁਰੂ ਗ੍ਰੰਥ ਸਾਹਿਬ ਜੀ'),
            style: TextStyle(
              fontSize: 26,
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
              letterSpacing: 2,
              fontFamily: "ArialUnicodeMS",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Date Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.onPrimary.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NANAKSHAHI: $nanakshahiDate',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          _buildOrnament(),
        ],
      ),
    );
  }

  // Raag and Ang Section - Now using data from API
  Widget _buildRaagAng() {
    final theme = Theme.of(context);

    // Format Raag name - remove underscores and capitalize
    String displayRaag = raag;
    if (raag.contains('_')) {
      displayRaag = raag
          .split('_')
          .map(
            (word) =>
                word.substring(0, 1).toUpperCase() +
                word.substring(1).toLowerCase(),
          )
          .join(' ');
    }

    // Format Ang with proper prefix
    String displayAng = ang;
    if (ang != 'Unknown' && ang.isNotEmpty) {
      displayAng = ang.padLeft(3, '0');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Raag Section
          Column(
            children: [
              Text(
                'RAAG',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayRaag,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Show author if available
              if (author.isNotEmpty && author != 'Unknown')
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'By: $author',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          // Ang Section
          Column(
            children: [
              Text(
                'ANG',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayAng,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Optional: Show page number format
              if (ang != 'Unknown' && ang.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'Page ${ang.padLeft(3, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Verse Card with Traditional Style
  Widget _buildVerseCard(dynamic verse, int index) {
    final theme = Theme.of(context);
    final line = verse['line'] ?? {};
    final gurmukhi = normalizeGurbani(line['gurmukhi']?['unicode'] ?? '');
    final translation = line['translation']?['english']?['default'] ?? '';
    final lineNumber = line['linenum']?.toString() ?? '';
    final verseNumber = index + 1;

    // Try to get translation source
    // final translationSource = 'GurbaniNow';

    final bool isCurrent = _currentIndex == index;

    return Container(
      // duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isCurrent
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.surface,
                ],
              )
            : null,
        color: isCurrent ? null : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: isCurrent ? 20 : 15,
            offset: Offset(0, isCurrent ? 8 : 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Verse Number with Ornament
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '❀',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? theme.colorScheme.primary.withOpacity(0.2)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    lineNumber.isNotEmpty ? 'Line $lineNumber' : '$verseNumber',
                    style: TextStyle(
                      fontSize: 13,
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '❀',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Gurmukhi Text
            if (gurmukhi.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                    top: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  gurmukhi,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                    height: 1.8,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            if (gurmukhi.isNotEmpty && translation.isNotEmpty)
              const SizedBox(height: 16),

            // Translation
            if (translation.isNotEmpty)
              Column(
                children: [
                  Text(
                    '“$translation”',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

            // Bottom Ornament
            const SizedBox(height: 12),
            Text(
              '~ ~ ~',
              style: TextStyle(
                fontSize: 10,
                color: isCurrent
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.3),
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Control buttons for auto-scroll
  Widget _buildControls() {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speed control
            IconButton(
              icon: const Icon(Icons.speed, size: 20),
              color: theme.colorScheme.onSurface,
              onPressed: () {
                _showSpeedDialog();
              },
            ),
            const SizedBox(width: 4),
            // Pause/Resume
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 24),
              color: theme.colorScheme.onSurface,
              onPressed: () {
                setState(() {
                  if (_isPaused) {
                    _resumeAutoScroll();
                  } else {
                    _pauseAutoScroll();
                  }
                });
              },
            ),
            const SizedBox(width: 4),
            // Stop/Start
            IconButton(
              icon: Icon(
                _isAutoScrolling ? Icons.stop : Icons.play_circle,
                size: 24,
              ),
              color: _isAutoScrolling
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              onPressed: () {
                setState(() {
                  if (_isAutoScrolling) {
                    _stopAutoScroll();
                    _isAutoScrolling = false;
                  } else {
                    _startAutoScroll();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Scroll Speed',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Speed: ${_scrollSpeed.toStringAsFixed(1)}x',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _scrollSpeed,
              min: 0.5,
              max: 3.0,
              divisions: 25,
              label: '${_scrollSpeed.toStringAsFixed(1)}x',
              activeColor: theme.colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  _scrollSpeed = value;
                  // Restart auto-scroll with new speed
                  if (_isAutoScrolling && !_isPaused) {
                    _stopAutoScroll();
                    _startAutoScroll();
                  }
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Progress indicator
  Widget _buildProgress() {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 80,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Text(
          '${_currentIndex + 1}/${verses.length}',
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ੴ',
                  style: TextStyle(
                    fontSize: 40,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading Hukamnama...',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });
                      fetchHukamnama();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '॥',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'HUKAMNAMA',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '॥',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Toggle auto-scroll from app bar
          IconButton(
            icon: Icon(
              _isAutoScrolling ? Icons.auto_awesome : Icons.auto_awesome_mosaic,
              color: _isAutoScrolling
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            onPressed: () {
              setState(() {
                if (_isAutoScrolling) {
                  _stopAutoScroll();
                  _isAutoScrolling = false;
                } else {
                  _startAutoScroll();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = '';
              });
              fetchHukamnama();
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildRaagAng()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: _buildOrnament(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildVerseCard(verses[index], index);
                }, childCount: verses.length),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildOrnament(),
                      const SizedBox(height: 8),
                      Text(
                        '✧ Guru Granth Sahib Ji ✧',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '~ ~ ~',
                        style: TextStyle(
                          color: theme.colorScheme.outline.withOpacity(0.3),
                          fontSize: 10,
                          letterSpacing: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Progress indicator
          // if (verses.isNotEmpty) _buildProgress(),
          // // Control buttons
          // if (verses.isNotEmpty) _buildControls(),
        ],
      ),
    );
  }
}
