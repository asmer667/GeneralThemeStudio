import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// مصدر Palettes مجاني
enum PaletteSource {
  coolors,      // Coolors.co — trending palettes
  colormind,    // Colormind.io — AI palettes
  colorhunt,    // Color Hunt — curated palettes
  uigradients,  // UI Gradients — gradients ready
}

extension PaletteSourceExt on PaletteSource {
  String get label {
    switch (this) {
      case PaletteSource.coolors:
        return 'Coolors';
      case PaletteSource.colormind:
        return 'Colormind AI';
      case PaletteSource.colorhunt:
        return 'Color Hunt';
      case PaletteSource.uigradients:
        return 'UI Gradients';
    }
  }

  String get description {
    switch (this) {
      case PaletteSource.coolors:
        return 'ألوان شائعة من مجتمع Coolors';
      case PaletteSource.colormind:
        return 'توليد ذكي بالذكاء الاصطناعي';
      case PaletteSource.colorhunt:
        return 'لوحات مختارة بعناية';
      case PaletteSource.uigradients:
        return 'تدرجات جاهزة احترافية';
    }
  }

  IconData get icon {
    switch (this) {
      case PaletteSource.coolors:
        return Icons.palette;
      case PaletteSource.colormind:
        return Icons.auto_awesome;
      case PaletteSource.colorhunt:
        return Icons.color_lens;
      case PaletteSource.uigradients:
        return Icons.gradient;
    }
  }

  Color get color {
    switch (this) {
      case PaletteSource.coolors:
        return const Color(0xFF16D9F2);
      case PaletteSource.colormind:
        return const Color(0xFF8B5CF6);
      case PaletteSource.colorhunt:
        return const Color(0xFFFF6B9D);
      case PaletteSource.uigradients:
        return const Color(0xFF10E5A0);
    }
  }
}

/// نموذج palette من الإنترنت
class OnlinePalette {
  final String id;
  final String name;
  final List<Color> colors;
  final String? author;
  final String source;
  final bool isGradient;

  const OnlinePalette({
    required this.id,
    required this.name,
    required this.colors,
    this.author,
    this.source = 'Unknown',
    this.isGradient = false,
  });

