// Provider for mood entries management.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/mood_entry.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/database_service.dart';
import 'user_provider.dart';

class MoodProvider extends ChangeNotifier {
  List<MoodEntry> _moods = [];
  List<MoodEntry> get moods => _moods;

  Future<void> loadMoods() async {
    final dbService = DatabaseService();
    _moods = await dbService.getMoodEntries();
    notifyListeners();
  }

  Future<void> addMood(BuildContext context, MoodEntry entry) async {
    final dbService = DatabaseService();
    await dbService.insertMood(entry);
    await loadMoods();
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    final apiClient = ApiClient();
    final response = await apiClient.callAiMood({
      'profile': profile.toMap(),
      'mood': entry.toMap(),
    });
    entry.aiSuggestion = jsonDecode(response)['suggestion'];
    // Update entry in DB if needed
    notifyListeners();
  }
}