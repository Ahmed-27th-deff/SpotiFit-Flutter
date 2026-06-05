import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/nutrition_data.dart';
import '../services/nutrition_service.dart';

class MacroDetailsScreen extends StatefulWidget {
  const MacroDetailsScreen({super.key});

  @override
  State<MacroDetailsScreen> createState() => _MacroDetailsScreenState();
}

class _MacroDetailsScreenState extends State<MacroDetailsScreen> {

  String selectedMacro = "Protein";

  final List<String> macros = [
    "Calories",
    "Protein",
    "Carbs",
    "Fats",
  ];

  int selectedWeek = 0;

  // =========================
  // 🔥 VALUE SELECTOR
  // =========================
  double getValue(meal) {
    switch (selectedMacro) {
      case "Protein":
        return NutritionService.getMealProtein(meal);
      case "Carbs":
        return NutritionService.getMealCarbs(meal);
      case "Fats":
        return NutritionService.getMealFats(meal);
      default:
        return NutritionService.getMealCalories(meal);
    }
  }

  // =========================
  // 🔥 MONTHLY DATA
  // =========================
  List<FlSpot> getMonthlySpots() {
    return monthlyMeals.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), getValue(e.value));
    }).toList();
  }

  // =========================
  // 🔥 WEEKLY DATA
  // =========================
  List<FlSpot> getWeeklySpots() {
    final weekMeals =
    NutritionService.getWeekMeals(monthlyMeals, selectedWeek);

    return weekMeals.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), getValue(e.value));
    }).toList();
  }

  // =========================
  // 🔥 INSIGHT
  // =========================
  String getInsight() {

    double total = monthlyMeals.fold(
        0.0, (sum, m) => sum + getValue(m));

    double avg = total / monthlyMeals.length;

    double target;

    switch (selectedMacro) {
      case "Protein":
        target = dietPlan.proteinTarget;
        break;
      case "Carbs":
        target = dietPlan.carbsTarget;
        break;
      case "Fats":
        target = dietPlan.fatTarget;
        break;
      default:
        target = dietPlan.dailyCaloriesTarget;
    }

    return NutritionService.getMacroFeedback(avg, target, selectedMacro);
  }

  // =========================
  // 🔥 DESCRIPTION
  // =========================
  String getDescription() {
    switch (selectedMacro) {
      case "Protein":
        return "Protein helps in muscle recovery and growth. Low intake slows progress.";
      case "Carbs":
        return "Carbs are your main energy source. Low carbs reduce performance.";
      case "Fats":
        return "Fats support hormones like testosterone. Too low affects recovery.";
      default:
        return "Calories control your weight. Surplus = gain, deficit = loss.";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Macro Details"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            // =========================
            // 🔥 DROPDOWN
            // =========================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedMacro,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
                items: macros.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMacro = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 MONTHLY CHART
            // =========================
            Text(
              "$selectedMacro Monthly Trend",
              style: const TextStyle(color: Colors.white),
            ),

            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getMonthlySpots(),
                      isCurved: true,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 WEEK SELECTOR
            // =========================
            DropdownButton<int>(
              value: selectedWeek,
              dropdownColor: Colors.black,
              items: const [
                DropdownMenuItem(value: 0, child: Text("Week 1")),
                DropdownMenuItem(value: 1, child: Text("Week 2")),
                DropdownMenuItem(value: 2, child: Text("Week 3")),
                DropdownMenuItem(value: 3, child: Text("Week 4")),
              ],
              onChanged: (v) {
                setState(() {
                  selectedWeek = v!;
                });
              },
            ),

            const SizedBox(height: 10),

            // =========================
            // 🔥 WEEKLY CHART
            // =========================
            Text(
              "$selectedMacro Weekly Trend",
              style: const TextStyle(color: Colors.white),
            ),

            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getWeeklySpots(),
                      isCurved: true,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 INSIGHT
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                getInsight(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // 🔥 DESCRIPTION
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                getDescription(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}