import 'package:flutter/material.dart';

/// أدوات التعامل مع الألوان
class ColorUtils {
  ColorUtils._();

  /// تحويل لون إلى HEX (RRGGBBAA)
  static String toHex(Color color) {
    final r = color.red.toRadixString(16).padLeft(2, '0');
    final g = color.green.toRadixString(16).padLeft(2, '0');
    final b = color.blue.toRadixString(16).padLeft(2, '0');
    final a = color.alpha.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b$a'.toUpperCase();
  }

  /// HEX بدون شفافية
  static String toHexRgb(Color color) {
    final r = color.red.toRadixString(16).padLeft(2, '0');
    final g = color.green.toRadixString(16).padLeft(2, '0');
    final b = color.blue.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  /// من نص HEX
  static Color fromHex(String hex) {
    String h = hex.replaceAll('#', '').trim();
    if (h.length == 3) {
      h = '${h[0]}${h[0]}${h[1]}${h[1]}${h[2]}${h[2]}';
    }
    if (h.length == 6) h = '${h}FF';
    if (h.length == 8) {
      try {
        return Color(int.parse(h, radix: 16));
      } catch (_) {
        return const Color(0xFF000000);
      }
    }
    return const Color(0xFF000000);
  }

  /// تعديل السطوع
  static Color adjustBrightness(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final newLightness = (hsl.lightness + factor).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  /// لون متباين (أبيض أو أسود)
  static Color getContrastingColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  /// خلط لونين
  static Color blend(Color a, Color b, double t) {
    return Color.lerp(a, b, t) ?? a;
  }

  /// شفافية
  static Color opaque(Color color) => color.withOpacity(1.0);
  static Color withAlpha(Color color, double alpha) =>
      color.withOpacity(alpha);

  /// فرق بين لونين
  static double difference(Color a, Color b) {
    final dr = (a.red - b.red).abs() / 255.0;
    final dg = (a.green - b.green).abs() / 255.0;
    final db = (a.blue - b.blue).abs() / 255.0;
    return (dr + dg + db) / 3.0;
  }

  /// تباين ضعيف؟
  static bool isLowContrast(Color foreground, Color background) {
    return difference(foreground, background) < 0.15;
  }

  /// سلسلة تدرجات من لون
  static List<Color> generateContainerScale(Color surface) {
    final hsl = HSLColor.fromColor(surface);
    return [
      hsl.withLightness((hsl.lightness + 0.03).clamp(0.0, 1.0)).toColor(),
      hsl.withLightness((hsl.lightness + 0.07).clamp(0.0, 1.0)).toColor(),
      hsl.withLightness((hsl.lightness + 0.12).clamp(0.0, 1.0)).toColor(),
      hsl.withLightness((hsl.lightness + 0.17).clamp(0.0, 1.0)).toColor(),
      hsl.withLightness((hsl.lightness + 0.22).clamp(0.0, 1.0)).toColor(),
    ];
  }

  /// اسم عربي للون
  static String toArabicName(Color color) {
    final hsl = HSLColor.fromColor(color);
    final hue = hsl.hue;
    final sat = hsl.saturation;
    final light = hsl.lightness;

    if (sat < 0.1) {
      if (light > 0.9) return 'أبيض';
      if (light < 0.1) return 'أسود';
      if (light > 0.7) return 'رمادي فاتح';
      if (light < 0.3) return 'رمادي داكن';
      return 'رمادي';
    }

    if (hue < 15 || hue >= 345) return 'أحمر';
    if (hue < 45) return 'برتقالي';
    if (hue < 70) return 'أصفر';
    if (hue < 160) return 'أخضر';
    if (hue < 200) return 'سماوي';
    if (hue < 250) return 'أزرق';
    if (hue < 290) return 'بنفسجي';
    if (hue < 345) return 'وردي';
    return 'لون';
  }

  /// نسخة أفتح
  static Color lighten(Color color, [double amount = 0.1]) =>
      adjustBrightness(color, amount);

  /// نسخة أغمق
  static Color darken(Color color, [double amount = 0.1]) =>
      adjustBrightness(color, -amount);

  /// تدرج خطي
  static LinearGradient gradient(Color a, Color b) {
    return LinearGradient(
      colors: [a, b],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
