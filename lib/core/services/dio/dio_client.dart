import 'dart:developer';

import 'package:assignment_travaly/core/shared_preferences/shared_preferences_keys.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== DIO CLIENT SETUP ====================

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;

  // Singleton pattern - always returns the same instance
  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.mytravaly.com/public/v1/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }

  // Direct access to Dio instance
  Dio get dio => _dio;
}

// ==================== AUTH INTERCEPTOR ====================

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
      final String? visitorToken = prefs.getString('visitorToken');

      if (visitorToken != null && visitorToken.isNotEmpty) {
        // Add visitor token to headers
        options.headers['visitorToken'] = visitorToken;
        log('✅ Visitor token added to request headers');
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

// ==================== LOGGING INTERCEPTOR ====================

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

// ==================== SHARED PREFERENCES HELPER ====================

class AuthStorage {
  // Save visitor token
  static Future<bool> saveVisitorToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(
        SharedPreferencesKeys.visitorTokenKey,
        token,
      );
    } catch (e) {
      log('Error saving visitor token: $e');
      return false;
    }
  }

  // Get visitor token
  static Future<String?> getVisitorToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(SharedPreferencesKeys.visitorTokenKey);
    } catch (e) {
      log('Error getting visitor token: $e');
      return null;
    }
  }

  // Check if visitor token exists
  static Future<bool> hasVisitorToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(SharedPreferencesKeys.visitorTokenKey);
    } catch (e) {
      log('Error checking visitor token: $e');
      return false;
    }
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
