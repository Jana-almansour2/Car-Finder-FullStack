import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided');
});

class LanguageNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const String _key = 'selected_language';

  LanguageNotifier(this._prefs) : super(_prefs.getString(_key) ?? 'en');

  Future<void> setLanguage(String lang) async {
    state = lang;
    await _prefs.setString(_key, lang);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref.watch(sharedPreferencesProvider));
});

class DarkModeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const String _key = 'is_dark_mode';

  DarkModeNotifier(this._prefs) : super(_prefs.getBool(_key) ?? false);

  Future<void> toggleDarkMode(bool isDark) async {
    state = isDark;
    await _prefs.setBool(_key, isDark);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(ref.watch(sharedPreferencesProvider));
});
