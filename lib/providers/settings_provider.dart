import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// إعدادات التطبيق
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  bool _hapticFeedback = true;
  bool get hapticFeedback => _hapticFeedback;

  bool _autoSave = true;
  bool get autoSave => _autoSave;

  bool _showGrid = true;
  bool get showGrid => _showGrid;

  bool _onboardingDone = false;
  bool get onboardingDone => _onboardingDone;

  String _defaultExportName = 'my_theme';
  String get defaultExportName => _defaultExportName;

  SettingsProvider() {
    _load();
  }

  // ═══ Load / Save ═══

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt('settings.theme_mode') ?? 2;
    _themeMode = ThemeMode.values[themeModeIndex];

    final localeCode = prefs.getString('settings.locale') ?? 'ar';
    _locale = Locale(localeCode);

    _hapticFeedback = prefs.getBool('settings.haptic') ?? true;
    _autoSave = prefs.getBool('settings.autosave') ?? true;
    _showGrid = prefs.getBool('settings.show_grid') ?? true;
    _onboardingDone = prefs.getBool('app.onboarding_done') ?? false;
    _defaultExportName = prefs.getString('settings.export_name') ?? 'my_theme';

    notifyListeners();
  }

  // ═══ Updates ═══

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('settings.theme_mode', mode.index);
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings.locale', locale.languageCode);
  }

  Future<void> toggleLocale() async {
    await setLocale(
      _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar'),
    );
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings.haptic', value);
  }

  Future<void> setAutoSave(bool value) async {
    _autoSave = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings.autosave', value);
  }

  Future<void> setShowGrid(bool value) async {
    _showGrid = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings.show_grid', value);
  }

  Future<void> setOnboardingDone(bool value) async {
    _onboardingDone = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app.onboarding_done', value);
  }

  Future<void> setDefaultExportName(String value) async {
    _defaultExportName = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings.export_name', value);
  }

  bool get isDark => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';
}
