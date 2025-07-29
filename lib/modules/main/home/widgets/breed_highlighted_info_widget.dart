import 'package:flutter/material.dart';
import '../../../../models/cat_breed.dart';
import '../../../../views/wikipedia_view.dart';

class BreedHighlightedInfoWidget extends StatelessWidget {
  final CatBreed breed;
  final bool isDark;

  const BreedHighlightedInfoWidget({
    super.key,
    required this.breed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white24
                        : Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: isDark ? Colors.white : Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    breed.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.deepPurple,
                    ),
                  ),
                ),
                if (breed.wikipediaUrl != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.white24, Colors.white12]
                            : [Colors.deepPurple, Colors.deepPurple.shade700],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.language,
                        color: isDark ? Colors.white : Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WikiWebView(
                              title: '${breed.name} - Wikipedia',
                              url: breed.wikipediaUrl!,
                            ),
                          ),
                        );
                      },
                      tooltip: 'Leer más en Wikipedia',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _buildHighlightedInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.deepPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white24
              : Colors.deepPurple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: isDark ? Colors.amber : Colors.deepPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Información Destacada',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (breed.origin != null)
            _buildHighlightedRow('Origen', breed.origin!, isDark),
          if (breed.lifeSpan != null)
            _buildHighlightedRow(
                'Expectativa de vida', '${breed.lifeSpan} años', isDark),
          if (breed.intelligence != null)
            _buildHighlightedRow(
                'Inteligencia', '${breed.intelligence}/10', isDark),
        ],
      ),
    );
  }

  Widget _buildHighlightedRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.deepPurple,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
