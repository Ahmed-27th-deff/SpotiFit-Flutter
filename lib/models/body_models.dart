// =======================
// BODY COMPOSITION MODELS
// =======================

class BodyComposition {
  final double weight;
  final double bodyFat;
  final double skeletalMuscle;
  final double bodyWater;
  final double fatMass;

  BodyComposition({
    required this.weight,
    required this.bodyFat,
    required this.skeletalMuscle,
    required this.bodyWater,
    required this.fatMass,
  });

  factory BodyComposition.fromJson(Map<String, dynamic> json) {
    return BodyComposition(
      weight: (json['weight'] as num).toDouble(),
      bodyFat: (json['bodyFat'] as num).toDouble(),
      skeletalMuscle: (json['skeletalMuscle'] as num).toDouble(),
      bodyWater: (json['bodyWater'] as num).toDouble(),
      fatMass: (json['fatMass'] as num).toDouble(),
    );
  }
}

class BodyAnalysis {
  final double bmi;
  final double metabolicRate;

  BodyAnalysis({
    required this.bmi,
    required this.metabolicRate,
  });

  factory BodyAnalysis.fromJson(Map<String, dynamic> json) {
    return BodyAnalysis(
      bmi: (json['bmi'] as num).toDouble(),
      metabolicRate: (json['metabolicRate'] as num).toDouble(),
    );
  }
}

class InBody {
  final BodyComposition composition;
  final BodyAnalysis analysis;

  InBody({
    required this.composition,
    required this.analysis,
  });

  factory InBody.fromJson(Map<String, dynamic> json) {
    // JSON has flat structure - composition fields directly in json['inBody']
    final inBodyData = json['inBody'] as Map<String, dynamic>;
    final analysisData = json['analysis'] as Map<String, dynamic>;

    return InBody(
      composition: BodyComposition.fromJson(inBodyData),
      analysis: BodyAnalysis.fromJson(analysisData),
    );
  }
}

class BodyProgressLog {
  final DateTime date;
  final double totalScore;
  final double rpe;
  final InBody inBody;

  BodyProgressLog({
    required this.date,
    required this.totalScore,
    required this.rpe,
    required this.inBody,
  });

  factory BodyProgressLog.fromJson(Map<String, dynamic> json) {
    return BodyProgressLog(
      date: DateTime.parse(json['date'] as String),
      totalScore: (json['totalScore'] as num).toDouble(),
      rpe: (json['rpe'] as num).toDouble(),
      inBody: InBody.fromJson(json),
    );
  }
}

/// Container for all body progress logs from JSON
class BodyProgressData {
  final List<BodyProgressLog> progressLogs;

  BodyProgressData({required this.progressLogs});

  factory BodyProgressData.fromJson(Map<String, dynamic> json) {
    final logs = (json['progressLogs'] as List<dynamic>)
        .map((e) => BodyProgressLog.fromJson(e as Map<String, dynamic>))
        .toList();
    return BodyProgressData(progressLogs: logs);
  }
}
