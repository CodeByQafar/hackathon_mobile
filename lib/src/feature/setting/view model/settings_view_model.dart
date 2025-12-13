import 'package:flutter/material.dart';
import '../../../core/cache/cache_service.dart';
import '../../../core/cache/user_cache.dart';
import '../../../core/components/alert dialog/language_alert_dialog.dart';
import '../../../core/components/alert dialog/logout_dialog.dart';

class SettingsViewModel extends ChangeNotifier {
  ThemeMode _themeMode = GlobalUserCache.themeMode;
  ThemeMode get themeMode => _themeMode;

  SettingsViewModel() {
    _themeMode = GlobalUserCache.themeMode;
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    GlobalUserCache.themeMode = _themeMode;

    CacheService.instance.write(
      "theme_mode",
      _themeMode == ThemeMode.light ? "light" : "dark",
    );

    print("Theme changed: $_themeMode");
    print("Cached theme value: ${GlobalUserCache.themeMode}");

    notifyListeners();
  }

  String? get token => GlobalUserCache.token;
  String? get email => GlobalUserCache.email;

  void changeLanguage(BuildContext context) {
    showLanguageSelectionDialog(context);
  }

  Future<void> logout(BuildContext context) async {
    bool result = await showLogoutDialog(context);
    if (!result) return;

    GlobalUserCache.clear();

    print("Cache cleared:");
    print("Token: ${GlobalUserCache.token}");
    print("Email: ${GlobalUserCache.email}");
    print("Theme: ${GlobalUserCache.themeMode}");

    notifyListeners();
  }
}
