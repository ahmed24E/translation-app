import 'package:flutter/material.dart';
import 'package:transelation_p/feature/translator/domain/entities/similar_word_entity.dart';

class SimilarWordsWidget extends StatelessWidget {
  final List<SimilarWordEntity> words;
  final ValueChanged<SimilarWordEntity>? onWordTap;

  const SimilarWordsWidget({super.key, required this.words, this.onWordTap});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hub_rounded, size: 16, color: Color(0xFF3D5AFE)),
              SizedBox(width: 6),
              Text(
                'Similar Words from History',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D5AFE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) => _buildWordChip(word)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordChip(SimilarWordEntity word) {
    return GestureDetector(
      onTap: () => onWordTap?.call(word),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.sourceWord,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),

            Text(
              word.translatedWord,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
