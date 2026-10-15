/// ثوابت المشروع
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'General Theme Studio';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appAuthor = 'General Studio';

  // FUTO Theme Format
  static const String themeFormatVersion = '1.0';
  static const String themeFileExtension = '.zip';
  static const String themeConfigFile = 'theme.txt';
  static const String themeReadmeFile = 'README.md';
  static const String themeLicenseFile = 'LICENSE.txt';

  // Asset sizes
  static const int borderAssetWidth = 128;
  static const int borderAssetHeight = 140;
  static const int iconAssetSize = 64;
  static const int targetDensity = 640;

  // 9-slice defaults
  static const double defaultSliceTop = 16.0;
  static const double defaultSliceRight = 16.0;
  static const double defaultSliceBottom = 16.0;
  static const double defaultSliceLeft = 16.0;

  // File limits
  static const int maxAssetSizeBytes = 12 * 1024 * 1024;
  static const int maxFontSizeBytes = 8 * 1024 * 1024;
  static const int maxThemeNameLength = 45;

  // Prefs keys
  static const String prefThemeMode = 'settings.theme_mode';
  static const String prefLocale = 'settings.locale';
  static const String prefSavedProjects = 'projects.saved';

  // Defaults
  static const double defaultRoundedness = 0.5;
  static const double defaultScaleText = 1.0;
  static const double defaultScaleHints = 0.9;

  // Asset names
  static const String assetButtonDefault = 'Button-default.png';
  static const String assetButtonFunction = 'Button-function.png';
  static const String assetButtonSpace = 'Button-space.png';
  static const String assetButtonPressed = 'Button-pressed.png';
  static const String assetIconBackspace = 'Icon-backspace.png';
  static const String assetIconEnter = 'Icon-enter.png';
  static const String assetIconShift = 'Icon-shift.png';
  static const String assetIconEmoji = 'Icon-emoji.png';

  // FUTO Selectors
  static const List<String> futoSelectors = [
    'normal',
    'functional',
    'spacebar',
    'action',
    'icon delete_key',
    'icon enter_key',
    'icon shift_key',
    'icon action_emoji',
    'icon settings',
    'icon language_switch',
    'pressed',
    'popup',
    'morekeysbox',
    'morekey',
    'morekey pressed',
  ];

  // Arabic labels for selectors
  static const Map<String, String> selectorLabelsAr = {
    'normal': 'أزرار الكتابة',
    'functional': 'الأزرار الوظيفية',
    'spacebar': 'زر المسافة',
    'action': 'زر Enter',
    'icon delete_key': 'زر الحذف',
    'icon enter_key': 'زر Enter',
    'icon shift_key': 'زر Shift',
    'icon action_emoji': 'زر الإيموجي',
    'icon settings': 'زر الإعدادات',
    'icon language_switch': 'زر اللغة',
    'pressed': 'عند الضغط',
    'popup': 'نافذة الحرف',
    'morekeysbox': 'صندوق الحروف',
    'morekey': 'حرف إضافي',
    'morekey pressed': 'حرف إضافي مضغوط',
  };
}
