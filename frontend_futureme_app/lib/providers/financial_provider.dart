// Provider for financial entries management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/financial_entry.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/database_service.dart';
import 'user_provider.dart';

class FinancialProvider extends ChangeNotifier {
  List<FinancialEntry> _entries = [];
  List<FinancialEntry> get entries => _entries;

  Future<void> loadFinancials() async {
    final dbService = DatabaseService();
    _entries = await dbService.getFinancials();
    notifyListeners();
  }

  Future<void> addEntry(BuildContext context, FinancialEntry entry) async {
    final dbService = DatabaseService();
    await dbService.insertFinancial(entry);
    await loadFinancials();
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    final apiClient = ApiClient();
    final response = await apiClient.callAiFinancial({
      'profile': profile.toMap(),
      'new_entry': entry.toMap(),
    });
    // Handle response if needed
    notifyListeners();
  }
}