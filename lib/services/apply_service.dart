import 'package:flutter/material.dart';

import '../models/apply_target.dart';
import '../models/background_asset.dart';
import '../models/border_asset.dart';
import '../models/gradient_preset.dart';
import '../models/key_group.dart';
import '../models/key_shape.dart';
import '../models/theme_project.dart';

/// Applies selected assets to the actual project model (not only to previews).
class ApplyService {
  ApplyService._();

  static ThemeProject applyColor({
    required ThemeProject project,
    required Color color,
    required ApplySelection selection,
    bool useGradient = false,
  }) {
    switch (selection.target) {
      case ApplyTarget.keyboardBackground:
        return project.copyWith(
          keyboardSurface: color,
          keyboardContainer: color,
          updatedAt: DateTime.now(),
        );
      case ApplyTarget.screenBackground:
        return project.copyWith(background: color, updatedAt: DateTime.now());
      case ApplyTarget.keyBackground:
      case ApplyTarget.allKeys:
        final all = _applyColorToGroups(project, color, (g) => true);
        return _applyColorToSelectors(all, color, const [
          'normal row 0', 'normal row -1', 'functional row -1',
          'functional row -1 col 0', 'functional row -1 col 1',
          'functional row -1 col -1', 'icon shift_key', 'icon delete_key',
          'icon action_emoji', 'icon enter_key', 'spacebar',
        ], 'كل الأزرار');
      case ApplyTarget.lettersRow:
        return _applyColorToGroups(project, color,
            (g) => _matches(g, const ['normal', 'letter', 'writing']));
      case ApplyTarget.topRow:
        return _applyColorToSelector(project, 'normal row 0', color, 'الصف العلوي');
      case ApplyTarget.bottomRow:
        return _applyColorToSelectors(project, color, const [
          'normal row -1', 'functional row -1', 'functional row -1 col 0',
          'functional row -1 col 1', 'functional row -1 col -1',
          'icon action_emoji', 'icon enter_key', 'spacebar',
        ], 'الصف السفلي');
      case ApplyTarget.functionalKeys:
        final functional = _applyColorToGroups(project, color,
            (g) => _matches(g, const ['functional', 'function']));
        return _applyColorToSelectors(functional, color, const [
          'functional row -1', 'functional row -1 col 0',
          'functional row -1 col 1', 'functional row -1 col -1',
          'icon shift_key', 'icon delete_key', 'icon action_emoji', 'icon enter_key',
        ], 'الأزرار الوظيفية');
      case ApplyTarget.deleteKey:
        return _applyColorToSelector(project, 'icon delete_key', color, 'زر الحذف');
      case ApplyTarget.enterKey:
        return _applyColorToSelector(project, 'icon enter_key', color, 'زر Enter');
      case ApplyTarget.emojiKey:
        return _applyColorToSelector(project, 'icon action_emoji', color, 'زر الإيموجي');
      case ApplyTarget.spacebar:
        return _applyColorToSelector(project, 'spacebar', color, 'زر المسافة');
      case ApplyTarget.shiftKey:
        return _applyColorToSelector(project, 'icon shift_key', color, 'زر Shift');
      case ApplyTarget.symbolsKey:
        return _applyColorToSelector(project, 'functional row -1 col 0', color, 'زر ?123');
      case ApplyTarget.customGroup:
        return _applyColorToSelector(project, selection.effectiveSelector, color, 'مجموعة مخصصة');
      case ApplyTarget.customKey:
        return _applyColorToSelector(project, selection.effectiveSelector, color, 'زر مخصص');
    }
  }

