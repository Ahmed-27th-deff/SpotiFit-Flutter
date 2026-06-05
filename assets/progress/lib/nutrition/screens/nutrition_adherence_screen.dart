import 'package:flutter/material.dart';
import '../data/nutrition_data.dart';
import '../services/nutrition_service.dart';

class NutritionAdherenceScreen extends StatefulWidget {
  const NutritionAdherenceScreen({super.key});

  @override
  State<NutritionAdherenceScreen> createState() =>
      _NutritionAdherenceScreenState();
}

class _NutritionAdherenceScreenState
    extends State<NutritionAdherenceScreen> {

  int selectedWeek = 0;

  @override
  Widget build(BuildContext context) {

    final weekMeals =
    NutritionService.getWeekMeals(monthlyMeals, selectedWeek);

    final adherence =
    NutritionService.getDayAdherence(weekMeals);

    final missedFoods =
    NutritionService.getMissedFoods(weekMeals);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Nutrition Adherence"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [

          const SizedBox(height: 10),

          // 🔥 WEEK SELECTOR
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

          const SizedBox(height: 20),

          // 🔥 ADHERENCE %
          Text(
            "Adherence: ${(adherence * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Missed Foods",
            style: TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: missedFoods.map((f) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(f.name,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      "${f.calories} kcal",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}