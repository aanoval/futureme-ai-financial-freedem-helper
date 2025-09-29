// Local storage service for user profile using SharedPreferences.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../../core/utils/logger.dart';

class LocalStorageService {
  static const String profileKey = 'user_profile';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileKey, jsonEncode(profile.toMap()));
  }

  Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(profileKey);
    if (json != null) {
      return UserProfile.fromMap(jsonDecode(json));
    }
    return null;
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(profileKey);
  }
}