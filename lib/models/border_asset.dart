import 'package:flutter/material.dart';

import 'gradient_preset.dart';
import 'key_shape.dart';

/// أصل الحدود (صورة زر)
class BorderAsset {
  final String id;
  final String name;
  final KeyShape shape;

  // ألوان (لون واحد)
  final Color backgroundTint;
  final Color foregroundTint;
  final Color borderColor;
  final double borderWidth;

  // ⭐ التدرج (بديل عن backgroundTint)
  final GradientPreset? gradient;

  // تدرج الحدود (نادر)
  final GradientPreset? borderGradient;

  final int targetDensity;

  // 9-slice
  final double sliceTop;
  final double sliceRight;
  final double sliceBottom;
  final double sliceLeft;

  final int gapTop;
  final int gapRight;
  final int gapBottom;
  final int gapLeft;

  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double paddingLeft;

  final String? customImagePath;

  const BorderAsset({
    required this.id,
    required this.name,
    this.shape = KeyShape.roundedRectangle,
    this.backgroundTint = const Color(0xFF102C43),
    this.foregroundTint = const Color(0xFFF4FAFF),
    this.borderColor = const Color(0xFF327D9D),
    this.borderWidth = 2.0,
    this.gradient,
    this.borderGradient,
    this.targetDensity = 640,
    this.sliceTop = 16.0,
    this.sliceRight = 16.0,
    this.sliceBottom = 16.0,
    this.sliceLeft = 16.0,
    this.gapTop = 2,
    this.gapRight = 2,
    this.gapBottom = 2,
    this.gapLeft = 2,
    this.paddingTop = 0.0,
    this.paddingRight = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.customImagePath,
  });

  factory BorderAsset.createDefault({
    required String name,
    KeyShape shape = KeyShape.roundedRectangle,
    Color backgroundTint = const Color(0xFF102C43),
    Color borderColor = const Color(0xFF327D9D),
  }) {
    return BorderAsset(
      id: 'border_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      shape: shape,
      backgroundTint: backgroundTint,
      borderColor: borderColor,
    );
  }

