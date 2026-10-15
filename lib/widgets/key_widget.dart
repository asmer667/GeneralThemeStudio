import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/key_shape.dart';
import 'shape_widget.dart';

/// زر لوحة مفاتيح واحد قابل للعرض
class KeyWidget extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final KeyShape shape;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double borderWidth;
  final double roundedness;
  final double width;
  final double height;
  final double fontSize;
  final String? fontFamily;
  final String? backgroundImagePath;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isPressed;
  final bool showShadow;

  const KeyWidget({
    super.key,
    this.label,
    this.icon,
    this.shape = KeyShape.roundedRectangle,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.roundedness = 0.5,
    this.width = 44,
    this.height = 48,
    this.fontSize = 16,
    this.fontFamily,
    this.backgroundImagePath,
    this.onTap,
    this.onLongPress,
    this.isPressed = false,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPressed ? _pressedColor(backgroundColor) : backgroundColor;

    Widget keyContent;
    if (icon != null) {
      keyContent = Icon(icon, color: foregroundColor, size: fontSize + 4);
    } else if (label != null) {
      keyContent = Text(
        label!,
        style: TextStyle(
          color: foregroundColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      keyContent = const SizedBox.shrink();
    }

    Widget shapeWidget = ShapeWidget(
      shape: shape,
      color: bg,
      borderColor: borderColor,
      borderWidth: borderWidth,
      roundedness: roundedness,
      width: width,
      height: height,
      backgroundImagePath: backgroundImagePath,
      child: keyContent,
    );

    if (showShadow && !isPressed) {
      shapeWidget = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: shapeWidget,
      );
    }

    if (onTap == null && onLongPress == null) {
      return shapeWidget;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: shapeWidget,
    );
  }

  Color _pressedColor(Color base) {
    final hsl = HSLColor.fromColor(base);
    return hsl.withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0)).toColor();
  }
}

/// صف أزرار كامل
class KeyRow extends StatelessWidget {
  final List<KeyData> keys;
  final double spacing;

  const KeyRow({
    super.key,
    required this.keys,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          KeyWidget(
            label: keys[i].label,
            icon: keys[i].icon,
            shape: keys[i].shape,
            backgroundColor: keys[i].backgroundColor,
            foregroundColor: keys[i].foregroundColor,
            borderColor: keys[i].borderColor,
            borderWidth: keys[i].borderWidth,
            roundedness: keys[i].roundedness,
            width: keys[i].width,
            height: keys[i].height,
            fontSize: keys[i].fontSize,
            fontFamily: keys[i].fontFamily,
            backgroundImagePath: keys[i].backgroundImagePath,
            isPressed: keys[i].isPressed,
          ),
          if (i < keys.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}

/// بيانات زر واحد
class KeyData {
  final String? label;
  final IconData? icon;
  final KeyShape shape;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double borderWidth;
  final double roundedness;
  final double width;
  final double height;
  final double fontSize;
  final String? fontFamily;
  final String? backgroundImagePath;
  final bool isPressed;

  const KeyData({
    this.label,
    this.icon,
    this.shape = KeyShape.roundedRectangle,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.roundedness = 0.5,
    this.width = 44,
    this.height = 48,
    this.fontSize = 16,
    this.fontFamily,
    this.backgroundImagePath,
    this.isPressed = false,
  });

  factory KeyData.letter({
    required String label,
    required Color bg,
    required Color fg,
    KeyShape shape = KeyShape.roundedRectangle,
    double roundedness = 0.5,
    bool isPressed = false,
    double width = 44,
    double height = 48,
    double fontSize = 16,
    String? fontFamily,
    String? backgroundImagePath,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
  }) {
    return KeyData(
      label: label,
      backgroundColor: bg,
      foregroundColor: fg,
      shape: shape,
      roundedness: roundedness,
      isPressed: isPressed,
      width: width,
      height: height,
      fontSize: fontSize,
      fontFamily: fontFamily,
      backgroundImagePath: backgroundImagePath,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  factory KeyData.iconKey({
    required IconData icon,
    required Color bg,
    required Color fg,
    KeyShape shape = KeyShape.roundedRectangle,
    double roundedness = 0.5,
    double width = 44,
    double height = 48,
    double fontSize = 16,
    String? fontFamily,
    String? backgroundImagePath,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
  }) {
    return KeyData(
      icon: icon,
      backgroundColor: bg,
      foregroundColor: fg,
      shape: shape,
      roundedness: roundedness,
      width: width,
      height: height,
      fontSize: fontSize,
      fontFamily: fontFamily,
      backgroundImagePath: backgroundImagePath,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }
}
