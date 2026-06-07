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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? _selectedDateOfBirth;
  double _height = 170;
  double _weight = 70;
  String? _selectedGender;
  final List<String> _selectedFitnessGoals = [];
  String? _selectedFitnessLevel;

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  final List<String> fitnessGoals = [
    'weight_loss',
    'muscle_gain',
    'endurance',
    'flexibility',
    'strength',
    'general_health',
  ];
  final List<String> fitnessLevels = ['beginner', 'intermediate', 'advanced'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final lastDate = DateTime(now.year - 13, now.month, now.day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.cyanLight,
              onPrimary: AppTheme.darkBg,
              surface: AppTheme.cardBg,
              onSurface: AppTheme.textWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

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
                      children: List.generate(6, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(right: index < 6 ? 8 : 0),
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
                      'Step $_currentStep of 6',
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
                          _currentStep == 6
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
        return _buildNameStep(languageProvider);
      case 2:
        return _buildDateOfBirthStep(languageProvider);
      case 3:
        return _buildPhysicalStatsStep(languageProvider);
      case 4:
        return _buildGenderStep(languageProvider);
      case 5:
        return _buildFitnessGoalsStep(languageProvider);
      case 6:
        return _buildFitnessLevelStep(languageProvider);
      default:
        return Container();
    }
  }

  Widget _buildNameStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('personalInfo'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('personalInfoDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: firstNameController,
          focusNode: _firstNameFocus,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_lastNameFocus);
          },
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: languageProvider.t('firstName'),
            labelStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.cyanLight),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: lastNameController,
          focusNode: _lastNameFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            labelText: languageProvider.t('lastName'),
            labelStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.cyanLight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('dateOfBirth'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('dateOfBirthDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        InkWell(
          onTap: () => _selectDateOfBirth(context),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border.all(
                color: _selectedDateOfBirth != null
                    ? AppTheme.cyanLight
                    : Colors.grey.shade800,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: _selectedDateOfBirth != null
                      ? AppTheme.cyanLight
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedDateOfBirth != null
                      ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                      : languageProvider.t('selectDate'),
                  style: TextStyle(
                    color: _selectedDateOfBirth != null
                        ? Colors.white
                        : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

  Widget _buildFitnessGoalsStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('fitnessGoals'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('fitnessGoalsDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: fitnessGoals.map((goal) {
            final isSelected = _selectedFitnessGoals.contains(goal);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFitnessGoals.remove(goal);
                  } else {
                    _selectedFitnessGoals.add(goal);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  languageProvider.t(goal),
                  style: TextStyle(
                    color: isSelected ? AppTheme.cyanLight : Colors.white,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFitnessLevelStep(LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageProvider.t('fitnessLevel'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          languageProvider.t('fitnessLevelDesc'),
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
        const SizedBox(height: 40),
        ...fitnessLevels.map((level) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildOptionButton(
              level,
              languageProvider.t(level),
              _selectedFitnessLevel == level,
              () => setState(() => _selectedFitnessLevel = level),
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
        return firstNameController.text.trim().isNotEmpty && 
               lastNameController.text.trim().isNotEmpty;
      case 2:
        return _selectedDateOfBirth != null;
      case 3:
        return true; // Height and weight always have values
      case 4:
        return _selectedGender != null;
      case 5:
        return _selectedFitnessGoals.isNotEmpty;
      case 6:
        return _selectedFitnessLevel != null;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 6) {
      setState(() => _currentStep++);
    } else {
      // Complete onboarding
      context.read<AuthCubit>().completeOnboarding(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: _selectedGender!,
        dateOfBirth: _selectedDateOfBirth!,
        height: _height,
        weight: _weight,
        fitnessLevel: _selectedFitnessLevel!,
        fitnessGoals: _selectedFitnessGoals,
      );
      context.go('/dashboard');
    }
  }
}
