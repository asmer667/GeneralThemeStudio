import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/border_asset.dart';
import '../models/icon_asset.dart';
import '../models/key_group.dart';
import '../models/theme_project.dart';
import '../utils/color_utils.dart';
import 'zip_service.dart';

/// خدمة استيراد الثيمات
class ThemeImportService {
  ThemeImportService._();

  /// استيراد ثيم من ZIP
  static Future<ThemeProject> importTheme(File zipFile) async {
    final isValid = await ZipService.isValidZip(zipFile);
    if (!isValid) throw Exception('الملف ليس ZIP صالح');

    final contents = await ZipService.readZip(zipFile);

    final themeBytes = contents[AppConstants.themeConfigFile] ??
        contents['theme.toml'];

    if (themeBytes == null || themeBytes.isEmpty) {
      throw Exception('لم يتم العثور على theme.txt');
    }

    final themeText = String.fromCharCodes(themeBytes);
    final parsed = _parseToml(themeText);

    return _buildProject(parsed, contents);
  }

  // ═══ TOML Parsing ═══

  static Map<String, dynamic> _parseToml(String content) {
    final result = <String, dynamic>{};
    final lines = content.split('\n');

    String? currentSection;
    dynamic currentSectionValue;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      if (line.startsWith('[[') && line.endsWith(']]')) {
        final sectionName = line.substring(2, line.length - 2);
        currentSection = sectionName;
        if (!result.containsKey(sectionName)) {
          result[sectionName] = <Map<String, dynamic>>[];
        }
        final arr = result[sectionName] as List;
        final newMap = <String, dynamic>{};
        arr.add(newMap);
        currentSectionValue = newMap;
        continue;
      }

      if (line.startsWith('[') && line.endsWith(']')) {
        final sectionName = line.substring(1, line.length - 1);
        currentSection = sectionName;
        if (!result.containsKey(sectionName)) {
          result[sectionName] = <String, dynamic>{};
        }
        currentSectionValue = result[sectionName];
        continue;
      }

      final eqIndex = line.indexOf('=');
      if (eqIndex == -1) continue;

      final key = line.substring(0, eqIndex).trim();
      final valueStr = line.substring(eqIndex + 1).trim();
      final value = _parseValue(valueStr);

      if (currentSectionValue is Map) {
        currentSectionValue[key] = value;
      } else {
        result[key] = value;
      }
    }

