# Progress Hub - Gym Progress Tracking App

A Flutter application for tracking gym progress including workout performance, nutrition adherence, and body composition metrics.

---

## Project Overview

**App Name:** gym_app  
**Version:** 1.0.0+1  
**SDK:** Dart ^3.11.4  
**Description:** A comprehensive fitness tracking application with workout plans, nutrition monitoring, and body composition analysis.

---

## Project Structure

### Root Directory Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Project configuration, dependencies, and metadata |
| `pubspec.lock` | Locked dependency versions for reproducible builds |
| `analysis_options.yaml` | Dart analyzer configuration with lint rules |
| `.metadata` | Flutter project metadata for tooling and migrations |
| `.gitignore` | Git ignore patterns for the project |

---

## Platform Directories

### `/android`
Android-specific platform code and configuration.

| Path | Purpose |
|------|---------|
| `android/app/` | Android app module source code |
| `android/app/build.gradle.kts` | App-level Gradle build configuration (Kotlin DSL) |
| `android/build.gradle.kts` | Project-level Gradle configuration |
| `android/settings.gradle.kts` | Gradle project settings |
| `android/gradle.properties` | Gradle build properties |
| `android/gradle/wrapper/` | Gradle wrapper files |
| `android/.gitignore` | Android-specific git ignore patterns |

### `/ios`
iOS-specific platform code and Xcode project files.

| Path | Purpose |
|------|---------|
| `ios/Flutter/` | Flutter-specific iOS configuration files |
| `ios/Runner/` | Main iOS app source code and resources |
| `ios/Runner.xcodeproj/` | Xcode project configuration |
| `ios/Runner.xcworkspace/` | Xcode workspace configuration |
| `ios/RunnerTests/` | iOS unit tests |
| `ios/.gitignore` | iOS-specific git ignore patterns |

### `/linux`
Linux desktop platform support.

| Path | Purpose |
|------|---------|
| `linux/flutter/` | Flutter Linux plugin registration |
| `linux/runner/` | Linux app runner source code |
| `linux/CMakeLists.txt` | CMake build configuration |
| `linux/.gitignore` | Linux-specific git ignore patterns |

### `/macos`
macOS desktop platform support.

| Path | Purpose |
|------|---------|
| `macos/Flutter/` | Flutter macOS configuration |
| `macos/Runner/` | macOS app source and resources |
| `macos/Runner.xcodeproj/` | macOS Xcode project |
| `macos/Runner.xcworkspace/` | macOS Xcode workspace |
| `macos/RunnerTests/` | macOS unit tests |
| `macos/.gitignore` | macOS-specific git ignore patterns |

### `/windows`
Windows desktop platform support.

| Path | Purpose |
|------|---------|
| `windows/flutter/` | Flutter Windows plugin registration |
| `windows/runner/` | Windows app runner source code and resources |
| `windows/CMakeLists.txt` | CMake build configuration |
| `windows/.gitignore` | Windows-specific git ignore patterns |

### `/web`
Web platform support (PWA).

| Path | Purpose |
|------|---------|
| `web/index.html` | Main HTML entry point |
| `web/manifest.json` | PWA manifest configuration |
| `web/favicon.png` | Site favicon |
| `web/icons/` | PWA icon assets (Icon-192.png, Icon-512.png, Icon-maskable-*.png) |

---

## Application Code (`/lib`)

### Entry Point

| File | Purpose |
|------|---------|
| `lib/main.dart` | Application entry point. Initializes the app and sets `DashboardScreen` as the home route. Configures `MaterialApp` with debug banner disabled. |

---

### Core Application (`/lib/models`, `/lib/data`, `/lib/services`, `/lib/screens`, `/lib/widgets`)

#### `/lib/models/app_models.dart`
Defines core data models used across the application:

