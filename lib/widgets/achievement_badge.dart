import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AchievementBadge extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final bool isUnlocked;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.progress = 1.0,
    this.isUnlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.cardBg : AppTheme.cardBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.cyanLight.withOpacity(0.3)
              : AppTheme.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppTheme.goldColor.withOpacity(0.15)
                  : AppTheme.textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: 28,
                  color: isUnlocked
                      ? AppTheme.goldColor
                      : AppTheme.textLight.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isUnlocked
                        ? AppTheme.textWhite
                        : AppTheme.textLight.withOpacity(0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isUnlocked
                        ? AppTheme.textLight
                        : AppTheme.textLight.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                if (!isUnlocked && progress < 1.0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppTheme.borderColor,
                      valueColor: const AlwaysStoppedAnimation(
                        AppTheme.cyanLight,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(Icons.check_circle, color: AppTheme.cyanLight, size: 22),
        ],
      ),
    );
  }
}
