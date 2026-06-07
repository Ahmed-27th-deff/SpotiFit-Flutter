import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/screens/splash_screen.dart';
import 'package:kinedemo/screens/login_screen.dart';
import 'package:kinedemo/screens/signup_screen.dart';
import 'package:kinedemo/screens/onboarding_screen.dart';
import 'package:kinedemo/screens/main_navigation_screen.dart';
import 'package:kinedemo/screens/exercise_detail_screen.dart';
import 'package:kinedemo/screens/exercise_tracking_screen.dart';
import 'package:kinedemo/screens/settings_screen.dart';
import 'package:kinedemo/models/workout_models.dart';
import 'package:kinedemo/repositories/auth_repository.dart';
import 'package:kinedemo/cubits/auth/auth_cubit.dart';
import 'package:kinedemo/cubits/auth/auth_state.dart';
import 'package:kinedemo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        Provider(create: (_) => AuthRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(authRepository: context.read<AuthRepository>()),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp.router(
            title: 'AI Fitness Coach',
            theme: AppTheme.lightTheme(),
            debugShowCheckedModeBanner: false,
            locale: Locale(languageProvider.language),
            supportedLocales: const [Locale('en'), Locale('ar')],
            routerConfig: _buildRouter(context),
          );
        },
      ),
    );
  }

  GoRouter _buildRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final authState = context.read<AuthCubit>().state;
        final isAuthenticated = authState is AuthAuthenticated;

        final isGoingToAuth =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup' ||
            state.matchedLocation == '/splash';

        // If not authenticated and not going to auth screens, redirect to login
        if (!isAuthenticated && !isGoingToAuth) {
          return '/login';
        }

        // If authenticated and going to auth screens (except splash), redirect to dashboard
        if (isAuthenticated && isGoingToAuth && state.matchedLocation != '/splash') {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const MainNavigationScreen(),
        ),
        GoRoute(
          path: '/exercise-detail',
          builder: (context, state) {
            final exercise = state.extra as Exercise?;
            return ExerciseDetailScreen(exercise: exercise);
          },
        ),
        GoRoute(
          path: '/exercise-tracking',
          builder: (context, state) {
            final exercise = state.extra as Exercise?;
            return ExerciseTrackingScreen(exercise: exercise);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}
