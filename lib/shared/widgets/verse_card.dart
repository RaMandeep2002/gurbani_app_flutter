// lib/widgets/verse_card.dart (updated)

import 'package:flutter/material.dart';
import 'package:gurbani/models/bani_model.dart';


class VerseCard extends StatelessWidget {
  final BaniVerse verse;
  final Color? backgroundColor;

  const VerseCard({
    super.key,
    required this.verse,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = backgroundColor ?? (isDark ? Colors.grey[800] : Colors.white);
    final textColor = isDark ? Colors.white : const Color(0xFF1A2B4A);
    final secondaryTextColor = isDark ? Colors.grey[300] : const Color(0xFF1A2B4A);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      elevation: isDark ? 2 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metadata row
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // Source
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2B4A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    verse.source?.sourceId == 'G'
                        ? 'SGGS'
                        : verse.source?.english ?? 'Source',
                    style: const TextStyle(
                      color: Color(0xFFE2BF80),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text('▶', style: TextStyle(fontSize: 10, color: Color(0xFF1A2B4A))),
                if (verse.pageNo != null)
                  Text(
                    'Ang ${verse.pageNo}',
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                if (verse.raag?.english != null) ...[
                  const Text('▶', style: TextStyle(fontSize: 10, color: Color(0xFF1A2B4A))),
                  Text(
                    verse.raag!.english!,
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
                // Line number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Line ${verse.lineNo ?? 'N/A'}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Writer
                if (verse.writer?.english != null) ...[
                  const SizedBox(width: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        size: 12,
                        color: const Color(0xFF1A2B4A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        verse.writer!.english!,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Gurmukhi
            if (verse.verse.unicode != null)
              Text(
                verse.verse.unicode!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.6,
                ),
              ),

            const SizedBox(height: 8),

            // Transliteration
            if (verse.transliteration?.english != null)
              Text(
                verse.transliteration!.english!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),

            const SizedBox(height: 8),

            // Translation
            if (verse.translation?.en?.bdb != null)
              Text(
                verse.translation!.en!.bdb!,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}