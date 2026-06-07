import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transelation_p/feature/translator/domain/entities/translation_entity.dart';

class TranslationResultWidget extends StatelessWidget {
  final TranslationEntity translation;

  const TranslationResultWidget({super.key, required this.translation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          
          Row(
            children: [
              const Text(
                '✦ EDITORIAL TRANSLATION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9E9E9E),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
             
              GestureDetector(
                onTap: () => _copyToClipboard(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          
          Text(
            translation.translatedText,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),

          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${translation.sourceText}  •  ${translation.formattedDate}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: translation.translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Translation copied!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
