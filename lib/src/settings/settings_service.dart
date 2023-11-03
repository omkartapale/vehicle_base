import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Loads the User's preferred ThemeMode from local or remote storage.
  // Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<ThemeMode> themeMode() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await _prefs;
    final themeMode = prefs.getString('themeMode');

    return switch (themeMode) {
      'ThemeMode.light' => ThemeMode.light,
      'ThemeMode.dark' => ThemeMode.dark,
      _ => ThemeMode.system
    };
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    // Obtain shared preferences.
    final SharedPreferences prefs = await _prefs;
    // Save an String value to 'themeMode' key.
    await prefs.setString('themeMode', theme.toString());
  }

  /// Clear the user's preferred ThemeMode from local or remote storage.
  Future<void> clearThemeMode() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await _prefs;
    // Save an String value to 'themeMode' key.
    await prefs.remove('themeMode');
  }
}
