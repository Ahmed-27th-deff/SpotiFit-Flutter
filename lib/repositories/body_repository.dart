import 'package:kinedemo/services/api_service.dart';

class BodyRepository {
  final ApiService _apiService;

  BodyRepository(this._apiService);

  Future<void> logBodyProgress(
    int userId, {
    required double weight,
    required double bodyFat,
    required double muscle,
    required double water,
  }) async {
    try {
      await _apiService.logBodyMeasurement(userId, {
        'weight': weight,
        'bodyFat': bodyFat,
        'muscle': muscle,
        'water': water,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('✅ Body progress logged to API');
    } catch (e) {
      print('❌ Failed to log body progress: $e');
      rethrow;
    }
  }
}
