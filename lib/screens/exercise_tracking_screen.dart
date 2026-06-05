import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/models/workout_models.dart';

class ExerciseTrackingScreen extends StatefulWidget {
  final Exercise? exercise;

  const ExerciseTrackingScreen({super.key, this.exercise});

  @override
  State<ExerciseTrackingScreen> createState() => _ExerciseTrackingScreenState();
}

class _ExerciseTrackingScreenState extends State<ExerciseTrackingScreen> {
  int seconds = 0;
  bool isRunning = false;
  int currentSet = 1;
  int completedReps = 0;
  late Exercise exercise;

  @override
  void initState() {
    super.initState();
    exercise = widget.exercise ?? _defaultExercise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close, color: AppTheme.textWhite),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${exercise.muscleGroup} • ${exercise.exerciseType}',
                        style: TextStyle(
                          color: AppTheme.textLight.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTag(
                            exercise.category.toUpperCase(),
                            exercise.category == 'gym'
                                ? AppTheme.blueDark
                                : AppTheme.cyanLight,
                          ),
                          const SizedBox(width: 8),
                          _buildTag(
                            '${exercise.sets} SETS',
                            AppTheme.cyanLight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.cyanLight.withOpacity(0.1),
                    border: Border.all(
                      color: AppTheme.cyanLight.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: AppTheme.cyanLight,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatContainer('Set', '$currentSet/${exercise.sets}'),
                    _buildStatContainer(
                      'Reps',
                      '$completedReps/${exercise.reps}',
                    ),
                    _buildStatContainer('Rest', '${exercise.restMinutes}s'),
                  ],
                ),
                const SizedBox(height: 48),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => completedReps++);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cyanLight,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Rep Done',
                          style: TextStyle(
                            color: AppTheme.darkBg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => currentSet++);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blueDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Next Set',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => isRunning = !isRunning);
                      if (isRunning) {
                        _startTimer();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(isRunning ? 'Pause Timer' : 'Start Timer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !isRunning) return false;
      setState(() => seconds++);
      return true;
    });
  }

  Widget _buildStatContainer(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.cyanLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Exercise _defaultExercise() {
    return Exercise(
      id: 0,
      name: 'Pushups',
      description: 'Bodyweight chest exercise',
      muscleGroup: 'Chest',
      difficulty: 'Beginner',
      sets: 4,
      reps: 12,
      restMinutes: 1,
      category: 'home',
      exerciseType: 'Compound',
      equipment: 'None',
      instructions: ['Lower chest to floor', 'Push back up'],
    );
  }
}
