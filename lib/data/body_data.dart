import '../models/body_models.dart';

final List<BodyProgressLog> bodyLogs = [
  // Week 1
  BodyProgressLog(
    date: DateTime(2024, 1, 1),
    totalScore: 70,
    rpe: 6,
    inBody: InBody(
      composition: BodyComposition(
        weight: 80,
        bodyFat: 20,
        skeletalMuscle: 35,
        bodyWater: 55,
        fatMass: 16,
      ),
      analysis: BodyAnalysis(
        bmi: 25,
        metabolicRate: 1800,
      ),
    ),
  ),
  // Week 2
  BodyProgressLog(
    date: DateTime(2024, 1, 8),
    totalScore: 75,
    rpe: 7,
    inBody: InBody(
      composition: BodyComposition(
        weight: 79,
        bodyFat: 19,
        skeletalMuscle: 36,
        bodyWater: 56,
        fatMass: 15,
      ),
      analysis: BodyAnalysis(
        bmi: 24.5,
        metabolicRate: 1820,
      ),
    ),
  ),
  // Week 3
  BodyProgressLog(
    date: DateTime(2024, 1, 15),
    totalScore: 80,
    rpe: 8,
    inBody: InBody(
      composition: BodyComposition(
        weight: 78.5,
        bodyFat: 18.5,
        skeletalMuscle: 36.5,
        bodyWater: 56.5,
        fatMass: 14.5,
      ),
      analysis: BodyAnalysis(
        bmi: 24,
        metabolicRate: 1850,
      ),
    ),
  ),
  // Week 4
  BodyProgressLog(
    date: DateTime(2024, 1, 22),
    totalScore: 85,
    rpe: 8.5,
    inBody: InBody(
      composition: BodyComposition(
        weight: 78,
        bodyFat: 18,
        skeletalMuscle: 37,
        bodyWater: 57,
        fatMass: 14,
      ),
      analysis: BodyAnalysis(
        bmi: 23.8,
        metabolicRate: 1880,
      ),
    ),
  ),
];
