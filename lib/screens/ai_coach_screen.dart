import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinedemo/providers/language_provider.dart';
import 'package:kinedemo/theme/app_theme.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'How can I help you today?', 'isAI': true},
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            color: AppTheme.darkBg,
            child: Column(
              children: [
                Container(
                  color: AppTheme.cardBg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          languageProvider.t('aiCoach'),
                          style: const TextStyle(
                            color: AppTheme.textWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppTheme.textWhite,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Align(
                              alignment: message['isAI']
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: message['isAI']
                                      ? AppTheme.cyanLight.withOpacity(0.1)
                                      : AppTheme.cyanLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppTheme.cyanLight.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: message['isAI']
                                        ? AppTheme.textLight
                                        : AppTheme.darkBg,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(
                                  color: AppTheme.textWhite,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Ask anything...',
                                  hintStyle: const TextStyle(
                                    color: AppTheme.textLight,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.cardBg,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppTheme.borderColor,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                if (_controller.text.isNotEmpty) {
                                  setState(() {
                                    messages.add({
                                      'text': _controller.text,
                                      'isAI': false,
                                    });
                                    messages.add({
                                      'text': '''The Macro Strategy
                                      To maintain muscle and keep energy stable across a long shift, target a daily baseline of roughly 2,800 calories: 180–200g of Protein for muscle repair, 320–350g of Carbohydrates for sustained fuel, and 75–85g of Healthy Fats for joint health and hormone regulation.

                                      Daily Meal Schedule
                                      Meal 1 (Pre-Shift Breakfast): 4 whole eggs, 100g oats cooked in water, and 1 banana. This combines slow-digesting complex carbs with quality protein to anchor your energy through your first few morning clients.

                                    Meal 2 (Mid-Morning Quick Refuel): 200g plain Greek yogurt, 30g almonds, and an apple. A portable, zero-prep option that fits perfectly into a 5-minute break between sessions.

                                    Meal 3 (Midday Power Lunch): 200g grilled chicken breast or lean beef, 250g cooked basmati rice or sweet potato, and a large portion of steamed green vegetables drizzled with 1 tbsp of olive oil. This restocks your glycogen stores without causing an afternoon crash.

                                    Meal 4 (Late Afternoon / Pre-Workout): 1 scoop of whey protein isolate mixed with an easily digestible carb powder (or 2-3 rice cakes). Liquid nutrition bypasses heavy digestion, giving your muscles immediate energy without making you sluggish on the gym floor.

                                    Meal 5 (Recovery Dinner): 200g grilled salmon, 300g baked potato wedges, and a mixed green salad with half an avocado. The Omega-3s in the fish fight joint inflammation from standing all day, while the carbs promote better sleep and overnight recovery.''',
                                      'isAI': true,
                                    });
                                  });
                                  _controller.clear();
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppTheme.cyanLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: AppTheme.darkBg,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
