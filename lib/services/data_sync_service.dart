import 'package:dio/dio.dart';
import 'package:kinedemo/repositories/workout_repository.dart';
import 'package:kinedemo/repositories/nutrition_repository.dart';
import 'package:kinedemo/repositories/body_repository.dart';
import 'package:kinedemo/repositories/user_repository.dart';
import 'package:kinedemo/services/api_service.dart';

/// Service that provides easy access to all data repositories
/// Automatically initializes repositories with ApiService
class DataSyncService {
  late WorkoutRepository workoutRepository;
  late NutritionRepository nutritionRepository;
  late BodyRepository bodyRepository;
  late UserRepository userRepository;

  DataSyncService({ApiService? apiService}) {
    final api = apiService ?? ApiService(dio: Dio());
    workoutRepository = WorkoutRepository(api);
    nutritionRepository = NutritionRepository(api);
    bodyRepository = BodyRepository(api);
    userRepository = UserRepository(api);
  }

  /// Example: Log a workout for a user
  /// Usage in screens:
  /// final service = DataSyncService();
  /// await service.logWorkout(userId, exerciseName: 'Bench Press', ...);
  Future<void> logWorkout({
    required int userId,
    required String exerciseName,
    required int sets,
    required int reps,
    double? weight,
    required int durationSeconds,
    required double rating,
  }) async {
    await workoutRepository.logWorkoutSession(
      userId,
      exerciseName: exerciseName,
      sets: sets,
      reps: reps,
      weight: weight,
      durationSeconds: durationSeconds,
      rating: rating,
    );
  }

  /// Log a meal for a user
  Future<void> logMeal({
    required int userId,
    required String mealName,
    required List<Map<String, dynamic>> foods,
    required double totalCalories,
    required double protein,
    required double carbs,
    required double fats,
  }) async {
    await nutritionRepository.logMealEntry(
      userId,
      mealName: mealName,
      foods: foods,
      totalCalories: totalCalories,
      protein: protein,
      carbs: carbs,
      fats: fats,
    );
  }

  /// Log body measurements for a user
  Future<void> logBodyProgress({
    required int userId,
    required double weight,
    required double bodyFat,
    required double muscle,
    required double water,
  }) async {
    await bodyRepository.logBodyProgress(
      userId,
      weight: weight,
      bodyFat: bodyFat,
      muscle: muscle,
      water: water,
    );
  }

  // =====================
  // USER ACCOUNT METHODS
  // =====================

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
    return await userRepository.registerUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      age: age,
      height: height,
      weight: weight,
      gender: gender,
      fitnessLevel: fitnessLevel,
    );
  }

  /// Get user profile by ID
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    return await userRepository.getUserProfile(userId);
  }

  /// Update user profile
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
    return await userRepository.updateUserProfile(
      userId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      age: age,
      height: height,
      weight: weight,
      gender: gender,
      fitnessLevel: fitnessLevel,
    );
  }

  /// Get user account summary (profile + history counts)
  Future<Map<String, dynamic>> getUserAccountSummary(int userId) async {
    return await userRepository.getUserAccountSummary(userId);
  }

  /// Get user workout history
  Future<List<dynamic>> getUserWorkoutHistory(int userId) async {
    return await userRepository.getWorkoutHistory(userId);
  }

  /// Get user body progress history
  Future<List<dynamic>> getUserBodyHistory(int userId) async {
    return await userRepository.getBodyHistory(userId);
  }
}
