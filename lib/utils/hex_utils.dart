import 'package:flutter/material.dart';

/// أدوات HEX
class HexUtils {
  HexUtils._();

  /// تحويل نص HEX إلى Color (يقبل #RGB, #RRGGBB, #RRGGBBAA)
  static Color? parse(String? hex) {
    if (hex == null) return null;
    var h = hex.trim().replaceAll('#', '');
    if (h.isEmpty) return null;

    if (h.length == 3) {
      h = '${h[0]}${h[0]}${h[1]}${h[1]}${h[2]}${h[2]}';
    }
    if (h.length == 6) h = '${h}FF';
    if (h.length != 8) return null;

    try {
      return Color(int.parse(h, radix: 16));
    } catch (_) {
      return null;
    }
  }

  /// مع قيمة افتراضية
  static Color parseOrDefault(String? hex, Color fallback) {
    return parse(hex) ?? fallback;
  }

  /// Color إلى HEX كامل
  static String toHex8(Color color) {
    final r = _hex2(color.r);
    final g = _hex2(color.g);
    final b = _hex2(color.b);
    final a = _hex2(color.a);
    return '#$r$g$b$a'.toUpperCase();
  }

  /// Color إلى HEX بدون شفافية
  static String toHex6(Color color) {
    final r = _hex2(color.r);
    final g = _hex2(color.g);
    final b = _hex2(color.b);
    return '#$r$g$b'.toUpperCase();
  }

  /// بدون #
  static String toNumbersOnly(Color color) =>
      toHex8(color).replaceAll('#', '');

  static String _hex2(double v) {
    return (v * 255).round().toRadixString(16).padLeft(2, '0');
  }

  /// صالح؟
  static bool isValid(String? hex) => parse(hex) != null;

  /// يحتوي على شفافية؟
  static bool hasAlpha(String? hex) {
    if (hex == null) return false;
    return hex.replaceAll('#', '').length == 8;
  }

  /// إلى RGB
  static Map<String, int> toRgb(Color color) => {
        'r': (color.r * 255).round(),
        'g': (color.g * 255).round(),
        'b': (color.b * 255).round(),
      };

  /// إلى RGBA
  static Map<String, int> toRgba(Color color) => {
        'r': (color.r * 255).round(),
        'g': (color.g * 255).round(),
        'b': (color.b * 255).round(),
        'a': (color.a * 255).round(),
      };

  /// من RGB
  static Color fromRgb(int r, int g, int b, [int a = 255]) =>
      Color.fromARGB(a, r, g, b);

  /// صيغة FUTO (RRGGBBAA بدون #)
  static String toFutoFormat(Color color) =>
      toHex8(color).replaceAll('#', '');

  /// من صيغة FUTO
  static Color fromFutoFormat(String futo) =>
      parseOrDefault(futo, Colors.black);

  /// قائمة ألوان إلى HEX
  static List<String> colorsToHex(List<Color> colors) =>
      colors.map(toHex8).toList();

  /// قائمة HEX إلى ألوان
  static List<Color> hexToColors(List<String> hexList) =>
      hexList.map((h) => parseOrDefault(h, Colors.black)).toList();
}
