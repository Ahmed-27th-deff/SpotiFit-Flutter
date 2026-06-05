// =======================
// NUTRITION MODELS
// =======================

class DietPlan {
  final int dailyCaloriesTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;

  DietPlan({
    required this.dailyCaloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      dailyCaloriesTarget: json['dailyCaloriesTarget'] as int,
      proteinTarget: (json['proteinTarget'] as num).toDouble(),
      carbsTarget: (json['carbsTarget'] as num).toDouble(),
      fatTarget: (json['fatTarget'] as num).toDouble(),
    );
  }
}

class DailyMeal {
  final int dayOfWeek;
  final String mealTime;
  final int mealOrder;
  final List<FoodItem> items;

  DailyMeal({
    required this.dayOfWeek,
    required this.mealTime,
    required this.mealOrder,
    required this.items,
  });

  factory DailyMeal.fromJson(Map<String, dynamic> json) {
    return DailyMeal(
      dayOfWeek: json['dayOfWeek'] as int,
      mealTime: json['mealTime'] as String,
      mealOrder: json['mealOrder'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FoodItem {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double grams;
  bool isEaten;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.grams,
    required this.isEaten,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      grams: (json['grams'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      isEaten: json['isEaten'] as bool,
    );
  }

  FoodItem copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? grams,
    bool? isEaten,
  }) {
    return FoodItem(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      grams: grams ?? this.grams,
      isEaten: isEaten ?? this.isEaten,
    );
  }
}

/// Weekly nutrition data container from JSON
class WeeklyNutrition {
  final int weekIndex;
  final DietPlan dietPlan;
  final List<DailyMeal> weeklyMeals;

  WeeklyNutrition({
    required this.weekIndex,
    required this.dietPlan,
    required this.weeklyMeals,
  });

  factory WeeklyNutrition.fromJson(Map<String, dynamic> json) {
    return WeeklyNutrition(
      weekIndex: json['weekIndex'] as int,
      dietPlan: DietPlan.fromJson(json['dietPlan'] as Map<String, dynamic>),
      weeklyMeals: (json['weeklyMeals'] as List<dynamic>)
          .map((e) => DailyMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Flatten all weekly meals into a single list with global day numbers
  List<DailyMeal> get allMeals => weeklyMeals;
}
