import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/cubits/auth/auth_cubit.dart';
import 'package:kinedemo/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 1;
  double _height = 170;
  double _weight = 70;
  String? _selectedGender;
  String? _selectedGoal;
  String? _selectedActivityLevel;
  String? _selectedEquipment;

  final List<String> goals = [
    'loseFat',
    'gainWeight',
    'buildMuscle',
    'improveFitness',
  ];
  final List<String> activityLevels = ['beginner', 'intermediate', 'advanced'];
  final List<String> equipment = ['home', 'gym'];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return PopScope(
      canPop: _currentStep <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentStep > 1) {
          setState(() => _currentStep--);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBg,
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                            decoration: BoxDecoration(
                              color: index < _currentStep
                                  ? AppTheme.cyanLight
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Step $_currentStep of 5',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildStepContent(languageProvider),
                ),
              ),
              // Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    if (_currentStep > 1)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _currentStep--);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.cyanLight,
                            side: BorderSide(color: AppTheme.cyanLight),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            languageProvider.t('back'),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    if (_currentStep > 1) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _canProceed() ? _handleNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.cyanLight,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade800,
                        ),
                        child: Text(
                          _currentStep == 5
                              ? languageProvider.t('complete')
                              : languageProvider.t('next'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(LanguageProvider languageProvider) {
    switch (_currentStep) {
      case 1:
        return _buildPhysicalStatsStep(languageProvider);
      case 2:
        return _buildGenderStep(languageProvider);
      case 3:
        return _buildGoalStep(languageProvider);
      case 4:
        return _buildActivityLevelStep(languageProvider);
      case 5:
        return _buildEquipmentStep(languageProvider);
      default:
        return Container();
    }
  }

  Widget _buildPhysicalStatsStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('physicalStats'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('physicalStatsDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        // Height Slider
        Text(
          '${languageProvider.t('height')}: ${_height.toInt()} cm',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.cyanLight,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: AppTheme.cyanLight,
            overlayColor: AppTheme.cyanLight.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _height,
            min: 120,
            max: 220,
            onChanged: (value) {
              setState(() => _height = value);
            },
          ),
        ),
        const SizedBox(height: 32),
        // Weight Slider
        Text(
          '${languageProvider.t('weight')}: ${_weight.toInt()} kg',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.cyanLight,
            inactiveTrackColor: Colors.grey.shade800,
            thumbColor: AppTheme.cyanLight,
            overlayColor: AppTheme.cyanLight.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _weight,
            min: 40,
            max: 150,
            onChanged: (value) {
              setState(() => _weight = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenderStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('selectGender'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('selectGenderDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        _buildOptionButton(
          'male',
          languageProvider.t('male'),
          _selectedGender == 'male',
          () => setState(() => _selectedGender = 'male'),
        ),
        const SizedBox(height: 16),
        _buildOptionButton(
          'female',
          languageProvider.t('female'),
          _selectedGender == 'female',
          () => setState(() => _selectedGender = 'female'),
        ),
      ],
    );
  }

  Widget _buildGoalStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('fitnessGoal'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('fitnessGoalDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        ...goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOptionButton(
              goal,
              languageProvider.t(goal),
              _selectedGoal == goal,
              () => setState(() => _selectedGoal = goal),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActivityLevelStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('activityLevel'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('activityLevelDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        ...activityLevels.map((level) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOptionButton(
              level,
              languageProvider.t(level),
              _selectedActivityLevel == level,
              () => setState(() => _selectedActivityLevel = level),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEquipmentStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('equipment'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('equipmentDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        ...equipment.map((equip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOptionButton(
              equip,
              languageProvider.t(equip),
              _selectedEquipment == equip,
              () => setState(() => _selectedEquipment = equip),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOptionButton(
    String value,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.cyanLight.withValues(alpha: 0.1)
              : Colors.grey.shade900,
          border: Border.all(
            color: isSelected ? AppTheme.cyanLight : Colors.grey.shade800,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.cyanLight : Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 1:
        return true; // Height and weight always have values
      case 2:
        return _selectedGender != null;
      case 3:
        return _selectedGoal != null;
      case 4:
        return _selectedActivityLevel != null;
      case 5:
        return _selectedEquipment != null;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
    } else {
      // Complete onboarding
      context.read<AuthCubit>().completeOnboarding(
        height: _height,
        weight: _weight,
        gender: _selectedGender!,
        goal: _selectedGoal!,
        activityLevel: _selectedActivityLevel!,
        equipment: _selectedEquipment!,
      );
      context.go('/dashboard');
    }
  }
}
