import 'package:flutter/material.dart';

/// نوع القاعدة
enum MatchRuleType { border, icon }

/// قاعدة المطابقة (selector → asset)
class MatchRule {
  final String id;
  final MatchRuleType type;
  final List<String> selectors;
  final String assetName;
  final int priority;
  final String? description;

  const MatchRule({
    required this.id,
    required this.type,
    required this.selectors,
    required this.assetName,
    this.priority = 0,
    this.description,
  });

  factory MatchRule.create({
    required MatchRuleType type,
    required List<String> selectors,
    required String assetName,
    int priority = 0,
    String? description,
  }) {
    return MatchRule(
      id: 'rule_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      selectors: selectors,
      assetName: assetName,
      priority: priority,
      description: description,
    );
  }

  MatchRule copyWith({
    String? id,
    MatchRuleType? type,
    List<String>? selectors,
    String? assetName,
    int? priority,
    String? description,
  }) {
    return MatchRule(
      id: id ?? this.id,
      type: type ?? this.type,
      selectors: selectors ?? this.selectors,
      assetName: assetName ?? this.assetName,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'selectors': selectors,
        'assetName': assetName,
        'priority': priority,
        'description': description,
      };

  factory MatchRule.fromJson(Map<String, dynamic> json) {
    return MatchRule(
      id: json['id'] as String,
      type: MatchRuleType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => MatchRuleType.border,
      ),
      selectors: List<String>.from(json['selectors'] as List),
      assetName: json['assetName'] as String,
      priority: json['priority'] as int? ?? 0,
      description: json['description'] as String?,
    );
  }

  /// توليد قطاع TOML
  String toTomlSection() {
    final selectorStr = selectors.join(' ');
    final key =
        type == MatchRuleType.border ? 'matchrules.border' : 'matchrules.icon';
    return '\n[[$key]]\nselector = "$selectorStr"\nasset = "$assetName"\n';
  }

  String get summary {
    if (description != null && description!.isNotEmpty) return description!;
    return '${selectors.join(" ")} → $assetName';
  }
}

/// معلومات مُحدِّد واحد
class SelectorInfo {
  final String selector;
  final String labelAr;
  final IconData icon;

  const SelectorInfo(this.selector, this.labelAr, this.icon);
}

/// المُحدِّدات الشائعة
class CommonSelectors {
  CommonSelectors._();

  static const String normal = 'normal';
  static const String functional = 'functional';
  static const String spacebar = 'spacebar';
  static const String action = 'action';
  static const String pressed = 'pressed';
  static const String popup = 'popup';
  static const String morekeysbox = 'morekeysbox';
  static const String morekey = 'morekey';
  static const String morekeyPressed = 'morekey pressed';

  static const String iconDelete = 'icon delete_key';
  static const String iconEnter = 'icon enter_key';
  static const String iconShift = 'icon shift_key';
  static const String iconEmoji = 'icon action_emoji';
  static const String iconSettings = 'icon settings';
  static const String iconLanguage = 'icon language_switch';

  static const List<SelectorInfo> all = [
    SelectorInfo('normal', 'أزرار الكتابة', Icons.keyboard),
    SelectorInfo('functional', 'الأزرار الوظيفية', Icons.functions),
    SelectorInfo('spacebar', 'زر المسافة', Icons.space_bar),
    SelectorInfo('action', 'زر Enter', Icons.keyboard_return),
    SelectorInfo('icon delete_key', 'زر الحذف', Icons.backspace),
    SelectorInfo('icon enter_key', 'أيقونة Enter', Icons.subdirectory_arrow_left),
    SelectorInfo('icon shift_key', 'زر Shift', Icons.keyboard_arrow_up),
    SelectorInfo('icon action_emoji', 'زر الإيموجي', Icons.emoji_emotions),
    SelectorInfo('icon settings', 'زر الإعدادات', Icons.settings),
    SelectorInfo('icon language_switch', 'زر اللغة', Icons.language),
    SelectorInfo('pressed', 'عند الضغط', Icons.touch_app),
    SelectorInfo('popup', 'نافذة الحرف', Icons.chat_bubble_outline),
    SelectorInfo('morekeysbox', 'صندوق الحروف الإضافية', Icons.more_horiz),
    SelectorInfo('morekey', 'حرف إضافي', Icons.text_fields),
    SelectorInfo('morekey pressed', 'حرف إضافي مضغوط', Icons.text_fields),
  ];
}
