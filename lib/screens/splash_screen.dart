import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Navigate to login after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          // Gradient Orbs Background
          Positioned(
            top: 50,
            left: isRTL ? null : 40,
            right: isRTL ? 40 : null,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cyanLight.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.cyanLight.withOpacity(0.1),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: isRTL ? 40 : null,
            left: isRTL ? null : 40,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.blueDark.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.blueDark.withOpacity(0.1),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container with Glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.cyanLight.withOpacity(0.4),
                                blurRadius: 48,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        // Logo background
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: AppTheme.cyanLight.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.cyanLight.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 32,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: AppTheme.cyanLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // App Name
                    Text(
                      languageProvider.t('appName'),
                      style: const TextStyle(
                        color: AppTheme.textWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your AI-Powered Fitness Journey',
                      style: TextStyle(color: AppTheme.textLight, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading Indicator at bottom
          Positioned(
            bottom: 96,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBouncingDot(0),
                  const SizedBox(width: 8),
                  _buildBouncingDot(150),
                  const SizedBox(width: 8),
                  _buildBouncingDot(300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingDot(int delayMs) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -8 * (value - 0.5).abs()),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.cyanLight,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cyanLight.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
