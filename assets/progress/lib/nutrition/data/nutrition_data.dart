import '../models/nutrition_models.dart';

final dietPlan = DietPlan(
  id: 1,
  planName: "Lean Bulk Plan",
  dailyCaloriesTarget: 2800,
  proteinTarget: 180,
  carbsTarget: 320,
  fatTarget: 80,
);

// -----------------------------

final List<DailyMeal> monthlyMeals = [

  // WEEK 1 - DAY 1
  DailyMeal(
    id: 1,
    dayOfWeek: 1,
    mealTime: "Breakfast",
    mealOrder: 1,
    items: [
      FoodItem(name: "Eggs", grams: 150, calories: 220, protein: 18, carbs: 2, fats: 14, isEaten: true),
      FoodItem(name: "Bread", grams: 100, calories: 250, protein: 8, carbs: 45, fats: 2, isEaten: true),
    ],
  ),

  DailyMeal(
    id: 2,
    dayOfWeek: 1,
    mealTime: "Lunch",
    mealOrder: 2,
    items: [
      FoodItem(name: "Chicken", grams: 200, calories: 400, protein: 40, carbs: 0, fats: 10, isEaten: true),
      FoodItem(name: "Rice", grams: 200, calories: 300, protein: 5, carbs: 60, fats: 2, isEaten: false),
    ],
  ),

  // WEEK 1 - DAY 2
  DailyMeal(
    id: 3,
    dayOfWeek: 2,
    mealTime: "Breakfast",
    mealOrder: 1,
    items: [
      FoodItem(name: "Oats", grams: 100, calories: 350, protein: 12, carbs: 60, fats: 6, isEaten: true),
    ],
  ),

  // WEEK 2
  DailyMeal(
    id: 4,
    dayOfWeek: 8,
    mealTime: "Lunch",
    mealOrder: 2,
    items: [
      FoodItem(name: "Beef", grams: 200, calories: 500, protein: 45, carbs: 0, fats: 20, isEaten: true),
    ],
  ),

  // WEEK 3
  DailyMeal(
    id: 5,
    dayOfWeek: 15,
    mealTime: "Dinner",
    mealOrder: 3,
    items: [
      FoodItem(name: "Fish", grams: 180, calories: 300, protein: 35, carbs: 0, fats: 12, isEaten: true),
    ],
  ),

  // WEEK 4
  DailyMeal(
    id: 6,
    dayOfWeek: 22,
    mealTime: "Dinner",
    mealOrder: 3,
    items: [
      FoodItem(name: "Chicken", grams: 200, calories: 400, protein: 40, carbs: 0, fats: 10, isEaten: true),
    ],
  ),
];