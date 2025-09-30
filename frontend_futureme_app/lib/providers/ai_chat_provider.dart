import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_strings.dart';
import '../../core/utils/logger.dart';
import '../data/models/user_profile.dart';
import '../data/services/api_client.dart';
import '../data/services/local_storage_service.dart';
import 'user_provider.dart';

class ChatProvider extends ChangeNotifier {
  List<Map<String, String>> _chatHistory = [];
  List<Map<String, String>> get chatHistory => _chatHistory;
  final LocalStorageService _localStorage = LocalStorageService();
  static const String chatHistoryKey = 'chat_history';

  ChatProvider() {
    // Load chat history when provider is initialized
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? json = prefs.getString(chatHistoryKey);
      if (json != null) {
        final List<dynamic> decoded = jsonDecode(json);
        _chatHistory = decoded.map((item) => Map<String, String>.from(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      logError('Failed to load chat history', e);
      _chatHistory = [];
      notifyListeners();
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(chatHistoryKey, jsonEncode(_chatHistory));
      logInfo('Chat history saved successfully');
    } catch (e) {
      logError('Failed to save chat history', e);
    }
  }

  Future<void> sendMessage(BuildContext context, String message) async {
    try {
      // Add user message to chat history
      _chatHistory = [..._chatHistory, {'user': message}];
      notifyListeners();
      await _saveChatHistory();

      // Get user profile, use default values if null
      final profile = Provider.of<UserProvider>(context, listen: false).profile;
      final profileData = profile != null
          ? profile.toMap()
          : {
              'name': 'Pengguna Anonim',
              'age': 0,
              'targetFreedomAge': 0,
              'savings': 0.0,
              'debts': 0.0,
            };

      // Call API
      final apiClient = ApiClient();
      String aiResponse;
      try {
        final response = await apiClient.callAiChatbot({
          'profile': profileData,
          'message': message,
        });
        // Parse response safely
        try {
          final decodedResponse = jsonDecode(response);
          aiResponse = decodedResponse['response']?.toString() ?? AppStrings.errorApi;
        } catch (e) {
          aiResponse = AppStrings.errorApi;
          logError('Failed to parse API response', e);
        }
      } catch (e) {
        // Handle API failure gracefully
        aiResponse = 'Maaf, layanan AI saat ini tidak tersedia. Silakan coba lagi nanti.';
        logError('AI Chatbot call failed', e);
      }

      // Add AI response to chat history
      _chatHistory = [..._chatHistory, {'ai': aiResponse}];
      notifyListeners();
      await _saveChatHistory();
    } catch (e) {
      // Add error message to chat history
      _chatHistory = [..._chatHistory, {'ai': 'Error: $e'}];
      notifyListeners();
      await _saveChatHistory();
      logError('ChatProvider error', e);
    }
  }

  Future<void> clearChatHistory() async {
    try {
      _chatHistory = [];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(chatHistoryKey);
      logInfo('Chat history cleared');
    } catch (e) {
      logError('Failed to clear chat history', e);
    }
  }
}