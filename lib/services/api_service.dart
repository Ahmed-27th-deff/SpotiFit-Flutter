import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://10.242.133.106:8000';

  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  Future<Map<String, dynamic>> logWorkoutSession(
    int userId,
    Map<String, dynamic> sessionData,
  ) async {
    final response = await _dio.post(
      '/progress/$userId/log',
      data: {
        ...sessionData,
        'type': 'workout', // Help API distinguish workout vs body data
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> logMealEntry(
    int userId,
    Map<String, dynamic> mealData,
  ) async {
    final response = await _dio.post('/diet/$userId/log-meal', data: mealData);
    return response.data;
  }

  Future<Map<String, dynamic>> logBodyMeasurement(
    int userId,
    Map<String, dynamic> bodyData,
  ) async {
    final response = await _dio.post(
      '/progress/$userId/log',
      data: {
        ...bodyData,
        'type': 'body', // Help API distinguish workout vs body data
      },
    );
    return response.data;
  }

  // =====================
  // USER ENDPOINTS
  // =====================

  /// Register a new user
  Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    final response = await _dio.post('/users/register', data: userData);
    return response.data;
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final response = await _dio.get('/users/$userId');
    return response.data;
  }

  /// Update user profile information
  Future<Map<String, dynamic>> updateUserProfile(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    final response = await _dio.put('/users/$userId', data: userData);
    return response.data;
  }

  /// Delete user account
  Future<void> deleteUser(int userId) async {
    await _dio.delete('/users/$userId');
  }

  /// Get user workout history
  Future<List<dynamic>> getUserWorkoutHistory(int userId) async {
    final response = await _dio.get('/progress/$userId/history?type=workout');
    return response.data;
  }

  /// Get user body progress history
  Future<List<dynamic>> getUserBodyHistory(int userId) async {
    final response = await _dio.get('/progress/$userId/history?type=body');
    return response.data;
  }
}
