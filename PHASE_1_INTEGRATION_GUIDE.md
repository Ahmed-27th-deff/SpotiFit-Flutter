## Phase 1 Integration Guide

### ✅ What's Been Created

1. **Extended ApiService** (`lib/services/api_service.dart`)
   - `logWorkoutSession(userId, data)` → `POST /progress/{userId}/log`
   - `logMealEntry(userId, data)` → `POST /diet/{userId}/log-meal`
   - `logBodyMeasurement(userId, data)` → `POST /progress/{userId}/log`

2. **Created 3 Repositories**
   - `lib/repositories/workout_repository.dart`
   - `lib/repositories/nutrition_repository.dart`
   - `lib/repositories/body_repository.dart`

3. **Created Convenience Service**
   - `lib/services/data_sync_service.dart` - Easy wrapper for all repos

---

### 📝 How to Use in Screens

#### **Get User ID from AuthCubit**

```dart
// In any screen with access to context
final userId = (context.read<AuthCubit>().state as AuthAuthenticated).user.uid;
```

#### **Example 1: Log Workout in ExerciseTrackingScreen**

```dart
import 'package:kinedemo/services/data_sync_service.dart';

class _ExerciseTrackingScreenState extends State<ExerciseTrackingScreen> {
  final DataSyncService _syncService = DataSyncService();

  void _handleCompleteWorkout() async {
    try {
      // Get user ID
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      int userId = int.parse(authState.user.uid); // Convert UID to int

      // Log to API
      await _syncService.logWorkout(
        userId: userId,
        exerciseName: exercise.name,
        sets: currentSet,
        reps: completedReps,
        weight: 100.0, // You can add this to your UI
        durationSeconds: seconds,
        rating: 8.0, // You can ask user for rating
      );

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Workout saved to database!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

#### **Example 2: Log Meal in NutritionScreen**

```dart
import 'package:kinedemo/services/data_sync_service.dart';

class _NutritionScreenState extends State<NutritionScreen> {
  final DataSyncService _syncService = DataSyncService();

  void _handleMealLogged(String mealName) async {
    try {
      // Get user ID
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthAuthenticated) return;

      int userId = int.parse(authState.user.uid);

      // Get meal data
      final todayMeals = getTodayMeals(meals);
      final calories = NutritionService.getDailyCalories(todayMeals);
      final protein = NutritionService.getDailyProtein(todayMeals);
      final carbs = NutritionService.getDailyCarbs(todayMeals);
      final fats = NutritionService.getDailyFats(todayMeals);

      // Log to API
      await _syncService.logMeal(
        userId: userId,
        mealName: mealName,
        foods: todayMeals.expand((m) => m.items).map((f) => {
          'name': f.name,
          'calories': f.calories,
          'protein': f.protein,
          'carbs': f.carbs,
          'fats': f.fats,
          'grams': f.grams,
          'isEaten': f.isEaten,
        }).toList(),
        totalCalories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Meal saved to database!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

#### **Example 3: Log Body Progress in ProgressScreen**

```dart
import 'package:kinedemo/services/data_sync_service.dart';

class _ProgressScreenState extends State<ProgressScreen> {
  final DataSyncService _syncService = DataSyncService();

  double _weight = 80.0;
  double _bodyFat = 20.0;
  double _muscle = 35.0;
  double _water = 55.0;

  void _handleLogBodyProgress() async {
    try {
      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthAuthenticated) return;

      int userId = int.parse(authState.user.uid);

      await _syncService.logBodyProgress(
        userId: userId,
        weight: _weight,
        bodyFat: _bodyFat,
        muscle: _muscle,
        water: _water,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Body progress saved to database!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

---

### 🔄 Data Flow

```
User completes workout in ExerciseTrackingScreen
    ↓
_handleCompleteWorkout() called
    ↓
_syncService.logWorkout() called with userId & workout data
    ↓
WorkoutRepository.logWorkoutSession() called
    ↓
ApiService.logWorkoutSession() called
    ↓
POST /progress/{userId}/log sent to http://10.242.133.106:8000
    ↓
Your local database receives & stores the data
    ↓
✅ Success snackbar shown to user
```

---

### ⚠️ Important Notes

1. **User ID Conversion**
   - Firebase UID is a String (e.g., "abc123def456")
   - Your API might expect an Int (e.g., 1, 2, 3)
   - Use `int.parse(authState.user.uid)` or ask your backend to accept String UIDs

2. **Error Handling**
   - All methods throw exceptions on failure
   - Catch them and show snackbars (as shown in examples)
   - Check console logs for debug info

3. **Network Availability**
   - Since your database PC is local, make sure it's running
   - If API is offline, error will show
   - No offline caching yet (add in Phase 2 if needed)

---

### ✅ Testing Checklist

- [ ] Log a workout → Check console logs for "✅ Workout logged successfully"
- [ ] Check your API backend → See if workout data was received
- [ ] Log a meal → Check for "✅ Meal logged successfully"
- [ ] Log body progress → Check for success message
- [ ] Test with API offline → Should show error snackbar
- [ ] Check your local database PC → Verify all data is stored

---

### 🚀 Next Steps

To integrate into actual screens, simply:

1. Import `DataSyncService`
2. Create instance: `final _syncService = DataSyncService();`
3. Get userId from `AuthCubit`
4. Call the appropriate method when user completes an action
5. Wrap in try-catch and show snackbar on success/error
