import 'package:flutter/material.dart';

import 'background_asset.dart';
import 'key_group.dart';

/// المشروع الكامل — يحتوي كل بيانات ثيم واحد
class ThemeProject {
  // Metadata
  String id;
  String name;
  String author;
  String description;
  int version;

  // Primary Colors
  Color primary;
  Color onPrimary;
  Color primaryContainer;
  Color onPrimaryContainer;

  // Secondary Colors
  Color secondary;
  Color onSecondary;
  Color secondaryContainer;
  Color onSecondaryContainer;

  // Tertiary
  Color tertiary;
  Color onTertiary;

  // Background
  Color background;
  Color onBackground;

  // Surface
  Color surface;
  Color onSurface;
  Color surfaceVariant;
  Color onSurfaceVariant;

  // Error
  Color error;
  Color onError;

  // Outline
  Color outline;
  Color outlineVariant;

  // Keyboard
  Color keyboardSurface;
  Color keyboardContainer;
  Color keyboardContainerVariant;
  Color onKeyboardContainer;
  Color keyboardPress;
  Color keyboardContainerPressed;
  Color onKeyboardContainerPressed;

  // Options
  double roundedness;
  double scaleText;
  double scaleHints;
  int weightText;
  int weightHints;
  bool autoBorders;
  bool centerHints;

  // Groups
  List<KeyGroup> groups;

  // Fonts
  String? fontName;
  String? fontPath;

  // Background Image (asset)
  String? backgroundImagePath;

  // Background Asset (for images/gradients)
  BackgroundAsset? backgroundAsset;

  // Timestamps
  DateTime createdAt;
  DateTime updatedAt;

  ThemeProject({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    this.version = 1,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.error,
    required this.onError,
    required this.outline,
    required this.outlineVariant,
    required this.keyboardSurface,
    required this.keyboardContainer,
    required this.keyboardContainerVariant,
    required this.onKeyboardContainer,
    required this.keyboardPress,
    required this.keyboardContainerPressed,
    required this.onKeyboardContainerPressed,
    this.roundedness = 0.5,
    this.scaleText = 1.0,
    this.scaleHints = 0.9,
    this.weightText = 400,
    this.weightHints = 400,
    this.autoBorders = true,
    this.centerHints = false,
    required this.groups,
    this.fontName,
    this.fontPath,
    this.backgroundImagePath,
    this.backgroundAsset,
    required this.createdAt,
    required this.updatedAt,
  });

