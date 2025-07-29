import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/cat_provider.dart';
import 'widgets/breed_dropdown_widget.dart';
import 'widgets/image_carousel_widget.dart';
import 'widgets/breed_highlighted_info_widget.dart';
import 'widgets/breed_description_widget.dart';
import 'widgets/loading_indicator_widget.dart';
import 'widgets/error_message_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    // This method is no longer needed as the carousel is now in a separate widget
  }

  @override
  void dispose() {
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
                                const Color(0xFF1a1a2e).withValues(alpha: 1),
                                const Color(0xFF16213e).withValues(alpha: 1),
                              ]
                            : [
                                const Color(0xFF667eea).withValues(alpha: 1),
                                const Color(0xFF764ba2).withValues(alpha: 1),
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
                          BreedDropdownWidget(
                            catProvider: catProvider,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),

                          // Carrusel de imágenes
                          if (catProvider.selectedBreed != null)
                            ImageCarouselWidget(
                              catProvider: catProvider,
                              isDark: isDark,
                            ),

                          const SizedBox(height: 24),

                          // Información destacada de la raza
                          if (catProvider.selectedBreed != null)
                            BreedHighlightedInfoWidget(
                              breed: catProvider.selectedBreed!,
                              isDark: isDark,
                            ),

                          const SizedBox(height: 24),

                          // Descripción con Wikipedia
                          if (catProvider.selectedBreed != null)
                            BreedDescriptionWidget(
                              breed: catProvider.selectedBreed!,
                              isDark: isDark,
                            ),

                          if (catProvider.isLoading)
                            LoadingIndicatorWidget(isDark: isDark),

                          // Mensaje de error mejorado
                          if (catProvider.error != null)
                            ErrorMessageWidget(
                              error: catProvider.error!,
                              isDark: isDark,
                            ),
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
}

