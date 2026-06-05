import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/body_data.dart';
import '../services/body_service.dart';
import 'body_details_screen.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  // =========================
  // 🔥 WEEKLY WEIGHT
  // =========================
  List<FlSpot> getWeightSpots() {
    final weekly = BodyService.getWeeklyAvg(
      bodyLogs,
      BodyService.getWeight,
    );

    return weekly.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  // =========================
  // 🔥 INSIGHT (UI LOGIC)
  // =========================
  String getInsight(double change) {
    if (change < 0) {
      return "You are losing weight. Good if your goal is fat loss 🔥";
    } else if (change > 0) {
      return "You are gaining weight. Ensure it's muscle, not fat 💪";
    } else {
      return "Your weight is stable.";
    }
  }

  @override
  Widget build(BuildContext context) {

    final change = BodyService.getChange(
      bodyLogs,
      BodyService.getWeight,
    );

    final percent = BodyService.getChangePercent(
      bodyLogs,
      BodyService.getWeight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Body Composition"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            // =========================
            // 🔥 TITLE
            // =========================
            const Text(
              "Weekly Weight Progress",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

            const SizedBox(height: 10),

            // =========================
            // 🔥 CHART
            // =========================
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return Text(
                            "W${value.toInt() + 1}",
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getWeightSpots(),
                      isCurved: true,
                      color: Colors.green,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // 🔥 CHANGE
            // =========================
            Text(
              "Change: ${change.toStringAsFixed(1)} kg (${percent.toStringAsFixed(1)}%)",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 5),

            Text(
              getInsight(change),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 BODY CARDS
            // =========================
            buildCard(context, "Body Fat"),
            buildCard(context, "Muscle"),
            buildCard(context, "Water"),
            buildCard(context, "BMI"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🔥 CARD
  // =========================
  Widget buildCard(BuildContext context, String type) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(type, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BodyDetailsScreen(type: type),
            ),
          );
        },
      ),
    );
  }
}