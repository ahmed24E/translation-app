import 'package:flutter/material.dart';
import 'package:transelation_p/core/constants/app_constants.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String sourceLang;
  final String targetLang;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;
  final VoidCallback onSwap;

  const LanguageSelectorWidget({
    super.key,
    required this.sourceLang,
    required this.targetLang,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: Row(
        children: [
   
          Expanded(
            child: _buildDropdown(
              value: sourceLang,
              onChanged: onSourceChanged,
            ),
          ),

        
          GestureDetector(
            onTap: onSwap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

   
          Expanded(
            child: _buildDropdown(
              value: targetLang,
              onChanged: onTargetChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: AppConstants.supportedLanguages.entries
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e.value,
                  child: Text(e.key),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
