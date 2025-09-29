// Provider for user profile state management.
import 'package:flutter/material.dart';
import '../data/models/user_profile.dart';
import '../data/services/local_storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile(name: '', age: 0, targetFreedomAge: 0);
  UserProfile get profile => _profile;

  UserProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final localStorage = LocalStorageService();
    final profile = await localStorage.getProfile();
    if (profile != null) {
      _profile = profile;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    final localStorage = LocalStorageService();
    await localStorage.saveProfile(newProfile);
    notifyListeners();
  }
}