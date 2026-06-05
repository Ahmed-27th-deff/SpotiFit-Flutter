// =======================
// WORKOUT MODELS
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
  final String category;
  final String exerciseType;
  final String? homeAlternative;
  final String? gymAlternative;
  final String equipment;
  final List<String> instructions;
  final int estimatedMinutes;
  final int caloriesBurned;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.difficulty,
    required this.sets,
    required this.reps,
    required this.restMinutes,
    this.category = 'both',
    required this.exerciseType,
    this.homeAlternative,
    this.gymAlternative,
    this.equipment = 'None',
    this.instructions = const [],
    this.estimatedMinutes = 5,
    this.caloriesBurned = 30,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      muscleGroup: json['muscleGroup'],
      difficulty: json['difficulty'],
      sets: json['sets'],
      reps: json['reps'],
      restMinutes: json['restMinutes'],
      category: json['category'] ?? 'both',
      exerciseType: json['exerciseType'],
      homeAlternative: json['homeAlternative'],
      gymAlternative: json['gymAlternative'],
      equipment: json['equipment'] ?? 'None',
      instructions: List<String>.from(json['instructions'] ?? []),
      estimatedMinutes: json['estimatedMinutes'] ?? 5,
      caloriesBurned: json['caloriesBurned'] ?? 30,
    );
  }
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
