import 'package:flutter/material.dart';
import '../data/workout_month_data.dart';
import '../services/training_service.dart';

class AdherenceScreen extends StatefulWidget {
  const AdherenceScreen({super.key});

  @override
  State<AdherenceScreen> createState() => _AdherenceScreenState();
}

class _AdherenceScreenState extends State<AdherenceScreen> {

  int selectedWeek = 0;

  @override
  Widget build(BuildContext context) {

    final weekSessions = TrainingService.getWeekSessions(
        workoutSessions, selectedWeek);
    if (weekSessions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            "No data for this week",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final completedSessions =
    TrainingService.getCompletedSessions(weekSessions);

    final missedSessions =
    TrainingService.getMissedSessions(weekSessions);

    final adherence =
    TrainingService.getAdherence(weekSessions);

    final grouped = TrainingService.getMissedByMuscleGroup(
      weekSessions,
      workoutPlan.days,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Adherence Details"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 WEEK SELECTOR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: selectedWeek,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                underline: const SizedBox(),

                items: const [
                  DropdownMenuItem(value: 0, child: Text("Week 1")),
                  DropdownMenuItem(value: 1, child: Text("Week 2")),
                  DropdownMenuItem(value: 2, child: Text("Week 3")),
                  DropdownMenuItem(value: 3, child: Text("Week 4")),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedWeek = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 ADHERENCE %
            Text(
              "Adherence: ${(adherence * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 SESSION CARDS
            Row(
              children: [
                Expanded(
                  child: buildSummaryCard(
                    "Completed",
                    completedSessions.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildSummaryCard(
                    "Missed",
                    missedSessions.toString(),
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Missed Exercises",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 LIST
            Expanded(
              child: ListView(
                children: grouped.entries.map((entry) {
                  return buildMuscleCard(entry.key, entry.value);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildMuscleCard(String muscle, List<String> exercises) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "$muscle (${exercises.length})",
              style: const TextStyle(color: Colors.orange),
            ),

            const SizedBox(height: 8),

            ...exercises.map((e) => Text(
              "❌ $e",
              style: const TextStyle(color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}