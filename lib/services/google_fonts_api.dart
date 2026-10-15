import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../data/fonts/fonts_catalog.dart';

/// خدمة الاتصال بـ Google Fonts API
/// تجلب جميع الخطوط المتاحة (~2000 خط)
class GoogleFontsApi {
  GoogleFontsApi._();

  static const String _apiKey = 'AIzaSyD-placeholder';
  static const String _baseUrl = 'https://www.googleapis.com/webfonts/v1/webfonts';
  static const String _fontsCssUrl = 'https://fonts.googleapis.com/css2';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': 'GeneralThemeStudio/1.0',
      },
    ),
  );

  // Cache in memory
  static List<GoogleFont>? _cachedFonts;

  /// جلب كل الخطوط المتاحة من Google Fonts
  /// ملاحظة: نستخدم طريقة بديلة بدون API Key (مصدر مفتوح)
  static Future<List<GoogleFont>> fetchAllFonts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedFonts != null) {
      return _cachedFonts!;
    }

    try {
      // استخدام GitHub Mirror — أسرع وأكثر استقراراً
      final response = await _dio.get(
        'https://raw.githubusercontent.com/jonathantneal/google-fonts-complete/master/api-response.json',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final fonts = <GoogleFont>[];

        data.forEach((key, value) {
          try {
            fonts.add(GoogleFont.fromGoogleFontsComplete(key, value));
          } catch (e) {
            // تجاهل الخطوط غير الصالحة
          }
        });

        _cachedFonts = fonts;
        return fonts;
      }
    } catch (e) {
      debugPrint('GoogleFontsApi error: $e');
    }

    // Fallback: static list
    return _fallbackFonts();
  }

  /// جلب الخطوط مع الفلترة حسب اللغة
  static Future<List<GoogleFont>> fetchBySubset({
    required String subset,
  }) async {
    final all = await fetchAllFonts();
    return all.where((f) => f.subsets.contains(subset)).toList();
  }

  /// الخطوط العربية فقط
  static Future<List<GoogleFont>> fetchArabicFonts() async {
    return fetchBySubset(subset: 'arabic');
  }

  /// الخطوط اللاتينية
  static Future<List<GoogleFont>> fetchLatinFonts() async {
    return fetchBySubset(subset: 'latin');
  }

  /// بحث
  static Future<List<GoogleFont>> search(String query) async {
    final all = await fetchAllFonts();
    if (query.trim().isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((f) =>
        f.family.toLowerCase().contains(q) ||
        f.category.toLowerCase().contains(q)).toList();
  }

  /// جلب تفاصيل خط واحد
  static Future<GoogleFont?> getFont(String family) async {
    final all = await fetchAllFonts();
    try {
      return all.firstWhere(
        (f) => f.family.toLowerCase() == family.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// الحصول على رابط TTF مباشر لخط
  static String getTtfUrl(String family, {String weight = '400'}) {
    // Google Fonts direct download URL
    return 'https://fonts.gstatic.com/s/$family/v1/${family.replaceAll(" ", "")}-${weight}.ttf';
  }

  /// جلب الخط من Google Fonts CSS (طريقة أكثر دقة)
  static Future<String?> getFontFileUrl(
    GoogleFont font, {
    String weight = '400',
  }) async {
    try {
      final family = font.family.replaceAll(' ', '+');
      final url = '$_fontsCssUrl?family=$family:$weight&display=swap';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
          responseType: ResponseType.plain,
        ),
      );

      final css = response.data as String;
      // استخراج رابط TTF من CSS
      final regex = RegExp(r'url\((https://[^)]+\.(?:ttf|woff2?))\)');
      final match = regex.firstMatch(css);

      if (match != null) {
        return match.group(1);
      }
      return null;
    } catch (e) {
      debugPrint('getFontFileUrl error: $e');
      return null;
    }
  }

  /// Fallback - قائمة ثابتة للخطوط الشائعة
  static List<GoogleFont> _fallbackFonts() {
    final builtIn = FontsCatalog.fonts;
    return builtIn.map((f) => GoogleFont(
      family: f.family,
      category: 'sans-serif',
      variants: const ['regular'],
      subsets: f.language == 'ar' ? const ['arabic'] : const ['latin'],
      version: 'v1',
      lastModified: DateTime.now().toIso8601String(),
    )).toList();
  }
}

/// نموذج خط Google
class GoogleFont {
  final String family;
  final String category; // sans-serif | serif | display | handwriting | monospace
  final List<String> variants;
  final List<String> subsets;
  final String version;
  final String lastModified;

  const GoogleFont({
    required this.family,
    required this.category,
    required this.variants,
    required this.subsets,
    required this.version,
    required this.lastModified,
  });

  /// بناء من API response
  factory GoogleFont.fromJson(Map<String, dynamic> json) {
    return GoogleFont(
      family: json['family'] as String,
      category: json['category'] as String? ?? 'sans-serif',
      variants: List<String>.from(json['variants'] ?? ['regular']),
      subsets: List<String>.from(json['subsets'] ?? ['latin']),
      version: json['version'] as String? ?? 'v1',
      lastModified: json['lastModified'] as String? ?? '',
    );
  }

  /// بناء من google-fonts-complete
  factory GoogleFont.fromGoogleFontsComplete(String family, dynamic data) {
    final variants = <String>[];
    final subsets = <String>[];

    if (data is Map<String, dynamic>) {
      final variantsData = data['variants'];
      if (variantsData is Map) {
        variantsData.forEach((key, _) {
          variants.add(key.toString());
        });
      }
      final subsetsData = data['subsets'];
      if (subsetsData is Map) {
        subsetsData.forEach((key, _) {
          subsets.add(key.toString());
        });
      }
      if (subsets.isEmpty) {
        subsets.add('latin');
      }
    }

    return GoogleFont(
      family: family,
      category: data is Map ? (data['category'] ?? 'sans-serif') : 'sans-serif',
      variants: variants.isEmpty ? ['regular'] : variants,
      subsets: subsets,
      version: 'v1',
      lastModified: DateTime.now().toIso8601String(),
    );
  }

  /// هل الخط يدعم العربية؟
  bool get supportsArabic => subsets.contains('arabic');

  /// هل الخط لاتيني؟
  bool get supportsLatin => subsets.contains('latin');

  /// هل الخط شائع؟
  bool get isPopular {
    const popular = [
      'Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Poppins',
      'Inter', 'Raleway', 'Ubuntu', 'Nunito', 'Oswald',
      'Cairo', 'Tajawal', 'Almarai', 'Amiri', 'Changa',
      'El Messiri', 'Harmattan', 'Mada', 'Noto Sans Arabic',
    ];
    return popular.contains(family);
  }

  /// الأيقونة المرئية حسب الفئة
  String get categoryLabel {
    switch (category) {
      case 'serif':
        return 'Serif';
      case 'sans-serif':
        return 'Sans';
      case 'display':
        return 'Display';
      case 'handwriting':
        return 'Script';
      case 'monospace':
        return 'Mono';
      default:
        return category;
    }
  }
}
