import '../models/body_models.dart';

class BodyService {

  // =========================
  // 🔥 WEEK FILTER
  // =========================
  static List<ProgressLog> getWeekLogs(
      List<ProgressLog> logs,
      int week,
      ) {
    return logs.where((l) {
      int w = (l.date.day - 1) ~/ 7;
      return w == week;
    }).toList();
  }

  // =========================
  // 🔥 WEEKLY AVERAGE
  // =========================
  static List<double> getWeeklyAvg(
      List<ProgressLog> logs,
      double Function(ProgressLog) selector,
      ) {

    List<double> result = [];

    for (int i = 0; i < 4; i++) {
      var chunk = getWeekLogs(logs, i);

      if (chunk.isEmpty) {
        result.add(0);
        continue;
      }

      double avg =
          chunk.fold(0.0, (sum, e) => sum + selector(e)) / chunk.length;

      result.add(avg);
    }

    return result;
  }

  // =========================
  // 🔥 CHANGE (START → END)
  // =========================
  static double getChange(
      List<ProgressLog> logs,
      double Function(ProgressLog) selector,
      ) {

    if (logs.isEmpty) return 0;

    return selector(logs.last) - selector(logs.first);
  }

  // =========================
  // 🔥 PERCENT CHANGE
  // =========================
  static double getChangePercent(
      List<ProgressLog> logs,
      double Function(ProgressLog) selector,
      ) {

    if (logs.isEmpty) return 0;

    double start = selector(logs.first);
    double end = selector(logs.last);

    if (start == 0) return 0;

    return ((end - start) / start) * 100;
  }

  // =========================
  // 🔥 SELECTORS (جاهزة)
  // =========================
  static double getWeight(ProgressLog l) =>
      l.inBody.composition.weight;

  static double getBodyFat(ProgressLog l) =>
      l.inBody.composition.bodyFat;

  static double getMuscle(ProgressLog l) =>
      l.inBody.composition.skeletalMuscle;

  static double getWater(ProgressLog l) =>
      l.inBody.composition.bodyWater;

  static double getFatMass(ProgressLog l) =>
      l.inBody.composition.fatMass;

  static double getBMI(ProgressLog l) =>
      l.inBody.analysis.bmi;

  static double getBMR(ProgressLog l) =>
      l.inBody.analysis.metabolicRate;
}