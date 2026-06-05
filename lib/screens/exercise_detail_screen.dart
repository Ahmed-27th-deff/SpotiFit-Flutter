import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/models/workout_models.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise? exercise;

  const ExerciseDetailScreen({super.key, this.exercise});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final Exercise ex = exercise ?? _defaultExercise();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
        ),
        title: Text(
          ex.name,
          style: const TextStyle(color: AppTheme.textWhite, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor(ex.category).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              ex.category.toUpperCase(),
              style: TextStyle(
                color: _getCategoryColor(ex.category),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.category,
                            'Type',
                            ex.exerciseType,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.fitness_center,
                            'Muscle',
                            ex.muscleGroup,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.trending_up,
                            'Level',
                            ex.difficulty,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppTheme.borderColor),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatBox(
                            '${ex.sets}',
                            'SETS',
                            AppTheme.cyanLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatBox(
                            '${ex.reps}',
                            'REPS',
                            AppTheme.cyanLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatBox(
                            '${ex.restMinutes}m',
                            'REST',
                            AppTheme.blueDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Description',
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ex.description,
                style: const TextStyle(color: AppTheme.textLight, height: 1.6),
              ),

              const SizedBox(height: 24),

              Text(
                'Equipment Needed',
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.build, color: AppTheme.cyanLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ex.equipment,
                        style: const TextStyle(color: AppTheme.textLight),
                      ),
                    ),
                  ],
                ),
              ),

              if (ex.homeAlternative != null || ex.gymAlternative != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Alternatives',
                  style: const TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (ex.homeAlternative != null)
                  _buildAlternativeCard(
                    'Home Alternative',
                    ex.homeAlternative!,
                    Icons.home,
                    AppTheme.cyanLight,
                  ),
                if (ex.homeAlternative != null && ex.gymAlternative != null)
                  const SizedBox(height: 8),
                if (ex.gymAlternative != null)
                  _buildAlternativeCard(
                    'Gym Alternative',
                    ex.gymAlternative!,
                    Icons.fitness_center,
                    AppTheme.blueDark,
                  ),
              ],

              const SizedBox(height: 24),

              Text(
                'Instructions',
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...ex.instructions.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.cyanLight.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: AppTheme.cyanLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('${ex.estimatedMinutes}m', 'Duration'),
                    _buildSummaryItem('${ex.caloriesBurned}', 'Calories'),
                    _buildSummaryItem('${ex.restMinutes}m', 'Rest'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/exercise-tracking', extra: ex),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cyanLight,
                    foregroundColor: AppTheme.darkBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '${languageProvider.t('startExercise')} - ${ex.name}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.cyanLight, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textLight.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textWhite,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: AppTheme.textLight, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard(
    String label,
    String name,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
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
          style: TextStyle(
            color: AppTheme.textLight.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
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

  Exercise _defaultExercise() {
    return Exercise(
      id: 0,
      name: 'Full Body Blast',
      description: 'This is a comprehensive full body workout.',
      muscleGroup: 'Full Body',
      difficulty: 'Intermediate',
      sets: 4,
      reps: 10,
      restMinutes: 2,
      category: 'both',
      exerciseType: 'Compound',
      equipment: 'Dumbbells',
      instructions: ['Perform each rep with control'],
      estimatedMinutes: 45,
      caloriesBurned: 320,
    );
  }
}
