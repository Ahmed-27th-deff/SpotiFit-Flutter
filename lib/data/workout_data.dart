import '../models/workout_models.dart';
import '../services/exercise_service.dart';

// Re-export exercise data from service for backward compatibility
List<Exercise> get allExercises => ExerciseService.allExercises;
List<String> get exerciseCategories => ExerciseService.categories;

// =======================
// WORKOUT PLAN
// =======================

final workoutPlan = WorkoutPlan(
  id: 1,
  planName: "Hypertrophy Plan",
  weeklyFrequency: 3,
  difficultyLevel: "Intermediate",
  days: [
    WorkoutDay(
      id: 1,
      dayOfWeek: 1,
      dayName: "Day 1 - Chest",
      isRestDay: false,
      exercises: [
        Exercise(
          id: 1,
          name: "Bench Press",
          description: "Chest press",
          muscleGroup: "Chest",
          difficulty: "Intermediate",
          sets: 4,
          reps: 10,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Compound",
        ),
        Exercise(
          id: 2,
          name: "Incline Dumbbell Press",
          description: "Upper chest",
          muscleGroup: "Chest",
          difficulty: "Intermediate",
          sets: 3,
          reps: 12,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Incline",
        ),
      ],
    ),
    WorkoutDay(
      id: 2,
      dayOfWeek: 2,
      dayName: "Day 2 - Back",
      isRestDay: false,
      exercises: [
        Exercise(
          id: 3,
          name: "Lat Pulldown",
          description: "Back width",
          muscleGroup: "Back",
          difficulty: "Intermediate",
          sets: 4,
          reps: 10,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Vertical Pull",
        ),
        Exercise(
          id: 4,
          name: "Seated Row",
          description: "Back thickness",
          muscleGroup: "Back",
          difficulty: "Intermediate",
          sets: 3,
          reps: 12,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Horizontal Pull",
        ),
      ],
    ),
    WorkoutDay(
      id: 3,
      dayOfWeek: 3,
      dayName: "Day 3 - Legs",
      isRestDay: false,
      exercises: [
        Exercise(
          id: 5,
          name: "Squat",
          description: "Leg strength",
          muscleGroup: "Legs",
          difficulty: "Intermediate",
          sets: 4,
          reps: 10,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Compound",
        ),
        Exercise(
          id: 6,
          name: "Hamstring Curl",
          description: "Hamstrings",
          muscleGroup: "Legs",
          difficulty: "Intermediate",
          sets: 3,
          reps: 12,
          restMinutes: 2,
          category: "gym",
          exerciseType: "Isolation",
        ),
      ],
    ),
  ],
);

// =======================
// WORKOUT SESSIONS (4 WEEKS)
// =======================

final workoutSessions = [
  // WEEK 1
  WorkoutSession(
    id: 1,
    dayId: 1,
    sessionDate: DateTime(2024, 1, 1),
    startTime: DateTime(2024, 1, 1, 10, 0),
    endTime: DateTime(2024, 1, 1, 11, 0),
    completionStatus: false,
    sessionRating: 7,
    completedExercises: ["Bench Press"],
    missedExercises: ["Incline Dumbbell Press"],
  ),
  WorkoutSession(
    id: 2,
    dayId: 2,
    sessionDate: DateTime(2024, 1, 3),
    startTime: DateTime(2024, 1, 3, 10, 0),
    endTime: DateTime(2024, 1, 3, 11, 5),
    completionStatus: false,
    sessionRating: 6,
    completedExercises: ["Lat Pulldown"],
    missedExercises: ["Seated Row"],
  ),
  WorkoutSession(
    id: 3,
    dayId: 3,
    sessionDate: DateTime(2024, 1, 5),
    startTime: DateTime(2024, 1, 5, 10, 0),
    endTime: DateTime(2024, 1, 5, 11, 10),
    completionStatus: false,
    sessionRating: 5,
    completedExercises: ["Squat"],
    missedExercises: ["Hamstring Curl"],
  ),
  // WEEK 2
  WorkoutSession(
    id: 4,
    dayId: 1,
    sessionDate: DateTime(2024, 1, 8),
    startTime: DateTime(2024, 1, 8, 10, 0),
    endTime: DateTime(2024, 1, 8, 10, 55),
    completionStatus: true,
    sessionRating: 7.5,
    completedExercises: ["Bench Press", "Incline Dumbbell Press"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 5,
    dayId: 2,
    sessionDate: DateTime(2024, 1, 10),
    startTime: DateTime(2024, 1, 10, 10, 0),
    endTime: DateTime(2024, 1, 10, 11, 0),
    completionStatus: true,
    sessionRating: 7,
    completedExercises: ["Lat Pulldown", "Seated Row"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 6,
    dayId: 3,
    sessionDate: DateTime(2024, 1, 12),
    startTime: DateTime(2024, 1, 12, 10, 0),
    endTime: DateTime(2024, 1, 12, 11, 5),
    completionStatus: false,
    sessionRating: 6.5,
    completedExercises: ["Squat"],
    missedExercises: ["Hamstring Curl"],
  ),
  // WEEK 3
  WorkoutSession(
    id: 7,
    dayId: 1,
    sessionDate: DateTime(2024, 1, 15),
    startTime: DateTime(2024, 1, 15, 10, 0),
    endTime: DateTime(2024, 1, 15, 10, 50),
    completionStatus: true,
    sessionRating: 8,
    completedExercises: ["Bench Press", "Incline Dumbbell Press"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 8,
    dayId: 2,
    sessionDate: DateTime(2024, 1, 17),
    startTime: DateTime(2024, 1, 17, 10, 0),
    endTime: DateTime(2024, 1, 17, 10, 55),
    completionStatus: true,
    sessionRating: 7.5,
    completedExercises: ["Lat Pulldown", "Seated Row"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 9,
    dayId: 3,
    sessionDate: DateTime(2024, 1, 19),
    startTime: DateTime(2024, 1, 19, 10, 0),
    endTime: DateTime(2024, 1, 19, 11, 0),
    completionStatus: true,
    sessionRating: 7,
    completedExercises: ["Squat", "Hamstring Curl"],
    missedExercises: [],
  ),
  // WEEK 4
  WorkoutSession(
    id: 10,
    dayId: 1,
    sessionDate: DateTime(2024, 1, 22),
    startTime: DateTime(2024, 1, 22, 10, 0),
    endTime: DateTime(2024, 1, 22, 10, 45),
    completionStatus: true,
    sessionRating: 8.5,
    completedExercises: ["Bench Press", "Incline Dumbbell Press"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 11,
    dayId: 2,
    sessionDate: DateTime(2024, 1, 24),
    startTime: DateTime(2024, 1, 24, 10, 0),
    endTime: DateTime(2024, 1, 24, 10, 50),
    completionStatus: true,
    sessionRating: 8,
    completedExercises: ["Lat Pulldown", "Seated Row"],
    missedExercises: [],
  ),
  WorkoutSession(
    id: 12,
    dayId: 3,
    sessionDate: DateTime(2024, 1, 26),
    startTime: DateTime(2024, 1, 26, 10, 0),
    endTime: DateTime(2024, 1, 26, 10, 55),
    completionStatus: true,
    sessionRating: 7.5,
    completedExercises: ["Squat", "Hamstring Curl"],
    missedExercises: [],
  ),
];

Map<String, List<WorkoutSession>> monthlySessions = {
  "Jan": List<WorkoutSession>.from(workoutSessions),
  "Feb": List<WorkoutSession>.from(workoutSessions),
  "Mar": List<WorkoutSession>.from(workoutSessions),
};