  static ThemeProject applyGradient({
    required ThemeProject project,
    required GradientPreset gradient,
    required ApplySelection selection,
  }) {
    final target = selection.target;
    if (target == ApplyTarget.keyboardBackground ||
        target == ApplyTarget.screenBackground ||
        target == ApplyTarget.keyBackground) {
      if (gradient.colors.isEmpty) return project;
      final asset = BackgroundAsset.gradient(
        name: gradient.name,
        colors: gradient.colors,
        angle: gradient.angle,
      );
      if (target == ApplyTarget.keyboardBackground) {
        return project.copyWith(
          backgroundAsset: asset,
          keyboardSurface: gradient.colors.first,
          updatedAt: DateTime.now(),
        );
      }
      if (target == ApplyTarget.screenBackground) {
        return project.copyWith(
          backgroundAsset: asset,
          background: gradient.colors.first,
          updatedAt: DateTime.now(),
        );
      }
      var updated = _applyGradientToGroups(project, gradient, (g) => true);
      for (final row in const [('normal row 0', 'الصف العلوي'), ('normal row -1', 'الصف السفلي'), ('functional row -1', 'الصف السفلي الوظيفي')]) {
        if (!updated.groups.any((g) => g.selector == row.$1)) {
          final color = gradient.colors.first;
          final border = BorderAsset.createDefault(
            name: 'Button-${row.$1.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
            backgroundTint: color,
          ).copyWith(gradient: gradient);
          updated = updated.copyWith(
            groups: [...updated.groups, KeyGroup.create(name: row.$2, selector: row.$1, backgroundTint: color).copyWith(gradient: gradient, border: border)],
            updatedAt: DateTime.now(),
          );
        }
      }
      return _applyGradientToSelectors(updated, gradient, const [
        'normal row 0', 'normal row -1', 'functional row -1',
        'functional row -1 col 0', 'functional row -1 col 1',
        'functional row -1 col -1', 'icon shift_key', 'icon delete_key',
        'icon action_emoji', 'icon enter_key', 'spacebar',
      ]);
    }

    var updated = _applyGradientToGroups(project, gradient, (g) => _targetMatchesGroup(g, selection));
    if (target == ApplyTarget.allKeys) {
      for (final row in const [('normal row 0', 'الصف العلوي'), ('normal row -1', 'الصف السفلي'), ('functional row -1', 'الصف السفلي الوظيفي')]) {
        if (!updated.groups.any((g) => g.selector == row.$1)) {
          final color = gradient.colors.isNotEmpty ? gradient.colors.first : updated.keyboardContainer;
          final border = BorderAsset.createDefault(
            name: 'Button-${row.$1.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
            backgroundTint: color,
          ).copyWith(gradient: gradient);
          updated = updated.copyWith(groups: [...updated.groups, KeyGroup.create(name: row.$2, selector: row.$1, backgroundTint: color).copyWith(gradient: gradient, border: border)]);
        }
      }
    }
    if (target == ApplyTarget.allKeys) {
      updated = _applyGradientToSelectors(updated, gradient, const [
        'normal row 0', 'normal row -1', 'functional row -1',
        'functional row -1 col 0', 'functional row -1 col 1',
        'functional row -1 col -1', 'icon shift_key', 'icon delete_key',
        'icon action_emoji', 'icon enter_key', 'spacebar',
      ]);
    } else if (target == ApplyTarget.functionalKeys) {
      updated = _applyGradientToSelectors(updated, gradient, const [
        'functional row -1', 'functional row -1 col 0',
        'functional row -1 col 1', 'functional row -1 col -1',
        'icon shift_key', 'icon delete_key', 'icon action_emoji', 'icon enter_key',
      ]);
    } else if (target == ApplyTarget.bottomRow) {
      updated = _applyGradientToSelectors(updated, gradient, const [
        'normal row -1', 'functional row -1', 'functional row -1 col 0',
        'functional row -1 col 1', 'functional row -1 col -1',
        'icon action_emoji', 'icon enter_key', 'spacebar',
      ]);
    }
    if ((target == ApplyTarget.topRow || target == ApplyTarget.bottomRow ||
            target == ApplyTarget.deleteKey || target == ApplyTarget.enterKey ||
            target == ApplyTarget.emojiKey || target == ApplyTarget.spacebar ||
            target == ApplyTarget.shiftKey || target == ApplyTarget.symbolsKey ||
            target == ApplyTarget.customKey) &&
        !updated.groups.any((g) => g.selector == selection.effectiveSelector)) {
      final selector = selection.effectiveSelector;
      final color = gradient.colors.isNotEmpty ? gradient.colors.first : updated.keyboardContainer;
      final base = BorderAsset.createDefault(
        name: 'Button-${selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
        backgroundTint: color,
      ).copyWith(gradient: gradient);
      final group = KeyGroup.create(name: selection.target.labelAr, selector: selector, backgroundTint: color).copyWith(gradient: gradient, border: base);
      updated = updated.copyWith(groups: [...updated.groups, group], updatedAt: DateTime.now());
    }
    return updated;
  }

