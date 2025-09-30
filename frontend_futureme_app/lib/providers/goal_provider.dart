// Provider for goal tracking management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/goal.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/database_service.dart';
import 'user_provider.dart';
import '../../core/constants/app_strings.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  GoalProvider() {
    loadGoals();
  }

  Future<void> loadGoals() async {
    try {
      final dbService = DatabaseService();
      _goals = await dbService.getGoals();
      notifyListeners();
    } catch (e) {
      // Handle error silently or log it
      print('Error loading goals: $e');
      _goals = [];
      notifyListeners();
    }
  }

  Future<void> addGoal(BuildContext context, Goal goal) async {
    try {
      final dbService = DatabaseService();
      await dbService.insertGoal(goal);
      await loadGoals();
      final profile = Provider.of<UserProvider>(context, listen: false).profile;
      if (profile == null) {
        throw Exception('Profil pengguna tidak ditemukan');
      }
      final apiClient = ApiClient();
      await apiClient.callAiGoal({
        'profile': profile.toMap(),
        'goal': goal.toMap(),
      });
      notifyListeners();
    } catch (e) {
      // Show error in UI via rethrow
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProgress(int id, double progress) async {
    try {
      final dbService = DatabaseService();
      await dbService.updateGoalProgress(id, progress.clamp(0.0, 1.0));
      await loadGoals();
      notifyListeners();
    } catch (e) {
      print('Error updating goal progress: $e');
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}