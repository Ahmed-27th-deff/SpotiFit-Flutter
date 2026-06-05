import '../models/workout_models.dart';

class TrainingService {
  // =========================
  // PERFORMANCE
  // =========================
  static double getPerformance(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    double sum = 0;
    for (var s in sessions) {
      sum += s.sessionRating;
    }
    return sum / sessions.length;
  }

  // =========================
  // SESSION ADHERENCE
  // =========================
  static double getSessionAdherence(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    int completed = sessions.where((s) => s.completionStatus).length;
    return completed / sessions.length;
  }

  // =========================
  // EXERCISE ADHERENCE
  // =========================
  static double getExerciseAdherence(List<WorkoutSession> sessions) {
    int completed = 0;
    int total = 0;
    for (var s in sessions) {
      completed += s.completedExercises.length;
      total += s.completedExercises.length + s.missedExercises.length;
    }
    if (total == 0) return 0;
    return completed / total;
  }

  // =========================
  // FINAL ADHERENCE
  // =========================
  static double getAdherence(List<WorkoutSession> sessions) {
    double sessionAdh = getSessionAdherence(sessions);
    double exerciseAdh = getExerciseAdherence(sessions);
    return (0.6 * sessionAdh) + (0.4 * exerciseAdh);
  }

  // =========================
  // MISSED DATA
  // =========================
  static int getCompletedSessions(List<WorkoutSession> sessions) {
    return sessions.where((s) => s.completionStatus).length;
  }

  static int getMissedSessions(List<WorkoutSession> sessions) {
    return sessions.where((s) => !s.completionStatus).length;
  }

  static int getCompletedExercises(List<WorkoutSession> sessions) {
    int total = 0;
    for (var s in sessions) {
      total += s.completedExercises.length;
    }
    return total;
  }

  static int getMissedExercises(List<WorkoutSession> sessions) {
    int total = 0;
    for (var s in sessions) {
      total += s.missedExercises.length;
    }
    return total;
  }

  static List<String> getMissedExercisesList(List<WorkoutSession> sessions) {
    List<String> missed = [];
    for (var s in sessions) {
      missed.addAll(s.missedExercises);
    }
    return missed;
  }

  // =========================
  // WEEKLY PERFORMANCE
  // =========================
  static List<double> getWeeklyPerformance(List<WorkoutSession> sessions) {
    List<double> weekly = [];
    for (int i = 0; i < 4; i++) {
      var week = sessions.skip(i * 3).take(3).toList();
      if (week.isEmpty) {
        weekly.add(0.0);
        continue;
      }
      double avg = week.fold(0.0, (sum, s) => sum + s.sessionRating) / week.length;
      weekly.add(avg);
    }
    return weekly;
  }

  static List<WorkoutSession> getWeekSessions(
    List<WorkoutSession> sessions,
    int weekIndex,
  ) {
    if (sessions.isEmpty) return [];
    sessions.sort((a, b) => a.sessionDate.compareTo(b.sessionDate));
    final startDate = sessions.first.sessionDate;
    return sessions.where((s) {
      final diff = s.sessionDate.difference(startDate).inDays;
      final week = diff ~/ 7;
      return week == weekIndex;
    }).toList();
  }

  static double getWeekAdherence(List<WorkoutSession> weekSessions) {
    return getAdherence(weekSessions);
  }

  // =========================
  // DURATION PER DAY
  // =========================
  static List<double> getDayDurations(
    List<WorkoutSession> sessions,
    int dayId,
  ) {
    final filtered = sessions.where((s) => s.dayId == dayId).toList();
    return filtered.map((s) => s.duration).toList();
  }

  // =========================
  // RPE
  // =========================
  static double getAverageRPE(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    double sum = 0;
    for (var s in sessions) {
      sum += s.sessionRating;
    }
    return sum / sessions.length;
  }

  static String getRPEAnalysis(double rpe) {
    if (rpe >= 8) {
      return "High intensity. You are training very hard, which can improve performance but may lead to fatigue if not managed properly.";
    } else if (rpe >= 5) {
      return "Moderate intensity. This is optimal for consistent progress and balanced recovery.";
    } else {
      return "Low intensity. You may not be pushing hard enough to achieve significant progress.";
    }
  }

  static String getRPETips(double rpe) {
    if (rpe >= 8) {
      return "Consider adding more rest or reducing volume slightly to avoid overtraining.";
    } else if (rpe >= 5) {
      return "Keep maintaining this balance. You are in a good training zone.";
    } else {
      return "Try increasing weight or effort gradually to challenge your muscles more.";
    }
  }

  static double getPerformanceChangePercent(List<WorkoutSession> sessions) {
    final weekly = getWeeklyPerformance(sessions);
    if (weekly.length < 2) return 0;
    double first = weekly.first;
    double last = weekly.last;
    if (first == 0) return 0;
    return ((last - first) / first) * 100;
  }

  static String getPerformanceInsight(double change) {
    if (change > 0) {
      return "Your performance improved by ${change.toStringAsFixed(1)}% this month. Keep going!";
    } else if (change < 0) {
      return "Your performance decreased by ${change.abs().toStringAsFixed(1)}% this month. Try to stay consistent.";
    } else {
      return "No significant change in performance this month.";
    }
  }

  static Map<String, List<String>> getMissedByMuscleGroup(
    List<WorkoutSession> sessions,
    List<WorkoutDay> days,
  ) {
    Map<String, List<String>> result = {};
    for (var session in sessions) {
      var day = days.firstWhere(
        (d) => d.id == session.dayId,
        orElse: () => WorkoutDay(
          id: -1,
          dayOfWeek: 0,
          dayName: 'Unknown',
          isRestDay: true,
          exercises: [],
        ),
      );
      if (day.id == -1) continue;
      for (var missed in session.missedExercises) {
        var exercise = day.exercises.firstWhere(
          (e) => e.name == missed,
          orElse: () => Exercise(
            id: -1,
            name: missed,
            description: '',
            muscleGroup: 'Unknown',
            difficulty: '',
            sets: 0,
            reps: 0,
            restMinutes: 0, exerciseType: '',
          ),
        );
        String muscle = exercise.muscleGroup;
        if (!result.containsKey(muscle)) {
          result[muscle] = [];
        }
        result[muscle]!.add(missed);
      }
    }
    return result;
  }

  static String getPerformanceLevel(double score) {
    if (score >= 8) {
      return "Excellent performance. You are progressing very well.";
    } else if (score >= 5) {
      return "Good performance. You are on the right track.";
    } else {
      return "Low performance. Try to improve consistency and effort.";
    }
  }
}
