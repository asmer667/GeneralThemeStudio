import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/shape_3d.dart';

/// محرّك رسم الأشكال 3D الحقيقي
class Shape3DRenderer {
  Shape3DRenderer._();

  static void render(
    Shape3DType type,
    Canvas canvas,
    Size size,
    Shape3DSettings settings,
  ) {
    switch (type) {
      case Shape3DType.cube:
        _drawCube(canvas, size, settings);
        break;
      case Shape3DType.sphere:
        _drawSphere(canvas, size, settings);
        break;
      case Shape3DType.cylinder:
        _drawCylinder(canvas, size, settings);
        break;
      case Shape3DType.cone:
        _drawCone(canvas, size, settings);
        break;
      case Shape3DType.pyramid:
        _drawPyramid(canvas, size, settings);
        break;
      case Shape3DType.torus:
        _drawTorus(canvas, size, settings);
        break;
      case Shape3DType.prism:
        _drawPrism(canvas, size, settings);
        break;
      case Shape3DType.diamond:
        _drawDiamond(canvas, size, settings);
        break;
      case Shape3DType.crystal:
        _drawCrystal(canvas, size, settings);
        break;
      case Shape3DType.ring:
        _drawRing(canvas, size, settings);
        break;
      case Shape3DType.pill:
        _drawPill(canvas, size, settings);
        break;
      case Shape3DType.block:
        _drawBlock(canvas, size, settings);
        break;
      case Shape3DType.plate:
        _drawPlate(canvas, size, settings);
        break;
      case Shape3DType.disk:
        _drawDisk(canvas, size, settings);
        break;
      case Shape3DType.coin:
        _drawCoin(canvas, size, settings);
        break;
      case Shape3DType.barrel:
        _drawBarrel(canvas, size, settings);
        break;
      case Shape3DType.dome:
        _drawDome(canvas, size, settings);
        break;
      case Shape3DType.frustum:
        _drawFrustum(canvas, size, settings);
        break;
      case Shape3DType.wedge:
        _drawWedge(canvas, size, settings);
        break;
      case Shape3DType.helix:
        _drawHelix(canvas, size, settings);
        break;
    }
  }

  // ═══ HELPERS ═══

  static double _angleRad(Shape3DSettings s) {
    switch (s.projection) {
      case Projection3D.isometric:
        return math.pi / 6;
      case Projection3D.dimetric:
        return math.pi / 7;
      case Projection3D.trimetric:
        return math.pi / 8;
      case Projection3D.perspective:
        return math.pi / 5;
      case Projection3D.cavalier:
        return math.pi / 4;
      case Projection3D.cabinet:
        return math.pi / 6;
    }
  }

  static Offset _depthOffset(Shape3DSettings s, double baseSize) {
    final angle = _angleRad(s);
    final depth = baseSize * s.depth;
    return Offset(depth * math.cos(angle), -depth * math.sin(angle));
  }

