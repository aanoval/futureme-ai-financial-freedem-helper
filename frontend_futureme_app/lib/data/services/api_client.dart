// Client for calling Python AI backend with error handling.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import '../../core/utils/logger.dart';

class ApiClient {
  static const String baseUrl = 'https://backend.futureme.com/api';

  Future<String> callAiChatbot(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) return response.body;
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      logError('AI Chatbot call failed', e);
      return jsonEncode({'error': AppStrings.errorApi});
    }
  }

  Future<String> callAiFinancial(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/financial'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) return response.body;
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      logError('AI Financial call failed', e);
      return jsonEncode({'error': AppStrings.errorApi});
    }
  }

  Future<String> callAiMood(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mood'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) return response.body;
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      logError('AI Mood call failed', e);
      return jsonEncode({'error': AppStrings.errorApi});
    }
  }

  Future<String> callAiGoal(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/goal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) return response.body;
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      logError('AI Goal call failed', e);
      return jsonEncode({'error': AppStrings.errorApi});
    }
  }
}