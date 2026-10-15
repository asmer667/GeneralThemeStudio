import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants.dart';
import '../models/border_asset.dart';
import '../models/icon_asset.dart';
import '../models/key_shape.dart';
import '../models/shape_3d.dart';
import 'shape_3d_renderer.dart';
import 'shape_renderer.dart';

class AssetGeneratorService {
  AssetGeneratorService._();

  // ═══ Border PNG (2D + 3D + Gradient) ═══

  static Future<Uint8List> generateBorderPng(BorderAsset asset) async {
    final width = AppConstants.borderAssetWidth.toDouble();
    final height = AppConstants.borderAssetHeight.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final path = ShapeRenderer.render(
      asset.shape, Size(width, height), roundedness: 0.5,
    );

    if (asset.customImagePath != null) {
      try {
        Uint8List bytes;
        if (asset.customImagePath!.startsWith('assets/')) {
          final data = await rootBundle.load(asset.customImagePath!);
          bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        } else {
          bytes = await File(asset.customImagePath!).readAsBytes();
        }
        final codec = await ui.instantiateImageCodec(
          bytes, targetWidth: width.toInt(), targetHeight: height.toInt(),
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;
        canvas.save();
        canvas.clipPath(path);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(0, 0, width, height),
          Paint()..filterQuality = FilterQuality.high,
        );
        canvas.restore();
        image.dispose();
        codec.dispose();
      } catch (_) {
        canvas.drawPath(path, Paint()..color = asset.backgroundTint..isAntiAlias = true);
      }
    } else if (asset.shape.is3D) {
      final settings = Shape3DSettings.fromColor(asset.effectiveColor).copyWith(
        depth: asset.borderWidth > 2 ? 0.35 : 0.25,
        highlightIntensity: 0.6,
        shadowIntensity: 0.4,
      );
      Shape3DRenderer.render(_shapeTo3D(asset.shape), canvas, Size(width, height), settings);
    } else {
      if (asset.gradient != null) {
        final bounds = path.getBounds();
        final paint = Paint()
          ..shader = asset.gradient!.toFlutterGradient().createShader(bounds)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;
        canvas.drawPath(path, paint);
      } else {
        canvas.drawPath(
          path,
          Paint()..color = asset.backgroundTint..style = PaintingStyle.fill..isAntiAlias = true,
        );
      }
    }

    if (asset.borderWidth > 0 && !asset.shape.is3D) {
      canvas.drawPath(
        path,
        Paint()..color = asset.borderColor..style = PaintingStyle.stroke..strokeWidth = asset.borderWidth..isAntiAlias = true,
      );
    }
    return _pictureToPng(recorder, width.toInt(), height.toInt());
  }

  // ═══ Icon PNG (Material + Image + Emoji) ═══

  static Future<Uint8List> generateIconPng(IconAsset asset) async {
    final size = asset.size;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    if (asset.type == IconType.material && asset.materialIcon != null) {
      final icon = asset.materialIcon!;
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: size * 0.75,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: asset.tint,
          ),
        ),
      )..layout();
      textPainter.paint(
        canvas,
        Offset(
          (size - textPainter.width) / 2,
          (size - textPainter.height) / 2,
        ),
      );
    } else if (asset.type == IconType.customImage &&
        asset.customImagePath != null) {
      final file = File(asset.customImagePath!);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: size,
          targetHeight: size,
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(
              0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          Paint(),
        );
      }
    } else if (asset.type == IconType.emoji && asset.emoji != null) {
      final emojiPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: asset.emoji!,
          style: TextStyle(
            fontSize: size * 0.85,
            color: Colors.white,
          ),
        ),
      )..layout();
      emojiPainter.paint(
        canvas,
        Offset(
          (size - emojiPainter.width) / 2,
          (size - emojiPainter.height) / 2,
        ),
      );
    }

    return _pictureToPng(recorder, size, size);
  }

  // ═══ Save / Generate ═══

  static Future<File> savePng(
      String name, Uint8List bytes, Directory dir) async {
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<Directory> generateAllAssets({
    required List<BorderAsset> borders,
    required List<IconAsset> icons,
    required Directory outputDir,
  }) async {
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    for (final border in borders) {
      final bytes = await generateBorderPng(border);
      await savePng(border.name, bytes, outputDir);
    }

    for (final icon in icons) {
      final bytes = await generateIconPng(icon);
      await savePng(icon.name, bytes, outputDir);
    }

    return outputDir;
  }

  static Future<Directory> createAssetsDir() async {
    final tempDir = await getTemporaryDirectory();
    final assetsDir = Directory('${tempDir.path}/generated_assets');
    if (await assetsDir.exists()) {
      await assetsDir.delete(recursive: true);
    }
    await assetsDir.create(recursive: true);
    return assetsDir;
  }

  // ═══ Helpers ═══

  static Shape3DType _shapeTo3D(KeyShape shape) {
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

  static Future<Uint8List> _pictureToPng(
    ui.PictureRecorder recorder,
    int width,
    int height,
  ) async {
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
