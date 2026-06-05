import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/workout_models.dart';

class ExerciseService {
  static List<Exercise> _exercises = [];
  static List<String> _categories = [];
  static bool _loaded = false;

  static Future<void> loadExercises() async {
    if (_loaded) return;

    final String jsonString = await rootBundle.loadString('assets/data/exercises.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    _categories = List<String>.from(jsonData['categories']);
    
    _exercises = (jsonData['exercises'] as List)
        .map((e) => Exercise.fromJson(e))
        .toList();

    _loaded = true;
  }

  static List<Exercise> get allExercises => List.unmodifiable(_exercises);
  
  static List<String> get categories => List.unmodifiable(_categories);

  static List<Exercise> getByMuscleGroup(String muscleGroup) {
    return _exercises.where((e) => e.muscleGroup == muscleGroup).toList();
  }

  static List<Exercise> getByCategory(String category) {
    if (category == 'All') return _exercises;
    return _exercises.where((e) => e.category == category).toList();
  }

  static List<Exercise> filter({String? muscleGroup, String? category}) {
    return _exercises.where((e) {
      final matchesMuscle = muscleGroup == null || muscleGroup == 'All' || e.muscleGroup == muscleGroup;
      final matchesCategory = category == null || category == 'All' || e.category == category;
      return matchesMuscle && matchesCategory;
    }).toList();
  }

  static Exercise? getById(int id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
