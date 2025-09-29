// Layar AI Mood Booster dengan picker mood dan animasi suggestion.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../providers/mood_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../../data/models/mood_entry.dart';

class MoodScreen extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();
  String _mood = 'senang';

  @override
  Widget build(BuildContext context) {
    final moods = context.watch<MoodProvider>().moods;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.aiMood)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: moods.length,
              itemBuilder: (ctx, i) {
                final entry = moods[i];
                return AnimatedSlide(
                  offset: Offset.zero,
                  duration: animationDuration,
                  child: ListTile(
                    title: Text('${entry.mood} - ${formatDate(entry.date)}'),
                    subtitle: Text(entry.aiSuggestion ?? entry.note),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _mood,
                  items: ['senang', 'sedih', 'marah', 'netral'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => _mood = val!,
                ),
                CustomTextField(hint: 'Catatan', controller: _noteController),
                CustomButton(
                  text: AppStrings.save,
                  onPressed: () {
                    final entry = MoodEntry(mood: _mood, date: DateTime.now(), note: _noteController.text);
                    context.read<MoodProvider>().addMood(context, entry);
                    _noteController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}