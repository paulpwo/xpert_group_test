import 'package:flutter/material.dart';
import '../../../../providers/cat_provider.dart';

class ImageCarouselWidget extends StatefulWidget {
  final CatProvider catProvider;
  final bool isDark;

  const ImageCarouselWidget({
    super.key,
    required this.catProvider,
    required this.isDark,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  PageController? _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  // void _resetCarousel() {
  //   setState(() {
  //     _currentPage = 0;
  //   });
  //   _pageController?.animateToPage(
  //     0,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.catProvider.breedImages.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: widget.isDark
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
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: widget.isDark ? Colors.white54 : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay imágenes disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.isDark ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: widget.isDark
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
                    color: widget.isDark
                        ? Colors.white24
                        : Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: widget.isDark ? Colors.white : Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Imágenes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.white24
                        : Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.catProvider.breedImages.length} imágenes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.isDark ? Colors.white70 : Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.catProvider.breedImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final image = widget.catProvider.breedImages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.network(
                            image.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  color: widget.isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.deepPurple,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Cargando imagen...',
                                        style: TextStyle(
                                          color: widget.isDark
                                              ? Colors.white70
                                              : Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: widget.isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error,
                                        size: 50,
                                        color: widget.isDark
                                            ? Colors.red[300]
                                            : Colors.red,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Error al cargar imagen',
                                        style: TextStyle(
                                          color: widget.isDark
                                              ? Colors.red[300]
                                              : Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Overlay con información de la imagen
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Imagen ${index + 1} de ${widget.catProvider.breedImages.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Indicadores de página mejorados
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.catProvider.breedImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: index == _currentPage
                          ? (widget.isDark ? Colors.white : Colors.deepPurple)
                          : (widget.isDark ? Colors.white38 : Colors.grey[300]),
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
