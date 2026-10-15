import 'package:flutter/material.dart';

import 'border_asset.dart';
import 'gradient_preset.dart';
import 'icon_asset.dart';
import 'key_config.dart';
import 'key_shape.dart';
import 'match_rule.dart';

/// مجموعة أزرار
class KeyGroup {
  final String id;
  final String name;
  final String selector;

  final BorderAsset? border;
  final BorderAsset? pressedBorder;
  final BorderAsset? longPressBorder;

  final IconAsset? icon;
  final IconAsset? pressedIcon;

  // التدرج الجديد
  final GradientPreset? gradient;
  final GradientPreset? pressedGradient;

  final KeyShape shape;
  final KeyConfig config;
  final bool enabled;
  final String? notes;

  const KeyGroup({
    required this.id,
    required this.name,
    required this.selector,
    this.border,
    this.pressedBorder,
    this.longPressBorder,
    this.icon,
    this.pressedIcon,
    this.gradient,
    this.pressedGradient,
    this.shape = KeyShape.roundedRectangle,
    this.config = const KeyConfig(id: 'default'),
    this.enabled = true,
    this.notes,
  });

  factory KeyGroup.create({
    required String name,
    required String selector,
    KeyShape shape = KeyShape.roundedRectangle,
    Color? backgroundTint,
  }) {
    return KeyGroup(
      id: 'group_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      selector: selector,
      shape: shape,
      config: KeyConfig.defaultConfig(),
      border: backgroundTint != null
          ? BorderAsset.createDefault(
              name: 'Button-${selector.replaceAll(" ", "_")}.png',
              shape: shape,
              backgroundTint: backgroundTint,
            )
          : null,
    );
  }

  KeyGroup copyWith({
    String? id,
    String? name,
    String? selector,
    BorderAsset? border,
    BorderAsset? pressedBorder,
    BorderAsset? longPressBorder,
    IconAsset? icon,
    IconAsset? pressedIcon,
    GradientPreset? gradient,
    GradientPreset? pressedGradient,
    KeyShape? shape,
    KeyConfig? config,
    bool? enabled,
    String? notes,
  }) {
    return KeyGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      selector: selector ?? this.selector,
      border: border ?? this.border,
      pressedBorder: pressedBorder ?? this.pressedBorder,
      longPressBorder: longPressBorder ?? this.longPressBorder,
      icon: icon ?? this.icon,
      pressedIcon: pressedIcon ?? this.pressedIcon,
      gradient: gradient ?? this.gradient,
      pressedGradient: pressedGradient ?? this.pressedGradient,
      shape: shape ?? this.shape,
      config: config ?? this.config,
      enabled: enabled ?? this.enabled,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'selector': selector,
        'border': border?.toJson(),
        'pressedBorder': pressedBorder?.toJson(),
        'longPressBorder': longPressBorder?.toJson(),
        'icon': icon?.toJson(),
        'pressedIcon': pressedIcon?.toJson(),
        'gradient': gradient?.toJson(),
        'pressedGradient': pressedGradient?.toJson(),
        'shape': shape.name,
        'config': config.toJson(),
        'enabled': enabled,
        'notes': notes,
      };

  factory KeyGroup.fromJson(Map<String, dynamic> json) {
    return KeyGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      selector: json['selector'] as String,
      border: json['border'] != null
          ? BorderAsset.fromJson(json['border'] as Map<String, dynamic>)
          : null,
      pressedBorder: json['pressedBorder'] != null
          ? BorderAsset.fromJson(json['pressedBorder'] as Map<String, dynamic>)
          : null,
      longPressBorder: json['longPressBorder'] != null
          ? BorderAsset.fromJson(
              json['longPressBorder'] as Map<String, dynamic>)
          : null,
      icon: json['icon'] != null
          ? IconAsset.fromJson(json['icon'] as Map<String, dynamic>)
          : null,
      pressedIcon: json['pressedIcon'] != null
          ? IconAsset.fromJson(json['pressedIcon'] as Map<String, dynamic>)
          : null,
      gradient: json['gradient'] != null
          ? GradientPreset.fromJson(json['gradient'] as Map<String, dynamic>)
          : null,
      pressedGradient: json['pressedGradient'] != null
          ? GradientPreset.fromJson(
              json['pressedGradient'] as Map<String, dynamic>)
          : null,
      shape: KeyShape.values.firstWhere(
        (s) => s.name == json['shape'],
        orElse: () => KeyShape.roundedRectangle,
      ),
      config: json['config'] != null
          ? KeyConfig.fromJson(json['config'] as Map<String, dynamic>)
          : const KeyConfig(id: 'default'),
      enabled: json['enabled'] as bool? ?? true,
      notes: json['notes'] as String?,
    );
  }

  List<MatchRule> toMatchRules() {
    final rules = <MatchRule>[];
    if (!enabled) return rules;

    if (border != null) {
      rules.add(MatchRule.create(
        type: MatchRuleType.border,
        selectors: [selector],
        assetName: border!.name,
        priority: 0,
        description: '$name (عادي)',
      ));
    }

    if (pressedBorder != null) {
      rules.add(MatchRule.create(
        type: MatchRuleType.border,
        selectors: [selector, 'pressed'],
        assetName: pressedBorder!.name,
        priority: 10,
        description: '$name (مضغوط)',
      ));
    }

    if (longPressBorder != null) {
      rules.add(MatchRule.create(
        type: MatchRuleType.border,
        selectors: [selector, 'morekey'],
        assetName: longPressBorder!.name,
        priority: 20,
        description: '$name (مطول)',
      ));
    }

    if (icon != null) {
      rules.add(MatchRule.create(
        type: MatchRuleType.icon,
        selectors: [selector],
        assetName: icon!.name,
        priority: 0,
        description: '$name أيقونة',
      ));
    }

    if (pressedIcon != null) {
      rules.add(MatchRule.create(
        type: MatchRuleType.icon,
        selectors: [selector, 'pressed'],
        assetName: pressedIcon!.name,
        priority: 10,
        description: '$name أيقونة مضغوطة',
      ));
    }

    return rules;
  }

  bool get hasAssets =>
      border != null ||
      pressedBorder != null ||
      longPressBorder != null ||
      icon != null ||
      pressedIcon != null ||
      gradient != null;

  int get assetCount {
    int count = 0;
    if (border != null) count++;
    if (pressedBorder != null) count++;
    if (longPressBorder != null) count++;
    if (icon != null) count++;
    if (pressedIcon != null) count++;
    if (gradient != null) count++;
    return count;
  }
}

/// المجموعات الافتراضية
class DefaultGroups {
  DefaultGroups._();

  static List<KeyGroup> createDefaultList(
    Color keyboardContainer,
    Color functionalColor,
  ) {
    return [
      KeyGroup.create(
        name: 'أزرار الكتابة',
        selector: 'normal',
        backgroundTint: keyboardContainer,
      ),
      KeyGroup.create(
        name: 'الأزرار الوظيفية',
        selector: 'functional',
        backgroundTint: functionalColor,
      ),
      KeyGroup.create(
        name: 'زر المسافة',
        selector: 'spacebar',
        backgroundTint: keyboardContainer,
      ),
    ];
  }
}