  BorderAsset copyWith({
    String? id,
    String? name,
    KeyShape? shape,
    Color? backgroundTint,
    Color? foregroundTint,
    Color? borderColor,
    double? borderWidth,
    GradientPreset? gradient,
    GradientPreset? borderGradient,
    bool clearGradient = false,
    int? targetDensity,
    double? sliceTop,
    double? sliceRight,
    double? sliceBottom,
    double? sliceLeft,
    int? gapTop,
    int? gapRight,
    int? gapBottom,
    int? gapLeft,
    double? paddingTop,
    double? paddingRight,
    double? paddingBottom,
    double? paddingLeft,
    String? customImagePath,
    bool clearCustomImage = false,
  }) {
    return BorderAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      shape: shape ?? this.shape,
      backgroundTint: backgroundTint ?? this.backgroundTint,
      foregroundTint: foregroundTint ?? this.foregroundTint,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      gradient: clearGradient ? null : (gradient ?? this.gradient),
      borderGradient:
          clearGradient ? null : (borderGradient ?? this.borderGradient),
      targetDensity: targetDensity ?? this.targetDensity,
      sliceTop: sliceTop ?? this.sliceTop,
      sliceRight: sliceRight ?? this.sliceRight,
      sliceBottom: sliceBottom ?? this.sliceBottom,
      sliceLeft: sliceLeft ?? this.sliceLeft,
      gapTop: gapTop ?? this.gapTop,
      gapRight: gapRight ?? this.gapRight,
      gapBottom: gapBottom ?? this.gapBottom,
      gapLeft: gapLeft ?? this.gapLeft,
      paddingTop: paddingTop ?? this.paddingTop,
      paddingRight: paddingRight ?? this.paddingRight,
      paddingBottom: paddingBottom ?? this.paddingBottom,
      paddingLeft: paddingLeft ?? this.paddingLeft,
      customImagePath: clearCustomImage ? null : (customImagePath ?? this.customImagePath),
    );
  }

  /// هل للتدرج؟
  bool get hasGradient => gradient != null;

  /// لون الأساس (أول لون في التدرج إن وُجد)
  Color get effectiveColor {
    if (gradient != null && gradient!.colors.isNotEmpty) {
      return gradient!.colors.first;
    }
    return backgroundTint;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shape': shape.name,
        'backgroundTint': backgroundTint.value,
        'foregroundTint': foregroundTint.value,
        'borderColor': borderColor.value,
        'borderWidth': borderWidth,
        'gradient': gradient?.toJson(),
        'borderGradient': borderGradient?.toJson(),
        'targetDensity': targetDensity,
        'sliceTop': sliceTop,
        'sliceRight': sliceRight,
        'sliceBottom': sliceBottom,
        'sliceLeft': sliceLeft,
        'gapTop': gapTop,
        'gapRight': gapRight,
        'gapBottom': gapBottom,
        'gapLeft': gapLeft,
        'paddingTop': paddingTop,
        'paddingRight': paddingRight,
        'paddingBottom': paddingBottom,
        'paddingLeft': paddingLeft,
        'customImagePath': customImagePath,
      };

  factory BorderAsset.fromJson(Map<String, dynamic> json) {
    return BorderAsset(
      id: json['id'] as String,
      name: json['name'] as String,
      shape: KeyShape.values.firstWhere(
        (s) => s.name == json['shape'],
        orElse: () => KeyShape.roundedRectangle,
      ),
      backgroundTint: Color(json['backgroundTint'] as int),
      foregroundTint: Color(json['foregroundTint'] as int),
      borderColor: Color(json['borderColor'] as int),
      borderWidth: (json['borderWidth'] as num).toDouble(),
      gradient: json['gradient'] != null
          ? GradientPreset.fromJson(json['gradient'] as Map<String, dynamic>)
          : null,
      borderGradient: json['borderGradient'] != null
          ? GradientPreset.fromJson(
              json['borderGradient'] as Map<String, dynamic>)
          : null,
      targetDensity: json['targetDensity'] as int,
      sliceTop: (json['sliceTop'] as num).toDouble(),
      sliceRight: (json['sliceRight'] as num).toDouble(),
      sliceBottom: (json['sliceBottom'] as num).toDouble(),
      sliceLeft: (json['sliceLeft'] as num).toDouble(),
      gapTop: json['gapTop'] as int,
      gapRight: json['gapRight'] as int,
      gapBottom: json['gapBottom'] as int,
      gapLeft: json['gapLeft'] as int,
      paddingTop: (json['paddingTop'] as num).toDouble(),
      paddingRight: (json['paddingRight'] as num).toDouble(),
      paddingBottom: (json['paddingBottom'] as num).toDouble(),
      paddingLeft: (json['paddingLeft'] as num).toDouble(),
      customImagePath: json['customImagePath'] as String?,
    );
  }

  String toTomlSection() {
    final bgHex = _hex(backgroundTint);
    final fgHex = _hex(foregroundTint);
    final sb = StringBuffer();

    if (gradient != null) {
      sb.writeln('# Gradient: ${gradient!.name}');
      sb.writeln('# Colors: ${gradient!.colors.map(_hex).join(" → ")}');
      sb.writeln('# Angle: ${gradient!.angle}°');
    }

    sb.writeln('\n[[asset.border]]');
    sb.writeln('name = "$name"');
    sb.writeln('background_tint = "$bgHex"');
    sb.writeln('foreground_tint = "$fgHex"');
    sb.writeln(
        'padding = [$paddingTop, $paddingRight, $paddingBottom, $paddingLeft]');
    sb.writeln('slicing = [$sliceTop, $sliceRight, $sliceBottom, $sliceLeft]');
    sb.writeln('gap = [$gapTop, $gapRight, $gapBottom, $gapLeft]');
    sb.writeln('target_density = $targetDensity');

    // إذا كان هناك تدرج → أضف حقل gradient
    if (gradient != null) {
      final stops = gradient!.stops ?? [];
      sb.writeln(
          'gradient_colors = [${gradient!.colors.map((c) => '"${_hex(c)}"').join(", ")}]');
      if (stops.isNotEmpty) {
        sb.writeln('gradient_stops = [$stops]');
      }
      sb.writeln('gradient_angle = ${gradient!.angle}');
    }

    return sb.toString();
  }

  static String _hex(Color c) {
    final r = (c.red).toRadixString(16).padLeft(2, '0');
    final g = (c.green).toRadixString(16).padLeft(2, '0');
    final b = (c.blue).toRadixString(16).padLeft(2, '0');
    final a = (c.alpha).toRadixString(16).padLeft(2, '0');
    return (c.alpha == 255 ? '#$r$g$b' : '#$r$g$b$a').toUpperCase();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BorderAsset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
