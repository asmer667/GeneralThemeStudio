import 'package:flutter/material.dart';

/// نطاق التطبيق
enum ApplyScope {
  single,
  group,
  all,
}

extension ApplyScopeExt on ApplyScope {
  String get labelAr {
    switch (this) {
      case ApplyScope.single:
        return 'زر واحد';
      case ApplyScope.group:
        return 'مجموعة';
      case ApplyScope.all:
        return 'الكل';
    }
  }

  IconData get icon {
    switch (this) {
      case ApplyScope.single:
        return Icons.touch_app;
      case ApplyScope.group:
        return Icons.group_work;
      case ApplyScope.all:
        return Icons.apps;
    }
  }
}

/// إعدادات حجم زر واحد
class KeyConfig {
  final String id;

  // الأبعاد
  final double width;
  final double height;
  final double minWidth;
  final double maxWidth;

  // الحشو
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double paddingLeft;

  // الهوامش (gap)
  final double gapTop;
  final double gapRight;
  final double gapBottom;
  final double gapLeft;

  // الزوايا والاستدارة
  final double borderRadius;
  final double roundedness;

  // الحدود
  final double borderWidth;
  final Color borderColor;

  // الشفافية
  final double opacity;
  final double blur;

  // الخط
  final double fontSize;
  final int fontWeight;

  const KeyConfig({
    required this.id,
    this.width = 44,
    this.height = 48,
    this.minWidth = 24,
    this.maxWidth = 200,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingBottom = 0,
    this.paddingLeft = 0,
    this.gapTop = 2,
    this.gapRight = 2,
    this.gapBottom = 2,
    this.gapLeft = 2,
    this.borderRadius = 12,
    this.roundedness = 0.5,
    this.borderWidth = 1.2,
    this.borderColor = const Color(0xFF327D9D),
    this.opacity = 1.0,
    this.blur = 0.0,
    this.fontSize = 15,
    this.fontWeight = 600,
  });

  /// إعداد افتراضي
  factory KeyConfig.defaultConfig() {
    return const KeyConfig(
      id: 'default',
    );
  }

  KeyConfig copyWith({
    String? id,
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? paddingTop,
    double? paddingRight,
    double? paddingBottom,
    double? paddingLeft,
    double? gapTop,
    double? gapRight,
    double? gapBottom,
    double? gapLeft,
    double? borderRadius,
    double? roundedness,
    double? borderWidth,
    Color? borderColor,
    double? opacity,
    double? blur,
    double? fontSize,
    int? fontWeight,
  }) {
    return KeyConfig(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      paddingTop: paddingTop ?? this.paddingTop,
      paddingRight: paddingRight ?? this.paddingRight,
      paddingBottom: paddingBottom ?? this.paddingBottom,
      paddingLeft: paddingLeft ?? this.paddingLeft,
      gapTop: gapTop ?? this.gapTop,
      gapRight: gapRight ?? this.gapRight,
      gapBottom: gapBottom ?? this.gapBottom,
      gapLeft: gapLeft ?? this.gapLeft,
      borderRadius: borderRadius ?? this.borderRadius,
      roundedness: roundedness ?? this.roundedness,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'width': width,
        'height': height,
        'minWidth': minWidth,
        'maxWidth': maxWidth,
        'paddingTop': paddingTop,
        'paddingRight': paddingRight,
        'paddingBottom': paddingBottom,
        'paddingLeft': paddingLeft,
        'gapTop': gapTop,
        'gapRight': gapRight,
        'gapBottom': gapBottom,
        'gapLeft': gapLeft,
        'borderRadius': borderRadius,
        'roundedness': roundedness,
        'borderWidth': borderWidth,
        'borderColor': borderColor.value,
        'opacity': opacity,
        'blur': blur,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
      };

  factory KeyConfig.fromJson(Map<String, dynamic> json) {
    return KeyConfig(
      id: json['id'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      minWidth: (json['minWidth'] as num?)?.toDouble() ?? 24,
      maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? 200,
      paddingTop: (json['paddingTop'] as num).toDouble(),
      paddingRight: (json['paddingRight'] as num).toDouble(),
      paddingBottom: (json['paddingBottom'] as num).toDouble(),
      paddingLeft: (json['paddingLeft'] as num).toDouble(),
      gapTop: (json['gapTop'] as num).toDouble(),
      gapRight: (json['gapRight'] as num).toDouble(),
      gapBottom: (json['gapBottom'] as num).toDouble(),
      gapLeft: (json['gapLeft'] as num).toDouble(),
      borderRadius: (json['borderRadius'] as num).toDouble(),
      roundedness: (json['roundedness'] as num).toDouble(),
      borderWidth: (json['borderWidth'] as num).toDouble(),
      borderColor: Color(json['borderColor'] as int),
      opacity: (json['opacity'] as num).toDouble(),
      blur: (json['blur'] as num).toDouble(),
      fontSize: (json['fontSize'] as num).toDouble(),
      fontWeight: json['fontWeight'] as int,
    );
  }

  /// نسخ السطر كامل للتطبيق
  KeyConfig applyToAll() => copyWith(id: 'all');

  /// الحشو الكامل
  EdgeInsets get padding => EdgeInsets.fromLTRB(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      );

  /// الحشو الفردي (gap)
  EdgeInsets get gap => EdgeInsets.fromLTRB(
        gapLeft,
        gapTop,
        gapRight,
        gapBottom,
      );

  /// حجم مطلق
  Size get size => Size(width, height);
}
