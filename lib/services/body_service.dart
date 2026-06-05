import '../models/body_models.dart';

class BodyService {
  // =========================
  // WEEK FILTER
  // =========================
  static List<BodyProgressLog> getWeekLogs(
    List<BodyProgressLog> logs,
    int week,
  ) {
    return logs.where((l) {
      int w = (l.date.day - 1) ~/ 7;
      return w == week;
    }).toList();
  }

  // =========================
  // WEEKLY AVERAGE
  // =========================
  static List<double> getWeeklyAvg(
    List<BodyProgressLog> logs,
    double Function(BodyProgressLog) selector,
  ) {
    List<double> result = [];
    for (int i = 0; i < 4; i++) {
      var chunk = getWeekLogs(logs, i);
      if (chunk.isEmpty) {
        result.add(0);
        continue;
      }
      double avg = chunk.fold(0.0, (sum, e) => sum + selector(e)) / chunk.length;
      result.add(avg);
    }
    return result;
  }

  // =========================
  // CHANGE (START -> END)
  // =========================
  static double getChange(
    List<BodyProgressLog> logs,
    double Function(BodyProgressLog) selector,
  ) {
    if (logs.isEmpty) return 0;
    return selector(logs.last) - selector(logs.first);
  }

  // =========================
  // PERCENT CHANGE
  // =========================
  static double getChangePercent(
    List<BodyProgressLog> logs,
    double Function(BodyProgressLog) selector,
  ) {
    if (logs.isEmpty) return 0;
    double start = selector(logs.first);
    double end = selector(logs.last);
    if (start == 0) return 0;
    return ((end - start) / start) * 100;
  }

  // =========================
  // SELECTORS
  // =========================
  static double getWeight(BodyProgressLog l) => l.inBody.composition.weight;

  static double getBodyFat(BodyProgressLog l) => l.inBody.composition.bodyFat;

  static double getMuscle(BodyProgressLog l) => l.inBody.composition.skeletalMuscle;

  static double getWater(BodyProgressLog l) => l.inBody.composition.bodyWater;

  static double getFatMass(BodyProgressLog l) => l.inBody.composition.fatMass;

  static double getBMI(BodyProgressLog l) => l.inBody.analysis.bmi;

  static double getBMR(BodyProgressLog l) => l.inBody.analysis.metabolicRate;

  // =========================
  // INSIGHT HELPERS
  // =========================
  static String getWeightInsight(double change) {
    if (change < 0) {
      return "You are losing weight. Good if your goal is fat loss";
    } else if (change > 0) {
      return "You are gaining weight. Ensure it is muscle, not fat";
    } else {
      return "Your weight is stable.";
    }
  }

  static String getBodyFatInsight(double change) {
    if (change < 0) {
      return "Body fat decreasing. Excellent progress!";
    } else if (change > 0) {
      return "Body fat increasing. Consider adjusting your diet.";
    } else {
      return "Body fat is stable.";
    }
  }

  static String getMuscleInsight(double change) {
    if (change > 0) {
      return "Muscle mass increasing. Great gains!";
    } else if (change < 0) {
      return "Muscle decreasing. Check protein intake and training.";
    } else {
      return "Muscle mass is stable.";
    }
  }
}
