import 'package:flutter/material.dart';

import '../models/shape_3d.dart';
import '../services/shape_3d_renderer.dart';

/// Widget لعرض شكل 3D مع إعدادات كاملة
class Shape3DWidgetFull extends StatelessWidget {
  final Shape3DType type;
  final Shape3DSettings settings;
  final double width;
  final double height;
  final Widget? child;

  const Shape3DWidgetFull({
    super.key,
    required this.type,
    required this.settings,
    required this.width,
    required this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: Shape3DPainter(
        type: type,
        settings: settings,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}

/// Painter للشكل 3D
class Shape3DPainter extends CustomPainter {
  final Shape3DType type;
  final Shape3DSettings settings;

  const Shape3DPainter({
    required this.type,
    required this.settings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Shape3DRenderer.render(type, canvas, size, settings);
  }

  @override
  bool shouldRepaint(covariant Shape3DPainter old) {
    return old.type != type ||
        old.settings.frontColor != settings.frontColor ||
        old.settings.sideColor != settings.sideColor ||
        old.settings.topColor != settings.topColor ||
        old.settings.depth != settings.depth;
  }
}
