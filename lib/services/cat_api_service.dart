import '../models/cat_breed.dart';
import '../models/cat_image.dart';
import 'http_service.dart';

class CatApiService {
  static final CatApiService _instance = CatApiService._internal();
  factory CatApiService() => _instance;
  CatApiService._internal();

  final HttpService _httpService = HttpService.instance;
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _apiKey =
      'live_JBT0Ah0Nt12iyl2IpjQVLDWjcLk0GQwf4zI9wBMfmfejKmcC31mOJp4yJz5TsOUP';

  void initialize() {
    _httpService.setBaseUrl(_baseUrl);
    _httpService.setAuthToken(_apiKey);
  }

  // Obtener todas las razas de gatos
  Future<List<CatBreed>> getBreeds() async {
    try {
      final response = await _httpService.get('/breeds');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CatBreed.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error al obtener las razas de gatos: $e');
    }
  }

  // Obtener imágenes de una raza específica
  Future<List<CatImage>> getBreedImages(String breedId,
      {int limit = 10}) async {
    try {
      final response = await _httpService.get(
        '/images/search',
        queryParameters: {
          'limit': limit,
          'breed_ids': breedId,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CatImage.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error al obtener las imágenes de la raza: $e');
    }
  }

  // Obtener una imagen aleatoria de una raza específica
  Future<CatImage?> getRandomBreedImage(String breedId) async {
    try {
      final response = await _httpService.get(
        '/images/search',
        queryParameters: {
          'limit': 1,
          'breed_ids': breedId,
        },
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        return CatImage.fromJson(response.data[0]);
      }

      return null;
    } catch (e) {
      throw Exception('Error al obtener la imagen aleatoria: $e');
    }
  }
}
