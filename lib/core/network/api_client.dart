import 'package:dio/dio.dart';
import '../storage/storage_service.dart';

/// Centralized Dio API Client with auth interceptors and logging
class ApiClient {
  late final Dio dio;

  ApiClient({String baseUrl = 'https://api.mausam.gov.in/v1'}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token =
              await StorageService.readSecure(StorageService.secureAuthToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Log or transform error
          return handler.next(error);
        },
      ),
    );
  }
}