  static ThemeProject applyShape({
    required ThemeProject project,
    required KeyShape shape,
    required ApplySelection selection,
  }) {
    if (selection.target == ApplyTarget.keyboardBackground ||
        selection.target == ApplyTarget.screenBackground) {
      return project;
    }
    final updated = project.groups.map((group) {
      if (_targetMatchesGroup(group, selection)) {
        final base = group.border ?? BorderAsset.createDefault(
          name: 'Button-${group.selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
          shape: shape,
          backgroundTint: project.keyboardContainer,
        );
        final pressed = group.pressedBorder?.copyWith(shape: shape);
        final longPress = group.longPressBorder?.copyWith(shape: shape);
        return group.copyWith(
          shape: shape,
          border: base.copyWith(shape: shape),
          pressedBorder: pressed,
          longPressBorder: longPress,
        );
      }
      return group;
    }).toList();
    final shapeSelectors = <String>[];
    if (selection.target == ApplyTarget.allKeys || selection.target == ApplyTarget.keyBackground) {
      shapeSelectors.addAll(const [
        'normal row 0', 'normal row -1', 'functional row -1',
        'functional row -1 col 0', 'functional row -1 col 1',
        'functional row -1 col -1', 'icon shift_key', 'icon delete_key',
        'icon action_emoji', 'icon enter_key', 'spacebar',
      ]);
    } else if (selection.target == ApplyTarget.functionalKeys) {
      shapeSelectors.addAll(const [
        'functional row -1', 'functional row -1 col 0',
        'functional row -1 col 1', 'functional row -1 col -1',
        'icon shift_key', 'icon delete_key', 'icon action_emoji', 'icon enter_key',
      ]);
    } else if (selection.target == ApplyTarget.bottomRow) {
      shapeSelectors.addAll(const [
        'normal row -1', 'functional row -1', 'functional row -1 col 0',
        'functional row -1 col 1', 'functional row -1 col -1',
        'icon action_emoji', 'icon enter_key', 'spacebar',
      ]);
    }
    for (final targetSelector in shapeSelectors) {
      if (!updated.any((g) => g.selector == targetSelector)) {
        updated.add(KeyGroup.create(
          name: selection.target.labelAr, selector: targetSelector, shape: shape,
          backgroundTint: project.keyboardContainer,
        ));
      }
    }
    final selector = selection.effectiveSelector;
    final needsNewGroup = selection.target != ApplyTarget.allKeys &&
        selection.target != ApplyTarget.lettersRow &&
        selection.target != ApplyTarget.functionalKeys &&
        selection.target != ApplyTarget.keyBackground &&
        selection.target != ApplyTarget.keyboardBackground &&
        selection.target != ApplyTarget.screenBackground &&
        !updated.any((g) => g.selector == selector);
    if (needsNewGroup) {
      updated.add(KeyGroup.create(
        name: selection.target.labelAr,
        selector: selector,
        shape: shape,
        backgroundTint: project.keyboardContainer,
      ));
    }
    if (selection.target == ApplyTarget.bottomRow &&
        !updated.any((g) => g.selector == 'functional row -1')) {
      updated.add(KeyGroup.create(
        name: 'الصف السفلي الوظيفي', selector: 'functional row -1',
        shape: shape, backgroundTint: project.keyboardContainer,
      ));
    }
    return project.copyWith(groups: updated, updatedAt: DateTime.now());
  }

