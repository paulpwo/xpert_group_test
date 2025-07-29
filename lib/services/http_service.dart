import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class HttpService {
  static HttpService? _instance;
  static HttpService get instance {
    _instance ??= HttpService._internal();
    return _instance!;
  }

  late Dio _dio;
  final int _maxRetries = 3;
  final Duration _retryDelay = const Duration(seconds: 2);

  HttpService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio();

    // Configuración base
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Configuración del caché
    final cacheOptions = CacheOptions(
      // Política de caché por defecto
      policy: CachePolicy.request,
      // Tiempo de expiración de 5 minutos
      maxStale: const Duration(minutes: 10),
      // Prioridad del caché
      priority: CachePriority.normal,
      // Headers que invalidan el caché
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Almacenamiento en memoria
      store: MemCacheStore(),
    );

    // Interceptor para logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Interceptor para caché
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Interceptor para retry automático
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      maxRetries: _maxRetries,
      retryDelay: _retryDelay,
    ));
  }

  /// Método GET con retry automático
  /// [path] - La ruta de la API
  /// [queryParameters] - Parámetros de la consulta
  /// [options] - Opciones de la petición
  /// [cancelToken] - Token de cancelación
  /// [onReceiveProgress] - Callback para recibir el progreso de la respuesta
  /// [cachePolicy] - Política de caché
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    CachePolicy? cachePolicy,
  }) async {
    // Configurar opciones de caché si se proporcionan
    final requestOptions = options ?? Options();
    if (cachePolicy != null) {
      requestOptions.extra = {
        ...requestOptions.extra ?? {},
        'cache_policy': cachePolicy,
      };
    }

    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Método POST con retry automático
  /// [path] - La ruta de la API
  /// [data] - Datos a enviar
  /// [queryParameters] - Parámetros de la consulta
  /// [options] - Opciones de la petición
  /// [cancelToken] - Token de cancelación
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Método PUT con retry automático
  /// [path] - La ruta de la API
  /// [data] - Datos a enviar
  /// [queryParameters] - Parámetros de la consulta
  /// [options] - Opciones de la petición
  /// [cancelToken] - Token de cancelación
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Método DELETE con retry automático
  /// [path] - La ruta de la API
  /// [data] - Datos a enviar
  /// [queryParameters] - Parámetros de la consulta
  /// [options] - Opciones de la petición
  /// [cancelToken] - Token de cancelación
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Método para configurar el token de autorización
  /// [token] - El token de autorización
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Método para limpiar el token de autorización
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Método para configurar la URL base
  /// [baseUrl] - La URL base
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Método para limpiar el caché
  Future<void> clearCache() async {
    await MemCacheStore().clean();
  }

  /// Getter para acceder a la instancia de Dio directamente si es necesario
  Dio get dio => _dio;
}

// Interceptor personalizado para manejar retry
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    required this.maxRetries,
    required this.retryDelay,
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    int retryCount = 0;

    // Obtener el número de intentos desde los headers de la request
    final requestOptions = err.requestOptions;
    final retryCountHeader = requestOptions.headers['retry-count'];
    retryCount = retryCountHeader != null ? int.parse(retryCountHeader) : 0;

    // Verificar si debemos hacer retry
    if (_shouldRetry(err) && retryCount < maxRetries) {
      retryCount++;

      // Actualizar el contador de intentos en los headers
      requestOptions.headers['retry-count'] = retryCount.toString();

      // Esperar antes del siguiente intento
      await Future.delayed(retryDelay * retryCount);

      try {
        // Reintentar la request
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Si falla, continuar con el siguiente intento o fallar definitivamente
        if (retryCount >= maxRetries) {
          handler.reject(err);
          return;
        }
      }
    }

    handler.reject(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry en caso de errores de red o timeout
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            (err.response?.statusCode == 500 ||
                err.response?.statusCode == 502 ||
                err.response?.statusCode == 503 ||
                err.response?.statusCode == 504));
  }
}
