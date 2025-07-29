import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final bool isDark;

  const LoadingIndicatorWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF2d3748).withValues(alpha: 0.9),
                    const Color(0xFF4a5568).withValues(alpha: 0.9),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.7),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: isDark ? Colors.white : Colors.deepPurple,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando información...',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
