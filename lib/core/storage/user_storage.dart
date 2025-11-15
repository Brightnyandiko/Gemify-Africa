// lib/core/storage/user_storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/authentication/domain/entities/user.dart';

class UserStorage {
  final SharedPreferences _prefs;

  static const String _userKey = 'current_user';
  static const String _onboardingKey = 'onboarding_completed';

  // ✅ OPTION 1: Positional parameter (simpler)
  // UserStorage(this._prefs, {required SharedPreferences prefs});

  // ✅ OPTION 2: Named parameter (more explicit)
  UserStorage({required SharedPreferences prefs}) : _prefs = prefs;

  Future<void> saveUser(User user) async {
    final userJson = json.encode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _prefs.remove(_userKey);
  }

  bool hasUser() {
    return _prefs.containsKey(_userKey);
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }
}