import 'package:flutter/material.dart';
import '../models/cat_breed.dart';
import '../models/cat_image.dart';
import '../services/cat_api_service.dart';

class CatProvider extends ChangeNotifier {
  final CatApiService _catApiService = CatApiService();

  List<CatBreed> _breeds = [];
  List<CatImage> _breedImages = [];
  CatBreed? _selectedBreed;
  bool _isLoading = false;
  String? _error;

  List<CatBreed> get breeds => _breeds;
  List<CatImage> get breedImages => _breedImages;
  CatBreed? get selectedBreed => _selectedBreed;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void initialize() {
    _catApiService.initialize();
  }

  // Cargar todas las razas
  Future<void> loadBreeds() async {
    _setLoading(true);
    _clearError();

    try {
      _breeds = await _catApiService.getBreeds();
      // take only 3 breeds
      // _breeds = _breeds.take(3).toList(); //NOTE used for testing
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar las razas: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Seleccionar una raza y cargar sus imágenes
  Future<void> selectBreed(CatBreed breed) async {
    _selectedBreed = breed;
    _setLoading(true);
    _clearError();

    try {
      _breedImages = await _catApiService.getBreedImages(breed.id);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar las imágenes: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Obtener una imagen específica para una raza
  Future<String> getBreedImage(String breedId) async {
    try {
      final images = await _catApiService.getBreedImages(breedId, limit: 1);
      if (images.isNotEmpty) {
        return images.first.url;
      }
      throw Exception('No se encontraron imágenes para esta raza');
    } catch (e) {
      throw Exception('Error al cargar la imagen: $e');
    }
  }

  // Limpiar selección
  void clearSelection() {
    _selectedBreed = null;
    _breedImages = [];
    notifyListeners();
  }

  // Métodos privados para manejar el estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
