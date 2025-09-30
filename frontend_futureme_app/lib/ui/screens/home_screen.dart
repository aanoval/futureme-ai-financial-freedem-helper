// Layar beranda dengan integrasi fitur Chat dan Mood, desain modern, dan animasi halus.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../providers/ai_chat_provider.dart';
import '../../providers/mood_provider.dart';
import '../../data/models/mood_entry.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _moodNoteController = TextEditingController();
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
    _chatController.dispose();
    _moodNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final moodProvider = context.watch<MoodProvider>();
    final profile = context.watch<UserProvider>().profile;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profil
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, ${profile.name}!',
                        style: AppTextStyles.heading1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Umur: ${profile.age} | Target Kebebasan Finansial: ${profile.targetFreedomAge}',
                        style: AppTextStyles.body,
                      ),
                      Text(
                        'Tahun Tersisa: ${calculateYearsToFreedom(profile.age, profile.targetFreedomAge)}',
                        style: AppTextStyles.body.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section Chatbot
                Text('Chat dengan AI', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: chatProvider.chatHistory.length,
                    itemBuilder: (ctx, i) {
                      final msg = chatProvider.chatHistory[i];
                      final isUser = msg['user'] != null;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isUser) const Icon(Icons.android, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                msg['user'] ?? msg['ai'] ?? '',
                                style: AppTextStyles.body,
                              ),
                            ),
                            if (isUser) const SizedBox(width: 8),
                            if (isUser) const Icon(Icons.person, color: AppColors.primary, size: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hint: 'Ketik pesan...',
                        controller: _chatController,
                        prefixIcon: Icons.chat_bubble_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: 'Kirim',
                      onPressed: () {
                        if (_chatController.text.isNotEmpty) {
                          chatProvider.sendMessage(context, _chatController.text);
                          _chatController.clear();
                        }
                      },
                      backgroundColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section Mood Tracker
                Text('Catat Mood Anda', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedMood,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['senang', 'sedih', 'marah', 'netral']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedMood = val!),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hint: 'Catatan (opsional)',
                  controller: _moodNoteController,
                  prefixIcon: Icons.note_outlined,
                ),
                CustomButton(
                  text: 'Simpan Mood',
                  onPressed: () {
                    final entry = MoodEntry(
                      mood: _selectedMood,
                      date: DateTime.now(),
                      note: _moodNoteController.text,
                    );
                    moodProvider.addMood(context, entry);
                    _moodNoteController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mood disimpan!')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: moodProvider.moods.length,
                    itemBuilder: (ctx, i) {
                      final entry = moodProvider.moods[i];
                      return ListTile(
                        title: Text(
                          '${entry.mood.capitalize()} - ${formatDate(entry.date)}',
                          style: AppTextStyles.body,
                        ),
                        subtitle: Text(
                          entry.aiSuggestion ?? entry.note,
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                        leading: Icon(
                          _getMoodIcon(entry.mood),
                          color: AppColors.primary,
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}