  /// مشروع افتراضي
  factory ThemeProject.createDefault() {
    const primary = Color(0xFF16D9F2);
    const secondary = Color(0xFF8B5CF6);
    const surface = Color(0xFF071426);
    const container = Color(0xFF102C43);
    const containerHigh = Color(0xFF183D58);
    const onSurface = Color(0xFFF4FAFF);

    return ThemeProject(
      id: 'studio.${DateTime.now().millisecondsSinceEpoch}',
      name: 'My Theme',
      author: 'Anonymous',
      description: 'A theme created with General Theme Studio.',
      primary: primary,
      onPrimary: const Color(0xFFFFFFFF),
      primaryContainer: primary,
      onPrimaryContainer: surface,
      secondary: secondary,
      onSecondary: const Color(0xFFFFFFFF),
      secondaryContainer: containerHigh,
      onSecondaryContainer: onSurface,
      tertiary: secondary,
      onTertiary: const Color(0xFFFFFFFF),
      background: surface,
      onBackground: onSurface,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: container,
      onSurfaceVariant: onSurface,
      error: const Color(0xFFC00100),
      onError: const Color(0xFFFFFFFF),
      outline: const Color(0xFF327D9D),
      outlineVariant: const Color(0xFF327D9D),
      keyboardSurface: surface,
      keyboardContainer: container,
      keyboardContainerVariant: containerHigh,
      onKeyboardContainer: onSurface,
      keyboardPress: primary,
      keyboardContainerPressed: containerHigh,
      onKeyboardContainerPressed: onSurface,
      groups: DefaultGroups.createDefaultList(container, containerHigh),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  ThemeProject copyWith({
    String? id,
    String? name,
    String? author,
    String? description,
    int? version,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? error,
    Color? onError,
    Color? outline,
    Color? outlineVariant,
    Color? keyboardSurface,
    Color? keyboardContainer,
    Color? keyboardContainerVariant,
    Color? onKeyboardContainer,
    Color? keyboardPress,
    Color? keyboardContainerPressed,
    Color? onKeyboardContainerPressed,
    double? roundedness,
    double? scaleText,
    double? scaleHints,
    int? weightText,
    int? weightHints,
    bool? autoBorders,
    bool? centerHints,
    List<KeyGroup>? groups,
    String? fontName,
    String? fontPath,
    String? backgroundImagePath,
    BackgroundAsset? backgroundAsset,
    bool clearBackgroundAsset = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThemeProject(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      description: description ?? this.description,
      version: version ?? this.version,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer:
          onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      keyboardSurface: keyboardSurface ?? this.keyboardSurface,
      keyboardContainer: keyboardContainer ?? this.keyboardContainer,
      keyboardContainerVariant:
          keyboardContainerVariant ?? this.keyboardContainerVariant,
      onKeyboardContainer:
          onKeyboardContainer ?? this.onKeyboardContainer,
      keyboardPress: keyboardPress ?? this.keyboardPress,
      keyboardContainerPressed:
          keyboardContainerPressed ?? this.keyboardContainerPressed,
      onKeyboardContainerPressed:
          onKeyboardContainerPressed ?? this.onKeyboardContainerPressed,
      roundedness: roundedness ?? this.roundedness,
      scaleText: scaleText ?? this.scaleText,
      scaleHints: scaleHints ?? this.scaleHints,
      weightText: weightText ?? this.weightText,
      weightHints: weightHints ?? this.weightHints,
      autoBorders: autoBorders ?? this.autoBorders,
      centerHints: centerHints ?? this.centerHints,
      groups: groups ?? this.groups,
      fontName: fontName ?? this.fontName,
      fontPath: fontPath ?? this.fontPath,
      backgroundImagePath:
          backgroundImagePath ?? this.backgroundImagePath,
      backgroundAsset: clearBackgroundAsset
          ? null
          : (backgroundAsset ?? this.backgroundAsset),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ThemeProject touch() => copyWith(updatedAt: DateTime.now());

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'author': author,
        'description': description,
        'version': version,
        'primary': primary.toARGB32(),
        'onPrimary': onPrimary.toARGB32(),
        'primaryContainer': primaryContainer.toARGB32(),
        'onPrimaryContainer': onPrimaryContainer.toARGB32(),
        'secondary': secondary.toARGB32(),
        'onSecondary': onSecondary.toARGB32(),
        'secondaryContainer': secondaryContainer.toARGB32(),
        'onSecondaryContainer': onSecondaryContainer.toARGB32(),
        'tertiary': tertiary.toARGB32(),
        'onTertiary': onTertiary.toARGB32(),
        'background': background.toARGB32(),
        'onBackground': onBackground.toARGB32(),
        'surface': surface.toARGB32(),
        'onSurface': onSurface.toARGB32(),
        'surfaceVariant': surfaceVariant.toARGB32(),
        'onSurfaceVariant': onSurfaceVariant.toARGB32(),
        'error': error.toARGB32(),
        'onError': onError.toARGB32(),
        'outline': outline.toARGB32(),
        'outlineVariant': outlineVariant.toARGB32(),
        'keyboardSurface': keyboardSurface.toARGB32(),
        'keyboardContainer': keyboardContainer.toARGB32(),
        'keyboardContainerVariant': keyboardContainerVariant.toARGB32(),
        'onKeyboardContainer': onKeyboardContainer.toARGB32(),
        'keyboardPress': keyboardPress.toARGB32(),
        'keyboardContainerPressed': keyboardContainerPressed.toARGB32(),
        'onKeyboardContainerPressed':
            onKeyboardContainerPressed.toARGB32(),
        'roundedness': roundedness,
        'scaleText': scaleText,
        'scaleHints': scaleHints,
        'weightText': weightText,
        'weightHints': weightHints,
        'autoBorders': autoBorders,
        'centerHints': centerHints,
        'groups': groups.map((g) => g.toJson()).toList(),
        'fontName': fontName,
        'fontPath': fontPath,
        'backgroundImagePath': backgroundImagePath,
        'backgroundAsset': backgroundAsset?.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ThemeProject.fromJson(Map<String, dynamic> json) {
    return ThemeProject(
      id: json['id'] as String,
      name: json['name'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      version: json['version'] as int? ?? 1,
      primary: Color(json['primary'] as int),
      onPrimary: Color(json['onPrimary'] as int),
      primaryContainer: Color(json['primaryContainer'] as int),
      onPrimaryContainer: Color(json['onPrimaryContainer'] as int),
      secondary: Color(json['secondary'] as int),
      onSecondary: Color(json['onSecondary'] as int),
      secondaryContainer: Color(json['secondaryContainer'] as int),
      onSecondaryContainer: Color(json['onSecondaryContainer'] as int),
      tertiary: Color(json['tertiary'] as int),
      onTertiary: Color(json['onTertiary'] as int),
      background: Color(json['background'] as int),
      onBackground: Color(json['onBackground'] as int),
      surface: Color(json['surface'] as int),
      onSurface: Color(json['onSurface'] as int),
      surfaceVariant: Color(json['surfaceVariant'] as int),
      onSurfaceVariant: Color(json['onSurfaceVariant'] as int),
      error: Color(json['error'] as int),
      onError: Color(json['onError'] as int),
      outline: Color(json['outline'] as int),
      outlineVariant: Color(json['outlineVariant'] as int),
      keyboardSurface: Color(json['keyboardSurface'] as int),
      keyboardContainer: Color(json['keyboardContainer'] as int),
      keyboardContainerVariant:
          Color(json['keyboardContainerVariant'] as int),
      onKeyboardContainer: Color(json['onKeyboardContainer'] as int),
      keyboardPress: Color(json['keyboardPress'] as int),
      keyboardContainerPressed:
          Color(json['keyboardContainerPressed'] as int),
      onKeyboardContainerPressed:
          Color(json['onKeyboardContainerPressed'] as int),
      roundedness: (json['roundedness'] as num).toDouble(),
      scaleText: (json['scaleText'] as num).toDouble(),
      scaleHints: (json['scaleHints'] as num).toDouble(),
      weightText: json['weightText'] as int? ?? 400,
      weightHints: json['weightHints'] as int? ?? 400,
      autoBorders: json['autoBorders'] as bool? ?? true,
      centerHints: json['centerHints'] as bool? ?? false,
      groups: (json['groups'] as List)
          .map((g) => KeyGroup.fromJson(g as Map<String, dynamic>))
          .toList(),
      fontName: json['fontName'] as String?,
      fontPath: json['fontPath'] as String?,
      backgroundImagePath: json['backgroundImagePath'] as String?,
      backgroundAsset: json['backgroundAsset'] != null
          ? BackgroundAsset.fromJson(
              json['backgroundAsset'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  String get summary =>
      '$name — ${groups.length} مجموعة، ${groups.fold<int>(0, (sum, g) => sum + g.assetCount)} أصل';
}
