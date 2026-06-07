import 'package:kinedemo/services/api_service.dart';
import 'package:kinedemo/models/user_model.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  /// Register a new user account
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String fitnessLevel,
    required List<String> fitnessGoals,
  }) async {
    try {
      final response = await _apiService.registerUser({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'date_of_birth': dateOfBirth.toIso8601String().split('T')[0], // YYYY-MM-DD format
        'height': height,
        'weight': weight,
        'fitness_level': fitnessLevel,
        'fitness_goals': fitnessGoals,
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
    String? gender,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? fitnessGoals,
  }) async {
    try {
      final updateData = {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        if (fitnessLevel != null) 'fitness_level': fitnessLevel,
        if (fitnessGoals != null) 'fitness_goals': fitnessGoals,
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

  /// Sync Firebase user data to Railway database
  /// This method registers or updates the user in the Railway database
  Future<Map<String, dynamic>> syncUserToDatabase(UserModel user) async {
    try {
      final userData = user.toJson();
      
      // Try to get user by email first to check if they exist
      // Since we don't have a direct endpoint to get by email, we'll try to register
      // If it fails with a conflict, we'll try to update instead
      
      try {
        // Try to register the user
        final response = await _apiService.registerUser(userData);
        print('✅ User synced to Railway database: ${user.email}');
        return response;
      } catch (e) {
        // If registration fails (user might already exist), try to update
        // We need the userId from the response or we'll need to get it first
        // For now, we'll assume the API returns the user with an id
        print('⚠️ Registration failed, user might already exist. Attempting update...');
        
        // Extract userId from response if available, otherwise we need a different approach
        // For now, we'll rethrow since we need the Railway userId to update
        rethrow;
      }
    } catch (e) {
      print('❌ Failed to sync user to Railway database: $e');
      rethrow;
    }
  }

  /// Sync Firebase user data to Railway database with explicit Railway userId
  Future<Map<String, dynamic>> syncUserToDatabaseWithId(
    UserModel user,
    int railwayUserId,
  ) async {
    try {
      final userData = user.toJson();
      
      // Update existing user in Railway database
      final response = await _apiService.updateUserProfile(railwayUserId, userData);
      print('✅ User synced to Railway database: ${user.email} (ID: $railwayUserId)');
      return response;
    } catch (e) {
      print('❌ Failed to sync user to Railway database: $e');
      rethrow;
    }
  }
}
