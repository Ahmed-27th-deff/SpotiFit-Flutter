import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/services/exercise_service.dart';
import 'package:kinedemo/models/workout_models.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  String selectedCategory = 'All';
  String selectedMuscleGroup = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await ExerciseService.loadExercises();
    setState(() => isLoading = false);
  }

  List<String> get muscleGroups => ['All', ...ExerciseService.categories];

  List<String> get categories => ['All', 'gym', 'home'];

  List<Exercise> get filteredExercises {
    return ExerciseService.filter(
      muscleGroup: selectedMuscleGroup,
      category: selectedCategory,
    );
  }

  Map<String, List<Exercise>> get groupedExercises {
    final grouped = <String, List<Exercise>>{};
    for (final exercise in filteredExercises) {
      grouped.putIfAbsent(exercise.muscleGroup, () => []).add(exercise);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (isLoading) {
      return Container(
        color: AppTheme.darkBg,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.cyanLight),
        ),
      );
    }

    return Container(
      color: AppTheme.darkBg,
      child: Column(
        children: [
          Container(
            color: AppTheme.cardBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.t('exercises'),
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: muscleGroups.length,
                      itemBuilder: (context, index) {
                        final group = muscleGroups[index];
                        final isSelected = selectedMuscleGroup == group;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedMuscleGroup = group),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.cyanLight
                                  : AppTheme.darkBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              group,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.darkBg
                                    : AppTheme.textWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedCategory = cat),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: cat == 'home' ? 0 : 8,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.cyanLight
                                  : AppTheme.darkBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cat == 'All' ? 'All' : cat.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.darkBg
                                    : AppTheme.textWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredExercises.isEmpty
                ? const Center(
                    child: Text(
                      'No exercises found',
                      style: TextStyle(color: AppTheme.textLight),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: groupedExercises.length,
                    itemBuilder: (context, groupIndex) {
                      final groupName = groupedExercises.keys.elementAt(
                        groupIndex,
                      );
                      final exercises = groupedExercises[groupName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 8),
                            child: Text(
                              groupName,
                              style: const TextStyle(
                                color: AppTheme.cyanLight,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...exercises.map(
                            (exercise) => _buildExerciseCard(context, exercise),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    return GestureDetector(
      onTap: () => context.go('/exercise-detail', extra: exercise),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getCategoryColor(exercise.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getMuscleGroupIcon(exercise.muscleGroup),
                color: _getCategoryColor(exercise.category),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.sets} sets • ${exercise.reps} reps • ${exercise.exerciseType}',
                    style: TextStyle(
                      color: AppTheme.textLight.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildCategoryChip(exercise.category),
                      if (exercise.homeAlternative != null) ...[
                        const SizedBox(width: 6),
                        _buildAltChip(
                          'H: ${exercise.homeAlternative!}',
                          AppTheme.cyanLight,
                        ),
                      ],
                      if (exercise.gymAlternative != null) ...[
                        const SizedBox(width: 6),
                        _buildAltChip(
                          'G: ${exercise.gymAlternative!}',
                          AppTheme.blueDark,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final color = _getCategoryColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAltChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 8),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'gym':
        return AppTheme.blueDark;
      case 'home':
        return AppTheme.cyanLight;
      case 'both':
        return Colors.orange;
      default:
        return AppTheme.cyanLight;
    }
  }

  IconData _getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return Icons.fitness_center;
      case 'Back':
        return Icons.arrow_upward;
      case 'Legs':
        return Icons.directions_walk;
      case 'Shoulders':
        return Icons.accessibility_new;
      case 'Arms':
        return Icons.sports_martial_arts;
      case 'Core':
        return Icons.circle;
      default:
        return Icons.fitness_center;
    }
  }
}