- **`DietPlan`** - Nutrition plan with calorie and macro targets
- **`DailyMeal`** - Individual meal entry with food items
- **`FoodItem`** - Single food item with nutritional values (calories, protein, carbs, fats, grams, isEaten status)
- **`WorkoutPlan`** - Workout program with weekly frequency and difficulty
- **`WorkoutDay`** - Individual workout day with exercises
- **`Exercise`** - Single exercise with sets, reps, rest time, muscle group
- **`WorkoutSession`** - Completed workout session with timing, rating, completion status
- **`ProgressLog`** - Comprehensive progress entry with body composition metrics

#### `/lib/data/workout_month_data.dart`
Mock data for workout sessions across 4 weeks:
- `workoutPlan` - Sample hypertrophy plan (Chest/Back/Legs split)
- `workoutSessions` - 12 workout sessions with completion data
- `monthlySessions` - Map of sessions by month (Jan, Feb, Mar)

#### `/lib/services/training_service.dart`
Business logic for training analytics:

| Method | Purpose |
|--------|---------|
| `getPerformance()` | Calculate average session rating across sessions |
| `getSessionAdherence()` | % of fully completed sessions |
| `getExerciseAdherence()` | % of completed vs total exercises |
| `getAdherence()` | Weighted adherence score (60% session + 40% exercise) |
| `getCompleted/MissedSessions()` | Count completed/missed sessions |
| `getCompleted/MissedExercises()` | Count completed/missed exercises |
| `getWeeklyPerformance()` | Performance trends by week |
| `getWeekSessions()` | Filter sessions by week index |
| `getWeekAdherence()` | Adherence for specific week |
| `getDayDurations()` | Workout duration history for a specific day |
| `getAverageRPE()` | Average Rate of Perceived Exertion |
| `getRPEAnalysis()` | Text analysis of RPE levels |
| `getRPETips()` | Training recommendations based on RPE |
| `getPerformanceChangePercent()` | Month-over-month performance change |
| `getPerformanceInsight()` | Human-readable performance summary |
| `getMissedByMuscleGroup()` | Categorize missed exercises by muscle |

#### `/lib/screens/`
UI screens for the main application modules:

| File | Purpose |
|------|---------|
| `dashboard_screen.dart` | **Main dashboard** with metric dropdown (Weight/Body Fat/Muscle/Water), line chart visualization, and navigation cards to Training/Nutrition/Body sections |
| `training_screen.dart` | Training progress screen with detailed workout analytics |
| `adherence_screen.dart` | Adherence tracking and visualization |
| `speed_screen.dart` | Workout speed/timing analysis |

#### `/lib/widgets/weight_chart.dart`
Reusable chart widget using `fl_chart`:
- Displays weight progression line chart
- Curved line visualization with green color scheme
- Dark-themed container styling

---

### Body Composition Module (`/lib/body/`)

A dedicated feature module for tracking body composition metrics.

#### `/lib/body/models/body_models.dart`
Data models for body tracking:

- **`BodyComposition`** - Weight, body fat %, skeletal muscle, body water, fat mass
- **`BodyAnalysis`** - BMI and metabolic rate calculations
- **`InBody`** - Container combining composition and analysis data
- **`ProgressLog`** - Date-stamped log entry with total score, RPE, and InBody data

#### `/lib/body/data/body_data.dart`
Sample body composition data for 4 weeks showing progressive improvement:
- Week 1: Weight 80kg, Body Fat 20%, Muscle 35kg
- Week 4: Weight 78kg, Body Fat 18%, Muscle 37kg
- Tracks BMI decrease from 25 to 23.8
- Metabolic rate increase from 1800 to 1880

#### `/lib/body/services/body_service.dart`
Analytics service for body metrics:

| Method | Purpose |
|--------|---------|
| `getWeekLogs()` | Filter progress logs by week number |
| `getWeeklyAvg()` | Calculate weekly averages for any metric selector |
| `getChange()` | Calculate absolute change (start → end) |
| `getChangePercent()` | Calculate percentage change |
| Selector methods | `getWeight`, `getBodyFat`, `getMuscle`, `getWater`, `getFatMass`, `getBMI`, `getBMR` |

#### `/lib/body/screens/`

