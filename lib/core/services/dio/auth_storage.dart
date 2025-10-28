import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared_preferences/shared_preferences_keys.dart';

class AuthStorage {
  // Save visitor token
  static Future<bool> saveVisitorToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(
        SharedPreferencesKeys.visitorTokenKey,
        token,
      );
    } catch (e) {
      log('Error saving visitor token: $e');
      return false;
    }
  }

  // Get visitor token
  static Future<String?> getVisitorToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(SharedPreferencesKeys.visitorTokenKey);
    } catch (e) {
      log('Error getting visitor token: $e');
      return null;
    }
  }

  // Check if visitor token exists
  static Future<bool> hasVisitorToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(SharedPreferencesKeys.visitorTokenKey);
    } catch (e) {
      log('Error checking visitor token: $e');
      return false;
    }
  }
}
