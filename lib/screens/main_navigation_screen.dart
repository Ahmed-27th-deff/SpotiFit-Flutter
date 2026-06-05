import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/screens/dashboard_screen.dart';
import 'package:kinedemo/screens/exercise_list_screen.dart';
import 'package:kinedemo/screens/nutrition_screen.dart';
import 'package:kinedemo/screens/progress_screen.dart';
import 'package:kinedemo/screens/settings_screen.dart';
import 'package:kinedemo/screens/ai_coach_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExerciseListScreen(),
    NutritionScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  void _showAICoach() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AICoachScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAICoach,
        backgroundColor: AppTheme.cyanLight,
        child: const Icon(Icons.smart_toy, color: AppTheme.darkBg),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.cardBg,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: AppTheme.darkBg,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.cyanLight,
              color: AppTheme.textLight,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.fitness_center, text: 'Exercises'),
                GButton(icon: Icons.apple, text: 'Nutrition'),
                GButton(icon: Icons.trending_up, text: 'Progress'),
                GButton(icon: Icons.settings, text: 'Settings'),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
