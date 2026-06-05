class DietPlan {
  final int id;
  final String planName;

  final double dailyCaloriesTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;

  DietPlan({
    required this.id,
    required this.planName,
    required this.dailyCaloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
  });
}

// -----------------------------

class FoodItem {
  final String name;
  final double grams;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final bool isEaten;

  FoodItem({
    required this.name,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.isEaten,
  });
}

// -----------------------------

class DailyMeal {
  final int id;
  final int dayOfWeek;
  final String mealTime;
  final int mealOrder;

  final List<FoodItem> items;

  DailyMeal({
    required this.id,
    required this.dayOfWeek,
    required this.mealTime,
    required this.mealOrder,
    required this.items,
  });
}