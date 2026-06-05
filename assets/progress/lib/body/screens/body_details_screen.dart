import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/body_data.dart';
import '../services/body_service.dart';

class BodyDetailsScreen extends StatefulWidget {
  final String type;

  const BodyDetailsScreen({super.key, required this.type});

  @override
  State<BodyDetailsScreen> createState() => _BodyDetailsScreenState();
}

class _BodyDetailsScreenState extends State<BodyDetailsScreen> {

  int selectedWeek = 0;

  // =========================
  // 🔥 VALUE SELECTOR
  // =========================
  double getValue(log) {
    switch (widget.type) {
      case "Body Fat":
        return BodyService.getBodyFat(log);
      case "Muscle":
        return BodyService.getMuscle(log);
      case "Water":
        return BodyService.getWater(log);
      case "BMI":
        return BodyService.getBMI(log);
      default:
        return BodyService.getWeight(log);
    }
  }

  // =========================
  // 🔥 WEEKLY SPOTS
  // =========================
  List<FlSpot> getSpots() {
    final weekLogs =
    BodyService.getWeekLogs(bodyLogs, selectedWeek);

    return weekLogs.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), getValue(e.value));
    }).toList();
  }

  // =========================
  // 🔥 CHANGE
  // =========================
  double getChange() {
    final weekLogs =
    BodyService.getWeekLogs(bodyLogs, selectedWeek);

    if (weekLogs.isEmpty) return 0;

    return getValue(weekLogs.last) - getValue(weekLogs.first);
  }

  double getPercent() {
    final weekLogs =
    BodyService.getWeekLogs(bodyLogs, selectedWeek);

    if (weekLogs.isEmpty) return 0;

    double start = getValue(weekLogs.first);
    double end = getValue(weekLogs.last);

    if (start == 0) return 0;

    return ((end - start) / start) * 100;
  }

  // =========================
  // 🔥 INSIGHT (UI)
  // =========================
  String getInsight(double change) {

    if (widget.type == "Body Fat") {
      if (change < 0) return "Fat is decreasing 🔥";
      return "Fat is increasing ⚠";
    }

    if (widget.type == "Muscle") {
      if (change > 0) return "Muscle is increasing 💪";
      return "Muscle is decreasing";
    }

    if (widget.type == "Water") {
      if (change > 0) return "Hydration improving 💧";
      return "Hydration dropping";
    }

    if (widget.type == "BMI") {
      return "BMI reflects overall body balance";
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {

    final change = getChange();
    final percent = getPercent();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.type),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [

          const SizedBox(height: 20),

          // =========================
          // 🔥 WEEK SELECTOR
          // =========================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<int>(
              value: selectedWeek,
              dropdownColor: Colors.black,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 0, child: Text("W1")),
                DropdownMenuItem(value: 1, child: Text("W2")),
                DropdownMenuItem(value: 2, child: Text("W3")),
                DropdownMenuItem(value: 3, child: Text("W4")),
              ],
              onChanged: (v) {
                setState(() {
                  selectedWeek = v!;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // =========================
          // 🔥 CHART TITLE
          // =========================
          Text(
            "${widget.type} Trend",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 10),

          // =========================
          // 🔥 CHART
          // =========================
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: getSpots(),
                    isCurved: true,
                    color: Colors.orange,
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
            "Change: ${change.toStringAsFixed(2)} (${percent.toStringAsFixed(1)}%)",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 5),

          Text(
            getInsight(change),
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}