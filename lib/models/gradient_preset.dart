import 'package:flutter/material.dart';

/// نوع التدرج
enum GradientType {
  linear,
  radial,
  sweep,
}

/// تدرج مخصص
class GradientPreset {
  final String id;
  final String name;
  final GradientType type;
  final List<Color> colors;
  final List<double>? stops;
  final double angle; // للـ linear
  final Alignment? center; // للـ radial
  final double radius; // للـ radial

  const GradientPreset({
    required this.id,
    required this.name,
    this.type = GradientType.linear,
    required this.colors,
    this.stops,
    this.angle = 0,
    this.center,
    this.radius = 0.5,
  });

  factory GradientPreset.create({
    required String name,
    List<Color>? colors,
    GradientType type = GradientType.linear,
    double angle = 0,
  }) {
    return GradientPreset(
      id: 'grad_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      colors: colors ??
          const [Color(0xFF16D9F2), Color(0xFF8B5CF6)],
      type: type,
      angle: angle,
    );
  }

  GradientPreset copyWith({
    String? id,
    String? name,
    GradientType? type,
    List<Color>? colors,
    List<double>? stops,
    double? angle,
    Alignment? center,
    double? radius,
  }) {
    return GradientPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colors: colors ?? this.colors,
      stops: stops ?? this.stops,
      angle: angle ?? this.angle,
      center: center ?? this.center,
      radius: radius ?? this.radius,
    );
  }

  /// تحويل إلى Gradient Flutter
  Gradient toFlutterGradient() {
    switch (type) {
      case GradientType.linear:
        return LinearGradient(
          colors: colors,
          stops: stops,
          begin: _angleToAlignment(angle),
          end: _angleToAlignment(angle + 180),
        );
      case GradientType.radial:
        return RadialGradient(
          colors: colors,
          stops: stops,
          center: center ?? Alignment.center,
          radius: radius,
        );
      case GradientType.sweep:
        return SweepGradient(
          colors: colors,
          stops: stops,
          center: center ?? Alignment.center,
        );
    }
  }

  /// تحويل للـ BoxDecoration
  BoxDecoration toBoxDecoration({double? borderRadius}) {
    return BoxDecoration(
      gradient: toFlutterGradient(),
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius)
          : null,
    );
  }

  Alignment _angleToAlignment(double angleDegrees) {
    final rad = angleDegrees * (3.141592653589793 / 180);
    return Alignment(
      _cos(rad),
      _sin(rad),
    );
  }

  double _cos(double x) {
    // Taylor approximation
    final x2 = x * x;
    return 1 - x2 / 2 + x2 * x2 / 24 - x2 * x2 * x2 / 720;
  }

  double _sin(double x) {
    final x2 = x * x;
    return x - x2 * x / 6 + x2 * x2 * x / 120;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'colors': colors.map((c) => c.toARGB32()).toList(),
        'stops': stops,
        'angle': angle,
        'radius': radius,
      };

  factory GradientPreset.fromJson(Map<String, dynamic> json) {
    return GradientPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      type: GradientType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => GradientType.linear,
      ),
      colors: (json['colors'] as List).map((c) => Color(c as int)).toList(),
      stops: json['stops'] != null
          ? List<double>.from(json['stops'] as List)
          : null,
      angle: (json['angle'] as num?)?.toDouble() ?? 0,
      radius: (json['radius'] as num?)?.toDouble() ?? 0.5,
    );
  }

  /// قطاع TOML للتصدير (يُستخدم في asset.border)
  String toTomlComment() {
    return '# Gradient: ${colors.map(_hex).join(" → ")}';
  }

  static String _hex(Color c) {
    return '#${(c.r * 255).round().toRadixString(16).padLeft(2, "0")}'
        '${(c.g * 255).round().toRadixString(16).padLeft(2, "0")}'
        '${(c.b * 255).round().toRadixString(16).padLeft(2, "0")}';
  }
}
