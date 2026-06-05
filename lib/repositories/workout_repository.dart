import 'package:kinedemo/services/api_service.dart';

class WorkoutRepository {
  final ApiService _apiService;

  WorkoutRepository(this._apiService);

  Future<void> logWorkoutSession(
    int userId, {
    required String exerciseName,
    required int sets,
    required int reps,
    required double? weight,
    required int durationSeconds,
    required double rating,
  }) async {
    try {
      await _apiService.logWorkoutSession(userId, {
        'exerciseName': exerciseName,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'durationSeconds': durationSeconds,
        'rating': rating,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('✅ Workout logged to API');
    } catch (e) {
      print('❌ Failed to log workout: $e');
      rethrow;
    }
  }
}