| File | Purpose |
|------|---------|
| `body_screen.dart` | Main body composition dashboard showing all metrics |
| `body_details_screen.dart` | Detailed body metric breakdown and history |

---

### Nutrition Module (`/lib/nutrition/`)

A dedicated feature module for diet and nutrition tracking.

#### `/lib/nutrition/models/nutrition_models.dart`
Data models for nutrition tracking:

- **`DietPlan`** - Plan ID, name, daily calorie target, macro targets (protein/carbs/fat)
- **`FoodItem`** - Food name, portion (grams), calories, macros, consumption status
- **`DailyMeal`** - Meal entry with day of week, meal time, order, and food items list

#### `/lib/nutrition/data/nutrition_data.dart`
Sample nutrition data:
- `dietPlan` - "Lean Bulk Plan" (2800 cal, 180g protein, 320g carbs, 80g fat)
- `monthlyMeals` - Sample meals across 4 weeks with varying adherence

#### `/lib/nutrition/services/nutrition_service.dart`
Business logic for nutrition analytics:

| Method | Purpose |
|--------|---------|
| `getMealCalories/Protein/Carbs/Fats()` | Calculate consumed macros for a meal |
| `getDayMeals()` | Filter meals by day |
| `getDailyCalories/Protein/Carbs/Fats()` | Daily macro totals |
| `getMealAdherence()` | % of food items eaten in a meal |
| `getDayAdherence()` | % of fully completed meals in a day |
| `getWeekMeals()` | Filter meals by week index |
| `getWeeklyCalories()` | Total calories per week |
| `getCaloriesFeedback()` | Smart feedback on calorie intake vs target |
| `getMacroFeedback()` | Smart feedback on specific macro intake |
| `getMissedFoods()` | List of uneaten food items |
| `getNutritionInsight()` | Comprehensive nutrition assessment |

#### `/lib/nutrition/screens/`

| File | Purpose |
|------|---------|
| `nutrition_screen.dart` | Main nutrition dashboard with meal tracking and macro visualization |
| `macro_details_screen.dart` | Detailed macronutrient breakdown and analysis |
| `nutrition_adherence_screen.dart` | Nutrition adherence tracking and compliance metrics |

---

## Testing

### `/test/widget_test.dart`
Basic widget tests verifying:
- App launches successfully
- Dashboard title is displayed
- Navigation cards (Training Progress, Nutrition Progress, Body Stats) are present

---

## Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` (SDK) | - | Flutter framework |
| `fl_chart` | ^0.66.0 | Chart and graph visualization |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` (SDK) | - | Flutter testing framework |
| `flutter_lints` | ^6.0.0 | Recommended lint rules |

---

## Architecture Overview

The app follows a **modular feature-based architecture**:

```
lib/
├── main.dart              # Entry point
├── models/               # Core shared models
├── data/                 # Mock/sample data
├── services/             # Business logic (app-level)
├── screens/              # Main app screens
├── widgets/              # Reusable UI components
├── body/                 # Body composition feature module
│   ├── models/
│   ├── data/
│   ├── services/
│   └── screens/
└── nutrition/            # Nutrition feature module
    ├── models/
    ├── data/
    ├── services/
    └── screens/
```

Each feature module (`body/`, `nutrition/`) is self-contained with its own models, data, services, and screens, promoting separation of concerns and maintainability.

---

## Key Features

1. **Dashboard** - Central hub with metric visualization and module navigation
2. **Training Tracking** - Workout sessions, exercise completion, performance analytics
3. **Body Composition** - Weight, body fat, muscle mass tracking with progress charts
4. **Nutrition Monitoring** - Meal logging, macro tracking, adherence scoring
5. **Progress Visualization** - Interactive charts using `fl_chart`

---

## Multi-Platform Support

The app supports 6 platforms:
- **Android** - Gradle/Kotlin build system
- **iOS** - Xcode project with Swift/Objective-C
- **Linux** - CMake build with GTK
- **macOS** - Xcode project with Cocoa
- **Windows** - CMake build with Win32
- **Web** - PWA-ready with manifest and icons
