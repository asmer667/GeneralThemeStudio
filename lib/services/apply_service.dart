import 'package:flutter/material.dart';

import '../models/apply_target.dart';
import '../models/background_asset.dart';
import '../models/border_asset.dart';
import '../models/gradient_preset.dart';
import '../models/key_shape.dart';
import '../models/theme_project.dart';

/// خدمة تطبيق الألوان/التدرجات/الأشكال على نطاقات مختلفة
class ApplyService {
  ApplyService._();

  /// تطبيق لون على نطاق
  static ThemeProject applyColor({
    required ThemeProject project,
    required Color color,
    required ApplySelection selection,
    bool useGradient = false,
  }) {
    switch (selection.target) {
      case ApplyTarget.keyboardBackground:
      case ApplyTarget.keyBackground:
      case ApplyTarget.screenBackground:
        return project.copyWith(
          keyboardSurface: color,
          keyboardContainer: color,
          updatedAt: DateTime.now(),
        );
      case ApplyTarget.spacebar:
        return _applyToGroup(
          project: project,
          selector: 'spacebar',
          color: color,
        );
      case ApplyTarget.deleteKey:
        return _applyToGroup(
          project: project,
          selector: 'icon delete_key',
          color: color,
        );
      case ApplyTarget.enterKey:
        return _applyToGroup(
          project: project,
          selector: 'icon enter_key',
          color: color,
        );
      case ApplyTarget.emojiKey:
        return _applyToGroup(
          project: project,
          selector: 'icon action_emoji',
          color: color,
        );
      case ApplyTarget.shiftKey:
        return _applyToGroup(
          project: project,
          selector: 'icon shift_key',
          color: color,
        );
      case ApplyTarget.symbolsKey:
        return _applyToGroup(
          project: project,
          selector: 'functional',
          color: color,
        );
      case ApplyTarget.lettersRow:
      case ApplyTarget.allKeys:
        return _applyToGroup(
          project: project,
          selector: 'normal',
          color: color,
        );
      case ApplyTarget.functionalKeys:
        return _applyToGroup(
          project: project,
          selector: 'functional',
          color: color,
        );
      case ApplyTarget.customGroup:
        return _applyToGroup(
          project: project,
          selector: selection.customGroupId ?? '',
          color: color,
        );
      default:
        return project;
    }
  }

  /// تطبيق تدرج على نطاق
  static ThemeProject applyGradient({
    required ThemeProject project,
    required GradientPreset gradient,
    required ApplySelection selection,
  }) {
    final updatedGroups = project.groups.map((g) {
      if (selection.target == ApplyTarget.allKeys ||
          g.selector == selection.effectiveSelector) {
        return g.copyWith(gradient: gradient);
      }
      return g;
    }).toList();

    // إذا كان النطاق خلفية → استخدم أول لون في التدرج
    if (selection.target == ApplyTarget.keyboardBackground ||
        selection.target == ApplyTarget.keyBackground ||
        selection.target == ApplyTarget.screenBackground) {
      final firstColor = gradient.colors.isNotEmpty
          ? gradient.colors.first
          : project.keyboardSurface;
      return project.copyWith(
        keyboardSurface: firstColor,
        updatedAt: DateTime.now(),
      );
    }

    return project.copyWith(
      groups: updatedGroups,
      updatedAt: DateTime.now(),
    );
  }

  /// تطبيق شكل على نطاق
  static ThemeProject applyShape({
    required ThemeProject project,
    required KeyShape shape,
    required ApplySelection selection,
  }) {
    if (selection.target == ApplyTarget.allKeys) {
      final updated = project.groups.map((g) {
        return g.copyWith(shape: shape);
      }).toList();
      return project.copyWith(
        groups: updated,
        updatedAt: DateTime.now(),
      );
    }

    final updated = project.groups.map((g) {
      if (g.selector == selection.effectiveSelector) {
        return g.copyWith(shape: shape);
      }
      return g;
    }).toList();

    return project.copyWith(
      groups: updated,
      updatedAt: DateTime.now(),
    );
  }

  /// تطبيق خلفية على نطاق
  static ThemeProject applyBackground({
    required ThemeProject project,
    required BackgroundAsset background,
    required ApplySelection selection,
  }) {
    return project.copyWith(
      backgroundAsset: background,
      updatedAt: DateTime.now(),
    );
  }

  // ═══════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════

  static ThemeProject _applyToGroup({
    required ThemeProject project,
    required String selector,
    required Color color,
  }) {
    final updated = project.groups.map((g) {
      if (g.selector == selector || selector == 'all') {
        final border = g.border ??
            BorderAsset.createDefault(
              name: 'Button-${g.selector.replaceAll(" ", "_")}.png',
              shape: g.shape,
              backgroundTint: color,
            );
        return g.copyWith(border: border.copyWith(backgroundTint: color));
      }
      return g;
    }).toList();

    return project.copyWith(
      groups: updated,
      updatedAt: DateTime.now(),
    );
  }
}
