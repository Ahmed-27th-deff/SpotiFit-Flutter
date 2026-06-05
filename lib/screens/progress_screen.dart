import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';

import 'package:kinedemo/data/workout_data.dart';
import 'package:kinedemo/data/body_data.dart';
import 'package:kinedemo/data/nutrition_data.dart';
import 'package:kinedemo/services/training_service.dart';
import 'package:kinedemo/services/body_service.dart';
import 'package:kinedemo/services/nutrition_service.dart';
import 'package:kinedemo/widgets/metric_chart.dart';
import 'package:kinedemo/widgets/progress_card.dart';
import 'package:kinedemo/widgets/achievement_badge.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedMetric = 'Weight';
  String selectedMonth = 'Jan';

  final List<String> metrics = [
    'Weight',
    'Body Fat',
    'Muscle',
    'Water',
    'BMI',
    'BMR',
  ];

  final List<String> months = ['Jan', 'Feb', 'Mar'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<double> getMetricData() {
    switch (selectedMetric) {
      case 'Body Fat':
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getBodyFat);
      case 'Muscle':
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getMuscle);
      case 'Water':
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getWater);
      case 'BMI':
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getBMI);
      case 'BMR':
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getBMR);
      default:
        return BodyService.getWeeklyAvg(bodyLogs, BodyService.getWeight);
    }
  }

  String getMetricUnit() {
    switch (selectedMetric) {
      case 'Body Fat':
        return '%';
      case 'Water':
        return '%';
      case 'BMI':
        return '';
      case 'BMR':
        return ' cal';
      default:
        return ' kg';
    }
  }

  String getMetricInsight() {
    final change = BodyService.getChange(
      bodyLogs,
      selectedMetric == 'Body Fat'
          ? BodyService.getBodyFat
          : selectedMetric == 'Muscle'
          ? BodyService.getMuscle
          : BodyService.getWeight,
    );

    switch (selectedMetric) {
      case 'Body Fat':
        return BodyService.getBodyFatInsight(change);
      case 'Muscle':
        return BodyService.getMuscleInsight(change);
      default:
        return BodyService.getWeightInsight(change);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

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
                children: [
                  Text(
                    languageProvider.t('progress'),
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppTheme.cyanLight,
                    indicatorWeight: 3,
                    labelColor: AppTheme.cyanLight,
                    unselectedLabelColor: AppTheme.textLight,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Body', icon: Icon(Icons.accessibility)),
                      Tab(text: 'Training', icon: Icon(Icons.fitness_center)),
                      Tab(text: 'Nutrition', icon: Icon(Icons.restaurant)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBodyTab(),
                _buildTrainingTab(),
                _buildNutritionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyTab() {
    final data = getMetricData();
    final change = BodyService.getChange(
      bodyLogs,
      selectedMetric == 'Body Fat'
          ? BodyService.getBodyFat
          : selectedMetric == 'Muscle'
          ? BodyService.getMuscle
          : BodyService.getWeight,
    );
    final percentChange = BodyService.getChangePercent(
      bodyLogs,
      selectedMetric == 'Body Fat'
          ? BodyService.getBodyFat
          : selectedMetric == 'Muscle'
          ? BodyService.getMuscle
          : BodyService.getWeight,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: DropdownButton<String>(
              value: selectedMetric,
              isExpanded: true,
              dropdownColor: AppTheme.cardBg,
              style: const TextStyle(color: AppTheme.textWhite),
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.cyanLight,
              ),
              items: metrics.map((m) {
                return DropdownMenuItem(value: m, child: Text(m));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMetric = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: MetricChart(
              data: data,
              title: '$selectedMetric Progress (Last 4 Weeks)',
              unit: getMetricUnit(),
              lineColor: AppTheme.cyanLight,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: change > 0
                    ? Colors.green.withOpacity(0.3)
                    : change < 0
                    ? Colors.orange.withOpacity(0.3)
                    : AppTheme.borderColor,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}${getMetricUnit()}',
                          style: TextStyle(
                            color: change > 0
                                ? Colors.green
                                : change < 0
                                ? Colors.orange
                                : AppTheme.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Percentage',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: percentChange > 0
                                ? Colors.green
                                : percentChange < 0
                                ? Colors.orange
                                : AppTheme.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  getMetricInsight(),
                  style: TextStyle(color: AppTheme.textLight, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildTrainingTab() {
    final sessions = monthlySessions[selectedMonth] ?? workoutSessions;
    final performance = TrainingService.getPerformance(sessions);
    final adherence = TrainingService.getAdherence(sessions);
    final rpe = TrainingService.getAverageRPE(sessions);
    final completedSessions = TrainingService.getCompletedSessions(sessions);
    final missedExercises = TrainingService.getMissedExercises(sessions);
    final weeklyPerformance = TrainingService.getWeeklyPerformance(sessions);
    final change = TrainingService.getPerformanceChangePercent(sessions);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: DropdownButton<String>(
              value: selectedMonth,
              isExpanded: true,
              dropdownColor: AppTheme.cardBg,
              style: const TextStyle(color: AppTheme.textWhite),
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.cyanLight,
              ),
              items: months.map((m) {
                return DropdownMenuItem(value: m, child: Text(m));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: MetricChart(
              data: weeklyPerformance,
              title: 'Weekly Performance Score - $selectedMonth',
              unit: '',
              lineColor: AppTheme.blueDark,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: change > 0
                  ? Colors.green.withOpacity(0.1)
                  : change < 0
                  ? Colors.red.withOpacity(0.1)
                  : AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: change > 0
                    ? Colors.green.withOpacity(0.3)
                    : change < 0
                    ? Colors.red.withOpacity(0.3)
                    : AppTheme.borderColor,
              ),
            ),
            child: Text(
              TrainingService.getPerformanceInsight(change),
              style: TextStyle(
                color: change > 0
                    ? Colors.green
                    : change < 0
                    ? Colors.red
                    : AppTheme.textLight,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ProgressCard(
            title: 'Performance Score',
            value: performance.toStringAsFixed(1),
            subtitle: TrainingService.getPerformanceLevel(
              performance,
            ).split('.').first,
            subtitleColor: performance >= 8
                ? Colors.green
                : performance >= 5
                ? Colors.orange
                : Colors.red,
            icon: Icons.trending_up,
            onTap: () => _showPerformanceDialog(context, performance),
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Adherence',
            value: '${(adherence * 100).toStringAsFixed(0)}%',
            subtitle: adherence >= 0.8
                ? 'Excellent'
                : adherence >= 0.5
                ? 'Good'
                : 'Needs Work',
            subtitleColor: adherence >= 0.8
                ? Colors.green
                : adherence >= 0.5
                ? Colors.orange
                : Colors.red,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Completed Sessions',
            value: '$completedSessions',
            subtitle: '/ ${sessions.length}',
            subtitleColor: AppTheme.cyanLight,
            icon: Icons.fitness_center,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Missed Exercises',
            value: '$missedExercises',
            subtitle: missedExercises == 0 ? 'Perfect!' : 'Keep improving',
            subtitleColor: missedExercises == 0 ? Colors.green : Colors.orange,
            icon: Icons.error_outline,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Average RPE',
            value: rpe.toStringAsFixed(1),
            subtitle: rpe >= 8
                ? 'High'
                : rpe >= 5
                ? 'Moderate'
                : 'Low',
            subtitleColor: rpe >= 8
                ? Colors.orange
                : rpe >= 5
                ? Colors.green
                : Colors.blue,
            icon: Icons.speed,
            onTap: () => _showRPEDialog(context, rpe),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTab() {
    final meals = monthlyMeals ?? fallbackMeals;
    final plan = dietPlan ?? fallbackDietPlan;
    final weeklyCalories = NutritionService.getWeeklyCalories(meals);
    final dailyCalories = NutritionService.getDailyCalories(meals);
    final dailyProtein = NutritionService.getDailyProtein(meals);
    final adherence = NutritionService.getDayAdherence(meals);
    final missedFoods = NutritionService.getMissedFoods(meals);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: MetricChart(
              data: weeklyCalories.isEmpty ? [0, 0, 0, 0] : weeklyCalories,
              title: 'Weekly Calorie Intake',
              unit: ' cal',
              lineColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  dailyCalories >= plan.dailyCaloriesTarget * 0.9 &&
                      dailyCalories <= plan.dailyCaloriesTarget * 1.1
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    dailyCalories >= plan.dailyCaloriesTarget * 0.9 &&
                        dailyCalories <= plan.dailyCaloriesTarget * 1.1
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
              ),
            ),
            child: Text(
              NutritionService.getNutritionInsight(
                dailyCalories,
                plan.dailyCaloriesTarget.toDouble(),
                dailyProtein,
                plan.proteinTarget,
              ),
              style: TextStyle(
                color:
                    dailyCalories >= plan.dailyCaloriesTarget * 0.9 &&
                        dailyCalories <= plan.dailyCaloriesTarget * 1.1
                    ? Colors.green
                    : Colors.orange,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ProgressCard(
            title: 'Daily Calories',
            value: dailyCalories.toStringAsFixed(0),
            subtitle: '/ ${plan.dailyCaloriesTarget} target',
            subtitleColor: dailyCalories >= plan.dailyCaloriesTarget * 0.9
                ? Colors.green
                : Colors.orange,
            icon: Icons.local_fire_department,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Daily Protein',
            value: '${dailyProtein.toStringAsFixed(0)}g',
            subtitle: '/ ${plan.proteinTarget.toStringAsFixed(0)}g target',
            subtitleColor: dailyProtein >= plan.proteinTarget * 0.9
                ? Colors.green
                : Colors.orange,
            icon: Icons.egg_alt,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Meal Adherence',
            value: '${(adherence * 100).toStringAsFixed(0)}%',
            subtitle: adherence >= 0.8
                ? 'On track'
                : adherence >= 0.5
                ? 'Getting there'
                : 'Needs focus',
            subtitleColor: adherence >= 0.8
                ? Colors.green
                : adherence >= 0.5
                ? Colors.orange
                : Colors.red,
            icon: Icons.restaurant_menu,
          ),
          const SizedBox(height: 12),
          ProgressCard(
            title: 'Missed Foods',
            value: '${missedFoods.length}',
            subtitle: missedFoods.isEmpty
                ? 'All meals completed!'
                : 'Log meals',
            subtitleColor: missedFoods.isEmpty ? Colors.green : Colors.orange,
            icon: Icons.no_meals,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Achievements',
          style: TextStyle(
            color: AppTheme.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        AchievementBadge(
          icon: '🔥',
          title: 'Week Warrior',
          description: 'Completed 7 workouts',
          isUnlocked: true,
        ),
        SizedBox(height: 12),
        AchievementBadge(
          icon: '💪',
          title: 'Strong Start',
          description: 'Completed 10 workouts',
          isUnlocked: true,
        ),
        SizedBox(height: 12),
        AchievementBadge(
          icon: '⭐',
          title: 'Consistency King',
          description: '30 day streak',
          progress: 0.7,
          isUnlocked: false,
        ),
        SizedBox(height: 12),
        AchievementBadge(
          icon: '🥗',
          title: 'Nutrition Master',
          description: 'Perfect meal adherence for 1 week',
          progress: 0.4,
          isUnlocked: false,
        ),
      ],
    );
  }

  void _showPerformanceDialog(BuildContext context, double performance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        title: const Text(
          'Performance Analysis',
          style: TextStyle(color: AppTheme.textWhite),
        ),
        content: Text(
          'Your performance score is ${performance.toStringAsFixed(1)}.\n\n'
          'This value represents the average of your session scores during $selectedMonth.\n\n'
          '${TrainingService.getPerformanceLevel(performance)}',
          style: const TextStyle(color: AppTheme.textLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.cyanLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showRPEDialog(BuildContext context, double rpe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderColor),
        ),
        title: const Text(
          'RPE Analysis',
          style: TextStyle(color: AppTheme.textWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your average RPE is ${rpe.toStringAsFixed(1)}.\n',
              style: const TextStyle(color: AppTheme.textLight),
            ),
            const Text(
              'Scale:\n'
              '1-4 → Light\n'
              '5-7 → Moderate\n'
              '8-10 → High\n',
              style: TextStyle(color: AppTheme.textLight, fontSize: 12),
            ),
            Text(
              TrainingService.getRPEAnalysis(rpe),
              style: const TextStyle(color: AppTheme.cyanLight),
            ),
            const SizedBox(height: 12),
            Text(
              'Advice:\n${TrainingService.getRPETips(rpe)}',
              style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.cyanLight),
            ),
          ),
        ],
      ),
    );
  }
}
