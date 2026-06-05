import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/cubits/auth/auth_cubit.dart';
import 'package:kinedemo/cubits/auth/auth_state.dart';
import 'package:kinedemo/widgets/auth_background.dart';
import 'package:kinedemo/widgets/auth_header.dart';
import 'package:kinedemo/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AuthAuthenticated) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBg,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AuthBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const AuthHeader(),
                        // Title Section
                        Column(
                          children: [
                            Text(
                              languageProvider.t('welcomeBack'),
                              style: const TextStyle(
                                color: AppTheme.textWhite,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              languageProvider.t('continueYourJourney'),
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        // Email Field
                        CustomTextField(
                          label: languageProvider.t('email'),
                          controller: emailController,
                          prefixIcon: Icons.mail_outline,
                          hintText: 'example@email.com',
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return isRTL
                                  ? 'الرجاء إدخال بريدك الإلكتروني'
                                  : 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return isRTL
                                  ? 'الرجاء إدخال بريد إلكتروني صحيح'
                                  : 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Password Field
                        CustomTextField(
                          label: languageProvider.t('password'),
                          controller: passwordController,
                          prefixIcon: Icons.lock_outline,
                          hintText: '••••••••',
                          obscureText: _obscurePassword,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          onVisibilityToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return isRTL
                                  ? 'الرجاء إدخال كلمة المرور'
                                  : 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return isRTL
                                  ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                                  : 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Forgot Password
                        Align(
                          alignment: isRTL
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _showForgotPasswordDialog,
                            child: Text(
                              languageProvider.t('forgotPassword'),
                              style: const TextStyle(
                                color: AppTheme.cyanLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Login Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.cyanLight,
                                  foregroundColor: AppTheme.darkBg,
                                  disabledBackgroundColor: AppTheme.cyanLight
                                      .withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                            AppTheme.darkBg,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        languageProvider.t('login'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isRTL
                                  ? "ليس لديك حساب؟ "
                                  : "Don't have an account? ",
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.go('/signup');
                              },
                              child: Text(
                                languageProvider.t('signUp'),
                                style: const TextStyle(
                                  color: AppTheme.cyanLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final emailResetController = TextEditingController(
      text: emailController.text,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBg,
          title: Text(
            languageProvider.t('forgotPassword'),
            style: const TextStyle(color: AppTheme.textWhite),
          ),
          content: TextField(
            controller: emailResetController,
            style: const TextStyle(color: AppTheme.textWhite),
            decoration: InputDecoration(
              hintText: 'example@email.com',
              hintStyle: const TextStyle(color: AppTheme.textLight),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.cyanLight),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                languageProvider.isRTL ? 'إلغاء' : 'Cancel',
                style: const TextStyle(color: AppTheme.textLight),
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = emailResetController.text.trim();
                if (email.isNotEmpty && email.contains('@')) {
                  Navigator.pop(context);
                  try {
                    await context.read<AuthCubit>().forgotPassword(email);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            languageProvider.isRTL
                                ? 'تم إرسال رابط إعادة تعيين كلمة المرور. يرجى التحقق من بريدك الإلكتروني ومجلد الرسائل غير المرغوب فيها (Spam).'
                                : 'Password reset link sent! Please check your email and spam folder.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceAll('Exception: ', ''),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        languageProvider.isRTL
                            ? 'الرجاء إدخال بريد إلكتروني صحيح'
                            : 'Please enter a valid email',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                languageProvider.isRTL ? 'إرسال' : 'Send',
                style: const TextStyle(color: AppTheme.cyanLight),
              ),
            ),
          ],
        );
      },
    );
  }
}
