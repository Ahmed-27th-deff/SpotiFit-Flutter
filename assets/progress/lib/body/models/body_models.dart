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
}

// -----------------------------

class BodyAnalysis {
  final double bmi;
  final double metabolicRate;

  BodyAnalysis({
    required this.bmi,
    required this.metabolicRate,
  });
}

// -----------------------------

class InBody {
  final BodyComposition composition;
  final BodyAnalysis analysis;

  InBody({
    required this.composition,
    required this.analysis,
  });
}

// -----------------------------

class ProgressLog {
  final DateTime date;
  final double totalScore;
  final double rpe;

  final InBody inBody;

  ProgressLog({
    required this.date,
    required this.totalScore,
    required this.rpe,
    required this.inBody,
  });
}