  static ThemeProject applyBackground({
    required ThemeProject project,
    required BackgroundAsset background,
    required ApplySelection selection,
  }) {
    switch (selection.target) {
      case ApplyTarget.keyboardBackground:
        return project.copyWith(
          backgroundAsset: background,
          keyboardSurface: background.solidColor ??
              (background.gradientColors?.isNotEmpty == true
                  ? background.gradientColors!.first
                  : project.keyboardSurface),
          updatedAt: DateTime.now(),
        );
      case ApplyTarget.screenBackground:
        return project.copyWith(
          backgroundAsset: background,
          background: background.solidColor ??
              (background.gradientColors?.isNotEmpty == true
                  ? background.gradientColors!.first
                  : project.background),
          updatedAt: DateTime.now(),
        );
      case ApplyTarget.keyBackground:
        final isImage = (background.type == BackgroundType.image ||
                background.type == BackgroundType.builtin) &&
            background.imagePath != null;
        if (isImage) {
          final groups = project.groups.map((g) {
            final base = g.border ?? BorderAsset.createDefault(
              name: 'Button-${g.selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
              shape: g.shape,
              backgroundTint: project.keyboardContainer,
            );
            return g.copyWith(
              border: base.copyWith(customImagePath: background.imagePath, clearGradient: true),
            );
          }).toList();
          for (final selector in const [
            'normal row 0', 'normal row -1', 'functional row -1',
            'functional row -1 col 0', 'functional row -1 col 1',
            'functional row -1 col -1', 'icon shift_key', 'icon delete_key',
            'icon action_emoji', 'icon enter_key', 'spacebar',
          ]) {
            if (!groups.any((g) => g.selector == selector)) {
              final border = BorderAsset.createDefault(
                name: 'Button-${selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
                backgroundTint: project.keyboardContainer,
              ).copyWith(customImagePath: background.imagePath);
              groups.add(KeyGroup.create(name: selector, selector: selector, backgroundTint: project.keyboardContainer).copyWith(border: border));
            }
          }
          return project.copyWith(groups: groups, updatedAt: DateTime.now());
        }
        final color = background.solidColor ??
            (background.gradientColors?.isNotEmpty == true
                ? background.gradientColors!.first
                : null);
        if (color == null) return project;
        var updated = _applyColorToGroups(project, color, (g) => true);
        updated = _applyColorToSelector(updated, 'normal row 0', color, 'الصف العلوي');
        updated = _applyColorToSelector(updated, 'normal row -1', color, 'الصف السفلي');
        updated = _applyColorToSelector(updated, 'functional row -1', color, 'الصف السفلي الوظيفي');
        return updated;
      default:
        return project.copyWith(backgroundAsset: background, updatedAt: DateTime.now());
    }
  }

  static ThemeProject _applyGradientToSelectors(
    ThemeProject project, GradientPreset gradient, List<String> selectors,
  ) {
    var updated = project;
    for (final selector in selectors) {
      final existing = updated.groups.where((g) => g.selector == selector).toList();
      if (existing.isNotEmpty) {
        final groups = updated.groups.map((g) {
          if (g.selector != selector) return g;
          final base = g.border ?? BorderAsset.createDefault(
            name: 'Button-${selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
            shape: g.shape,
            backgroundTint: gradient.colors.isNotEmpty ? gradient.colors.first : updated.keyboardContainer,
          );
          return g.copyWith(
            gradient: gradient,
            border: base.copyWith(
              gradient: gradient,
              backgroundTint: gradient.colors.isNotEmpty ? gradient.colors.first : base.backgroundTint,
              clearCustomImage: true,
            ),
          );
        }).toList();
        updated = updated.copyWith(groups: groups, updatedAt: DateTime.now());
      } else {
        final color = gradient.colors.isNotEmpty ? gradient.colors.first : updated.keyboardContainer;
        final border = BorderAsset.createDefault(
          name: 'Button-${selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
          backgroundTint: color,
        ).copyWith(gradient: gradient);
        updated = updated.copyWith(
          groups: [...updated.groups, KeyGroup.create(name: selector, selector: selector, backgroundTint: color).copyWith(gradient: gradient, border: border)],
          updatedAt: DateTime.now(),
        );
      }
    }
    return updated;
  }

  static ThemeProject _applyColorToSelectors(
    ThemeProject project, Color color, List<String> selectors, String name,
  ) {
    var updated = project;
    for (final selector in selectors) {
      updated = _applyColorToSelector(updated, selector, color, name);
    }
    return updated;
  }

