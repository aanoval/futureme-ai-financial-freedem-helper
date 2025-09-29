// Provider for AI chatbot state management.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import 'user_provider.dart';
import 'dart:convert';
import '../../core/constants/app_strings.dart';

class ChatProvider extends ChangeNotifier {
  List<Map<String, String>> _chatHistory = [];
  List<Map<String, String>> get chatHistory => _chatHistory;

  Future<void> sendMessage(BuildContext context, String message) async {
    _chatHistory = [..._chatHistory, {'user': message}];
    notifyListeners();
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    final apiClient = ApiClient();
    final response = await apiClient.callAiChatbot({
      'profile': profile.toMap(),
      'message': message,
    });
    _chatHistory = [..._chatHistory, {'ai': jsonDecode(response)['response'] ?? AppStrings.errorApi}];
    notifyListeners();
  }
}