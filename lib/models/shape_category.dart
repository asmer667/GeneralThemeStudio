import 'package:flutter/material.dart';

/// تصنيفات الأشكال (موسّعة)
enum ShapeCategory {
  basic,        // مستطيل، دائرة، مربع
  polygon,      // مضلعات 3-12 ضلعاً
  star,         // نجوم 3-12 رأساً
  arrow,        // أسهم
  nature,       // طبيعة (أوراق، زهور، أشجار)
  animal,       // حيوانات (قطة، كلب، فأر...)
  food,         // طعام (كيك، تفاح، قهوة...)
  symbol,       // رموز (قلب، صليب، قفل...)
  tech,         // تقني (سحابة، هاتف، wifi...)
  geometric3d,  // 3D (مكعب، كرة، أسطوانة...)
  ornamental,   // زخرفي (إسلامي، كريستال...)
  abstract,     // تجريدي
  custom,       // مخصص
}

extension ShapeCategoryExt on ShapeCategory {
  String get labelAr {
    switch (this) {
      case ShapeCategory.basic: return 'أساسية';
      case ShapeCategory.polygon: return 'مضلعات';
      case ShapeCategory.star: return 'نجوم';
      case ShapeCategory.arrow: return 'أسهم';
      case ShapeCategory.nature: return 'طبيعة';
      case ShapeCategory.animal: return 'حيوانات';
      case ShapeCategory.food: return 'طعام';
      case ShapeCategory.symbol: return 'رموز';
      case ShapeCategory.tech: return 'تقني';
      case ShapeCategory.geometric3d: return 'ثلاثي الأبعاد';
      case ShapeCategory.ornamental: return 'زخرفي';
      case ShapeCategory.abstract: return 'تجريدي';
      case ShapeCategory.custom: return 'مخصص';
    }
  }

  String get labelEn {
    switch (this) {
      case ShapeCategory.basic: return 'Basic';
      case ShapeCategory.polygon: return 'Polygons';
      case ShapeCategory.star: return 'Stars';
      case ShapeCategory.arrow: return 'Arrows';
      case ShapeCategory.nature: return 'Nature';
      case ShapeCategory.animal: return 'Animals';
      case ShapeCategory.food: return 'Food';
      case ShapeCategory.symbol: return 'Symbols';
      case ShapeCategory.tech: return 'Tech';
      case ShapeCategory.geometric3d: return '3D';
      case ShapeCategory.ornamental: return 'Ornamental';
      case ShapeCategory.abstract: return 'Abstract';
      case ShapeCategory.custom: return 'Custom';
    }
  }

  IconData get icon {
    switch (this) {
      case ShapeCategory.basic: return Icons.crop_square;
      case ShapeCategory.polygon: return Icons.hexagon_outlined;
      case ShapeCategory.star: return Icons.star_outline;
      case ShapeCategory.arrow: return Icons.arrow_forward;
      case ShapeCategory.nature: return Icons.local_florist_outlined;
      case ShapeCategory.animal: return Icons.pets_outlined;
      case ShapeCategory.food: return Icons.restaurant_outlined;
      case ShapeCategory.symbol: return Icons.favorite_outline;
      case ShapeCategory.tech: return Icons.cloud_outlined;
      case ShapeCategory.geometric3d: return Icons.view_in_ar_outlined;
      case ShapeCategory.ornamental: return Icons.auto_awesome_outlined;
      case ShapeCategory.abstract: return Icons.blur_on_outlined;
      case ShapeCategory.custom: return Icons.upload_file_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ShapeCategory.basic: return const Color(0xFF16D9F2);
      case ShapeCategory.polygon: return const Color(0xFF8B5CF6);
      case ShapeCategory.star: return const Color(0xFFFFD700);
      case ShapeCategory.arrow: return const Color(0xFF3B82F6);
      case ShapeCategory.nature: return const Color(0xFF10E5A0);
      case ShapeCategory.animal: return const Color(0xFFFF6B9D);
      case ShapeCategory.food: return const Color(0xFFFF9500);
      case ShapeCategory.symbol: return const Color(0xFFFF3D5A);
      case ShapeCategory.tech: return const Color(0xFF00BCD4);
      case ShapeCategory.geometric3d: return const Color(0xFFA989F9);
      case ShapeCategory.ornamental: return const Color(0xFFE91E63);
      case ShapeCategory.abstract: return const Color(0xFFCDDC39);
      case ShapeCategory.custom: return const Color(0xFF808080);
    }
  }

  /// هل هذا التصنيف يدعم 3D؟
  bool get supports3D => this == ShapeCategory.geometric3d;
}