  static Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  // ═══ CUBE ═══
  static void _drawCube(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final depth = w * settings.depth;
    final offset = _depthOffset(settings, w);

    final frontRect = Rect.fromLTWH(0, depth * 0.5, w * 0.7, h * 0.7);
    canvas.drawRect(frontRect, Paint()..color = settings.frontColor);

    final topPath = Path()
      ..moveTo(frontRect.left, frontRect.top)
      ..lineTo(frontRect.left + offset.dx, frontRect.top + offset.dy)
      ..lineTo(frontRect.right + offset.dx, frontRect.top + offset.dy)
      ..lineTo(frontRect.right, frontRect.top)
      ..close();

    canvas.drawPath(
      topPath,
      Paint()
        ..shader = LinearGradient(
          colors: [_lighten(settings.topColor, 0.15), settings.topColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(topPath.getBounds()),
    );

    final sidePath = Path()
      ..moveTo(frontRect.right, frontRect.top)
      ..lineTo(frontRect.right + offset.dx, frontRect.top + offset.dy)
      ..lineTo(frontRect.right + offset.dx, frontRect.bottom + offset.dy)
      ..lineTo(frontRect.right, frontRect.bottom)
      ..close();

    canvas.drawPath(sidePath, Paint()..color = _darken(settings.sideColor, 0.08));

    if (settings.highlightIntensity > 0) {
      final hl = Path()
        ..moveTo(frontRect.left + offset.dx * 0.3, frontRect.top + offset.dy * 0.3)
        ..lineTo(frontRect.right + offset.dx * 0.3, frontRect.top + offset.dy * 0.3)
        ..lineTo(frontRect.right + offset.dx * 0.3, frontRect.top + offset.dy * 0.8)
        ..lineTo(frontRect.left + offset.dx * 0.3, frontRect.top + offset.dy * 0.8)
        ..close();

      canvas.drawPath(
        hl,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.08 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }

    canvas.drawRect(
      frontRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _darken(settings.frontColor, 0.15),
    );
  }

  // ═══ SPHERE ═══
  static void _drawSphere(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final radius = math.min(w, h) / 2;
    final center = Offset(w / 2, h / 2);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.4),
          radius: 0.9,
          colors: [
            _lighten(settings.topColor, 0.20),
            settings.frontColor,
            _darken(settings.sideColor, 0.25),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    if (settings.highlightIntensity > 0) {
      final hlCenter = center + Offset(-radius * 0.35, -radius * 0.35);
      canvas.drawCircle(
        hlCenter,
        radius * 0.20,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.7 * settings.highlightIntensity),
              Colors.white.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: hlCenter, radius: radius * 0.20)),
      );
    }

    if (settings.shadowIntensity > 0) {
      final shadowCenter = center + Offset(radius * 0.2, radius * 0.2);
      canvas.drawCircle(
        shadowCenter,
        radius * 0.5,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.3 * settings.shadowIntensity),
            ],
          ).createShader(Rect.fromCircle(center: shadowCenter, radius: radius * 0.5))
          ..blendMode = BlendMode.multiply,
      );
    }
  }

  // ═══ CYLINDER ═══
  static void _drawCylinder(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final bodyTop = h * 0.15;
    final bodyBottom = h * 0.85;
    final ellipseH = h * 0.12;

    final bodyRect = Rect.fromLTWH(w * 0.15, bodyTop, w * 0.7, bodyBottom - bodyTop);

    canvas.drawRect(
      bodyRect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.15),
            settings.frontColor,
            _lighten(settings.topColor, 0.10),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ).createShader(bodyRect),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, bodyBottom), width: w * 0.7, height: ellipseH),
      Paint()..color = _darken(settings.sideColor, 0.20),
    );

    final topOval = Rect.fromCenter(center: Offset(cx, bodyTop), width: w * 0.7, height: ellipseH);
    canvas.drawOval(
      topOval,
      Paint()
        ..shader = RadialGradient(
          colors: [_lighten(settings.topColor, 0.20), settings.topColor],
        ).createShader(topOval),
    );

    canvas.drawOval(
      topOval,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _darken(settings.topColor, 0.15),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.15, bodyTop + ellipseH * 0.3),
          width: w * 0.20,
          height: ellipseH * 0.4,
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  // ═══ CONE ═══
  static void _drawCone(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final baseY = h * 0.85;

    final conePath = Path()
      ..moveTo(cx, 0)
      ..lineTo(w * 0.15, baseY)
      ..lineTo(w * 0.85, baseY)
      ..close();

    canvas.drawPath(
      conePath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.15),
            settings.frontColor,
            _lighten(settings.topColor, 0.15),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(conePath.getBounds()),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, baseY), width: w * 0.7, height: h * 0.10),
      Paint()..color = _darken(settings.sideColor, 0.20),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawPath(
        Path()
          ..moveTo(cx - w * 0.05, h * 0.15)
          ..lineTo(w * 0.35, baseY * 0.95)
          ..lineTo(cx, baseY * 0.95)
          ..close(),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.10 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  // ═══ PYRAMID ═══
  static void _drawPyramid(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final apexY = h * 0.1;
    final baseY = h * 0.85;

    final leftFace = Path()
      ..moveTo(cx, apexY)
      ..lineTo(w * 0.15, baseY)
      ..lineTo(cx, baseY)
      ..close();

    canvas.drawPath(
      leftFace,
      Paint()
        ..shader = LinearGradient(
          colors: [_lighten(settings.frontColor, 0.10), settings.frontColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(leftFace.getBounds()),
    );

    final rightFace = Path()
      ..moveTo(cx, apexY)
      ..lineTo(cx, baseY)
      ..lineTo(w * 0.85, baseY)
      ..close();

    canvas.drawPath(
      rightFace,
      Paint()
        ..shader = LinearGradient(
          colors: [settings.frontColor, _darken(settings.sideColor, 0.15)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rightFace.getBounds()),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawPath(
        Path()
          ..moveTo(cx, apexY)
          ..lineTo(cx - w * 0.08, apexY + h * 0.15)
          ..lineTo(cx + w * 0.05, apexY + h * 0.12)
          ..close(),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }

    canvas.drawPath(
      Path()
        ..moveTo(cx, apexY)
        ..lineTo(w * 0.15, baseY)
        ..lineTo(w * 0.85, baseY)
        ..lineTo(cx, baseY)
        ..close(),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = _darken(settings.sideColor, 0.30),
    );
  }

  // ═══ TORUS ═══
  static void _drawTorus(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final outer = math.min(w, h) / 2;

    canvas.drawCircle(
      Offset(cx, cy),
      outer,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            _lighten(settings.topColor, 0.15),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: outer)),
    );

    canvas.drawCircle(
      Offset(cx, cy),
      outer * 0.45,
      Paint()
        ..color = Colors.transparent
        ..blendMode = BlendMode.clear,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      outer * 0.45,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = _darken(settings.sideColor, 0.30),
    );
  }

  // ═══ PRISM ═══
  static void _drawPrism(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;

    final front = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..lineTo(w * 0.1, h * 0.85)
      ..lineTo(w * 0.9, h * 0.85)
      ..close();

    canvas.drawPath(
      front,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _lighten(settings.frontColor, 0.10),
            settings.frontColor,
            _darken(settings.sideColor, 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(front.getBounds()),
    );

    final side = Path()
      ..moveTo(w * 0.9, h * 0.85)
      ..lineTo(w, h * 0.75)
      ..lineTo(w * 0.6, h * 0.15)
      ..lineTo(w * 0.5, h * 0.2)
      ..close();

    canvas.drawPath(side, Paint()..color = _darken(settings.sideColor, 0.20));
  }

  // ═══ DIAMOND ═══
  static void _drawDiamond(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final topY = h * 0.05;
    final midY = h * 0.35;
    final botY = h * 0.95;

    final topLeft = Path()
      ..moveTo(cx, topY)
      ..lineTo(w * 0.15, midY)
      ..lineTo(cx, midY)
      ..close();

    final topRight = Path()
      ..moveTo(cx, topY)
      ..lineTo(cx, midY)
      ..lineTo(w * 0.85, midY)
      ..close();

    final botLeft = Path()
      ..moveTo(w * 0.15, midY)
      ..lineTo(cx, midY)
      ..lineTo(cx, botY)
      ..close();

    final botRight = Path()
      ..moveTo(cx, midY)
      ..lineTo(w * 0.85, midY)
      ..lineTo(cx, botY)
      ..close();

    canvas.drawPath(topLeft, Paint()..color = _lighten(settings.topColor, 0.20));
    canvas.drawPath(topRight, Paint()..color = settings.topColor);
    canvas.drawPath(botLeft, Paint()..color = settings.frontColor);
    canvas.drawPath(botRight, Paint()..color = _darken(settings.sideColor, 0.15));

    if (settings.highlightIntensity > 0) {
      canvas.drawPath(
        topLeft,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.30 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _darken(settings.sideColor, 0.30);

    canvas.drawPath(topLeft, border);
    canvas.drawPath(topRight, border);
    canvas.drawPath(botLeft, border);
    canvas.drawPath(botRight, border);
  }

  // ═══ CRYSTAL ═══
  static void _drawCrystal(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final body = Path()
      ..moveTo(cx, h * 0.05)
      ..lineTo(w * 0.85, h * 0.35)
      ..lineTo(w * 0.75, h * 0.90)
      ..lineTo(cx, h * 0.95)
      ..lineTo(w * 0.15, h * 0.85)
      ..lineTo(w * 0.10, h * 0.30)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _lighten(settings.topColor, 0.25),
            settings.frontColor,
            _darken(settings.sideColor, 0.20),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(body.getBounds()),
    );

    if (settings.highlightIntensity > 0) {
      final glow = Path()
        ..moveTo(cx, h * 0.25)
        ..lineTo(w * 0.55, h * 0.55)
        ..lineTo(cx, h * 0.75)
        ..lineTo(w * 0.45, h * 0.55)
        ..close();

      canvas.drawPath(
        glow,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }

    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = _darken(settings.sideColor, 0.35),
    );
  }

  // ═══ RING ═══
  static void _drawRing(Canvas canvas, Size size, Shape3DSettings settings) {
    _drawTorus(canvas, size, settings);
  }

  // ═══ PILL ═══
  static void _drawPill(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final pillH = h * 0.5;
    final r = pillH / 2;

    final rect = Rect.fromLTWH(w * 0.1, (h - pillH) / 2, w * 0.8, pillH);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(r));

    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.15),
            settings.frontColor,
            _lighten(settings.topColor, 0.20),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(rect),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            rect.left + r * 0.3,
            rect.top + r * 0.2,
            rect.width * 0.7,
            rect.height * 0.25,
          ),
          Radius.circular(r * 0.5),
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.20 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  // ═══ BLOCK ═══
  static void _drawBlock(Canvas canvas, Size size, Shape3DSettings settings) {
    _drawCube(canvas, size, settings);
  }

  // ═══ PLATE ═══
  static void _drawPlate(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final depth = h * 0.15;

    final top = Path()
      ..moveTo(w * 0.2, h * 0.2)
      ..lineTo(w, h * 0.2)
      ..lineTo(w * 0.8, h * 0.2 + depth)
      ..lineTo(0, h * 0.2 + depth)
      ..close();

    canvas.drawPath(top, Paint()..color = settings.topColor);

    final front = Path()
      ..moveTo(0, h * 0.2 + depth)
      ..lineTo(w * 0.8, h * 0.2 + depth)
      ..lineTo(w * 0.8, h * 0.8 + depth)
      ..lineTo(0, h * 0.8 + depth)
      ..close();

    canvas.drawPath(front, Paint()..color = settings.frontColor);

    final side = Path()
      ..moveTo(w * 0.8, h * 0.2 + depth)
      ..lineTo(w, h * 0.2)
      ..lineTo(w, h * 0.8)
      ..lineTo(w * 0.8, h * 0.8 + depth)
      ..close();

    canvas.drawPath(side, Paint()..color = _darken(settings.sideColor, 0.15));
  }

  // ═══ DISK ═══
  static void _drawDisk(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.05), width: w * 0.9, height: h * 0.35),
      Paint()..color = _darken(settings.sideColor, 0.30),
    );

    final topOval = Rect.fromCenter(center: Offset(cx, cy), width: w * 0.9, height: h * 0.35);
    canvas.drawOval(
      topOval,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.5),
          colors: [
            _lighten(settings.topColor, 0.20),
            settings.topColor,
            settings.frontColor,
          ],
        ).createShader(topOval),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.25, height: h * 0.10),
      Paint()..color = _darken(settings.sideColor, 0.20),
    );
  }

  // ═══ COIN ═══
  static void _drawCoin(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final rx = w * 0.45;
    final ry = h * 0.45;

    final sideOval = Rect.fromCenter(
      center: Offset(cx, cy + h * 0.08),
      width: rx * 2,
      height: ry * 2,
    );

    canvas.drawOval(
      sideOval,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.30),
            _darken(settings.sideColor, 0.15),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(sideOval),
    );

    final topOval = Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2);
    canvas.drawOval(
      topOval,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.6),
          radius: 0.9,
          colors: [
            _lighten(settings.topColor, 0.30),
            settings.topColor,
            settings.frontColor,
            _darken(settings.sideColor, 0.10),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ).createShader(topOval),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 1.2, height: ry * 1.2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = _darken(settings.sideColor, 0.25),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - rx * 0.3, cy - ry * 0.4),
          width: rx * 0.8,
          height: ry * 0.4,
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  // ═══ BARREL ═══
  static void _drawBarrel(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final topY = h * 0.15;
    final botY = h * 0.85;

    final body = Path()
      ..moveTo(w * 0.25, topY)
      ..quadraticBezierTo(w * 0.05, h * 0.5, w * 0.25, botY)
      ..lineTo(w * 0.75, botY)
      ..quadraticBezierTo(w * 0.95, h * 0.5, w * 0.75, topY)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.20),
            settings.frontColor,
            _lighten(settings.topColor, 0.15),
            settings.frontColor,
            _darken(settings.sideColor, 0.20),
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ).createShader(body.getBounds()),
    );

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _darken(settings.sideColor, 0.35);

    for (final y in [h * 0.30, h * 0.55, h * 0.80]) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, y), width: w * 0.6, height: h * 0.05),
        0,
        math.pi,
        false,
        ringPaint,
      );
    }

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, topY), width: w * 0.5, height: h * 0.08),
      Paint()..color = _lighten(settings.topColor, 0.20),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, botY), width: w * 0.5, height: h * 0.08),
      Paint()..color = _darken(settings.sideColor, 0.25),
    );
  }

  // ═══ DOME ═══
  static void _drawDome(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final baseY = h * 0.85;

    final dome = Path()
      ..moveTo(w * 0.1, baseY)
      ..arcToPoint(
        Offset(w * 0.9, baseY),
        radius: Radius.circular(w * 0.4),
        clockwise: false,
      )
      ..close();

    canvas.drawPath(
      dome,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.6),
          radius: 1.0,
          colors: [
            _lighten(settings.topColor, 0.30),
            settings.frontColor,
            _darken(settings.sideColor, 0.20),
          ],
        ).createShader(dome.getBounds()),
    );

    if (settings.highlightIntensity > 0) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.15, h * 0.35),
          width: w * 0.20,
          height: h * 0.15,
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.30 * settings.highlightIntensity)
          ..blendMode = BlendMode.plus,
      );
    }
  }

  // ═══ FRUSTUM ═══
  static void _drawFrustum(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final body = Path()
      ..moveTo(w * 0.35, h * 0.1)
      ..lineTo(w * 0.65, h * 0.1)
      ..lineTo(w * 0.85, h * 0.85)
      ..lineTo(w * 0.15, h * 0.85)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _darken(settings.sideColor, 0.15),
            settings.frontColor,
            _lighten(settings.topColor, 0.10),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(body.getBounds()),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h * 0.1), width: w * 0.3, height: h * 0.08),
      Paint()..color = _lighten(settings.topColor, 0.20),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h * 0.85), width: w * 0.7, height: h * 0.10),
      Paint()..color = _darken(settings.sideColor, 0.25),
    );
  }

  // ═══ WEDGE ═══
  static void _drawWedge(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;

    final front = Path()
      ..moveTo(0, h * 0.85)
      ..lineTo(w, h * 0.85)
      ..lineTo(0, h * 0.15)
      ..close();

    canvas.drawPath(
      front,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _lighten(settings.topColor, 0.10),
            settings.frontColor,
            _darken(settings.sideColor, 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(front.getBounds()),
    );

    final top = Path()
      ..moveTo(0, h * 0.15)
      ..lineTo(w * 0.3, h * 0.05)
      ..lineTo(w * 0.3, h * 0.75)
      ..lineTo(0, h * 0.85)
      ..close();

    canvas.drawPath(top, Paint()..color = _lighten(settings.topColor, 0.15));

    final side = Path()
      ..moveTo(w * 0.3, h * 0.05)
      ..lineTo(w, h * 0.75)
      ..lineTo(w, h * 0.85)
      ..lineTo(w * 0.3, h * 0.75)
      ..close();

    canvas.drawPath(side, Paint()..color = _darken(settings.sideColor, 0.20));
  }

  // ═══ HELIX ═══
  static void _drawHelix(Canvas canvas, Size size, Shape3DSettings settings) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int strand = 0; strand < 2; strand++) {
      final path = Path();
      final phase = strand * math.pi;
      const points = 60;

      for (int i = 0; i <= points; i++) {
        final t = i / points;
        final angle = t * math.pi * 4 + phase;
        final r = w * 0.35 * math.sin(t * math.pi);
        final x = cx + r * math.cos(angle);
        final y = h * 0.1 + h * 0.8 * t;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      paint.shader = LinearGradient(
        colors: [
          _lighten(settings.topColor, 0.20),
          settings.frontColor,
          _darken(settings.sideColor, 0.20),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

      canvas.drawPath(path, paint);
    }
  }
}
