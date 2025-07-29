import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../providers/cat_provider.dart';
import '../../../models/cat_breed.dart';

class VotingView extends StatefulWidget {
  const VotingView({super.key});

  @override
  State<VotingView> createState() => _VotingViewState();
}

class _VotingViewState extends State<VotingView> with TickerProviderStateMixin {
  late CardSwiperController _cardSwiperController;
  List<CatBreed> _breedsToVote = [];
  // true = like, false = dislike, null = no vote
  Map<String, bool?> votesMap = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cardSwiperController = CardSwiperController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Inicializar el provider y cargar las razas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProvider = context.read<CatProvider>();
      catProvider.initialize();
      catProvider.loadBreeds();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _cardSwiperController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onVotationGestur(String breedId, bool isLike) {
    setState(() {
      votesMap[breedId] = isLike;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLike ? '¡Te gusta esta raza!' : 'No te gusta esta raza',
        ),
        backgroundColor: isLike ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
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
        child: Consumer<CatProvider>(
          builder: (context, catProvider, child) {
            // Cargar razas para votar si no están cargadas
            if (_breedsToVote.isEmpty && catProvider.breeds.isNotEmpty) {
              _breedsToVote = List.from(catProvider.breeds);
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header con título y progreso
                  _buildHeader(isDark, catProvider),

                  // Carrusel de votación
                  Expanded(
                    child: _breedsToVote.isEmpty
                        ? _buildLoadingState(isDark)
                        : _buildVotingCarousel(isDark, catProvider),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, CatProvider catProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white24
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.how_to_vote,
                  color: isDark ? Colors.white : Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Vota por tus razas favoritas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
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
              'Cargando razas para votar...',
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

  Widget _buildVotingCarousel(bool isDark, CatProvider catProvider) {
    return CardSwiper(
      controller: _cardSwiperController,
      cardsCount: _breedsToVote.length,
      onSwipe: (previousIndex, currentIndex, direction) {
        // Voto basado en la dirección del swipe
        if (previousIndex < _breedsToVote.length) {
          final breed = _breedsToVote[previousIndex];
          bool isLike = false;

          switch (direction) {
            case CardSwiperDirection.left:
              isLike = false; // No me gusta
              break;
            case CardSwiperDirection.right:
              isLike = true; // Me gusta
              break;
            default:
              return false; // Cancelar swipe para otras direcciones
          }

          _onVotationGestur(breed.id, isLike);
        }

        return true;
      },
      onEnd: () {
        // Mostrar mensaje cuando se acaben las razas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Has votado por todas las razas!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      },
      allowedSwipeDirection: AllowedSwipeDirection.only(
        left: true,
        right: true,
        up: false,
        down: false,
      ),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        final breed = _breedsToVote[index];
        final hasVoted = votesMap[breed.id] != null;

        return _buildVotingCard(breed, isDark, hasVoted, catProvider);
      },
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 0,
        bottom: 30,
      ),
      maxAngle: 30,
      threshold: 50,
      duration: const Duration(milliseconds: 300),
      scale: 0.9,
      numberOfCardsDisplayed: 2,
      isLoop: false,
      backCardOffset: const Offset(20, 35),
    );
  }

  Widget _buildVotingCard(
      CatBreed breed, bool isDark, bool hasVoted, CatProvider catProvider) {
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
      child: Stack(
        children: [
          // Imagen del gato
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FutureBuilder<String>(
                  future: catProvider.getBreedImage(breed.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: isDark ? Colors.white : Colors.deepPurple,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 60,
                                color:
                                    isDark ? Colors.white54 : Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sin imagen',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  size: 50,
                                  color: isDark ? Colors.red[300] : Colors.red,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Error al cargar imagen',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.red[300] : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xFF60589C).withValues(alpha: 0.2),
                    Color(0xFF60589C).withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Nombre de la raza al top
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                breed.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Botones de votación al bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // "No me gusta"
                    _buildVoteButton(
                      isDark: isDark,
                      isLike: false,
                      hasVoted: hasVoted,
                      currentVote: votesMap[breed.id],
                      onPressed: () => _onVotationGestur(breed.id, false),
                    ),

                    // "Me gusta"
                    _buildVoteButton(
                      isDark: isDark,
                      isLike: true,
                      hasVoted: hasVoted,
                      currentVote: votesMap[breed.id],
                      onPressed: () => _onVotationGestur(breed.id, true),
                    ),
                  ],
                ),

                // stado de voto
                if (hasVoted) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: votesMap[breed.id] == true
                          ? Colors.green.withValues(alpha: 0.9)
                          : Colors.red.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          votesMap[breed.id] == true
                              ? Icons.thumb_up
                              : Icons.thumb_down,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          votesMap[breed.id] == true
                              ? 'Te gusta'
                              : 'No te gusta',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton({
    required bool isDark,
    required bool isLike,
    required bool hasVoted,
    required bool? currentVote,
    required VoidCallback onPressed,
  }) {
    final isSelected = hasVoted && currentVote == isLike;
    final isDisabled = hasVoted && currentVote != isLike;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected
              ? (isLike
                  ? [Colors.green, Colors.green.shade700]
                  : [Colors.red, Colors.red.shade700])
              : isDisabled
                  ? [
                      Colors.grey.withValues(alpha: 0.3),
                      Colors.grey.withValues(alpha: 0.3)
                    ]
                  : (isLike
                      ? [
                          Colors.green.withValues(alpha: 0.8),
                          Colors.green.shade600.withValues(alpha: 0.8)
                        ]
                      : [
                          Colors.red.withValues(alpha: 0.8),
                          Colors.red.shade600.withValues(alpha: 0.8)
                        ]),
        ),
        borderRadius: BorderRadius.circular(50), // Completamente redondo
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
          borderRadius: BorderRadius.circular(50), // Completamente redondo
          onTap: isDisabled ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.all(
                20), // Padding uniforme para forma circular
            child: Icon(
              isLike ? Icons.thumb_up : Icons.thumb_down,
              color: Colors.white,
              size: 28, // Icono ligeramente más grande para mejor proporción
            ),
          ),
        ),
      ),
    );
  }
}
