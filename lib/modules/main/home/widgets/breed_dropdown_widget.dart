import 'package:flutter/material.dart';
import 'package:xpert_group_demo/models/cat_breed.dart';
import 'package:xpert_group_demo/providers/cat_provider.dart';

class BreedDropdownWidget extends StatelessWidget {
  final CatProvider catProvider;
  final bool isDark;
  final VoidCallback? onBreedSelected;

  const BreedDropdownWidget({
    super.key,
    required this.catProvider,
    required this.isDark,
    this.onBreedSelected,
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
                Icon(
                  Icons.pets,
                  color: isDark ? Colors.white : Colors.deepPurple,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Selecciona una raza',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? const Color(0xFF1a202c) : Colors.grey[50],
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: DropdownButtonFormField<CatBreed>(
                value: catProvider.selectedBreed,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  labelText: 'Raza de gato',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                dropdownColor: isDark ? const Color(0xFF1a202c) : Colors.white,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                items: catProvider.breeds.map((breed) {
                  return DropdownMenuItem<CatBreed>(
                    value: breed,
                    child: Text(breed.name),
                  );
                }).toList(),
                onChanged: (CatBreed? newValue) {
                  if (newValue != null) {
                    catProvider.selectBreed(newValue);
                    onBreedSelected?.call();
                  }
                },
                isExpanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
