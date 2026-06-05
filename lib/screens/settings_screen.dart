import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';
import 'package:kinedemo/cubits/auth/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
        ),
        title: Text(
          languageProvider.t('settings'),
          style: const TextStyle(color: AppTheme.textWhite),
        ),
      ),
      body: ListView(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.cyanLight.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.cyanLight,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ahmad Ahmed',
                  style: TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ahmad@example.com',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.borderColor),
          // Settings Items
          _buildSettingItem(
            Icons.person,
            languageProvider.t('editProfile'),
            () {},
          ),
          _buildSettingItem(
            Icons.track_changes,
            languageProvider.t('changeGoal'),
            () {},
          ),
          _buildSettingItem(
            Icons.notifications,
            languageProvider.t('notifications'),
            () {},
          ),
          _buildSettingItem(Icons.language, 'Language', () {
            languageProvider.setLanguage(
              languageProvider.language == 'en' ? 'ar' : 'en',
            );
          }),
          _buildSettingItem(
            Icons.privacy_tip,
            languageProvider.t('privacy'),
            () {},
          ),
          const Divider(color: AppTheme.borderColor),
          // Logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                await context.read<AuthCubit>().signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(languageProvider.t('logout')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppTheme.cyanLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.cyanLight),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppTheme.textWhite, fontSize: 16),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}
