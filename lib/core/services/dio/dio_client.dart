import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared_preferences/shared_preferences_keys.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';

  // Singleton
  factory DioClient() {
    return _instance;
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      SharedPreferencesKeys.authTokenKey,
      '71523fdd8d26f585315b4233e39d9263',
    );
  }

  Dio get dio => _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Adding interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<Response> get(
    String action, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    data?.addAll({'action': action});
    return await _dio.get(
      baseUrl,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String action, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    data?.addAll({'action': action});
    return await _dio.post(
      baseUrl,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String action, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    data?.addAll({'action': action});
    return await _dio.put(
      baseUrl,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String action, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    data?.addAll({'action': action});
    return await _dio.delete(
      baseUrl,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Check if visitor token exists
      final String? visitorToken = prefs.getString(
        SharedPreferencesKeys.visitorTokenKey,
      );
      final String? authToken = prefs.getString(
        SharedPreferencesKeys.authTokenKey,
      );

      if (authToken != null && authToken.isNotEmpty) {
        // Add auth token to headers
        options.headers['authtoken'] = authToken;
        log('✅ Auth token added to request headers');
      } else {
        log('⚠️ No auth token found in SharedPreferences');
      }

      if (visitorToken != null && visitorToken.isNotEmpty) {
        // Add visitor token to headers
        options.headers['visitortoken'] = visitorToken;
        log('✅ Visitor token added to request headers $visitorToken');
      } else {
        log('⚠️ No visitor token found in SharedPreferences');
      }
    } catch (e) {
      log('❌ Error reading visitor token from SharedPreferences: $e');
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle response if needed
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors if needed
    log('❌ API Error: ${err.message}');

    if (err.response?.statusCode == 401) {
      log('🔒 Unauthorized - Token might be invalid');
      // Handle token refresh or logout here
    }

    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('┌─────────────────────────────────────────────────');
    log('│ 🌐 REQUEST');
    log('├─────────────────────────────────────────────────');
    log('│ Method: ${options.method}');
    log('│ URL: ${options.baseUrl}${options.path}');
    if (options.queryParameters.isNotEmpty) {
      log('│ Query Parameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      log('│ Body: ${options.data}');
    }
    log('└─────────────────────────────────────────────────');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('┌─────────────────────────────────────────────────');
    log('│ ✅ RESPONSE');
    log('│ Status Code: ${response.statusCode}');
    log('│ URL: ${response.requestOptions.uri}');
    log('│ Data: ${response.data}');
    log('└─────────────────────────────────────────────────');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('┌─────────────────────────────────────────────────');
    log('│ ❌ ERROR');
    log('│ URL: ${err.requestOptions.uri}');
    log('│ Status Code: ${err.response?.statusCode}');
    log('│ Error Message: ${err.message}');
    if (err.response?.data != null) {
      log('│ Error Data: ${err.response?.data}');
    }
    log('└─────────────────────────────────────────────────');

    handler.next(err);
  }
}

// ==================== HOW TO USE ====================

/*
// 1. Add to pubspec.yaml:
dependencies:
  dio: ^5.4.0
  shared_preferences: ^2.2.2

// 2. Save visitor token (do this once after login or app start):
await AuthStorage.saveVisitorToken('your-visitor-token-here');

// 3. Make API calls directly anywhere in your app:

// GET request
final response = await DioClient().dio.get('/hotels');

// GET with query parameters
final response = await DioClient().dio.get(
  '/hotels/search',
  queryParameters: {'query': 'New York', 'page': 1},
);

// POST request
final response = await DioClient().dio.post(
  '/bookings',
  data: {'hotelId': '123', 'guests': 2},
);

// PUT request
final response = await DioClient().dio.put(
  '/bookings/456',
  data: {'status': 'confirmed'},
);

// DELETE request
final response = await DioClient().dio.delete('/bookings/456');

// 4. The visitorToken will be automatically added to ALL requests!
// No need to manually add it to headers - the interceptor handles it.

// 5. Access response data:
print(response.data);
print(response.statusCode);

// 6. Helper methods for token management:
bool hasToken = await AuthStorage.hasVisitorToken();
String? token = await AuthStorage.getVisitorToken();
await AuthStorage.removeVisitorToken(); // For logout
*/
