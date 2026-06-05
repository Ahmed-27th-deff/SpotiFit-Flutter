import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../screens/training_screen.dart';
import '../nutrition/screens/nutrition_screen.dart';
import '../body/screens/body_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedMetric = "Weight";

  final List<String> metrics = ["Weight", "Body Fat", "Muscle", "Water"];

  // 🔥 Fake data (زي body logs)
  List<double> getData() {
    switch (selectedMetric) {
      case "Body Fat":
        return [20, 19, 18.5, 18];
      case "Muscle":
        return [35, 36, 37, 38];
      case "Water":
        return [55, 56, 57, 58];
      default:
        return [80, 81, 79, 78]; // Weight
    }
  }

  List<FlSpot> getSpots() {
    final data = getData();

    return data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  // =========================
  // 🔥 CARD
  // =========================
  Widget buildCard(String title, IconData icon, BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          if (title == "Training Progress") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TrainingScreen()),
            );
          }

          if (title == "Nutrition Progress") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NutritionScreen()),
            );
          }
          if (title == "Body Stats") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BodyScreen()),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // =========================
            // 🔥 DROPDOWN
            // =========================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedMetric,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),
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

            // =========================
            // 🔥 TITLE
            // =========================
            Text(
              "$selectedMetric Progress (Last 4 Weeks)",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 LINE CHART
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
                            "W${spot.x.toInt() + 1}\n${spot.y}",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      spots: getSpots(),
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // =========================
            // 🧩 SECTIONS
            // =========================
            buildCard("Training Progress", Icons.fitness_center, context),
            buildCard("Nutrition Progress", Icons.restaurant, context),
            buildCard("Body Stats", Icons.monitor_heart, context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
