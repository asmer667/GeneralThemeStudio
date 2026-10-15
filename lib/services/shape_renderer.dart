import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/key_shape.dart';

/// محرّك رسم الأشكال — يحوّل أي KeyShape إلى Path
class ShapeRenderer {
  ShapeRenderer._();

  /// الواجهة الرئيسية: أرجع Path لأي شكل
  static Path render(
    KeyShape shape,
    Size size, {
    double roundedness = 0.5,
  }) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = math.min(w, h) / 2;

    final path = Path();

    switch (shape) {
      // ═══════════════════════════════════════════
      // BASIC
      // ═══════════════════════════════════════════
      case KeyShape.rectangle:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.roundedRectangle:
        final rr = math.min(w, h) * 0.25 * (roundedness * 2).clamp(0.0, 1.0);
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h), Radius.circular(rr)));
        break;
      case KeyShape.square:
        final s = math.min(w, h);
        path.addRect(Rect.fromLTWH((w - s) / 2, (h - s) / 2, s, s));
        break;
      case KeyShape.circle:
      case KeyShape.oval:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.pill:
        final rr = math.min(w, h) / 2;
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h), Radius.circular(rr)));
        break;
      case KeyShape.squircle:
        _squircle(path, w, h);
        break;
      case KeyShape.capsule:
        final rr = w * 0.3;
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.2, w, h * 0.6), Radius.circular(rr)));
        break;
      case KeyShape.trapezoid:
        path.moveTo(w * 0.2, 0);
        path.lineTo(w * 0.8, 0);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case KeyShape.parallelogram:
        path.moveTo(w * 0.2, 0);
        path.lineTo(w, 0);
        path.lineTo(w * 0.8, h);
        path.lineTo(0, h);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // POLYGONS
      // ═══════════════════════════════════════════
      case KeyShape.triangle:
        path.moveTo(cx, 0);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case KeyShape.triangleDown:
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(cx, h);
        path.close();
        break;
      case KeyShape.triangleLeft:
        path.moveTo(w, 0);
        path.lineTo(w, h);
        path.lineTo(0, cy);
        path.close();
        break;
      case KeyShape.triangleRight:
        path.moveTo(0, 0);
        path.lineTo(0, h);
        path.lineTo(w, cy);
        path.close();
        break;
      case KeyShape.pentagon:
        _polygon(path, 5, cx, cy, r, -math.pi / 2);
        break;
      case KeyShape.pentagonDown:
        _polygon(path, 5, cx, cy, r, math.pi / 2);
        break;
      case KeyShape.hexagon:
        _polygon(path, 6, cx, cy, r, 0);
        break;
      case KeyShape.hexagonFlat:
        _polygon(path, 6, cx, cy, r, -math.pi / 2);
        break;
      case KeyShape.heptagon:
        _polygon(path, 7, cx, cy, r, -math.pi / 2);
        break;
      case KeyShape.octagon:
        _polygon(path, 8, cx, cy, r, math.pi / 8);
        break;
      case KeyShape.nonagon:
        _polygon(path, 9, cx, cy, r, -math.pi / 2);
        break;
      case KeyShape.decagon:
        _polygon(path, 10, cx, cy, r, 0);
        break;
      case KeyShape.dodecagon:
        _polygon(path, 12, cx, cy, r, 0);
        break;
      case KeyShape.rhombus:
        path.moveTo(cx, 0);
        path.lineTo(w, cy);
        path.lineTo(cx, h);
        path.lineTo(0, cy);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // STARS
      // ═══════════════════════════════════════════
      case KeyShape.star3:
        _star(path, 3, cx, cy, r, 0.5);
        break;
      case KeyShape.star4:
        _star(path, 4, cx, cy, r, 0.4);
        break;
      case KeyShape.star5:
        _star(path, 5, cx, cy, r, 0.5);
        break;
      case KeyShape.star6:
        _star(path, 6, cx, cy, r, 0.5);
        break;
      case KeyShape.star7:
        _star(path, 7, cx, cy, r, 0.55);
        break;
      case KeyShape.star8:
        _star(path, 8, cx, cy, r, 0.55);
        break;
      case KeyShape.star9:
        _star(path, 9, cx, cy, r, 0.6);
        break;
      case KeyShape.star10:
        _star(path, 10, cx, cy, r, 0.6);
        break;
      case KeyShape.star12:
        _star(path, 12, cx, cy, r, 0.65);
        break;
      case KeyShape.starSharp:
        _star(path, 5, cx, cy, r, 0.25);
        break;
      case KeyShape.starBurst:
        _star(path, 12, cx, cy, r, 0.7);
        break;
      case KeyShape.sparkle:
        _sparkle(path, cx, cy, r);
        break;

      // ═══════════════════════════════════════════
      // ARROWS
      // ═══════════════════════════════════════════
      case KeyShape.arrowRight:
        path.moveTo(0, h * 0.3);
        path.lineTo(w * 0.6, h * 0.3);
        path.lineTo(w * 0.6, h * 0.1);
        path.lineTo(w, cy);
        path.lineTo(w * 0.6, h * 0.9);
        path.lineTo(w * 0.6, h * 0.7);
        path.lineTo(0, h * 0.7);
        path.close();
        break;
      case KeyShape.arrowLeft:
        path.moveTo(w, h * 0.3);
        path.lineTo(w * 0.4, h * 0.3);
        path.lineTo(w * 0.4, h * 0.1);
        path.lineTo(0, cy);
        path.lineTo(w * 0.4, h * 0.9);
        path.lineTo(w * 0.4, h * 0.7);
        path.lineTo(w, h * 0.7);
        path.close();
        break;
      case KeyShape.arrowUp:
        path.moveTo(h * 0.3, h);
        path.lineTo(h * 0.3, h * 0.4);
        path.lineTo(h * 0.1, h * 0.4);
        path.lineTo(h * 0.5, 0);
        path.lineTo(h * 0.9, h * 0.4);
        path.lineTo(h * 0.7, h * 0.4);
        path.lineTo(h * 0.7, h);
        path.close();
        break;
      case KeyShape.arrowDown:
        path.moveTo(h * 0.3, 0);
        path.lineTo(h * 0.3, h * 0.6);
        path.lineTo(h * 0.1, h * 0.6);
        path.lineTo(h * 0.5, h);
        path.lineTo(h * 0.9, h * 0.6);
        path.lineTo(h * 0.7, h * 0.6);
        path.lineTo(h * 0.7, 0);
        path.close();
        break;
      case KeyShape.arrowCircleRight:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.arrowCircleLeft:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.chevronRight:
        path.moveTo(0, 0);
        path.lineTo(w * 0.5, cy);
        path.lineTo(0, h);
        path.lineTo(w * 0.3, h);
        path.lineTo(w * 0.8, cy);
        path.lineTo(w * 0.3, 0);
        path.close();
        break;
      case KeyShape.chevronLeft:
        path.moveTo(w, 0);
        path.lineTo(w * 0.5, cy);
        path.lineTo(w, h);
        path.lineTo(w * 0.7, h);
        path.lineTo(w * 0.2, cy);
        path.lineTo(w * 0.7, 0);
        path.close();
        break;
      case KeyShape.doubleArrow:
        path.moveTo(0, h / 2);
        path.lineTo(w * 0.2, h * 0.2);
        path.lineTo(w * 0.2, h * 0.4);
        path.lineTo(w * 0.8, h * 0.4);
        path.lineTo(w * 0.8, h * 0.2);
        path.lineTo(w, h / 2);
        path.lineTo(w * 0.8, h * 0.8);
        path.lineTo(w * 0.8, h * 0.6);
        path.lineTo(w * 0.2, h * 0.6);
        path.lineTo(w * 0.2, h * 0.8);
        path.close();
        break;
      case KeyShape.arrowFat:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.5);
        path.lineTo(w * 0.7, h * 0.5);
        path.lineTo(w * 0.7, h);
        path.lineTo(w * 0.3, h);
        path.lineTo(w * 0.3, h * 0.5);
        path.lineTo(0, h * 0.5);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // NATURE
      // ═══════════════════════════════════════════
      case KeyShape.leaf:
        path.moveTo(w / 2, 0);
        path.cubicTo(w, h * 0.3, w, h * 0.7, w / 2, h);
        path.cubicTo(0, h * 0.7, 0, h * 0.3, w / 2, 0);
        path.close();
        break;
      case KeyShape.leafSimple:
        path.moveTo(0, h / 2);
        path.cubicTo(w * 0.3, 0, w * 0.7, 0, w, h / 2);
        path.cubicTo(w * 0.7, h, w * 0.3, h, 0, h / 2);
        path.close();
        break;
      case KeyShape.leafOval:
        path.addOval(Rect.fromLTWH(w * 0.2, 0, w * 0.6, h));
        break;
      case KeyShape.flower:
        _flower(path, cx, cy, r, 5);
        break;
      case KeyShape.flowerDaisy:
        _flower(path, cx, cy, r, 8);
        break;
      case KeyShape.flowerTulip:
        path.moveTo(w * 0.3, h * 0.4);
        path.quadraticBezierTo(w * 0.2, 0, w * 0.5, 0);
        path.quadraticBezierTo(w * 0.8, 0, w * 0.7, h * 0.4);
        path.lineTo(w * 0.7, h * 0.7);
        path.quadraticBezierTo(w * 0.5, h, w * 0.3, h * 0.7);
        path.close();
        break;
      case KeyShape.flowerRose:
        _flower(path, cx, cy, r, 8);
        break;
      case KeyShape.clover:
        for (int i = 0; i < 4; i++) {
          final a = (math.pi / 2) * i;
          final px = cx + math.cos(a) * r * 0.45;
          final py = cy + math.sin(a) * r * 0.45;
          path.addOval(Rect.fromCircle(center: Offset(px, py), radius: r * 0.45));
        }
        break;
      case KeyShape.tree:
        path.addRect(Rect.fromLTWH(w * 0.4, h * 0.5, w * 0.2, h * 0.5));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.35), radius: h * 0.35));
        break;
      case KeyShape.treeSimple:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case KeyShape.pineTree:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.4);
        path.lineTo(w * 0.7, h * 0.4);
        path.lineTo(w, h * 0.8);
        path.lineTo(0, h * 0.8);
        path.lineTo(w * 0.3, h * 0.4);
        path.lineTo(0, h * 0.4);
        path.close();
        break;
      case KeyShape.palmTree:
        path.addRect(Rect.fromLTWH(w * 0.45, h * 0.4, w * 0.1, h * 0.6));
        for (int i = 0; i < 6; i++) {
          final a = (math.pi / 3) * i - math.pi / 2;
          final lx = w * 0.5 + math.cos(a) * w * 0.45;
          final ly = h * 0.4 + math.sin(a) * h * 0.3;
          path.moveTo(w * 0.5, h * 0.4);
          path.lineTo(lx, ly);
          path.lineTo(lx - w * 0.1, ly + h * 0.1);
          path.close();
        }
        break;
      case KeyShape.cactus:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.35, 0, w * 0.3, h), const Radius.circular(20)));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.1, h * 0.3, w * 0.25, h * 0.3), const Radius.circular(15)));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.65, h * 0.2, w * 0.25, h * 0.4), const Radius.circular(15)));
        break;
      case KeyShape.mushroom:
        path.moveTo(0, h * 0.5);
        path.quadraticBezierTo(w * 0.5, -h * 0.1, w, h * 0.5);
        path.close();
        path.addRect(Rect.fromLTWH(w * 0.35, h * 0.5, w * 0.3, h * 0.5));
        break;
      case KeyShape.drop:
        path.moveTo(w / 2, 0);
        path.quadraticBezierTo(w, h * 0.6, w * 0.7, h * 0.85);
        path.quadraticBezierTo(w * 0.5, h, w * 0.3, h * 0.85);
        path.quadraticBezierTo(0, h * 0.6, w / 2, 0);
        path.close();
        break;
      case KeyShape.dropDouble:
        path.moveTo(w * 0.5, 0);
        path.quadraticBezierTo(w, h * 0.7, w * 0.5, h);
        path.quadraticBezierTo(0, h * 0.7, w * 0.5, 0);
        path.close();
        break;
      case KeyShape.snowflake:
        for (int i = 0; i < 6; i++) {
          final a = (math.pi / 3) * i;
          final x = cx + r * math.cos(a);
          final y = cy + r * math.sin(a);
          path.moveTo(cx, cy);
          path.lineTo(x, y);
        }
        break;
      case KeyShape.sun:
        _sun(path, cx, cy, r, 8, 0.4);
        break;
      case KeyShape.sunRay:
        _sun(path, cx, cy, r, 12, 0.5);
        break;
      case KeyShape.moon:
      case KeyShape.crescentMoon:
        final outer = Path()..addOval(Rect.fromLTWH(0, 0, w, h));
        final inner = Path()..addOval(Rect.fromLTWH(w * 0.35, -h * 0.1, w * 0.9, h * 0.9));
        path.addPath(Path.combine(PathOperation.difference, outer, inner), Offset.zero);
        break;
      case KeyShape.moonFull:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.cloud:
        path.addOval(Rect.fromCircle(center: Offset(w * 0.35, h * 0.7), radius: w * 0.28));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.65, h * 0.7), radius: w * 0.3));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.45), radius: w * 0.32));
        path.addRect(Rect.fromLTWH(w * 0.1, h * 0.7, w * 0.8, h * 0.3));
        break;
      case KeyShape.cloudFlat:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.3, w, h * 0.5), Radius.circular(h * 0.25)));
        break;
      case KeyShape.mountain:
        path.moveTo(0, h);
        path.lineTo(w * 0.3, h * 0.3);
        path.lineTo(w * 0.5, h * 0.5);
        path.lineTo(w * 0.7, h * 0.2);
        path.lineTo(w, h);
        path.close();
        break;
      case KeyShape.wave:
        path.moveTo(0, h * 0.7);
        path.quadraticBezierTo(w * 0.25, h * 0.3, w * 0.5, h * 0.5);
        path.quadraticBezierTo(w * 0.75, h * 0.7, w, h * 0.3);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case KeyShape.feather:
        path.moveTo(w / 2, 0);
        path.cubicTo(w, h * 0.3, w, h * 0.7, w / 2, h);
        path.cubicTo(0, h * 0.7, 0, h * 0.3, w / 2, 0);
        path.close();
        break;
      case KeyShape.butterfly:
        path.addOval(Rect.fromLTWH(0, h * 0.2, w * 0.5, h * 0.6));
        path.addOval(Rect.fromLTWH(w * 0.5, h * 0.2, w * 0.5, h * 0.6));
        path.addRect(Rect.fromLTWH(w * 0.47, h * 0.3, w * 0.06, h * 0.5));
        break;
      case KeyShape.bee:
      case KeyShape.ladybug:
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.5));
        break;

      // ═══════════════════════════════════════════
      // ANIMALS
      // ═══════════════════════════════════════════
      case KeyShape.cat:
      case KeyShape.catFace:
        path.moveTo(w * 0.2, h * 0.3);
        path.lineTo(w * 0.1, 0);
        path.lineTo(w * 0.4, h * 0.15);
        path.lineTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.9, 0);
        path.lineTo(w * 0.8, h * 0.3);
        path.quadraticBezierTo(w, h * 0.6, w * 0.5, h * 0.95);
        path.quadraticBezierTo(0, h * 0.6, w * 0.2, h * 0.3);
        path.close();
        break;
      case KeyShape.dog:
      case KeyShape.dogFace:
      case KeyShape.bear:
      case KeyShape.bearFace:
      case KeyShape.panda:
      case KeyShape.pandaFace:
      case KeyShape.monkey:
        path.addOval(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.15, h * 0.25), radius: w * 0.15));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.85, h * 0.25), radius: w * 0.15));
        break;
      case KeyShape.mouse:
        path.addOval(Rect.fromLTWH(w * 0.1, h * 0.3, w * 0.8, h * 0.7));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.2, h * 0.25), radius: w * 0.15));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.8, h * 0.25), radius: w * 0.15));
        break;
      case KeyShape.rabbit:
      case KeyShape.rabbitFace:
      case KeyShape.unicorn:
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.35, w * 0.7, h * 0.65));
        path.addOval(Rect.fromLTWH(w * 0.25, 0, w * 0.15, h * 0.45));
        path.addOval(Rect.fromLTWH(w * 0.6, 0, w * 0.15, h * 0.45));
        break;
      case KeyShape.fox:
      case KeyShape.foxFace:
        path.moveTo(w * 0.2, h * 0.3);
        path.lineTo(w * 0.1, 0);
        path.lineTo(w * 0.4, h * 0.15);
        path.lineTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.9, 0);
        path.lineTo(w * 0.8, h * 0.3);
        path.quadraticBezierTo(w, h * 0.6, w * 0.5, h * 0.95);
        path.quadraticBezierTo(0, h * 0.6, w * 0.2, h * 0.3);
        path.close();
        break;
      case KeyShape.lion:
        _sun(path, cx, cy, r, 12, 0.6);
        path.addOval(Rect.fromLTWH(w * 0.25, h * 0.25, w * 0.5, h * 0.5));
        break;
      case KeyShape.tiger:
        path.moveTo(w * 0.2, h * 0.3);
        path.lineTo(w * 0.1, 0);
        path.lineTo(w * 0.4, h * 0.15);
        path.lineTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.9, 0);
        path.lineTo(w * 0.8, h * 0.3);
        path.quadraticBezierTo(w, h * 0.6, w * 0.5, h * 0.95);
        path.quadraticBezierTo(0, h * 0.6, w * 0.2, h * 0.3);
        path.close();
        break;
      case KeyShape.elephant:
        path.addOval(Rect.fromLTWH(w * 0.1, h * 0.2, w * 0.8, h * 0.7));
        path.addRect(Rect.fromLTWH(w * 0.45, h * 0.6, w * 0.1, h * 0.4));
        break;
      case KeyShape.penguin:
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.1, w * 0.6, h * 0.9));
        break;
      case KeyShape.bird:
      case KeyShape.chicken:
      case KeyShape.duck:
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.5));
        path.addOval(Rect.fromLTWH(w * 0.7, h * 0.45, w * 0.2, h * 0.1));
        break;
      case KeyShape.owl:
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.7, h * 0.7));
        break;
      case KeyShape.fish:
      case KeyShape.dolphin:
      case KeyShape.whale:
      case KeyShape.shark:
        path.addOval(Rect.fromLTWH(0, h * 0.3, w * 0.7, h * 0.4));
        path.moveTo(w * 0.7, h * 0.5);
        path.lineTo(w, h * 0.2);
        path.lineTo(w, h * 0.8);
        path.close();
        break;
      case KeyShape.octopus:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy * 0.7), radius: r * 0.6));
        break;
      case KeyShape.crab:
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.4, w * 0.6, h * 0.5));
        break;
      case KeyShape.turtle:
        path.addOval(Rect.fromLTWH(0, h * 0.3, w, h * 0.7));
        break;
      case KeyShape.frog:
        path.addOval(Rect.fromLTWH(0, h * 0.35, w, h * 0.6));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.25, h * 0.3), radius: w * 0.15));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.75, h * 0.3), radius: w * 0.15));
        break;
      case KeyShape.snake:
        path.moveTo(0, h);
        path.quadraticBezierTo(w, h * 0.7, 0, h * 0.5);
        path.quadraticBezierTo(w, h * 0.3, w, 0);
        break;
      case KeyShape.dragon:
        path.moveTo(w * 0.2, h * 0.3);
        path.lineTo(w * 0.1, 0);
        path.lineTo(w * 0.4, h * 0.15);
        path.lineTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.9, 0);
        path.lineTo(w * 0.8, h * 0.3);
        path.quadraticBezierTo(w, h * 0.6, w * 0.5, h * 0.95);
        path.quadraticBezierTo(0, h * 0.6, w * 0.2, h * 0.3);
        path.close();
        break;
      case KeyShape.dinosaur:
        path.addOval(Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.7));
        break;
      case KeyShape.spider:
        path.addOval(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w * 0.25));
        break;

      // ═══════════════════════════════════════════
      // FOOD
      // ═══════════════════════════════════════════
      case KeyShape.apple:
        path.addOval(Rect.fromLTWH(w * 0.1, h * 0.2, w * 0.8, h * 0.8));
        path.addRect(Rect.fromLTWH(w * 0.47, 0, w * 0.06, h * 0.25));
        break;
      case KeyShape.banana:
        path.moveTo(0, h * 0.5);
        path.quadraticBezierTo(w * 0.5, 0, w, h * 0.5);
        path.quadraticBezierTo(w * 0.5, h * 0.9, 0, h * 0.5);
        path.close();
        break;
      case KeyShape.orange:
      case KeyShape.lemon:
      case KeyShape.grape:
      case KeyShape.cherry:
      case KeyShape.peach:
      case KeyShape.tomato:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.watermelon:
        path.addArc(Rect.fromLTWH(0, 0, w, h * 2), 0, math.pi);
        path.close();
        break;
      case KeyShape.strawberry:
        path.moveTo(w / 2, 0);
        path.quadraticBezierTo(w, h * 0.4, w / 2, h);
        path.quadraticBezierTo(0, h * 0.4, w / 2, 0);
        path.close();
        break;
      case KeyShape.pineapple:
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.3, w * 0.7, h * 0.7));
        path.moveTo(w * 0.5, 0);
        path.lineTo(w * 0.3, h * 0.35);
        path.lineTo(w * 0.7, h * 0.35);
        path.close();
        break;
      case KeyShape.carrot:
        path.moveTo(w * 0.5, 0);
        path.lineTo(w, h * 0.35);
        path.lineTo(w * 0.5, h);
        path.lineTo(0, h * 0.35);
        path.close();
        break;
      case KeyShape.avocado:
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.7, h * 0.8));
        break;
      case KeyShape.pizza:
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(w / 2, h);
        path.close();
        break;
      case KeyShape.burger:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h * 0.4), Radius.circular(h * 0.2)));
        path.addRect(Rect.fromLTWH(0, h * 0.4, w, h * 0.2));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.6, w, h * 0.4), Radius.circular(h * 0.15)));
        break;
      case KeyShape.sandwich:
      case KeyShape.hotdog:
        path.moveTo(0, 0);
        path.lineTo(w, 0);
        path.lineTo(w / 2, h);
        path.close();
        break;
      case KeyShape.taco:
        path.addArc(Rect.fromLTWH(0, h * 0.3, w, h * 1.5), math.pi, math.pi);
        path.close();
        break;
      case KeyShape.donut:
      case KeyShape.cookie:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.cake:
      case KeyShape.cupcake:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.4, w, h * 0.6), const Radius.circular(8)));
        break;
      case KeyShape.chocolate:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.candy:
        path.addOval(Rect.fromLTWH(w * 0.3, h * 0.3, w * 0.4, h * 0.4));
        break;
      case KeyShape.coffee:
      case KeyShape.tea:
      case KeyShape.juice:
      case KeyShape.milk:
        path.moveTo(w * 0.2, h * 0.2);
        path.lineTo(w * 0.8, h * 0.2);
        path.lineTo(w * 0.7, h);
        path.lineTo(w * 0.3, h);
        path.close();
        break;
      case KeyShape.iceCream:
        path.addOval(Rect.fromLTWH(w * 0.2, 0, w * 0.6, h * 0.5));
        path.moveTo(w * 0.3, h * 0.5);
        path.lineTo(w * 0.7, h * 0.5);
        path.lineTo(w * 0.5, h);
        path.close();
        break;
      case KeyShape.popcorn:
        path.addOval(Rect.fromCircle(center: Offset(w * 0.3, h * 0.35), radius: w * 0.2));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.5, h * 0.25), radius: w * 0.2));
        path.addOval(Rect.fromCircle(center: Offset(w * 0.7, h * 0.35), radius: w * 0.2));
        path.addRect(Rect.fromLTWH(w * 0.2, h * 0.5, w * 0.6, h * 0.5));
        break;

      // ═══════════════════════════════════════════
      // SYMBOLS
      // ═══════════════════════════════════════════
      case KeyShape.heart:
      case KeyShape.heartOutline:
      case KeyShape.heartBroken:
        path.moveTo(w / 2, h);
        path.cubicTo(-w * 0.1, h * 0.6, 0, 0, w / 2, h * 0.3);
        path.cubicTo(w, 0, w * 1.1, h * 0.6, w / 2, h);
        path.close();
        break;
      case KeyShape.heartDouble:
        path.moveTo(w * 0.5, h * 0.95);
        path.cubicTo(w * 0.05, h * 0.55, w * 0.15, h * 0.15, w * 0.5, h * 0.4);
        path.cubicTo(w * 0.85, h * 0.15, w * 0.95, h * 0.55, w * 0.5, h * 0.95);
        path.close();
        break;
      case KeyShape.cross:
      case KeyShape.plus:
      case KeyShape.cross3D:
        path.addRect(Rect.fromLTWH(w * 0.4, 0, w * 0.2, h));
        path.addRect(Rect.fromLTWH(0, h * 0.4, w, h * 0.2));
        break;
      case KeyShape.x:
        path.moveTo(0, 0);
        path.lineTo(w * 0.2, 0);
        path.lineTo(w / 2, h * 0.4);
        path.lineTo(w * 0.8, 0);
        path.lineTo(w, 0);
        path.lineTo(w * 0.65, h / 2);
        path.lineTo(w, h);
        path.lineTo(w * 0.8, h);
        path.lineTo(w / 2, h * 0.6);
        path.lineTo(w * 0.2, h);
        path.lineTo(0, h);
        path.lineTo(w * 0.35, h / 2);
        path.close();
        break;
      case KeyShape.check:
        path.moveTo(w * 0.2, h * 0.5);
        path.lineTo(w * 0.4, h * 0.7);
        path.lineTo(w * 0.8, h * 0.2);
        path.lineTo(w * 0.85, h * 0.25);
        path.lineTo(w * 0.4, h * 0.8);
        path.lineTo(w * 0.15, h * 0.55);
        path.close();
        break;
      case KeyShape.minus:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.4, w, h * 0.2), const Radius.circular(4)));
        break;
      case KeyShape.infinity:
        path.addOval(Rect.fromLTWH(0, h * 0.3, w * 0.5, h * 0.4));
        path.addOval(Rect.fromLTWH(w * 0.5, h * 0.3, w * 0.5, h * 0.4));
        break;
      case KeyShape.skull:
        path.addOval(Rect.fromLTWH(w * 0.1, 0, w * 0.8, h * 0.7));
        path.addRect(Rect.fromLTWH(w * 0.3, h * 0.7, w * 0.4, h * 0.3));
        break;
      case KeyShape.ghost:
        path.moveTo(w * 0.1, h);
        path.lineTo(w * 0.1, h * 0.4);
        path.quadraticBezierTo(w * 0.1, 0, w / 2, 0);
        path.quadraticBezierTo(w * 0.9, 0, w * 0.9, h * 0.4);
        path.lineTo(w * 0.9, h);
        path.lineTo(w * 0.7, h * 0.85);
        path.lineTo(w * 0.5, h);
        path.lineTo(w * 0.3, h * 0.85);
        path.close();
        break;
      case KeyShape.crown:
        path.moveTo(0, h * 0.3);
        path.lineTo(w * 0.2, h * 0.6);
        path.lineTo(w * 0.4, 0);
        path.lineTo(w * 0.6, h * 0.6);
        path.lineTo(w * 0.8, 0);
        path.lineTo(w, h * 0.3);
        path.lineTo(w * 0.9, h);
        path.lineTo(w * 0.1, h);
        path.close();
        break;
      case KeyShape.trophy:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, 0, w * 0.6, h * 0.6), Radius.circular(20)));
        path.addRect(Rect.fromLTWH(w * 0.3, h * 0.6, w * 0.4, h * 0.15));
        path.addRect(Rect.fromLTWH(w * 0.2, h * 0.75, w * 0.6, h * 0.15));
        path.addRect(Rect.fromLTWH(w * 0.1, h * 0.9, w * 0.8, h * 0.1));
        break;
      case KeyShape.medal:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7));
        path.moveTo(cx - r * 0.3, cy + r * 0.6);
        path.lineTo(cx - r * 0.3, cy + r);
        path.lineTo(cx, cy + r * 0.85);
        path.lineTo(cx + r * 0.3, cy + r);
        path.lineTo(cx + r * 0.3, cy + r * 0.6);
        path.close();
        break;
      case KeyShape.ribbon:
        path.moveTo(0, 0);
        path.lineTo(w * 0.4, h / 2);
        path.lineTo(0, h);
        path.lineTo(w * 0.1, h / 2);
        path.close();
        path.moveTo(w, 0);
        path.lineTo(w * 0.6, h / 2);
        path.lineTo(w, h);
        path.lineTo(w * 0.9, h / 2);
        path.close();
        break;
      case KeyShape.badge:
      case KeyShape.shield:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.3);
        path.lineTo(w, h * 0.6);
        path.quadraticBezierTo(w, h, w / 2, h);
        path.quadraticBezierTo(0, h, 0, h * 0.6);
        path.lineTo(0, h * 0.3);
        path.close();
        break;
      case KeyShape.sword:
        path.moveTo(w / 2, 0);
        path.lineTo(w * 0.6, h * 0.15);
        path.lineTo(w * 0.55, h * 0.7);
        path.lineTo(w * 0.7, h * 0.75);
        path.lineTo(w * 0.65, h * 0.85);
        path.lineTo(w * 0.55, h * 0.8);
        path.lineTo(w * 0.55, h);
        path.lineTo(w * 0.45, h);
        path.lineTo(w * 0.45, h * 0.8);
        path.lineTo(w * 0.35, h * 0.85);
        path.lineTo(w * 0.3, h * 0.75);
        path.lineTo(w * 0.45, h * 0.7);
        path.lineTo(w * 0.4, h * 0.15);
        path.close();
        break;
      case KeyShape.anchor:
        path.addOval(Rect.fromCircle(center: Offset(w / 2, h * 0.15), radius: w * 0.15));
        path.addRect(Rect.fromLTWH(w * 0.45, h * 0.2, w * 0.1, h * 0.7));
        path.addRect(Rect.fromLTWH(w * 0.25, h * 0.3, w * 0.5, h * 0.08));
        break;
      case KeyShape.key:
      case KeyShape.key3D:
        path.addOval(Rect.fromCircle(center: Offset(w * 0.3, h * 0.5), radius: w * 0.25));
        path.addRect(Rect.fromLTWH(w * 0.5, h * 0.45, w * 0.5, h * 0.1));
        path.addRect(Rect.fromLTWH(w * 0.75, h * 0.55, w * 0.08, h * 0.15));
        break;
      case KeyShape.lock:
      case KeyShape.unlock:
        path.addRect(Rect.fromLTWH(w * 0.15, h * 0.4, w * 0.7, h * 0.6));
        path.addArc(Rect.fromLTWH(w * 0.25, 0, w * 0.5, h * 0.8), math.pi, math.pi);
        break;
      case KeyShape.bell:
      case KeyShape.bellRing:
        path.moveTo(w * 0.2, h * 0.7);
        path.lineTo(w * 0.2, h * 0.4);
        path.quadraticBezierTo(w * 0.2, 0, w / 2, 0);
        path.quadraticBezierTo(w * 0.8, 0, w * 0.8, h * 0.4);
        path.lineTo(w * 0.8, h * 0.7);
        path.lineTo(w * 0.9, h * 0.8);
        path.lineTo(w * 0.1, h * 0.8);
        path.close();
        break;
      case KeyShape.eye:
      case KeyShape.eyeClosed:
        path.addOval(Rect.fromLTWH(0, h * 0.2, w, h * 0.6));
        path.addOval(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: h * 0.2));
        break;
      case KeyShape.hand:
      case KeyShape.handThumb:
      case KeyShape.handPeace:
      case KeyShape.peace:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.25, h * 0.3, w * 0.5, h * 0.7),
            const Radius.circular(20)));
        for (int i = 0; i < 4; i++) {
          path.addRRect(RRect.fromRectAndRadius(
              Rect.fromLTWH(w * (0.25 + i * 0.13), h * 0.1, w * 0.1, h * 0.4),
              const Radius.circular(8)));
        }
        break;
      case KeyShape.yin_yang:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
        break;
      case KeyShape.atom:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.2));
        path.addOval(Rect.fromLTWH(cx - r, cy - r * 0.3, r * 2, r * 0.6));
        path.addOval(Rect.fromLTWH(cx - r * 0.3, cy - r, r * 0.6, r * 2));
        break;
      case KeyShape.target:
      case KeyShape.compass:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
        break;
      case KeyShape.gear:
      case KeyShape.cog:
      case KeyShape.wrench:
      case KeyShape.hammer:
      case KeyShape.screwdriver:
        _star(path, 8, cx, cy, r, 0.7);
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.4));
        break;

      // ═══════════════════════════════════════════
      // TECH
      // ═══════════════════════════════════════════
      case KeyShape.phone:
      case KeyShape.smartphone:
      case KeyShape.tablet:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.15, 0, w * 0.7, h),
            Radius.circular(w * 0.15)));
        break;
      case KeyShape.laptop:
      case KeyShape.desktop:
        path.addRect(Rect.fromLTWH(w * 0.1, 0, w * 0.8, h * 0.7));
        path.addRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.1));
        break;
      case KeyShape.watch:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.15, h * 0.2, w * 0.7, h * 0.6),
            Radius.circular(w * 0.15)));
        path.addRect(Rect.fromLTWH(w * 0.3, 0, w * 0.4, h * 0.2));
        path.addRect(Rect.fromLTWH(w * 0.3, h * 0.8, w * 0.4, h * 0.2));
        break;
      case KeyShape.camera:
      case KeyShape.videoCamera:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.2, w, h * 0.7), const Radius.circular(8)));
        path.addOval(Rect.fromCircle(center: Offset(w / 2, h * 0.55), radius: h * 0.2));
        break;
      case KeyShape.microphone:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.3, 0, w * 0.4, h * 0.6),
            Radius.circular(w * 0.2)));
        path.addRect(Rect.fromLTWH(w * 0.45, h * 0.6, w * 0.1, h * 0.3));
        break;
      case KeyShape.headphone:
        path.addArc(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8), math.pi, math.pi);
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.5, w * 0.25, h * 0.5), const Radius.circular(15)));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.75, h * 0.5, w * 0.25, h * 0.5), const Radius.circular(15)));
        break;
      case KeyShape.speaker:
      case KeyShape.tv:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h), const Radius.circular(8)));
        break;
      case KeyShape.gamepad:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.3, w, h * 0.5), Radius.circular(h * 0.25)));
        break;
      case KeyShape.keyboard:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.2, w, h * 0.6), const Radius.circular(6)));
        break;
      case KeyShape.mouseTech:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.25, 0, w * 0.5, h),
            Radius.circular(w * 0.25)));
        break;
      case KeyShape.printer:
        path.addRect(Rect.fromLTWH(0, h * 0.3, w, h * 0.5));
        path.addRect(Rect.fromLTWH(w * 0.2, 0, w * 0.6, h * 0.3));
        path.addRect(Rect.fromLTWH(w * 0.2, h * 0.7, w * 0.6, h * 0.3));
        break;
      case KeyShape.router:
      case KeyShape.wifi:
        path.addArc(Rect.fromLTWH(0, 0, w, h * 2), math.pi, math.pi);
        path.addArc(Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 1.4), math.pi, math.pi);
        path.addOval(Rect.fromCircle(center: Offset(w / 2, h * 0.85), radius: w * 0.08));
        break;
      case KeyShape.bluetooth:
        path.moveTo(w * 0.5, 0);
        path.lineTo(w * 0.8, h * 0.25);
        path.lineTo(w * 0.2, h * 0.75);
        path.lineTo(w * 0.8, h * 0.75);
        path.lineTo(w * 0.5, h);
        path.lineTo(w * 0.5, 0);
        break;
      case KeyShape.battery:
      case KeyShape.batteryFull:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.2, w * 0.85, h * 0.6), const Radius.circular(6)));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.9, h * 0.4, w * 0.1, h * 0.2), const Radius.circular(3)));
        break;
      case KeyShape.lightbulb:
        path.addOval(Rect.fromLTWH(w * 0.2, 0, w * 0.6, h * 0.7));
        path.addRect(Rect.fromLTWH(w * 0.35, h * 0.7, w * 0.3, h * 0.2));
        break;
      case KeyShape.flash:
        path.moveTo(w * 0.5, 0);
        path.lineTo(w * 0.15, h * 0.55);
        path.lineTo(w * 0.45, h * 0.55);
        path.lineTo(w * 0.35, h);
        path.lineTo(w * 0.85, h * 0.4);
        path.lineTo(w * 0.55, h * 0.4);
        path.close();
        break;
      case KeyShape.chip:
      case KeyShape.cpu:
        path.addRect(Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.7, h * 0.7));
        break;
      case KeyShape.database:
      case KeyShape.server:
        path.addOval(Rect.fromLTWH(0, 0, w, h * 0.3));
        path.addRect(Rect.fromLTWH(0, h * 0.15, w, h * 0.7));
        path.addOval(Rect.fromLTWH(0, h * 0.7, w, h * 0.3));
        break;
      case KeyShape.usb:
        path.addRect(Rect.fromLTWH(w * 0.3, 0, w * 0.4, h * 0.7));
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.25, h * 0.7, w * 0.5, h * 0.3), const Radius.circular(4)));
        break;
      case KeyShape.plug:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.7), const Radius.circular(8)));
        path.addRect(Rect.fromLTWH(w * 0.35, 0, w * 0.1, h * 0.4));
        path.addRect(Rect.fromLTWH(w * 0.55, 0, w * 0.1, h * 0.4));
        break;
      case KeyShape.power:
        path.addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
            -math.pi * 0.4, math.pi * 1.8);
        path.moveTo(cx, cy - r);
        path.lineTo(cx, cy);
        path.lineTo(cx + r * 0.05, cy - r);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // 3D SHAPES
      // ═══════════════════════════════════════════
      case KeyShape.cube3D:
      case KeyShape.cubeIso:
      case KeyShape.block3D:
      case KeyShape.brick3D:
      case KeyShape.box3D:
      case KeyShape.boxOpen3D:
      case KeyShape.dice3D:
        path.moveTo(w * 0.2, h * 0.3);
        path.lineTo(w * 0.7, h * 0.15);
        path.lineTo(w * 0.95, h * 0.4);
        path.lineTo(w * 0.95, h * 0.75);
        path.lineTo(w * 0.45, h * 0.95);
        path.lineTo(w * 0.2, h * 0.7);
        path.close();
        break;
      case KeyShape.cube3DTilt:
        path.moveTo(w * 0.15, h * 0.4);
        path.lineTo(w * 0.6, h * 0.1);
        path.lineTo(w * 0.9, h * 0.35);
        path.lineTo(w * 0.9, h * 0.8);
        path.lineTo(w * 0.4, h * 0.95);
        path.lineTo(w * 0.15, h * 0.7);
        path.close();
        break;
      case KeyShape.sphere3D:
      case KeyShape.sphere3DGradient:
      case KeyShape.ball3D:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.cylinder3D:
      case KeyShape.cylinderVertical:
      case KeyShape.barrel3D:
        path.addOval(Rect.fromLTWH(w * 0.15, 0, w * 0.7, h * 0.2));
        path.addRect(Rect.fromLTWH(w * 0.15, h * 0.1, w * 0.7, h * 0.8));
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.8, w * 0.7, h * 0.2));
        break;
      case KeyShape.cone3D:
      case KeyShape.coneInverted:
        path.moveTo(w / 2, 0);
        path.lineTo(w * 0.85, h * 0.85);
        path.addOval(Rect.fromLTWH(w * 0.15, h * 0.85, w * 0.7, h * 0.15));
        path.close();
        break;
      case KeyShape.pyramid3D:
      case KeyShape.pyramidSquare:
      case KeyShape.pyramidTriangle:
        path.moveTo(w / 2, 0);
        path.lineTo(w * 0.9, h);
        path.lineTo(w * 0.1, h);
        path.close();
        break;
      case KeyShape.torus3D:
      case KeyShape.donut3D:
      case KeyShape.ring3D:
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
        break;
      case KeyShape.prism3D:
      case KeyShape.prismTriangle:
      case KeyShape.prismHex:
        path.moveTo(w * 0.3, 0);
        path.lineTo(w * 0.7, 0);
        path.lineTo(w * 0.9, h);
        path.lineTo(w * 0.1, h);
        path.close();
        break;
      case KeyShape.diamond3D:
      case KeyShape.gem3D:
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.35);
        path.lineTo(w / 2, h);
        path.lineTo(0, h * 0.35);
        path.close();
        break;
      case KeyShape.crystal3D:
      case KeyShape.crystalCluster:
        path.moveTo(w / 2, 0);
        path.lineTo(w * 0.8, h * 0.3);
        path.lineTo(w * 0.9, h * 0.7);
        path.lineTo(w / 2, h);
        path.lineTo(w * 0.1, h * 0.7);
        path.lineTo(w * 0.2, h * 0.3);
        path.close();
        break;
      case KeyShape.pill3D:
      case KeyShape.capsule3D:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, h * 0.25, w, h * 0.5), Radius.circular(h * 0.25)));
        break;
      case KeyShape.plate3D:
      case KeyShape.plateRound3D:
      case KeyShape.disk3D:
      case KeyShape.coin3D:
        path.addOval(Rect.fromLTWH(0, h * 0.15, w, h * 0.7));
        break;
      case KeyShape.button3D:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h * 0.8), const Radius.circular(12)));
        path.addOval(Rect.fromLTWH(w * 0.1, h * 0.7, w * 0.8, h * 0.3));
        break;
      case KeyShape.gift3D:
        path.addRect(Rect.fromLTWH(w * 0.15, h * 0.3, w * 0.7, h * 0.7));
        path.addRect(Rect.fromLTWH(w * 0.1, h * 0.2, w * 0.8, h * 0.15));
        path.addRect(Rect.fromLTWH(w * 0.45, 0, w * 0.1, h));
        break;
      case KeyShape.building3D:
      case KeyShape.house3D:
      case KeyShape.tower3D:
      case KeyShape.obelisk3D:
        path.addRect(Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.85));
        break;
      case KeyShape.arch3D:
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.1, 0, w * 0.8, h * 1.5), Radius.circular(w * 0.4)));
        break;
      case KeyShape.stairs3D:
        path.moveTo(0, h);
        path.lineTo(w * 0.25, h);
        path.lineTo(w * 0.25, h * 0.75);
        path.lineTo(w * 0.5, h * 0.75);
        path.lineTo(w * 0.5, h * 0.5);
        path.lineTo(w * 0.75, h * 0.5);
        path.lineTo(w * 0.75, h * 0.25);
        path.lineTo(w, h * 0.25);
        path.lineTo(w, 0);
        path.lineTo(0, 0);
        path.close();
        break;
      case KeyShape.bowl3D:
      case KeyShape.vase3D:
      case KeyShape.pot3D:
      case KeyShape.cup3D:
      case KeyShape.jar3D:
        path.moveTo(w * 0.2, 0);
        path.lineTo(w * 0.8, 0);
        path.quadraticBezierTo(w, h, w * 0.5, h);
        path.quadraticBezierTo(0, h, w * 0.2, 0);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // ORNAMENTAL
      // ═══════════════════════════════════════════
      case KeyShape.arabesque:
      case KeyShape.arabesqueSimple:
      case KeyShape.mandala:
      case KeyShape.mandalaSimple:
        _star(path, 16, cx, cy, r, 0.7);
        break;
      case KeyShape.arabesqueStar:
      case KeyShape.islamicStar:
      case KeyShape.islamicStar8:
        _islamicStar(path, cx, cy, r, 8);
        break;
      case KeyShape.arabesqueCircle:
      case KeyShape.islamicStar16:
        _islamicStar(path, cx, cy, r, 16);
        break;
      case KeyShape.mandalaComplex:
      case KeyShape.flowerMandala:
      case KeyShape.kaleidoscope:
        _star(path, 24, cx, cy, r, 0.7);
        break;
      case KeyShape.filigree:
      case KeyShape.scroll:
      case KeyShape.scrollHorizontal:
      case KeyShape.flourish:
      case KeyShape.flourishLeft:
      case KeyShape.flourishRight:
        path.moveTo(0, h / 2);
        path.quadraticBezierTo(w * 0.3, 0, w * 0.5, h / 2);
        path.quadraticBezierTo(w * 0.7, h, w, h / 2);
        break;
      case KeyShape.damask:
      case KeyShape.damaskMotif:
      case KeyShape.wallpaper:
        _flower(path, cx, cy, r, 6);
        path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.3));
        break;
      case KeyShape.lattice:
      case KeyShape.trellis:
      case KeyShape.mesh:
        for (int i = 0; i <= 4; i++) {
          path.moveTo(w * i / 4, 0);
          path.lineTo(w * i / 4, h);
          path.moveTo(0, h * i / 4);
          path.lineTo(w, h * i / 4);
        }
        break;
      case KeyShape.honeycomb:
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            final hcx = w * (0.2 + i * 0.3);
            final hcy = h * (0.2 + j * 0.3);
            _polygon(path, 6, hcx, hcy, w * 0.15, 0);
          }
        }
        break;
      case KeyShape.weaves:
      case KeyShape.braid:
      case KeyShape.weave:
        for (int i = 0; i < 3; i++) {
          path.addRect(Rect.fromLTWH(i * w / 3, 0, w / 6, h));
          path.addRect(Rect.fromLTWH(0, i * h / 3, w, h / 6));
        }
        break;
      case KeyShape.geometricCircle:
        path.addOval(Rect.fromLTWH(0, 0, w, h));
        break;
      case KeyShape.geometricSquare:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
        break;

      // ═══════════════════════════════════════════
      // ABSTRACT
      // ═══════════════════════════════════════════
      case KeyShape.blob1:
        _blob(path, w, h, seed: 1);
        break;
      case KeyShape.blob2:
        _blob(path, w, h, seed: 2);
        break;
      case KeyShape.blob3:
        _blob(path, w, h, seed: 3);
        break;
      case KeyShape.blob4:
        _blob(path, w, h, seed: 4);
        break;
      case KeyShape.blob5:
        _blob(path, w, h, seed: 5);
        break;
      case KeyShape.blobOrganic:
      case KeyShape.blobRounded:
      case KeyShape.blobSquared:
      case KeyShape.blobHex:
      case KeyShape.blobTriangle:
        _blob(path, w, h, seed: 7);
        break;
      case KeyShape.liquidDrop:
      case KeyShape.splash:
      case KeyShape.splat:
      case KeyShape.ink:
        _blob(path, w, h, seed: 11);
        break;
      case KeyShape.smoke:
        _blob(path, w, h, seed: 21);
        break;
      case KeyShape.flame:
      case KeyShape.flameSimple:
      case KeyShape.flameDouble:
        path.moveTo(w / 2, h);
        path.quadraticBezierTo(w, h * 0.7, w * 0.7, h * 0.3);
        path.quadraticBezierTo(w * 0.5, 0, w * 0.6, 0);
        path.quadraticBezierTo(w * 0.3, h * 0.15, w * 0.3, h * 0.5);
        path.quadraticBezierTo(0, h * 0.7, w / 2, h);
        path.close();
        break;
      case KeyShape.sparkleStar:
      case KeyShape.sparkleSimple:
      case KeyShape.twinkle:
        _sparkle(path, cx, cy, r);
        break;
      case KeyShape.burst:
        _star(path, 16, cx, cy, r, 0.65);
        break;
      case KeyShape.spiral:
        _spiral(path, cx, cy, r, 3);
        break;
      case KeyShape.spiralTight:
        _spiral(path, cx, cy, r, 5);
        break;
      case KeyShape.swirl:
      case KeyShape.swirlDouble:
        _spiral(path, cx, cy, r, 2);
        break;
      case KeyShape.waveAbstract:
      case KeyShape.ribbonAbstract:
      case KeyShape.ribbonLoop:
      case KeyShape.ribbonCurve:
        path.moveTo(0, h * 0.7);
        path.quadraticBezierTo(w * 0.25, h * 0.3, w * 0.5, h * 0.5);
        path.quadraticBezierTo(w * 0.75, h * 0.7, w, h * 0.3);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;

      // ═══════════════════════════════════════════
      // CUSTOM (fallback)
      // ═══════════════════════════════════════════
      case KeyShape.customSvg:
      case KeyShape.customImage:
      case KeyShape.customMask:
      case KeyShape.customPath:
      case KeyShape.customText:
      case KeyShape.customEmoji:
      default:
        final rr = math.min(w, h) * 0.25;
        path.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, w, h), Radius.circular(rr)));
    }

    return path;
  }

  // ═══════════════════════════════════════════
  // HELPERS — دوال الرسم المساعدة
  // ═══════════════════════════════════════════

  static void _polygon(Path p, int sides, double cx, double cy, double r,
      double startAngle) {
    for (int i = 0; i < sides; i++) {
      final a = startAngle + (2 * math.pi / sides) * i;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        p.lineTo(x, y);
      }
    }
    p.close();
  }

  static void _star(Path p, int points, double cx, double cy, double r,
      double innerRatio) {
    final inner = r * innerRatio;
    for (int i = 0; i < points * 2; i++) {
      final rad = (i % 2 == 0) ? r : inner;
      final a = (math.pi / points) * i - math.pi / 2;
      final x = cx + rad * math.cos(a);
      final y = cy + rad * math.sin(a);
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        p.lineTo(x, y);
      }
    }
    p.close();
  }

  static void _squircle(Path p, double w, double h) {
    final k = 0.55;
    p.moveTo(w * 0.5, 0);
    p.cubicTo(w * (0.5 + k), 0, w, h * (0.5 - k), w, h * 0.5);
    p.cubicTo(w, h * (0.5 + k), w * (0.5 + k), h, w * 0.5, h);
    p.cubicTo(w * (0.5 - k), h, 0, h * (0.5 + k), 0, h * 0.5);
    p.cubicTo(0, h * (0.5 - k), w * (0.5 - k), 0, w * 0.5, 0);
    p.close();
  }

  static void _sparkle(Path p, double cx, double cy, double r) {
    final ir = r * 0.35;
    _star(p, 4, cx, cy, r, ir / r);
  }

  static void _flower(Path p, double cx, double cy, double r, int petals) {
    final pr = r * 0.5;
    for (int i = 0; i < petals; i++) {
      final a = (2 * math.pi / petals) * i;
      final px = cx + math.cos(a) * r * 0.6;
      final py = cy + math.sin(a) * r * 0.6;
      p.addOval(Rect.fromCircle(center: Offset(px, py), radius: pr));
    }
    p.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.3));
  }

  static void _sun(Path p, double cx, double cy, double r, int rays,
      double innerRatio) {
    final inner = r * innerRatio;
    for (int i = 0; i < rays * 2; i++) {
      final rad = (i % 2 == 0) ? r : inner;
      final a = (math.pi / rays) * i;
      final x = cx + rad * math.cos(a);
      final y = cy + rad * math.sin(a);
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        p.lineTo(x, y);
      }
    }
    p.close();
  }

  static void _islamicStar(Path p, double cx, double cy, double r, int sides) {
    final n = sides;
    for (int i = 0; i < n; i++) {
      final a = (2 * math.pi / n) * i;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0) {
        p.moveTo(x, y);
      } else {
        p.lineTo(x, y);
      }
    }
    p.close();
    final inner = r * 0.7;
    for (int i = 0; i < n; i++) {
      final a = (2 * math.pi / n) * i + math.pi / n;
      final x = cx + inner * math.cos(a);
      final y = cy + inner * math.sin(a);
      p.lineTo(x, y);
    }
    p.close();
  }

  static void _blob(Path p, double w, double h, {required int seed}) {
    final rnd = math.Random(seed);
    final cx = w / 2;
    final cy = h / 2;
    final r = math.min(w, h) / 2;
    const points = 8;
    for (int i = 0; i < points; i++) {
      final a = (2 * math.pi / points) * i;
      final variation = 0.75 + rnd.nextDouble() * 0.4;
      final px = cx + r * variation * math.cos(a);
      final py = cy + r * variation * math.sin(a);
      if (i == 0) {
        p.moveTo(px, py);
      } else {
        final prevA = (2 * math.pi / points) * (i - 1);
        final prevR = r * (0.75 + rnd.nextDouble() * 0.4);
        final prevPx = cx + prevR * math.cos(prevA);
        final prevPy = cy + prevR * math.sin(prevA);
        p.quadraticBezierTo(
          prevPx + (px - prevPx) * 0.5,
          prevPy + (py - prevPy) * 0.5,
          px,
          py,
        );
      }
    }
    p.close();
  }

  static void _spiral(Path p, double cx, double cy, double r, int turns) {
    p.moveTo(cx, cy);
    final total = turns * 72;
    for (int i = 0; i <= total; i++) {
      final t = i / total;
      final a = t * math.pi * 2 * turns;
      final rad = r * t;
      p.lineTo(cx + rad * math.cos(a), cy + rad * math.sin(a));
    }
  }

  /// هل الشكل يدعم الاستدارة؟
  static bool supportsRoundedness(KeyShape shape) {
    switch (shape) {
      case KeyShape.rectangle:
      case KeyShape.roundedRectangle:
      case KeyShape.square:
      case KeyShape.squircle:
        return true;
      default:
        return false;
    }
  }

  /// هل الشكل يحتاج رفع ملف؟
  static bool requiresFile(KeyShape shape) {
    switch (shape) {
      case KeyShape.customSvg:
      case KeyShape.customImage:
      case KeyShape.customMask:
      case KeyShape.customPath:
      case KeyShape.customText:
      case KeyShape.customEmoji:
        return true;
      default:
        return false;
    }
  }
}
