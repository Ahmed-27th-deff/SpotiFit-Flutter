import 'package:kinedemo/services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  /// Register a new user account
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String fitnessLevel,
  }) async {
    try {
      final response = await _apiService.registerUser({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'age': age,
        'height': height,
        'weight': weight,
        'gender': gender,
        'fitnessLevel': fitnessLevel,
        'createdAt': DateTime.now().toIso8601String(),
      });
      print('✅ User registered successfully: $email');
      return response;
    } catch (e) {
      print('❌ Failed to register user: $e');
      rethrow;
    }
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final profile = await _apiService.getUserProfile(userId);
      print('✅ User profile fetched for user $userId');
      return profile;
    } catch (e) {
      print('❌ Failed to fetch user profile: $e');
      rethrow;
    }
  }

  /// Update user profile information
  Future<Map<String, dynamic>> updateUserProfile(
    int userId, {
    String? firstName,
    String? lastName,
    String? phone,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? fitnessLevel,
  }) async {
    try {
      final updateData = {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phone != null) 'phone': phone,
        if (age != null) 'age': age,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        if (gender != null) 'gender': gender,
        if (fitnessLevel != null) 'fitnessLevel': fitnessLevel,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final response = await _apiService.updateUserProfile(userId, updateData);
      print('✅ User profile updated for user $userId');
      return response;
    } catch (e) {
      print('❌ Failed to update user profile: $e');
      rethrow;
    }
  }

  /// Delete user account (careful!)
  Future<void> deleteUserAccount(int userId) async {
    try {
      await _apiService.deleteUser(userId);
      print('✅ User account deleted for user $userId');
    } catch (e) {
      print('❌ Failed to delete user account: $e');
      rethrow;
    }
  }

  /// Get all workout history for a user
  Future<List<dynamic>> getWorkoutHistory(int userId) async {
    try {
      final history = await _apiService.getUserWorkoutHistory(userId);
      print(
        '✅ Workout history fetched for user $userId (${history.length} records)',
      );
      return history;
    } catch (e) {
      print('❌ Failed to fetch workout history: $e');
      rethrow;
    }
  }

  /// Get all body progress history for a user
  Future<List<dynamic>> getBodyHistory(int userId) async {
    try {
      final history = await _apiService.getUserBodyHistory(userId);
      print(
        '✅ Body history fetched for user $userId (${history.length} records)',
      );
      return history;
    } catch (e) {
      print('❌ Failed to fetch body history: $e');
      rethrow;
    }
  }

  /// Get user account summary
  Future<Map<String, dynamic>> getUserAccountSummary(int userId) async {
    try {
      final profile = await getUserProfile(userId);
      final workouts = await getWorkoutHistory(userId);
      final bodyRecords = await getBodyHistory(userId);

      final summary = {
        'profile': profile,
        'workoutCount': workouts.length,
        'bodyRecordCount': bodyRecords.length,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      print('✅ User summary generated for user $userId');
      return summary;
    } catch (e) {
      print('❌ Failed to generate user summary: $e');
      rethrow;
    }
  }
}