  static ThemeProject _applyColorToGroups(
    ThemeProject project,
    Color color,
    bool Function(dynamic group) predicate,
  ) {
    final groups = project.groups.map((g) {
      if (!predicate(g)) return g;
      final old = g.border;
      final border = (old ?? BorderAsset.createDefault(
        name: 'Button-${g.selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
        shape: g.shape,
        backgroundTint: color,
      )).copyWith(backgroundTint: color, clearGradient: true, clearCustomImage: true);
      final pressed = g.pressedBorder?.copyWith(backgroundTint: color, clearGradient: true, clearCustomImage: true);
      final longPress = g.longPressBorder?.copyWith(backgroundTint: color, clearGradient: true, clearCustomImage: true);
      return g.copyWith(border: border, pressedBorder: pressed, longPressBorder: longPress);
    }).toList();
    return project.copyWith(groups: groups, updatedAt: DateTime.now());
  }

  static ThemeProject _applyColorToSelector(
    ThemeProject project,
    String selector,
    Color color,
    String name,
  ) {
    final exists = project.groups.any((g) => g.selector == selector);
    final groups = project.groups.map((g) {
      if (g.selector != selector) return g;
      final border = (g.border ?? BorderAsset.createDefault(
        name: 'Button-${selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
        shape: g.shape,
        backgroundTint: color,
      )).copyWith(backgroundTint: color, clearGradient: true, clearCustomImage: true);
      return g.copyWith(border: border);
    }).toList();
    if (!exists) {
      groups.add(_newStyledGroup(selector, name, color));
    }
    return project.copyWith(groups: groups, updatedAt: DateTime.now());
  }

  static ThemeProject _applyGradientToGroups(
    ThemeProject project,
    GradientPreset gradient,
    bool Function(dynamic group) predicate,
  ) {
    final groups = project.groups.map((g) {
      if (!predicate(g)) return g;
      final base = g.border ?? BorderAsset.createDefault(
        name: 'Button-${g.selector.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.png',
        shape: g.shape,
        backgroundTint: gradient.colors.isNotEmpty ? gradient.colors.first : project.keyboardContainer,
      );
      return g.copyWith(
        gradient: gradient,
        border: base.copyWith(
          backgroundTint: gradient.colors.isNotEmpty ? gradient.colors.first : base.backgroundTint,
          gradient: gradient,
          clearCustomImage: true,
        ),
      );
    }).toList();
    return project.copyWith(groups: groups, updatedAt: DateTime.now());
  }

  static KeyGroup _newStyledGroup(String selector, String name, Color color) {
    return KeyGroup.create(name: name, selector: selector, backgroundTint: color);
  }

  static bool _targetMatchesGroup(dynamic group, ApplySelection selection) {
    final selector = (group.selector as String).toLowerCase();
    switch (selection.target) {
      case ApplyTarget.allKeys:
      case ApplyTarget.keyBackground:
        return true;
      case ApplyTarget.lettersRow:
        return _matches(group, const ['normal', 'letter', 'writing']);
      case ApplyTarget.topRow:
        return selector.contains('normal row 0');
      case ApplyTarget.bottomRow:
        return selector.contains('normal row -1') || selector.contains('functional row -1') || selector == 'spacebar';
      case ApplyTarget.functionalKeys:
        return _matches(group, const ['functional', 'function']);
      case ApplyTarget.deleteKey:
        return selector.contains('delete_key') || selector.contains('backspace');
      case ApplyTarget.enterKey:
        return selector.contains('enter_key') || selector.contains('enter');
      case ApplyTarget.emojiKey:
        return selector.contains('action_emoji') || selector.contains('emoji');
      case ApplyTarget.spacebar:
        return selector.contains('spacebar') || selector.contains('space');
      case ApplyTarget.shiftKey:
        return selector.contains('shift_key') || selector.contains('shift');
      case ApplyTarget.symbolsKey:
        return selector.contains('?123') || selector.contains('symbols') || selector.contains('row -1 col 0');
      case ApplyTarget.customGroup:
      case ApplyTarget.customKey:
        return selector == selection.effectiveSelector.toLowerCase();
      case ApplyTarget.keyboardBackground:
      case ApplyTarget.screenBackground:
        return false;
    }
  }

  static bool _matches(dynamic group, List<String> tokens) {
    final selector = (group.selector as String).toLowerCase();
    return tokens.any((token) => selector.contains(token));
  }
}
