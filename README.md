# SpotiFit - AI Fitness Coach

A comprehensive Flutter-based fitness coaching application with AI-powered guidance, workout tracking, nutrition management, and progress analytics.

**Status:** ✅ Production-Ready | **Platform:** Cross-platform (Currently Android)

## Project Idea
SpotiFit is designed to make fitness more personal, accessible, and motivating. Instead of a generic workout app, it helps users build healthier routines through smart onboarding, goal-based training, real-time workout tracking, nutrition awareness, and personalized guidance.

## App Summary
SpotiFit is a cross-platform fitness app that helps users:
- create a personalized fitness profile
- choose goals and activity preferences
- follow structured exercise programs
- track workouts using timers, sets, reps, and rest periods
- monitor nutrition and macro balance
- review progress and achievements over time
- receive guidance from an AI-style fitness coach

## Demo Video

[Watch the SpotiFit demo](https://drive.google.com/file/d/1ZpVNfd9WMz59akK9shPbqw862e1ZY4GP/view)

## Features

### Core Functionality
- **User Authentication** - Secure login and account creation with validation
- **Personalized Onboarding** - 5-step setup wizard for fitness profiling
  - Height/weight configuration
  - Gender selection
  - Fitness goal setting
  - Activity level assessment
  - Equipment availability
- **Comprehensive Dashboard** - Main hub with quick stats and training programs
- **Exercise Management** - Browse and review exercise details
- **Real-time Workout Tracking** - Timer, set/rep counters, and rest tracking
- **AI Coach Chat** - Conversational fitness guidance and motivation
- **Nutrition Tracking** - Meal logging with macro calculations (Protein, Carbs, Fats)
- **Progress Analytics** - Track metrics, achievements, and milestones
- **User Settings** - Profile management, preferences, and language selection

### Localization
- **Bilingual Support:** Arabic (AR) and English (EN)
- **RTL Support:** Full right-to-left layout support for Arabic
- **170+ Translation Keys:** Comprehensive app-wide localization

### Design System
- **Dark Theme:** Optimized for eye comfort and modern aesthetics
- **Custom Color Palette:**
  - Primary: Cyan (#B8F1FF)
  - Secondary: Blue (#76A8FF)
  - Dark Background: #0E0E0E
- **Glass-morphism Effects:** Modern UI with opacity overlays
- **Material Design 3:** Latest Material Design specifications
- **Custom Typography:** Google Fonts (Nunito) integration

## Project Structure

```text
lib/
├── main.dart                          # App entry point & routing
├── theme/
│   └── app_theme.dart                # Design system & theme configuration
├── providers/
│   └── language_provider.dart        # State management & localization
├── cubits/
├── repositories/
├── models/
├── screens/                          # Feature screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── onboarding_screen.dart
│   ├── dashboard_screen.dart
│   ├── exercise_list_screen.dart
│   ├── exercise_detail_screen.dart
│   ├── exercise_tracking_screen.dart
│   ├── ai_coach_screen.dart
│   ├── nutrition_screen.dart
│   ├── progress_screen.dart
│   └── settings_screen.dart
├── firebase_options.dart
└── widgets/
```

## Technology Used
- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- GoRouter for navigation
- Provider for state management
- Flutter Bloc for app state
- Google Fonts
- Intl for localization
- Shared Preferences
- URL Launcher
- Cached Network Image
- Flutter SVG
- Material Design and custom theming

## Architecture Overview
The app is organized using a clean Flutter architecture with:
- dedicated screens for each user journey
- centralized theme and design system
- provider and bloc patterns for state management
- Firebase integration for auth and backend services
- route-based navigation with GoRouter
- multilingual support for English and Arabic

## Getting Started

### Prerequisites
- **Flutter:** 3.9.0 or higher
- **Dart:** 3.9.0 or higher
- **Android SDK:** API level 21+ (for Android development)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Ahmed-27th-deff/KineDemo.git
cd KineDemo
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
# Android
flutter run -d android
```

## Supported Platforms

| Platform | Status | Min Version |
| --- | --- | --- |
| Android | ✅ Supported | API 21 (Android 5.0) |

## Development

### Running Tests
```bash
flutter test
```

### Build Release APK (Android)
```bash
flutter build apk --release
```


### Format Code
```bash
dart format .
```

### Analyze Code
```bash
flutter analyze
```

## Environment Setup

### Android Development
1. Install Android Studio or Android Command Line Tools
2. Accept Android licenses:

```bash
flutter doctor --android-licenses
```

## Troubleshooting

### Dependency Issues
```bash
flutter clean
flutter pub get
```

### Build Cache Issues
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Platform-Specific Issues
- **Android:** Check `android/local.properties` for SDK path

## Additional Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://m3.material.io/)
- [Provider Package Documentation](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## Contributing
This is a demonstration project showcasing Flutter best practices. For questions or improvements, please open an issue on GitHub.

## License
This project is open source and available under the MIT License.

## Author
**Ahmed** - [GitHub Profile](https://github.com/Ahmed-27th-deff)

## Support
For support, email: salemdeff@gmail.com or open an issue on GitHub.
