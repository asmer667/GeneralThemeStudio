import 'dart:math' as math;

import 'package:flutter/material.dart';

/// نوع الخلفية
enum BackgroundType {
  color,
  gradient,
  image,
  builtin,
  mesh,
}

extension BackgroundTypeExt on BackgroundType {
  String get labelAr {
    switch (this) {
      case BackgroundType.color:
        return 'لون';
      case BackgroundType.gradient:
        return 'تدرج';
      case BackgroundType.image:
        return 'صورة';
      case BackgroundType.builtin:
        return 'مدمج';
      case BackgroundType.mesh:
        return 'شبكي';
    }
  }

  IconData get icon {
    switch (this) {
      case BackgroundType.color:
        return Icons.format_color_fill;
      case BackgroundType.gradient:
        return Icons.gradient;
      case BackgroundType.image:
        return Icons.image;
      case BackgroundType.builtin:
        return Icons.wallpaper;
      case BackgroundType.mesh:
        return Icons.grid_goldenratio;
    }
  }
}

/// خلفية لوحة المفاتيح
class BackgroundAsset {
  final String id;
  final String name;
  final BackgroundType type;

  final Color? solidColor;

  final List<Color>? gradientColors;
  final double gradientAngle;

  final String? imagePath;

  final bool repeatImage;
  final double opacity;
  final double blurAmount;

  const BackgroundAsset({
    required this.id,
    required this.name,
    required this.type,
    this.solidColor,
    this.gradientColors,
    this.gradientAngle = 0,
    this.imagePath,
    this.repeatImage = false,
    this.opacity = 1.0,
    this.blurAmount = 0.0,
  });

  factory BackgroundAsset.solid({
    required String name,
    required Color color,
  }) {
    return BackgroundAsset(
      id: 'bg_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: BackgroundType.color,
      solidColor: color,
    );
  }

  factory BackgroundAsset.gradient({
    required String name,
    required List<Color> colors,
    double angle = 0,
  }) {
    return BackgroundAsset(
      id: 'bg_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: BackgroundType.gradient,
      gradientColors: colors,
      gradientAngle: angle,
    );
  }

  factory BackgroundAsset.image({
    required String name,
    required String path,
    bool repeat = false,
    double opacity = 1.0,
    double blur = 0.0,
  }) {
    return BackgroundAsset(
      id: 'bg_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: BackgroundType.image,
      imagePath: path,
      repeatImage: repeat,
      opacity: opacity,
      blurAmount: blur,
    );
  }

  factory BackgroundAsset.builtin({
    required String name,
    required String assetPath,
  }) {
    return BackgroundAsset(
      id: 'builtin_$name',
      name: name,
      type: BackgroundType.builtin,
      imagePath: assetPath,
    );
  }

  BackgroundAsset copyWith({
    String? id,
    String? name,
    BackgroundType? type,
    Color? solidColor,
    List<Color>? gradientColors,
    double? gradientAngle,
    String? imagePath,
    bool? repeatImage,
    double? opacity,
    double? blurAmount,
  }) {
    return BackgroundAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      solidColor: solidColor ?? this.solidColor,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientAngle: gradientAngle ?? this.gradientAngle,
      imagePath: imagePath ?? this.imagePath,
      repeatImage: repeatImage ?? this.repeatImage,
      opacity: opacity ?? this.opacity,
      blurAmount: blurAmount ?? this.blurAmount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'solidColor': solidColor?.value,
        'gradientColors':
            gradientColors?.map((c) => c.value).toList(),
        'gradientAngle': gradientAngle,
        'imagePath': imagePath,
        'repeatImage': repeatImage,
        'opacity': opacity,
        'blurAmount': blurAmount,
      };

  factory BackgroundAsset.fromJson(Map<String, dynamic> json) {
    return BackgroundAsset(
      id: json['id'] as String,
      name: json['name'] as String,
      type: BackgroundType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => BackgroundType.color,
      ),
      solidColor:
          json['solidColor'] != null ? Color(json['solidColor'] as int) : null,
      gradientColors: json['gradientColors'] != null
          ? (json['gradientColors'] as List)
              .map((c) => Color(c as int))
              .toList()
          : null,
      gradientAngle: (json['gradientAngle'] as num?)?.toDouble() ?? 0,
      imagePath: json['imagePath'] as String?,
      repeatImage: json['repeatImage'] as bool? ?? false,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      blurAmount: (json['blurAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  LinearGradient? toLinearGradient() {
    if (type != BackgroundType.gradient || gradientColors == null) {
      return null;
    }
    return LinearGradient(
      colors: gradientColors!,
      begin: _angleToAlignment(gradientAngle),
      end: _angleToAlignment(gradientAngle + 180),
    );
  }

  Alignment _angleToAlignment(double angleDegrees) {
    final radians = angleDegrees * (math.pi / 180);
    final x = 0.5 + 0.5 * math.cos(radians);
    final y = 0.5 + 0.5 * math.sin(radians);
    return Alignment(x * 2 - 1, y * 2 - 1);
  }
}

/// مكتبة الخلفيات المدمجة
class BuiltinBackgrounds {
  BuiltinBackgrounds._();

  static List<BackgroundAsset> get all => [
        BackgroundAsset.gradient(
          name: 'Aurora',
          colors: const [
            Color(0xFF16D9F2),
            Color(0xFF8B5CF6),
            Color(0xFFFF6B9D),
          ],
          angle: 45,
        ),
        BackgroundAsset.gradient(
          name: 'Sunset',
          colors: const [
            Color(0xFFFF9500),
            Color(0xFFFF6B9D),
            Color(0xFF8B5CF6),
          ],
          angle: 135,
        ),
        BackgroundAsset.gradient(
          name: 'Ocean',
          colors: const [
            Color(0xFF16D9F2),
            Color(0xFF3B82F6),
            Color(0xFF8B5CF6),
          ],
          angle: 90,
        ),
        BackgroundAsset.gradient(
          name: 'Forest',
          colors: const [
            Color(0xFF10E5A0),
            Color(0xFF16D9F2),
          ],
          angle: 45,
        ),
        BackgroundAsset.gradient(
          name: 'Fire',
          colors: const [
            Color(0xFFFFD700),
            Color(0xFFFF9500),
            Color(0xFFFF3D5A),
          ],
          angle: 90,
        ),
        BackgroundAsset.gradient(
          name: 'Cosmic',
          colors: const [
            Color(0xFF8B5CF6),
            Color(0xFFFF6B9D),
            Color(0xFF16D9F2),
          ],
          angle: 135,
        ),
        BackgroundAsset.gradient(
          name: 'Neon Night',
          colors: const [
            Color(0xFF05070D),
            Color(0xFF16D9F2),
            Color(0xFF8B5CF6),
          ],
          angle: 180,
        ),
        BackgroundAsset.gradient(
          name: 'Pastel',
          colors: const [
            Color(0xFF6EE8F5),
            Color(0xFFA989F9),
            Color(0xFFFFB4CE),
          ],
          angle: 45,
        ),
        BackgroundAsset.solid(
          name: 'أسود',
          color: const Color(0xFF000000),
        ),
        BackgroundAsset.solid(
          name: 'كحلي',
          color: const Color(0xFF071426),
        ),
        BackgroundAsset.solid(
          name: 'أزرق داكن',
          color: const Color(0xFF102C43),
        ),
        BackgroundAsset.solid(
          name: 'رمادي غامق',
          color: const Color(0xFF1A1A1A),
        ),
      ];
}
