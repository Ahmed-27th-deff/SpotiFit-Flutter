import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nutrition_models.dart';

/// Nutrition data loader that reads from JSON assets
class NutritionDataLoader {
  static List<WeeklyNutrition>? _cachedData;

  /// Load all nutrition data from JSON file
  static Future<List<WeeklyNutrition>> loadNutritionData() async {
    if (_cachedData != null) return _cachedData!;

    final String jsonString = await rootBundle.loadString(
      'assets/data/nutrition_data.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    _cachedData = jsonList
        .map((e) => WeeklyNutrition.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cachedData!;
  }

  /// Get the first (current) diet plan
  static Future<DietPlan> getDietPlan() async {
    final data = await loadNutritionData();
    return data.first.dietPlan;
  }

  /// Get all meals flattened across all weeks
  static Future<List<DailyMeal>> getAllMeals() async {
    final data = await loadNutritionData();
    return data.expand((week) => week.weeklyMeals).toList();
  }

  /// Clear cache (useful for testing or data refresh)
  static void clearCache() {
    _cachedData = null;
  }
}

/// Legacy synchronous accessors - loads once and caches
/// Note: These require async initialization before use
DietPlan? _syncDietPlan;
List<DailyMeal>? _syncMonthlyMeals;

/// Initialize synchronous data (call this before using dietPlan/monthlyMeals)
Future<void> initializeNutritionData() async {
  _syncDietPlan = await NutritionDataLoader.getDietPlan();
  _syncMonthlyMeals = await NutritionDataLoader.getAllMeals();
}

/// Synchronous access to diet plan (null if not initialized)
DietPlan? get dietPlan => _syncDietPlan;

/// Synchronous access to all meals (null if not initialized)
List<DailyMeal>? get monthlyMeals => _syncMonthlyMeals;

/// Fallback legacy data for backward compatibility
/// Use initializeNutritionData() to load real data from JSON
DietPlan get fallbackDietPlan => DietPlan(
  dailyCaloriesTarget: 2400,
  proteinTarget: 180,
  carbsTarget: 250,
  fatTarget: 75,
);

/// Fallback meals for when async data isn't loaded
final List<DailyMeal> fallbackMeals = [
  DailyMeal(
    dayOfWeek: 1,
    mealTime: '08:00',
    mealOrder: 1,
    items: [
      FoodItem(name: 'Oatmeal', grams: 60, calories: 220, protein: 8, carbs: 40, fats: 4, isEaten: true),
      FoodItem(name: 'Whey Protein', grams: 30, calories: 120, protein: 24, carbs: 2, fats: 1, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 1,
    mealTime: '13:00',
    mealOrder: 2,
    items: [
      FoodItem(name: 'Chicken Breast', grams: 200, calories: 330, protein: 62, carbs: 0, fats: 7, isEaten: true),
      FoodItem(name: 'Rice', grams: 150, calories: 195, protein: 4, carbs: 42, fats: 1, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 1,
    mealTime: '19:30',
    mealOrder: 3,
    items: [
      FoodItem(name: 'Salmon', grams: 150, calories: 310, protein: 30, carbs: 0, fats: 20, isEaten: true),
      FoodItem(name: 'Asparagus', grams: 100, calories: 20, protein: 2, carbs: 4, fats: 0, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 2,
    mealTime: '08:00',
    mealOrder: 1,
    items: [
      FoodItem(name: 'Oatmeal', grams: 60, calories: 220, protein: 8, carbs: 40, fats: 4, isEaten: true),
      FoodItem(name: 'Whey Protein', grams: 30, calories: 120, protein: 24, carbs: 2, fats: 1, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 2,
    mealTime: '13:00',
    mealOrder: 2,
    items: [
      FoodItem(name: 'Turkey Breast', grams: 200, calories: 280, protein: 58, carbs: 0, fats: 4, isEaten: false),
      FoodItem(name: 'Sweet Potato', grams: 200, calories: 180, protein: 4, carbs: 40, fats: 0, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 2,
    mealTime: '19:30',
    mealOrder: 3,
    items: [
      FoodItem(name: 'Lean Beef', grams: 200, calories: 380, protein: 52, carbs: 0, fats: 18, isEaten: true),
      FoodItem(name: 'Broccoli', grams: 150, calories: 50, protein: 4, carbs: 10, fats: 0, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 3,
    mealTime: '08:00',
    mealOrder: 1,
    items: [
      FoodItem(name: 'Greek Yogurt', grams: 200, calories: 240, protein: 20, carbs: 16, fats: 0, isEaten: true),
      FoodItem(name: 'Banana', grams: 120, calories: 105, protein: 1, carbs: 27, fats: 0, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 3,
    mealTime: '13:00',
    mealOrder: 2,
    items: [
      FoodItem(name: 'Tuna', grams: 150, calories: 195, protein: 42, carbs: 0, fats: 1, isEaten: true),
      FoodItem(name: 'Quinoa', grams: 150, calories: 255, protein: 9, carbs: 45, fats: 4, isEaten: true),
    ],
  ),
  DailyMeal(
    dayOfWeek: 3,
    mealTime: '19:30',
    mealOrder: 3,
    items: [
      FoodItem(name: 'Chicken Thigh', grams: 200, calories: 360, protein: 48, carbs: 0, fats: 18, isEaten: true),
      FoodItem(name: 'Green Beans', grams: 150, calories: 45, protein: 2, carbs: 10, fats: 0, isEaten: false),
    ],
  ),
];
