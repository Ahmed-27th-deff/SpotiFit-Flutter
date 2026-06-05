import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Chest',
    'Cardio',
    'Lower Body',
    'Upper Body',
    'Core',
  ];
  final List<Map<String, dynamic>> programs = [
    {
      'name': 'Full Body Blast',
      'duration': '45 min',
      'calories': 320,
      'progress': 75,
      'icon': Icons.fitness_center,
      'image': 'assets/images/full_body_blast.png',
    },
    {
      'name': 'Chest & Triceps',
      'duration': '35 min',
      'calories': 280,
      'progress': 60,
      'icon': Icons.directions_run,
      'image': 'assets/images/chest.png',
    },
    {
      'name': 'Cardio HIIT',
      'duration': '30 min',
      'calories': 400,
      'progress': 85,
      'icon': Icons.favorite,
      'image': 'assets/images/cardio_HIIT.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Container(
      color: AppTheme.darkBg,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                image: DecorationImage(
                  image: const AssetImage('assets/images/main.png'),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.darkBg.withOpacity(0.4),
                          AppTheme.darkBg,
                        ],
                      ),
                    ),
                  ),
                  // Header
                  Positioned(
                    top: 36,
                    left: isRTL ? null : 16,
                    right: isRTL ? 16 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cyanLight.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.cyanLight.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Mon, Jan 15',
                        style: TextStyle(
                          color: AppTheme.cyanLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Settings Button
                  Positioned(
                    top: 36,
                    right: isRTL ? null : 16, //isRTL ? 16 : null
                    left: isRTL ? 16 : null, //isRTL ? null : 16
                    child: GestureDetector(
                      onTap: () => context.go('/settings'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.cyanLight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.cyanLight.withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: AppTheme.textWhite,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    left: isRTL ? null : 16,
                    right: isRTL ? 16 : null,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: isRTL
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.cyanLight.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.cyanLight.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '${languageProvider.t('hello')}, Ahmad! 👋',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${languageProvider.t('goodDay')}\n${languageProvider.t('healthyBody')}',
                          style: const TextStyle(
                            color: AppTheme.textWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageProvider.t('youAreDoing'),
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Quick Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard('5', languageProvider.t('workouts')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '1.2k',
                      languageProvider.t('calories'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('180', 'Minutes')),
                ],
              ),
            ),
            // Category Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = category);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.cyanLight.withOpacity(0.15)
                              : AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.cyanLight.withOpacity(0.5)
                                : AppTheme.borderColor,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.cyanLight
                                : AppTheme.textLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Programs Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageProvider.t('trainingPrograms'),
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    languageProvider.t('seeAll'),
                    style: const TextStyle(
                      color: AppTheme.cyanLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Program Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: programs.map((program) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => context.go('/exercise-detail'),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppTheme.cardBg,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              // Background Image
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      program['image'] ??
                                          'assets/images/main.png',
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (_, __) {},
                                  ),
                                ),
                              ),
                              // Overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.darkBg.withOpacity(0.9),
                                    ],
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppTheme.cyanLight.withOpacity(
                                            0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: AppTheme.cyanLight,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          program['name'],
                                          style: const TextStyle(
                                            color: AppTheme.textWhite,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              '${program['duration']} • ',
                                              style: const TextStyle(
                                                color: AppTheme.textLight,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${program['calories']} cal',
                                              style: const TextStyle(
                                                color: AppTheme.cyanLight,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: program['progress'] / 100,
                                            minHeight: 4,
                                            backgroundColor:
                                                AppTheme.borderColor,
                                            valueColor:
                                                const AlwaysStoppedAnimation(
                                                  AppTheme.cyanLight,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cyanLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cyanLight.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.cyanLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textLight, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