  /// عرض مسبق كتدرج
  Gradient toGradient() {
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// خدمة جلب Palettes من الإنترنت
class PaletteApi {
  PaletteApi._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': 'GeneralThemeStudio/1.0',
      },
    ),
  );

  // ═══════════════════════════════════════════
  // Fetch All
  // ═══════════════════════════════════════════

  /// جلب palettes من مصدر معيّن
  static Future<List<OnlinePalette>> fetchPalettes({
    PaletteSource source = PaletteSource.coolors,
    int count = 20,
  }) async {
    switch (source) {
      case PaletteSource.coolors:
        return _fetchCoolorsTrending(count);
      case PaletteSource.colormind:
        return _fetchColormindAI(count);
      case PaletteSource.colorhunt:
        return _fetchColorHunt(count);
      case PaletteSource.uigradients:
        return _fetchUIGradients();
    }
  }

  // ═══════════════════════════════════════════
  // Coolors — Trending (Source: coolors.co من خلال GitHub)
  // ═══════════════════════════════════════════

  static Future<List<OnlinePalette>> _fetchCoolorsTrending(int count) async {
    // Coolors لا يوفر API مجاني — نستخدم palettes عامة من GitHub
    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/experience-monks/coolors-palettes/master/data/palettes.json',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> list;

        if (data is List) {
          list = data;
        } else if (data is Map && data.containsKey('palettes')) {
          list = data['palettes'] as List;
        } else {
          list = [];
        }

        final palettes = <OnlinePalette>[];
        for (int i = 0; i < list.length && palettes.length < count; i++) {
          try {
            final item = list[i];
            final colors = <Color>[];

            if (item is Map && item['colors'] is List) {
              for (final c in item['colors']) {
                final hex = c.toString().replaceAll('#', '');
                if (hex.length == 6) {
                  colors.add(Color(int.parse('FF$hex', radix: 16)));
                }
              }
            }

            if (colors.length >= 2) {
              palettes.add(OnlinePalette(
                id: 'coolors_$i',
                name: 'Palette ${i + 1}',
                colors: colors,
                source: 'Coolors',
              ));
            }
          } catch (_) {}
        }

        if (palettes.isNotEmpty) return palettes;
      }
    } catch (e) {
      debugPrint('Coolors error: $e');
    }

    // Fallback: palettes مشهورة
    return _fallbackCoolors(count);
  }

  // ═══════════════════════════════════════════
  // Colormind — AI Palettes
  // ═══════════════════════════════════════════

  static Future<List<OnlinePalette>> _fetchColormindAI(int count) async {
    // Colormind API مجاني
    final palettes = <OnlinePalette>[];

    try {
      for (int i = 0; i < (count / 5).ceil() && palettes.length < count; i++) {
        try {
          final response = await _dio.post(
            'http://colormind.io/api/',
            data: '{"model":"default"}',
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
          );

          if (response.statusCode == 200) {
            final data = response.data is String
                ? jsonDecode(response.data as String)
                : response.data;

            if (data is Map && data['result'] is List) {
              final rgbList = data['result'] as List;
              final colors = rgbList
                  .map<Color>((rgb) => Color.fromRGBO(
                        (rgb[0] as num).toInt(),
                        (rgb[1] as num).toInt(),
                        (rgb[2] as num).toInt(),
                        1,
                      ))
                  .toList();

              if (colors.isNotEmpty) {
                palettes.add(OnlinePalette(
                  id: 'colormind_${i}_${DateTime.now().millisecondsSinceEpoch}',
                  name: 'AI Palette ${palettes.length + 1}',
                  colors: colors,
                  source: 'Colormind',
                ));
              }
            }
          }
        } catch (e) {
          debugPrint('Colormind iteration error: $e');
        }
      }
    } catch (e) {
      debugPrint('Colormind error: $e');
    }

    // إضافة fallbacks
    if (palettes.length < count) {
      palettes.addAll(_fallbackColormind(count - palettes.length));
    }

    return palettes;
  }

  // ═══════════════════════════════════════════
  // Color Hunt — curated palettes
  // ═══════════════════════════════════════════

  static Future<List<OnlinePalette>> _fetchColorHunt(int count) async {
    // Color Hunt — قائمة من GitHub
    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/EMLGTM/colorhunt_scraper/master/colorhunt.json',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          final palettes = <OnlinePalette>[];
          for (int i = 0; i < data.length && palettes.length < count; i++) {
            try {
              final item = data[i];
              final colors = <Color>[];

              if (item is Map && item['colors'] is List) {
                for (final c in item['colors']) {
                  final hex = c.toString().replaceAll('#', '');
                  if (hex.length == 6) {
                    colors.add(Color(int.parse('FF$hex', radix: 16)));
                  }
                }
              }

              if (colors.length >= 2) {
                palettes.add(OnlinePalette(
                  id: 'ch_$i',
                  name: item['name']?.toString() ?? 'Palette ${i + 1}',
                  colors: colors,
                  source: 'Color Hunt',
                ));
              }
            } catch (_) {}
          }

          if (palettes.isNotEmpty) return palettes;
        }
      }
    } catch (e) {
      debugPrint('ColorHunt error: $e');
    }

    return _fallbackColorHunt(count);
  }

  // ═══════════════════════════════════════════
  // UI Gradients — تدرجات جاهزة
  // ═══════════════════════════════════════════

  static Future<List<OnlinePalette>> _fetchUIGradients() async {
    // قائمة تدرجات من uigradients (مصدر ثابت — موثوق)
    const gradients = [
      ['FF0099', '493240', 'Grade Grey'],
      ['00b09b', '96c93d', 'Green Beach'],
      ['2F7336', 'AA3A38', 'Piggy Pink'],
      ['1e130c', '9a8478', 'Inbox'],
      ['ee9ca7', 'ffdde1', 'Sweet Morning'],
      ['FF4B2B', 'FF416C', 'Bloody Mary'],
      ['355C7D', '6C5B7B', 'Kashmir'],
      ['2193b0', '6dd5ed', 'Sexy Blue'],
      ['1e3c72', '2a5298', 'Royal Blue'],
      ['ff7e5f', 'feb47b', 'Sunset'],
      ['141E30', '243B55', 'Dark Ocean'],
      ['8E2DE2', '4A00E0', 'Purple Love'],
      ['FC466B', '3F5EFB', 'Hyper'],
      ['FDC830', 'F37335', 'Orange Fun'],
      ['00C9FF', '92FE9D', 'Mountain Rock'],
      ['F953C6', 'B91D73', 'Pink Flavour'],
      ['7F00FF', 'E100FF', 'Purple Pink'],
      ['12c2e9', 'c471ed', 'JShine'],
      ['FF512F', 'DD2476', 'Passion'],
      ['0575E6', '021B79', 'Deep Blue'],
    ];

    return gradients.map((g) {
      return OnlinePalette(
        id: 'uig_${g[0]}_${g[1]}',
        name: g[2],
        colors: [
          Color(int.parse('FF${g[0]}', radix: 16)),
          Color(int.parse('FF${g[1]}', radix: 16)),
        ],
        source: 'UI Gradients',
        isGradient: true,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════
  // Fallback — palettes مشهورة
  // ═══════════════════════════════════════════

  static List<OnlinePalette> _fallbackCoolors(int count) {
    const palettes = [
      ['16D9F2', '8B5CF6', 'FF6B9D', '10E5A0'],
      ['FF9500', 'FF6B9D', '8B5CF6'],
      ['00BCD4', '2196F3', '3F51B5'],
      ['F44336', '9C27B0', '673AB7'],
      ['4CAF50', '8BC34A', 'CDDC39'],
      ['FFC107', 'FF9800', 'FF5722'],
      ['795548', '5D4037', '3E2723'],
      ['607D8B', '455A64', '263238'],
      ['E91E63', 'F06292', 'F8BBD0'],
      ['009688', '4DB6AC', 'B2DFDB'],
      ['FF5722', 'FF7043', 'FFAB91'],
      ['3F51B5', '5C6BC0', '9FA8DA'],
      ['9C27B0', 'AB47BC', 'CE93D8'],
      ['F44336', 'E53935', 'EF5350'],
      ['FFEB3B', 'FDD835', 'FBC02D'],
      ['4CAF50', '43A047', '66BB6A'],
      ['2196F3', '1E88E5', '42A5F5'],
      ['FF9800', 'FB8C00', 'FFA726'],
      ['673AB7', '5E35B1', '7E57C2'],
      ['009688', '00897B', '26A69A'],
    ];

    return List.generate(count, (i) {
      final p = palettes[i % palettes.length];
      return OnlinePalette(
        id: 'fallback_coolors_$i',
        name: 'Palette ${i + 1}',
        colors: p.map((h) => Color(int.parse('FF$h', radix: 16))).toList(),
        source: 'Coolors',
      );
    });
  }

  static List<OnlinePalette> _fallbackColormind(int count) {
    // توليد palettes عشوائية بألوان منسقة
    final palettes = <OnlinePalette>[];
    final baseColors = [
      const Color(0xFF16D9F2),
      const Color(0xFF8B5CF6),
      const Color(0xFFFF6B9D),
      const Color(0xFF10E5A0),
      const Color(0xFFFF9500),
      const Color(0xFF3B82F6),
    ];

    for (int i = 0; i < count; i++) {
      final shuffled = List<Color>.from(baseColors);
      shuffled.shuffle();
      palettes.add(OnlinePalette(
        id: 'fallback_cm_$i',
        name: 'AI Palette ${i + 1}',
        colors: shuffled.take(5).toList(),
        source: 'Colormind',
      ));
    }
    return palettes;
  }

  static List<OnlinePalette> _fallbackColorHunt(int count) {
    const curated = [
      ['264653', '2A9D8F', 'E9C46A', 'F4A261', 'E76F51'],
      ['003049', 'D62828', 'F77F00', 'FCBF49', 'EAE2B7'],
      ['0B090A', '161A1D', '660708', 'A4161A', 'BA181B'],
      ['F8F9FA', 'E9ECEF', 'DEE2E6', 'CED4DA', 'ADB5BD'],
      ['FFB703', 'FB8500', '219EBC', '023047', '8ECAE6'],
      ['FFCDB2', 'FFB4A2', 'E5989B', 'B5838D', '6D6875'],
      ['8ECAE6', '219EBC', '023047', 'FFB703', 'FB8500'],
      ['CDB4DB', 'FFC8DD', 'FFAFCC', 'BDE0FE', 'A2D2FF'],
      ['F72585', '7209B7', '560BAD', '480CA8', '3A0CA3'],
      ['D4E09B', 'F6F4D2', 'CBDFBD', 'F19C79', 'A44A3F'],
    ];

    return List.generate(count, (i) {
      final p = curated[i % curated.length];
      return OnlinePalette(
        id: 'fallback_ch_$i',
        name: 'Curated ${i + 1}',
        colors: p.map((h) => Color(int.parse('FF$h', radix: 16))).toList(),
        source: 'Color Hunt',
      );
    });
  }
}
