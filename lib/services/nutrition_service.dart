import '../models/nutrition_models.dart';

class NutritionService {
  // =========================
  // MEAL CALCULATIONS
  // =========================
  static double getMealCalories(DailyMeal meal) {
    return meal.items
        .where((f) => f.isEaten)
        .fold(0.0, (sum, f) => sum + f.calories);
  }

  static double getMealProtein(DailyMeal meal) {
    return meal.items
        .where((f) => f.isEaten)
        .fold(0.0, (sum, f) => sum + f.protein);
  }

  static double getMealCarbs(DailyMeal meal) {
    return meal.items
        .where((f) => f.isEaten)
        .fold(0.0, (sum, f) => sum + f.carbs);
  }

  static double getMealFats(DailyMeal meal) {
    return meal.items
        .where((f) => f.isEaten)
        .fold(0.0, (sum, f) => sum + f.fats);
  }

  // =========================
  // DAILY TOTAL (FULL DAY)
  // =========================
  static List<DailyMeal> getDayMeals(List<DailyMeal> allMeals, int day) {
    return allMeals.where((m) => m.dayOfWeek == day).toList();
  }

  static double getDailyCalories(List<DailyMeal> meals) {
    return meals.fold(0.0, (sum, m) => sum + getMealCalories(m));
  }

  static double getDailyProtein(List<DailyMeal> meals) {
    return meals.fold(0.0, (sum, m) => sum + getMealProtein(m));
  }

  static double getDailyCarbs(List<DailyMeal> meals) {
    return meals.fold(0.0, (sum, m) => sum + getMealCarbs(m));
  }

  static double getDailyFats(List<DailyMeal> meals) {
    return meals.fold(0.0, (sum, m) => sum + getMealFats(m));
  }

  // =========================
  // ADHERENCE
  // =========================
  static double getMealAdherence(DailyMeal meal) {
    int eaten = meal.items.where((f) => f.isEaten).length;
    int total = meal.items.length;
    if (total == 0) return 0;
    return eaten / total;
  }

  static double getDayAdherence(List<DailyMeal> meals) {
    int eatenMeals = meals.where((m) => getMealAdherence(m) == 1).length;
    int totalMeals = meals.length;
    if (totalMeals == 0) return 0;
    return eatenMeals / totalMeals;
  }

  // =========================
  // WEEKLY CALCULATIONS
  // =========================
  static List<DailyMeal> getWeekMeals(List<DailyMeal> meals, int weekIndex) {
    return meals.where((m) {
      int week = (m.dayOfWeek - 1) ~/ 7;
      return week == weekIndex;
    }).toList();
  }

  static List<double> getWeeklyCalories(List<DailyMeal> meals) {
    List<double> result = [];
    for (int i = 0; i < 4; i++) {
      var weekMeals = getWeekMeals(meals, i);
      double total = weekMeals.fold(
        0.0,
        (sum, m) => sum + getMealCalories(m),
      );
      result.add(total);
    }
    return result;
  }

  // =========================
  // FEEDBACK
  // =========================
  static String getCaloriesFeedback(double actual, double target) {
    double diff = target - actual;
    if (diff.abs() < target * 0.1) {
      return "Calories are on track";
    }
    if (diff > 0) {
      return "Increase calories intake";
    } else {
      return "You are overeating";
    }
  }

  static String getMacroFeedback(double actual, double target, String type) {
    double diff = target - actual;
    if (diff.abs() < target * 0.1) {
      return "$type is on target";
    }
    if (diff > 0) {
      return "Increase $type intake";
    } else {
      return "Reduce $type intake";
    }
  }

  // =========================
  // MISSED FOODS
  // =========================
  static List<FoodItem> getMissedFoods(List<DailyMeal> meals) {
    return meals
        .expand((m) => m.items)
        .where((f) => !f.isEaten)
        .toList();
  }

  // =========================
  // INSIGHT (SMART)
  // =========================
  static String getNutritionInsight(
    double calories,
    double target,
    double protein,
    double proteinTarget,
  ) {
    if (calories < target && protein < proteinTarget) {
      return "You are under-eating and lacking protein. This will affect muscle growth.";
    }
    if (calories > target) {
      return "You are exceeding your calories. Watch out for fat gain.";
    }
    if (protein < proteinTarget) {
      return "Protein intake is low. Increase protein for better recovery.";
    }
    return "Great job! Your nutrition is well balanced.";
  }
}
