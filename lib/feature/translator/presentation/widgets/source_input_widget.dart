import 'package:flutter/material.dart';

class SourceInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTranslate;
  final VoidCallback onClear;
  final bool isLoading;

  const SourceInputWidget({
    super.key,
    required this.controller,
    required this.onTranslate,
    required this.onClear,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
         
          const Text(
            'SOURCE TEXT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

         
          TextField(
            controller: controller,
            maxLines: 3,
            minLines: 1,
            style: const TextStyle(fontSize: 18, color: Color(0xFF1A1A2E)),
            decoration: InputDecoration(
              hintText: 'Enter text to translate...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              border: InputBorder.none,
          
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            onSubmitted: (_) => onTranslate(),
          ),

          const SizedBox(height: 12),

        
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onTranslate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Translate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
