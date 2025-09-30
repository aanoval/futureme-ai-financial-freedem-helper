// Provider for financial entries management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/financial_entry.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/database_service.dart';
import 'user_provider.dart';
import '../../core/constants/app_strings.dart';

class FinancialProvider extends ChangeNotifier {
  List<FinancialEntry> _entries = [];
  List<FinancialEntry> get entries => _entries;

  FinancialProvider() {
    loadFinancials();
  }

  Future<void> loadFinancials() async {
    try {
      final dbService = DatabaseService();
      _entries = await dbService.getFinancials();
      notifyListeners();
    } catch (e) {
      print('Error loading financials: $e');
      _entries = [];
      notifyListeners();
    }
  }

  Future<void> addEntry(BuildContext context, FinancialEntry entry) async {
    try {
      final dbService = DatabaseService();
      await dbService.insertFinancial(entry);
      await loadFinancials();
      final profile = Provider.of<UserProvider>(context, listen: false).profile;
      if (profile == null) {
        throw Exception('Profil pengguna tidak ditemukan');
      }
      final apiClient = ApiClient();
      final response = await apiClient.callAiFinancial({
        'profile': profile.toMap(),
        'new_entry': entry.toMap(),
      });
      // Handle response if needed (e.g., parse for AI insights)
      notifyListeners();
    } catch (e) {
      print('Error adding financial entry: $e');
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}