import 'package:flutter/material.dart';

/// نوع الإسقاط ثلاثي الأبعاد
enum Projection3D {
  isometric,    // isometric (متساوي القياس)
  dimetric,     // dimetric
  trimetric,    // trimetric
  perspective,  // منظوري
  cavalier,     // فرسان
  cabinet,      // خزانة
}

extension Projection3DExt on Projection3D {
  String get labelAr {
    switch (this) {
      case Projection3D.isometric: return 'متساوي القياس';
      case Projection3D.dimetric: return 'ثنائي القياس';
      case Projection3D.trimetric: return 'ثلاثي القياس';
      case Projection3D.perspective: return 'منظوري';
      case Projection3D.cavalier: return 'فرسان';
      case Projection3D.cabinet: return 'خزانة';
    }
  }
}

/// إعدادات 3D للشكل
class Shape3DSettings {
  /// نوع الإسقاط
  final Projection3D projection;

  /// زاوية الإسقاط (بالدرجات)
  final double angle;

  /// عمق البثق (0.0 - 1.0)
  final double depth;

  /// لون الوجه الأمامي
  final Color frontColor;

  /// لون الوجه الجانبي
  final Color sideColor;

  /// لون الوجه العلوي
  final Color topColor;

  /// شدة الظل
  final double shadowIntensity;

  /// انعكاس ضوئي
  final double highlightIntensity;

  /// زاوية الضوء
  final double lightAngle;

  const Shape3DSettings({
    this.projection = Projection3D.isometric,
    this.angle = 30,
    this.depth = 0.3,
    this.frontColor = const Color(0xFF16D9F2),
    this.sideColor = const Color(0xFF0A8DA0),
    this.topColor = const Color(0xFF6EE8F5),
    this.shadowIntensity = 0.4,
    this.highlightIntensity = 0.6,
    this.lightAngle = 135,
  });

  factory Shape3DSettings.fromColor(Color base) {
    return Shape3DSettings(
      frontColor: base,
      sideColor: _darken(base, 0.25),
      topColor: _lighten(base, 0.20),
    );
  }

  Shape3DSettings copyWith({
    Projection3D? projection,
    double? angle,
    double? depth,
    Color? frontColor,
    Color? sideColor,
    Color? topColor,
    double? shadowIntensity,
    double? highlightIntensity,
    double? lightAngle,
  }) {
    return Shape3DSettings(
      projection: projection ?? this.projection,
      angle: angle ?? this.angle,
      depth: depth ?? this.depth,
      frontColor: frontColor ?? this.frontColor,
      sideColor: sideColor ?? this.sideColor,
      topColor: topColor ?? this.topColor,
      shadowIntensity: shadowIntensity ?? this.shadowIntensity,
      highlightIntensity: highlightIntensity ?? this.highlightIntensity,
      lightAngle: lightAngle ?? this.lightAngle,
    );
  }

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}

/// أنواع الأشكال 3D
enum Shape3DType {
  cube,           // مكعب
  sphere,         // كرة
  cylinder,       // أسطوانة
  cone,           // مخروط
  pyramid,        // هرم
  torus,          // طارة
  prism,          // موشور
  diamond,        // ألماسة
  crystal,        // كريستال
  ring,           // حلقة
  pill,           // كبسولة
  block,          // بلوك
  plate,          // لوح
  disk,           // قرص
  coin,           // عملة
  barrel,         // برميل
  dome,           // قبة
  frustum,        // مخروط مقطوع
  wedge,          // إسفين
  helix,          // حلزوني
}

extension Shape3DTypeExt on Shape3DType {
  String get labelAr {
    switch (this) {
      case Shape3DType.cube: return 'مكعب';
      case Shape3DType.sphere: return 'كرة';
      case Shape3DType.cylinder: return 'أسطوانة';
      case Shape3DType.cone: return 'مخروط';
      case Shape3DType.pyramid: return 'هرم';
      case Shape3DType.torus: return 'طارة';
      case Shape3DType.prism: return 'موشور';
      case Shape3DType.diamond: return 'ألماسة';
      case Shape3DType.crystal: return 'كريستال';
      case Shape3DType.ring: return 'حلقة';
      case Shape3DType.pill: return 'كبسولة';
      case Shape3DType.block: return 'بلوك';
      case Shape3DType.plate: return 'لوح';
      case Shape3DType.disk: return 'قرص';
      case Shape3DType.coin: return 'عملة';
      case Shape3DType.barrel: return 'برميل';
      case Shape3DType.dome: return 'قبة';
      case Shape3DType.frustum: return 'مخروط مقطوع';
      case Shape3DType.wedge: return 'إسفين';
      case Shape3DType.helix: return 'حلزوني';
    }
  }

  IconData get icon {
    switch (this) {
      case Shape3DType.cube: return Icons.view_in_ar_outlined;
      case Shape3DType.sphere: return Icons.circle_outlined;
      case Shape3DType.cylinder: return Icons.rectangle_outlined;
      case Shape3DType.cone: return Icons.change_history_outlined;
      case Shape3DType.pyramid: return Icons.change_history;
      case Shape3DType.torus: return Icons.donut_large_outlined;
      case Shape3DType.prism: return Icons.hexagon_outlined;
      case Shape3DType.diamond: return Icons.diamond_outlined;
      case Shape3DType.crystal: return Icons.auto_awesome_outlined;
      case Shape3DType.ring: return Icons.circle_outlined;
      case Shape3DType.pill: return Icons.medication_outlined;
      case Shape3DType.block: return Icons.crop_square_outlined;
      case Shape3DType.plate: return Icons.square_outlined;
      case Shape3DType.disk: return Icons.album_outlined;
      case Shape3DType.coin: return Icons.monetization_on_outlined;
      case Shape3DType.barrel: return Icons.storage_outlined;
      case Shape3DType.dome: return Icons.wb_twilight_outlined;
      case Shape3DType.frustum: return Icons.filter_vintage_outlined;
      case Shape3DType.wedge: return Icons.arrow_forward_outlined;
      case Shape3DType.helix: return Icons.gesture_outlined;
    }
  }
}
