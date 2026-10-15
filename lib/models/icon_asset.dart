import 'package:flutter/material.dart';

/// نوع الأيقونة
enum IconType {
  material,
  customImage,
  emoji,
}

/// أصل أيقونة
class IconAsset {
  final String id;
  final String name;
  final IconType type;
  final Color tint;
  final int targetDensity;
  final int size;
  final IconData? materialIcon;
  final String? customImagePath;
  final String? emoji;

  const IconAsset({
    required this.id,
    required this.name,
    this.type = IconType.material,
    this.tint = const Color(0xFFFFFFFF),
    this.targetDensity = 640,
    this.size = 64,
    this.materialIcon,
    this.customImagePath,
    this.emoji,
  });

  factory IconAsset.fromMaterial({
    required String name,
    required IconData icon,
    Color tint = const Color(0xFFFFFFFF),
  }) {
    return IconAsset(
      id: 'icon_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: IconType.material,
      tint: tint,
      materialIcon: icon,
    );
  }

  factory IconAsset.fromImage({
    required String name,
    required String imagePath,
    Color tint = const Color(0xFFFFFFFF),
  }) {
    return IconAsset(
      id: 'icon_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: IconType.customImage,
      tint: tint,
      customImagePath: imagePath,
    );
  }

  factory IconAsset.fromEmoji({
    required String name,
    required String emoji,
    Color tint = const Color(0xFFFFFFFF),
  }) {
    return IconAsset(
      id: 'icon_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: IconType.emoji,
      tint: tint,
      emoji: emoji,
    );
  }

  IconAsset copyWith({
    String? id,
    String? name,
    IconType? type,
    Color? tint,
    int? targetDensity,
    int? size,
    IconData? materialIcon,
    String? customImagePath,
    String? emoji,
  }) {
    return IconAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      tint: tint ?? this.tint,
      targetDensity: targetDensity ?? this.targetDensity,
      size: size ?? this.size,
      materialIcon: materialIcon ?? this.materialIcon,
      customImagePath: customImagePath ?? this.customImagePath,
      emoji: emoji ?? this.emoji,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'tint': tint.toARGB32(),
        'targetDensity': targetDensity,
        'size': size,
        'materialIcon': materialIcon?.codePoint,
        'customImagePath': customImagePath,
        'emoji': emoji,
      };

  factory IconAsset.fromJson(Map<String, dynamic> json) {
    IconData? icon;
    if (json['materialIcon'] != null) {
      icon = IconData(
        json['materialIcon'] as int,
        fontFamily: 'MaterialIcons',
      );
    }
    return IconAsset(
      id: json['id'] as String,
      name: json['name'] as String,
      type: IconType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => IconType.material,
      ),
      tint: Color(json['tint'] as int),
      targetDensity: json['targetDensity'] as int,
      size: json['size'] as int,
      materialIcon: icon,
      customImagePath: json['customImagePath'] as String?,
      emoji: json['emoji'] as String?,
    );
  }

  String toTomlSection() {
    return '\n[[asset.icon]]\nname = "$name"\ntarget_density = $targetDensity\n';
  }

  bool get isValid {
    if (type == IconType.material) return materialIcon != null;
    if (type == IconType.customImage) return customImagePath != null;
    if (type == IconType.emoji) return emoji != null;
    return false;
  }

  /// هل هو إيموجي؟
  bool get isEmoji => type == IconType.emoji && emoji != null;
}
