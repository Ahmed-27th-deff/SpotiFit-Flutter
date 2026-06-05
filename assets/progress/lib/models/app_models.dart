// =======================
// 🔹 DIET SECTION
// =======================

class DietPlan {
  final int id;
  final String planName;
  final int dailyCaloriesTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;
  final List<DailyMeal> meals;

  DietPlan({
    required this.id,
    required this.planName,
    required this.dailyCaloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.meals,
  });
}

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

class FoodItem {
  final int id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double grams;
  final bool isEaten;

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.grams,
    required this.isEaten,
  });
}

// =======================
// 🔹 WORKOUT SECTION
// =======================

class WorkoutPlan {
  final int id;
  final String planName;
  final int weeklyFrequency;
  final String difficultyLevel;
  final List<WorkoutDay> days;

  WorkoutPlan({
    required this.id,
    required this.planName,
    required this.weeklyFrequency,
    required this.difficultyLevel,
    required this.days,
  });
}

class WorkoutDay {
  final int id;
  final int dayOfWeek;
  final String dayName;
  final bool isRestDay;
  final List<Exercise> exercises;

  WorkoutDay({
    required this.id,
    required this.dayOfWeek,
    required this.dayName,
    required this.isRestDay,
    required this.exercises,
  });
}

class Exercise {
  final int id;
  final String name;
  final String description;
  final String muscleGroup;
  final String difficulty;
  final int sets;
  final int reps;
  final int restMinutes;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.restMinutes,
  });
}

class WorkoutSession {
  final int id;
  final int dayId;
  final DateTime sessionDate;
  final DateTime startTime;
  final DateTime endTime;
  final bool completionStatus;
  final double sessionRating;
  final List<String> completedExercises;
  final List<String> missedExercises;

  WorkoutSession({
    required this.id,
    required this.dayId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.completionStatus,
    required this.sessionRating,
    required this.completedExercises,
    required this.missedExercises,

  });

  double get duration =>
      endTime.difference(startTime).inMinutes.toDouble();
}

// =======================
// 🔹 PROGRESS LOGS
// =======================

class ProgressLog {
  final int id;
  final DateTime logDate;
  final double totalScore;
  final double rpe;
  final double energyLevel;
  final int completedExercises;
  final int incompleteExercises;

  // Body Composition
  final double weight;
  final double bodyFat;
  final double muscleMass;
  final double bodyWater;

  ProgressLog({
    required this.id,
    required this.logDate,
    required this.totalScore,
    required this.rpe,
    required this.energyLevel,
    required this.completedExercises,
    required this.incompleteExercises,
    required this.weight,
    required this.bodyFat,
    required this.muscleMass,
    required this.bodyWater,
  });
}