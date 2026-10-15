import 'package:flutter/material.dart';

import '../models/key_shape.dart';
import '../models/shape_3d.dart';
import '../services/shape_3d_renderer.dart';
import '../services/shape_renderer.dart';

/// Widget يعرض أي شكل — 2D أو 3D
class ShapeWidget extends StatelessWidget {
  final KeyShape shape;
  final Color color;
  final Color borderColor;
  final Color? topColor;
  final Color? sideColor;
  final double borderWidth;
  final double roundedness;
  final double width;
  final double height;
  final Widget? child;

  const ShapeWidget({
    super.key,
    required this.shape,
    required this.color,
    this.borderColor = Colors.transparent,
    this.topColor,
    this.sideColor,
    this.borderWidth = 0,
    this.roundedness = 0.5,
    required this.width,
    required this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // إذا كان 3D → استخدم Shape3DWidget
    if (shape.is3D) {
      return Shape3DWidget(
        shape: shape,
        color: color,
        width: width,
        height: height,
        child: child,
      );
    }

    // 2D عادي
    return CustomPaint(
      size: Size(width, height),
      painter: _ShapePainter2D(
        shape: shape,
        color: color,
        borderColor: borderColor,
        borderWidth: borderWidth,
        roundedness: roundedness,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}

class _ShapePainter2D extends CustomPainter {
  final KeyShape shape;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double roundedness;

  const _ShapePainter2D({
    required this.shape,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.roundedness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = ShapeRenderer.render(shape, size, roundedness: roundedness);

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(path, fill);

    if (borderWidth > 0) {
      final border = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..isAntiAlias = true;

      canvas.drawPath(path, border);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter2D old) {
    return old.shape != shape ||
        old.color != color ||
        old.borderColor != borderColor ||
        old.borderWidth != borderWidth ||
        old.roundedness != roundedness;
  }
}

/// Widget لعرض الشكل 3D
class Shape3DWidget extends StatelessWidget {
  final KeyShape shape;
  final Color color;
  final double width;
  final double height;
  final Widget? child;

  const Shape3DWidget({
    super.key,
    required this.shape,
    required this.color,
    required this.width,
    required this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _Shape3DPainter(
        shape: shape,
        baseColor: color,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}

class _Shape3DPainter extends CustomPainter {
  final KeyShape shape;
  final Color baseColor;

  const _Shape3DPainter({
    required this.shape,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final settings = Shape3DSettings.fromColor(baseColor);
    final type = _shapeTo3DType(shape);
    Shape3DRenderer.render(type, canvas, size, settings);
  }

  Shape3DType _shapeTo3DType(KeyShape shape) {
    switch (shape) {
      case KeyShape.cube3D:
      case KeyShape.cubeIso:
      case KeyShape.cube3DTilt:
      case KeyShape.block3D:
      case KeyShape.brick3D:
      case KeyShape.box3D:
      case KeyShape.boxOpen3D:
      case KeyShape.dice3D:
      case KeyShape.cross3D:
        return Shape3DType.cube;
      case KeyShape.sphere3D:
      case KeyShape.sphere3DGradient:
      case KeyShape.ball3D:
        return Shape3DType.sphere;
      case KeyShape.cylinder3D:
      case KeyShape.cylinderVertical:
        return Shape3DType.cylinder;
      case KeyShape.cone3D:
      case KeyShape.coneInverted:
        return Shape3DType.cone;
      case KeyShape.pyramid3D:
      case KeyShape.pyramidSquare:
      case KeyShape.pyramidTriangle:
        return Shape3DType.pyramid;
      case KeyShape.torus3D:
      case KeyShape.donut3D:
        return Shape3DType.torus;
      case KeyShape.ring3D:
        return Shape3DType.ring;
      case KeyShape.prism3D:
      case KeyShape.prismTriangle:
      case KeyShape.prismHex:
        return Shape3DType.prism;
      case KeyShape.diamond3D:
      case KeyShape.gem3D:
        return Shape3DType.diamond;
      case KeyShape.crystal3D:
      case KeyShape.crystalCluster:
        return Shape3DType.crystal;
      case KeyShape.pill3D:
      case KeyShape.capsule3D:
        return Shape3DType.pill;
      case KeyShape.plate3D:
      case KeyShape.plateRound3D:
        return Shape3DType.plate;
      case KeyShape.disk3D:
        return Shape3DType.disk;
      case KeyShape.coin3D:
        return Shape3DType.coin;
      case KeyShape.button3D:
      case KeyShape.key3D:
      case KeyShape.gift3D:
      case KeyShape.building3D:
      case KeyShape.house3D:
      case KeyShape.tower3D:
      case KeyShape.obelisk3D:
        return Shape3DType.block;
      case KeyShape.arch3D:
        return Shape3DType.dome;
      case KeyShape.stairs3D:
        return Shape3DType.wedge;
      case KeyShape.bowl3D:
      case KeyShape.vase3D:
      case KeyShape.pot3D:
      case KeyShape.cup3D:
      case KeyShape.jar3D:
        return Shape3DType.frustum;
      case KeyShape.barrel3D:
        return Shape3DType.barrel;
      default:
        return Shape3DType.cube;
    }
  }

  @override
  bool shouldRepaint(covariant _Shape3DPainter old) {
    return old.shape != shape || old.baseColor != baseColor;
  }
}
