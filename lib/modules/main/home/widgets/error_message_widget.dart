import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String error;
  final bool isDark;

  const ErrorMessageWidget({
    super.key,
    required this.error,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.red.withValues(alpha: 0.2),
                  Colors.red.withValues(alpha: 0.1),
                ]
              : [
                  Colors.red[50]!,
                  Colors.red[25]!,
                ],
        ),
        border: Border.all(
          color: isDark ? Colors.red[300]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.red[300]!.withValues(alpha: 0.2)
                    : Colors.red[100]!,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.error_outline,
                color: isDark ? Colors.red[300] : Colors.red[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                error,
                style: TextStyle(
                  color: isDark ? Colors.red[300] : Colors.red[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
