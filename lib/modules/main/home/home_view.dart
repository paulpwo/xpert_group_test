import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cat_provider.dart';
import '../../../models/cat_breed.dart';
import '../../../views/wikipedia_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  PageController? _pageController;
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Inicializar el provider y cargar las razas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProvider = context.read<CatProvider>();
      catProvider.initialize();
      catProvider.loadBreeds();
      _fadeController.forward();
      _slideController.forward();
    });
  }

  void _resetCarousel() {
    setState(() {
      _currentPage = 0;
    });
    _pageController?.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    const Color(0xFFf093fb),
                  ],
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                elevation: 1,
                backgroundColor:
                    isDark ? const Color(0xFF1a1a2e) : const Color(0xFF667eea),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      '🐱 Cats 🐱',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                const Color(0xFF1a1a2e).withOpacity(1),
                                const Color(0xFF16213e).withOpacity(1),
                              ]
                            : [
                                const Color(0xFF667eea).withOpacity(1),
                                const Color(0xFF764ba2).withOpacity(1),
                              ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Consumer<CatProvider>(
            builder: (context, catProvider, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown de razas mejorado
                          _buildBreedDropdown(catProvider, isDark),
                          const SizedBox(height: 24),

                          // Carrusel de imágenes
                          if (catProvider.selectedBreed != null)
                            _buildImageCarousel(catProvider, isDark),

                          const SizedBox(height: 24),

                          // Información destacada de la raza
                          if (catProvider.selectedBreed != null)
                            _buildBreedHighlightedInfo(
                                catProvider.selectedBreed!, isDark),

                          const SizedBox(height: 24),

                          // Descripción con Wikipedia
                          if (catProvider.selectedBreed != null)
                            _buildBreedDescription(
                                catProvider.selectedBreed!, isDark),

                          // Indicador de carga mejorado
                          if (catProvider.isLoading)
                            _buildLoadingIndicator(isDark),

                          // Mensaje de error mejorado
                          if (catProvider.error != null)
                            _buildErrorMessage(catProvider.error!, isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBreedDropdown(CatProvider catProvider, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2d3748).withOpacity(0.9),
                  const Color(0xFF4a5568).withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                    _resetCarousel();
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

  Widget _buildBreedHighlightedInfo(CatBreed breed, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2d3748).withOpacity(0.9),
                  const Color(0xFF4a5568).withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                        : Colors.deepPurple.withOpacity(0.1),
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
            _buildHighlightedInfo(breed, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedInfo(CatBreed breed, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.deepPurple.withOpacity(0.2),
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

  Widget _buildImageCarousel(CatProvider catProvider, bool isDark) {
    if (catProvider.breedImages.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF2d3748).withOpacity(0.9),
                    const Color(0xFF4a5568).withOpacity(0.9),
                  ]
                : [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                  color: isDark ? Colors.white54 : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay imágenes disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white70 : Colors.grey[600],
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
          colors: isDark
              ? [
                  const Color(0xFF2d3748).withOpacity(0.9),
                  const Color(0xFF4a5568).withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                        : Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: isDark ? Colors.white : Colors.deepPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Imágenes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.deepPurple,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white24
                        : Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${catProvider.breedImages.length} imágenes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.deepPurple,
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
                itemCount: catProvider.breedImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final image = catProvider.breedImages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
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
                                  color: isDark
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
                                        color: isDark
                                            ? Colors.white
                                            : Colors.deepPurple,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Cargando imagen...',
                                        style: TextStyle(
                                          color: isDark
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
                                  color: isDark
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
                                        color: isDark
                                            ? Colors.red[300]
                                            : Colors.red,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Error al cargar imagen',
                                        style: TextStyle(
                                          color: isDark
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
                                    Colors.black.withOpacity(0.8),
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
                                    'Imagen ${index + 1} de ${catProvider.breedImages.length}',
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
                  catProvider.breedImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: index == _currentPage
                          ? (isDark ? Colors.white : Colors.deepPurple)
                          : (isDark ? Colors.white38 : Colors.grey[300]),
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

  Widget _buildLoadingIndicator(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF2d3748).withOpacity(0.9),
                    const Color(0xFF4a5568).withOpacity(0.9),
                  ]
                : [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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

  Widget _buildErrorMessage(String error, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
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
                    ? Colors.red[300]!.withOpacity(0.2)
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

  Widget _buildBreedDescription(CatBreed breed, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2d3748).withOpacity(0.9),
                  const Color(0xFF4a5568).withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                        : Colors.deepPurple.withOpacity(0.1),
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
                      ? Colors.white.withOpacity(0.05)
                      : Colors.deepPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white24
                        : Colors.deepPurple.withOpacity(0.2),
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
                        color: Colors.black.withOpacity(0.2),
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
