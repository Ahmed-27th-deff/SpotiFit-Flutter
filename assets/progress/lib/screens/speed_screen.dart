import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/workout_month_data.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({super.key});

  @override
  State<SpeedScreen> createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {

  int selectedDay = 1;

  // 🔥 جلب الداتا حسب اليوم
  List<FlSpot> getDayProgress(int dayId) {
    final filtered =
    workoutSessions.where((s) => s.dayId == dayId).toList();

    return filtered.asMap().entries.map((e) {
      return FlSpot(
        e.key.toDouble(),
        e.value.duration,
      );
    }).toList();
  }

  // 🔥 اسم اليوم الحقيقي
  String getDayName(int dayId) {
    final day = workoutPlan.days.firstWhere((d) => d.id == dayId);
    return day.dayName;
  }

  @override
  Widget build(BuildContext context) {

    final spots = getDayProgress(selectedDay);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Workout Speed"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: selectedDay,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),

                items: workoutPlan.days.map((day) {
                  return DropdownMenuItem(
                    value: day.id,
                    child: Text(day.dayName),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Title
            Text(
              "Workout Duration - ${getDayName(selectedDay)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Chart
            SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 3,

                  gridData: FlGridData(show: true),

                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),

                  // 🔥 AXIS
                  titlesData: FlTitlesData(

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
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "${value.toInt()}m",
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

                  // 🔥 TOOLTIP (المهم)
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {

                          final week = spot.x.toInt() + 1;
                          final minutes = spot.y.toInt();

                          return LineTooltipItem(
                            "Week $week\n$minutes min",
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
                      color: Colors.orange,
                      barWidth: 4,
                      spots: spots,

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
          ],
        ),
      ),
    );
  }
}