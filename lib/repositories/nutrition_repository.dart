import 'package:kinedemo/services/api_service.dart';

class NutritionRepository {
  final ApiService _apiService;

  NutritionRepository(this._apiService);

  Future<void> logMealEntry(
    int userId, {
    required String mealName,
    required List<Map<String, dynamic>> foods,
    required double totalCalories,
    required double protein,
    required double carbs,
    required double fats,
  }) async {
    try {
      await _apiService.logMealEntry(userId, {
        'mealName': mealName,
        'foods': foods,
        'totalCalories': totalCalories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'date': DateTime.now().toIso8601String(),
      });
      print('✅ Meal logged to API');
    } catch (e) {
      print('❌ Failed to log meal: $e');
      rethrow;
    }
  }
}