    return result;
  }

  static dynamic _parseValue(String s) {
    if (s.startsWith('"') && s.endsWith('"')) {
      return s.substring(1, s.length - 1);
    }
    if (s.startsWith('[') && s.endsWith(']')) {
      final inner = s.substring(1, s.length - 1);
      if (inner.trim().isEmpty) return <dynamic>[];
      return inner.split(',').map((e) => _parseValue(e.trim())).toList();
    }
    if (s == 'true') return true;
    if (s == 'false') return false;
    if (int.tryParse(s) != null) return int.parse(s);
    if (double.tryParse(s) != null) return double.parse(s);
    return s;
  }

  // ═══ Project Builder ═══

  static Future<ThemeProject> _buildProject(
    Map<String, dynamic> parsed,
    Map<String, Uint8List> contents,
  ) async {
    final name = parsed['name'] ?? 'Imported Theme';
    final author = parsed['author'] ?? 'Unknown';
    final id = parsed['id'] ?? 'imported.${DateTime.now().millisecondsSinceEpoch}';
    final version = parsed['version'] ?? 1;
    final description = parsed['description'] ?? '';

    final colors = parsed['colors'] as Map<String, dynamic>? ?? {};

    Color getColor(String key, Color fallback) {
      final v = colors[key];
      if (v is String) return ColorUtils.fromHex(v);
      return fallback;
    }

    final options = parsed['options'] as Map<String, dynamic>? ?? {};

    return ThemeProject(
      id: id,
      name: name,
      author: author,
      description: description,
      version: version,
      primary: getColor('primary', const Color(0xFF16D9F2)),
      onPrimary: getColor('on_primary', const Color(0xFFFFFFFF)),
      primaryContainer:
          getColor('primary_container', const Color(0xFF16D9F2)),
      onPrimaryContainer:
          getColor('on_primary_container', const Color(0xFF071426)),
      secondary: getColor('secondary', const Color(0xFF8B5CF6)),
      onSecondary: getColor('on_secondary', const Color(0xFFFFFFFF)),
      secondaryContainer:
          getColor('secondary_container', const Color(0xFF183D58)),
      onSecondaryContainer:
          getColor('on_secondary_container', const Color(0xFFF4FAFF)),
      tertiary: getColor('tertiary', const Color(0xFF8B5CF6)),
      onTertiary: getColor('on_tertiary', const Color(0xFFFFFFFF)),
      background: getColor('background', const Color(0xFF071426)),
      onBackground: getColor('on_background', const Color(0xFFF4FAFF)),
      surface: getColor('surface', const Color(0xFF071426)),
      onSurface: getColor('on_surface', const Color(0xFFF4FAFF)),
      surfaceVariant:
          getColor('surface_variant', const Color(0xFF102C43)),
      onSurfaceVariant:
          getColor('on_surface_variant', const Color(0xFFF4FAFF)),
      error: getColor('error', const Color(0xFFC00100)),
      onError: getColor('on_error', const Color(0xFFFFFFFF)),
      outline: getColor('outline', const Color(0xFF327D9D)),
      outlineVariant:
          getColor('outline_variant', const Color(0xFF327D9D)),
      keyboardSurface:
          getColor('keyboard_surface', const Color(0xFF071426)),
      keyboardContainer:
          getColor('keyboard_container', const Color(0xFF102C43)),
      keyboardContainerVariant:
          getColor('keyboard_container_variant', const Color(0xFF183D58)),
      onKeyboardContainer:
          getColor('on_keyboard_container', const Color(0xFFF4FAFF)),
      keyboardPress:
          getColor('keyboard_press', const Color(0xFF16D9F2)),
      keyboardContainerPressed:
          getColor('keyboard_container_pressed', const Color(0xFF204E6C)),
      onKeyboardContainerPressed:
          getColor('on_keyboard_container_pressed', const Color(0xFFF4FAFF)),
      roundedness: (options['roundedness'] as num?)?.toDouble() ?? 0.5,
      scaleText: (options['scale_text'] as num?)?.toDouble() ?? 1.0,
      scaleHints: (options['scale_hints'] as num?)?.toDouble() ?? 0.9,
      weightText: (options['weight_text'] as int?) ?? 400,
      weightHints: (options['weight_hints'] as int?) ?? 400,
      autoBorders: (options['auto_borders'] as bool?) ?? true,
      centerHints: (options['center_hints'] as bool?) ?? false,
      groups: _buildGroups(parsed),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<KeyGroup> _buildGroups(Map<String, dynamic> parsed) {
    final borderAssets = _buildBorderAssets(parsed);
    final iconAssets = _buildIconAssets(parsed);

    final borderRules = (parsed['matchrules.border'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final iconRules = (parsed['matchrules.icon'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    final selectorMap = <String, KeyGroup>{};

    for (final rule in borderRules) {
      final selector = rule['selector'] as String? ?? '';
      final assetName = rule['asset'] as String? ?? '';
      final border = borderAssets[assetName];
      if (border == null) continue;

      final isPressed = selector.contains('pressed');
      final isLongPress = selector.contains('morekey');
      final baseSelector = selector
          .replaceAll('pressed', '')
          .replaceAll('morekey', '')
          .trim();

      if (!selectorMap.containsKey(baseSelector)) {
        selectorMap[baseSelector] = KeyGroup.create(
          name: _getGroupName(baseSelector),
          selector: baseSelector,
        );
      }

      final existing = selectorMap[baseSelector]!;
      if (isPressed) {
        selectorMap[baseSelector] = existing.copyWith(pressedBorder: border);
      } else if (isLongPress) {
        selectorMap[baseSelector] =
            existing.copyWith(longPressBorder: border);
      } else {
        selectorMap[baseSelector] = existing.copyWith(border: border);
      }
    }

    for (final rule in iconRules) {
      final selector = rule['selector'] as String? ?? '';
      final assetName = rule['asset'] as String? ?? '';
      final icon = iconAssets[assetName];
      if (icon == null) continue;

      if (!selectorMap.containsKey(selector)) {
        selectorMap[selector] = KeyGroup.create(
          name: _getGroupName(selector),
          selector: selector,
        );
      }

      selectorMap[selector] =
          selectorMap[selector]!.copyWith(icon: icon);
    }

    return selectorMap.values.toList();
  }

  static Map<String, BorderAsset> _buildBorderAssets(
      Map<String, dynamic> parsed) {
    final result = <String, BorderAsset>{};
    final list =
        (parsed['asset.border'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    for (final item in list) {
      final name = item['name'] as String? ?? '';
      if (name.isEmpty) continue;

      result[name] = BorderAsset(
        id: 'imported_${name.hashCode}',
        name: name,
        backgroundTint: ColorUtils.fromHex(
            item['background_tint'] as String? ?? '#102C43FF'),
        foregroundTint: ColorUtils.fromHex(
            item['foreground_tint'] as String? ?? '#F4FAFFFF'),
        targetDensity: (item['target_density'] as int?) ?? 640,
      );
    }

    return result;
  }

  static Map<String, IconAsset> _buildIconAssets(
      Map<String, dynamic> parsed) {
    final result = <String, IconAsset>{};
    final list =
        (parsed['asset.icon'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    for (final item in list) {
      final name = item['name'] as String? ?? '';
      if (name.isEmpty) continue;

      result[name] = IconAsset(
        id: 'imported_${name.hashCode}',
        name: name,
        type: IconType.customImage,
        targetDensity: (item['target_density'] as int?) ?? 640,
      );
    }

    return result;
  }

  static String _getGroupName(String selector) {
    return AppConstants.selectorLabelsAr[selector] ?? selector;
  }
}
