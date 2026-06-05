import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/data/nutrition_data.dart';
import 'package:kinedemo/models/nutrition_models.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List<WeeklyNutrition>? _weeklyData;
  int _selectedWeekIndex = 0;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNutritionData() async {
    try {
      final data = await NutritionDataLoader.loadNutritionData();
      if (mounted) {
        setState(() {
          _weeklyData = data;
          _selectedWeekIndex = data.length - 1; // Default to last week
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleFoodItem(
    int weekIndex,
    int dayOfWeek,
    int mealOrder,
    int itemIndex,
  ) {
    setState(() {
      final week = _weeklyData![weekIndex];
      final meal = week.weeklyMeals.firstWhere(
        (m) => m.dayOfWeek == dayOfWeek && m.mealOrder == mealOrder,
      );
      meal.items[itemIndex].isEaten = !meal.items[itemIndex].isEaten;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      color: AppTheme.darkBg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SafeArea(
              bottom: false,
              child: Text(
                languageProvider.t('nutrition'),
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.cyanLight),
                  )
                : _weeklyData == null || _weeklyData!.isEmpty
                ? Center(
                    child: Text(
                      'No nutrition data available',
                      style: TextStyle(color: AppTheme.textLight),
                    ),
                  )
                : _buildNutritionContent(languageProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent(LanguageProvider languageProvider) {
    final currentWeek = _weeklyData![_selectedWeekIndex];
    final dietPlan = currentWeek.dietPlan;
    final weeklyMeals = currentWeek.weeklyMeals;

    // Group meals by day
    final Map<int, List<DailyMeal>> mealsByDay = {};
    for (final meal in weeklyMeals) {
      mealsByDay.putIfAbsent(meal.dayOfWeek, () => []).add(meal);
    }

    // Calculate daily totals for the week
    final List<Map<String, dynamic>> dailyTotals = [];
    final sortedDays = mealsByDay.keys.toList()..sort();

    for (final day in sortedDays) {
      final dayMeals = mealsByDay[day]!;
      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFats = 0;
      int itemsEaten = 0;
      int totalItems = 0;

      for (final meal in dayMeals) {
        for (final item in meal.items) {
          totalCalories += item.calories;
          totalProtein += item.protein;
          totalCarbs += item.carbs;
          totalFats += item.fats;
          totalItems++;
          if (item.isEaten) itemsEaten++;
        }
      }

      dailyTotals.add({
        'day': day,
        'calories': totalCalories,
        'protein': totalProtein,
        'carbs': totalCarbs,
        'fats': totalFats,
        'itemsEaten': itemsEaten,
        'totalItems': totalItems,
      });
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekSelector(),
          const SizedBox(height: 20),
          _buildDietPlan(dietPlan),
          const SizedBox(height: 20),
          _buildWeeklySummary(dailyTotals, dietPlan),
          const SizedBox(height: 20),
          ...sortedDays.map(
            (day) => _buildDaySection(
              day,
              mealsByDay[day]!,
              dailyTotals.firstWhere((t) => t['day'] == day),
              dietPlan,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppTheme.textWhite),
                onPressed: _selectedWeekIndex > 0
                    ? () {
                        setState(() {
                          _selectedWeekIndex--;
                        });
                      }
                    : null,
              ),
              Text(
                'Week ${_selectedWeekIndex + 1} of ${_weeklyData!.length}',
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textWhite,
                ),
                onPressed: _selectedWeekIndex < _weeklyData!.length - 1
                    ? () {
                        setState(() {
                          _selectedWeekIndex++;
                        });
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.history, color: AppTheme.cyanLight),
                onPressed: _showHistoryDialog,
                tooltip: 'View History',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildWeekOverview(),
      ],
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: const Text(
          'Nutrition History',
          style: TextStyle(color: AppTheme.textWhite),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: _weeklyData!.length,
            itemBuilder: (context, index) {
              final week = _weeklyData![index];
              final isSelected = index == _selectedWeekIndex;

              // Calculate week compliance
              int itemsEaten = 0;
              int totalItems = 0;
              for (final meal in week.weeklyMeals) {
                for (final item in meal.items) {
                  totalItems++;
                  if (item.isEaten) itemsEaten++;
                }
              }
              final compliance = totalItems > 0
                  ? (itemsEaten / totalItems * 100)
                  : 0;

              return ListTile(
                onTap: () {
                  setState(() {
                    _selectedWeekIndex = index;
                  });
                  Navigator.pop(context);
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.cyanLight.withOpacity(0.2)
                        : AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.cyanLight
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.cyanLight
                            : AppTheme.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Week ${index + 1}',
                  style: TextStyle(
                    color: isSelected ? AppTheme.cyanLight : AppTheme.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Compliance: ${compliance.toStringAsFixed(0)}%',
                  style: const TextStyle(color: AppTheme.textLight),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppTheme.cyanLight)
                    : null,
              );
            },
          ),
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

  Widget _buildWeekOverview() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _weeklyData!.length,
        itemBuilder: (context, index) {
          final week = _weeklyData![index];
          final isSelected = index == _selectedWeekIndex;

          // Calculate week compliance
          int itemsEaten = 0;
          int totalItems = 0;
          for (final meal in week.weeklyMeals) {
            for (final item in meal.items) {
              totalItems++;
              if (item.isEaten) itemsEaten++;
            }
          }
          final compliance = totalItems > 0
              ? (itemsEaten / totalItems * 100)
              : 0;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeekIndex = index;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.cyanLight.withOpacity(0.2)
                    : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.cyanLight : AppTheme.borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Week ${index + 1}',
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.cyanLight
                          : AppTheme.textWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${compliance.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.cyanLight
                          : AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: compliance / 100,
                      minHeight: 3,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: AlwaysStoppedAnimation(
                        isSelected ? AppTheme.cyanLight : AppTheme.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDietPlan(DietPlan dietPlan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Targets',
            style: TextStyle(
              color: AppTheme.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTargetItem(
                'Calories',
                '${dietPlan.dailyCaloriesTarget}',
                'kcal',
              ),
              _buildTargetItem(
                'Protein',
                '${dietPlan.proteinTarget.toInt()}',
                'g',
              ),
              _buildTargetItem('Carbs', '${dietPlan.carbsTarget.toInt()}', 'g'),
              _buildTargetItem('Fats', '${dietPlan.fatTarget.toInt()}', 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.cyanLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$unit $label',
          style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWeeklySummary(
    List<Map<String, dynamic>> dailyTotals,
    DietPlan dietPlan,
  ) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;
    int totalItemsEaten = 0;
    int totalItems = 0;

    for (final day in dailyTotals) {
      totalCalories += (day['calories'] as num).toDouble();
      totalProtein += (day['protein'] as num).toDouble();
      totalCarbs += (day['carbs'] as num).toDouble();
      totalFats += (day['fats'] as num).toDouble();
      totalItemsEaten += (day['itemsEaten'] as num).toInt();
      totalItems += (day['totalItems'] as num).toInt();
    }

    final avgCalories = totalCalories / dailyTotals.length;
    final avgProtein = totalProtein / dailyTotals.length;
    final avgCarbs = totalCarbs / dailyTotals.length;
    final avgFats = totalFats / dailyTotals.length;
    final complianceRate = totalItems > 0
        ? (totalItemsEaten / totalItems * 100)
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Summary',
            style: TextStyle(
              color: AppTheme.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Avg Calories',
            avgCalories.toInt(),
            dietPlan.dailyCaloriesTarget,
            'kcal',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Avg Protein',
            avgProtein.toInt(),
            dietPlan.proteinTarget.toInt(),
            'g',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Avg Carbs',
            avgCarbs.toInt(),
            dietPlan.carbsTarget.toInt(),
            'g',
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Avg Fats',
            avgFats.toInt(),
            dietPlan.fatTarget.toInt(),
            'g',
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Compliance Rate',
                style: TextStyle(color: AppTheme.textLight),
              ),
              Text(
                '${complianceRate.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppTheme.cyanLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: complianceRate / 100,
              minHeight: 6,
              backgroundColor: AppTheme.borderColor,
              valueColor: const AlwaysStoppedAnimation(AppTheme.cyanLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int current, int target, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textLight)),
        Text(
          '$current/$target $unit',
          style: const TextStyle(
            color: AppTheme.cyanLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySection(
    int day,
    List<DailyMeal> meals,
    Map<String, dynamic> totals,
    DietPlan dietPlan,
  ) {
    return Container(
      key: ValueKey('day_$day'),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day $day',
                  style: const TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${totals['calories'].toInt()} kcal',
                  style: const TextStyle(
                    color: AppTheme.cyanLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildDayMacros(totals, dietPlan),
          const SizedBox(height: 12),
          ...meals.map((meal) => _buildMealCard(meal, day)),
        ],
      ),
    );
  }

  Widget _buildDayMacros(Map<String, dynamic> totals, DietPlan dietPlan) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildMacroBar(
            'Protein',
            totals['protein'].toInt(),
            dietPlan.proteinTarget.toInt(),
            Colors.red,
          ),
          const SizedBox(height: 8),
          _buildMacroBar(
            'Carbs',
            totals['carbs'].toInt(),
            dietPlan.carbsTarget.toInt(),
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildMacroBar(
            'Fats',
            totals['fats'].toInt(),
            dietPlan.fatTarget.toInt(),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(DailyMeal meal, int dayOfWeek) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getMealName(meal.mealOrder),
                style: const TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                meal.mealTime,
                style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...meal.items.asMap().entries.map(
            (entry) => _buildFoodItem(
              entry.value,
              dayOfWeek,
              meal.mealOrder,
              entry.key,
            ),
          ),
        ],
      ),
    );
  }

  String _getMealName(int order) {
    switch (order) {
      case 1:
        return 'Breakfast';
      case 2:
        return 'Lunch';
      case 3:
        return 'Dinner';
      default:
        return 'Meal $order';
    }
  }

  Widget _buildFoodItem(
    FoodItem item,
    int dayOfWeek,
    int mealOrder,
    int itemIndex,
  ) {
    return GestureDetector(
      onTap: () =>
          _toggleFoodItem(_selectedWeekIndex, dayOfWeek, mealOrder, itemIndex),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.isEaten
              ? AppTheme.cardBg.withOpacity(0.3)
              : AppTheme.cardBg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: item.isEaten ? AppTheme.cyanLight : AppTheme.borderColor,
            width: item.isEaten ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isEaten ? AppTheme.cyanLight : AppTheme.borderColor,
              ),
              child: item.isEaten
                  ? const Icon(Icons.check, color: Colors.black, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: item.isEaten
                          ? AppTheme.textWhite
                          : AppTheme.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.grams.toInt()}g • ${item.calories.toInt()} kcal',
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'P: ${item.protein.toInt()}g',
                  style: const TextStyle(color: Colors.red, fontSize: 11),
                ),
                Text(
                  'C: ${item.carbs.toInt()}g',
                  style: const TextStyle(color: Colors.blue, fontSize: 11),
                ),
                Text(
                  'F: ${item.fats.toInt()}g',
                  style: const TextStyle(color: Colors.orange, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(String label, int current, int target, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
            ),
            Text(
              '$current/${target}g',
              style: const TextStyle(
                color: AppTheme.cyanLight,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / target,
            minHeight: 4,
            backgroundColor: AppTheme.borderColor,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
