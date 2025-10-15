// lib/theme_management/theme_preference_manager.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'theme_enum.dart';

class ThemePreferenceManager {
  static const _themeKey = 'app_theme_preference';

  Future<ThemeOption> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);

    if (themeName != null) {
      try {
        return ThemeOption.values.firstWhere(
              (e) => e.toString() == 'ThemeOption.$themeName',
        );
      } catch (_) {
        return ThemeOption.system;
      }
    }
    return ThemeOption.system;
  }

  Future<void> saveTheme(ThemeOption option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, option.name);
  }
}