import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/nutrition_data.dart';
import '../models/nutrition_models.dart';
import '../services/nutrition_service.dart';
import 'nutrition_adherence_screen.dart';
import 'macro_details_screen.dart';
// (اختياري) لو هتعملهم بعدين
// import 'nutrition_adherence_screen.dart';
// import 'macro_details_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String selectedMonth = "Jan";

  // لو هتدعم أكتر من شهر
  final Map<String, List<DailyMeal>> monthlyMealsMap = {
    "Jan": monthlyMeals,
    "Feb": monthlyMeals,
    "Mar": monthlyMeals,
  };

  // =========================
  // 🔥 WEEKLY CALORIES CHART
  // =========================
  List<FlSpot> getWeeklyCaloriesSpots(List<DailyMeal> meals) {
    final weekly = NutritionService.getWeeklyCalories(meals);

    return weekly.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  // =========================
  // 🔥 TODAY DATA
  // =========================
  List<DailyMeal> getTodayMeals(List<DailyMeal> allMeals) {
    // خليه Day 1 للتجربة
    return NutritionService.getDayMeals(allMeals, 1);
  }

  @override
  Widget build(BuildContext context) {
    final meals = monthlyMealsMap[selectedMonth]!;

    final todayMeals = getTodayMeals(meals);

    final calories = NutritionService.getDailyCalories(todayMeals);
    final protein = NutritionService.getDailyProtein(todayMeals);
    final carbs = NutritionService.getDailyCarbs(todayMeals);
    final fats = NutritionService.getDailyFats(todayMeals);

    final adherence = NutritionService.getDayAdherence(todayMeals);

    final insight = NutritionService.getNutritionInsight(
      calories,
      dietPlan.dailyCaloriesTarget,
      protein,
      dietPlan.proteinTarget,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Nutrition"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 10),

            // =========================
            // 🔥 MONTH SELECTOR
            // =========================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedMonth,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                items: monthlyMealsMap.keys.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 TITLE
            // =========================
            Text(
              "Weekly Calories - $selectedMonth",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 CHART
            // =========================
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 3,

                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "W${value.toInt() + 1}",
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),

                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black,
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                            "Week ${spot.x.toInt() + 1}\n${spot.y.toStringAsFixed(0)} kcal",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 4,
                      spots: getWeeklyCaloriesSpots(meals),
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // 🔥 INSIGHT
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                insight,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 CARDS
            // =========================

            buildCard(
              "Calories",
              "${calories.toStringAsFixed(0)} / ${dietPlan.dailyCaloriesTarget}",
              NutritionService.getCaloriesFeedback(
                calories,
                dietPlan.dailyCaloriesTarget,
              ),
            ),

            buildCard(
              "Protein",
              "${protein.toStringAsFixed(0)} / ${dietPlan.proteinTarget}",
              NutritionService.getMacroFeedback(
                protein,
                dietPlan.proteinTarget,
                "Protein",
              ),
            ),

            buildCard(
              "Carbs",
              "${carbs.toStringAsFixed(0)} / ${dietPlan.carbsTarget}",
              NutritionService.getMacroFeedback(
                carbs,
                dietPlan.carbsTarget,
                "Carbs",
              ),
            ),

            buildCard(
              "Fats",
              "${fats.toStringAsFixed(0)} / ${dietPlan.fatTarget}",
              NutritionService.getMacroFeedback(
                fats,
                dietPlan.fatTarget,
                "Fats",
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // 🔥 ADHERENCE
            // =========================
            Text(
              "Adherence: ${(adherence * 100).toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.green),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 NAV BUTTONS
            // =========================
            buildButton("View Adherence Details", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NutritionAdherenceScreen(),
                ),
              );
            }),

            buildButton("View Macro Details", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MacroDetailsScreen(),
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🔹 CARD
  // =========================
  Widget buildCard(String title, String value, String feedback) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(feedback, style: const TextStyle(color: Colors.grey)),
        trailing: Text(value, style: const TextStyle(color: Colors.orange)),
      ),
    );
  }

  // =========================
  // 🔹 BUTTON
  // =========================
  Widget buildButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}