import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/workout_month_data.dart';
import '../models/app_models.dart';
import '../services/training_service.dart';
import 'adherence_screen.dart';
import 'speed_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String selectedMonth = "Jan";

  // 🔥 Weekly Performance → Spots
  List<FlSpot> getWeeklyPerformance(List<WorkoutSession> sessions) {
    final weekly = TrainingService.getWeeklyPerformance(sessions);

    return weekly.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 أهم سطر (كل حاجة بتتغير حسب الشهر)
    final List<WorkoutSession> sessions = monthlySessions[selectedMonth]!;

    final performance = TrainingService.getPerformance(sessions);

    final rpe = TrainingService.getAverageRPE(sessions);

    final adherence = TrainingService.getAdherence(sessions);

    final change = TrainingService.getPerformanceChangePercent(sessions);

    final insight = TrainingService.getPerformanceInsight(change);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Training Progress"),
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

                items: monthlySessions.keys.map((month) {
                  return DropdownMenuItem(value: month, child: Text(month));
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
              "Weekly Performance Score - $selectedMonth",
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
                    // 🔹 X Axis
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) {
                            return const SizedBox();
                          }
                          return Text(
                            "W${value.toInt() + 1}",
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),

                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  // 🔥 TOOLTIP
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black,
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final week = spot.x.toInt() + 1;
                          final score = spot.y.toStringAsFixed(1);

                          return LineTooltipItem(
                            "W$week\nScore: $score",
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),

                  // 🔥 LINE
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      spots: getWeeklyPerformance(sessions),
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

            const SizedBox(height: 10),

            // =========================
            // 🔥 INSIGHT
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                insight,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: change > 0
                      ? Colors.green
                      : (change < 0 ? Colors.red : Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // 🔥 CARDS
            // =========================
            buildCard(context, "Performance", performance.toStringAsFixed(1), () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    "Performance Analysis",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    "Your performance score is ${performance.toStringAsFixed(1)}.\n\n"
                    "This value represents the average of your session scores during $selectedMonth.\n\n"
                    "${getPerformanceLevel(performance)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),

            buildCard(
              context,
              "Adherence",
              "${(adherence * 100).toStringAsFixed(1)}%",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdherenceScreen()),
                );
              },
            ),

            buildCard(context, "Workout Speed", "View", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpeedScreen()),
              );
            }),

            buildCard(context, "RPE", rpe.toStringAsFixed(1), () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    "RPE Analysis",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    "Your average RPE is ${rpe.toStringAsFixed(1)}.\n\n"
                    "1-4 → Light\n"
                    "5-7 → Moderate\n"
                    "8-10 → High\n\n"
                    "${TrainingService.getRPEAnalysis(rpe)}\n\n"
                    "Advice:\n${TrainingService.getRPETips(rpe)}",
                    style: const TextStyle(color: Colors.white),
                  ),
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
  // 🔹 CARD WIDGET
  // =========================
  Widget buildCard(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(value, style: const TextStyle(color: Colors.green)),
        onTap: onTap,
      ),
    );
  }

  String getPerformanceLevel(double score) {
    if (score >= 8) {
      return "Excellent performance. You are progressing very well.";
    } else if (score >= 5) {
      return "Good performance. You are on the right track.";
    } else {
      return "Low performance. Try to improve consistency and effort.";
    }
  }
}
