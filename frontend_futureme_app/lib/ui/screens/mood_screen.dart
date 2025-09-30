// Dokumen: Layar AI Mood Booster dengan picker mood, desain modern, dan animasi halus.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../providers/mood_provider.dart';
import '../../data/models/mood_entry.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  String _selectedMood = 'senang';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _noteController.dispose();
    super.dispose();
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return Icons.sentiment_satisfied;
      case 'sedih':
        return Icons.sentiment_dissatisfied;
      case 'marah':
        return Icons.sentiment_very_dissatisfied;
      case 'netral':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    final moods = moodProvider.moods;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeMood, style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.moodToday, style: AppTextStyles.heading1),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedMood,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSecondary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(_getMoodIcon(_selectedMood), color: AppColors.primary),
                        ),
                        items: ['senang', 'sedih', 'marah', 'netral']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.capitalize(), style: AppTextStyles.body),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedMood = val!),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hint: 'Catatan (opsional)',
                        controller: _noteController,
                        prefixIcon: Icons.note_outlined,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: AppStrings.save,
                        onPressed: () {
                          final entry = MoodEntry(
                            mood: _selectedMood,
                            date: DateTime.now(),
                            note: _noteController.text,
                          );
                          moodProvider.addMood(context, entry);
                          _noteController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(AppStrings.success)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Riwayat Mood', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: moods.isEmpty
                      ? Center(child: Text(AppStrings.noData, style: AppTextStyles.bodySecondary))
                      : ListView.builder(
                          itemCount: moods.length,
                          itemBuilder: (ctx, i) {
                            final entry = moods[i];
                            return FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(0.1 * i, 1.0, curve: Curves.easeIn),
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  _getMoodIcon(entry.mood),
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  '${entry.mood.capitalize()} - ${formatDate(entry.date)}',
                                  style: AppTextStyles.body,
                                ),
                                subtitle: Text(
                                  entry.aiSuggestion ?? entry.note,
                                  style: AppTextStyles.bodySecondary,
                                ),
                              ),
                            );
                          },
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}