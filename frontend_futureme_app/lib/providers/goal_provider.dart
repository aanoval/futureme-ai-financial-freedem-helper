// Provider for goal tracking management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/goal.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/database_service.dart';
import '../data/services/notification_service.dart';
import 'user_provider.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  GoalProvider() {
    loadGoals();
  }

  Future<void> loadGoals() async {
    final dbService = DatabaseService();
    _goals = await dbService.getGoals();
    notifyListeners();
  }

  Future<void> addGoal(BuildContext context, Goal goal) async {
    final dbService = DatabaseService();
    await dbService.insertGoal(goal);
    await loadGoals();
    final notificationService = NotificationService();
    await notificationService.scheduleNotification(goal.id ?? 0, 'Goal Reminder', goal.description, goal.targetDate);
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    final apiClient = ApiClient();
    await apiClient.callAiGoal({
      'profile': profile.toMap(),
      'goal': goal.toMap(),
    });
    notifyListeners();
  }

  Future<void> updateProgress(int id, double progress) async {
    // Update in DB, reload
    notifyListeners();
  }
}