import 'package:flutter/material.dart';
import '../../../../models/cat_breed.dart';
import '../../../../views/wikipedia_view.dart';

class BreedDescriptionWidget extends StatelessWidget {
  final CatBreed breed;
  final bool isDark;

  const BreedDescriptionWidget({
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
                    Icons.description,
                    color: isDark ? Colors.white : Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Descripción de la raza
            if (breed.description != null) ...[
              Text(
                breed.description!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Temperamento si está disponible
            if (breed.temperament != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.deepPurple.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white24
                        : Colors.deepPurple.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: isDark ? Colors.white : Colors.deepPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Temperamento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      breed.temperament!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Botón para Wikipedia mejorado
            if (breed.wikipediaUrl != null)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [Colors.white24, Colors.white12]
                          : [Colors.deepPurple, Colors.deepPurple.shade700],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language,
                              color: isDark ? Colors.white : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Leer más en Wikipedia',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
