import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/background_asset.dart';

/// خدمة إدارة الخلفيات
class BackgroundService {
  BackgroundService._();

  static const String _bgDir = 'backgrounds';

  /// مجلد الخلفيات
  static Future<Directory> getBackgroundsDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/$_bgDir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// رفع خلفية جديدة
  static Future<BackgroundAsset> uploadBackground(File sourceFile) async {
    final dir = await getBackgroundsDir();
    final fileName =
        'bg_${DateTime.now().millisecondsSinceEpoch}_${sourceFile.uri.pathSegments.last}';
    final target = File('${dir.path}/$fileName');
    await sourceFile.copy(target.path);

    return BackgroundAsset.image(
      name: sourceFile.uri.pathSegments.last
          .replaceAll(RegExp(r'\.(png|jpg|jpeg|webp)$'), ''),
      path: target.path,
    );
  }

  /// كل الخلفيات المرفوعة
  static Future<List<BackgroundAsset>> loadUploadedBackgrounds() async {
    try {
      final dir = await getBackgroundsDir();
      final files = await dir
          .list()
          .where((e) {
            if (e is! File) return false;
            final ext = e.path.split('.').last.toLowerCase();
            return ['png', 'jpg', 'jpeg', 'webp'].contains(ext);
          })
          .toList();

      final result = <BackgroundAsset>[];
      for (final f in files) {
        if (f is File) {
          final stat = await f.stat();
          final name = f.uri.pathSegments.last
              .replaceAll(RegExp(r'\.(png|jpg|jpeg|webp)$'), '');
          result.add(BackgroundAsset.image(
            name: name,
            path: f.path,
          ).copyWith(
            id: 'uploaded_${stat.modified.millisecondsSinceEpoch}',
          ));
        }
      }
      result.sort((a, b) => a.name.compareTo(b.name));
      return result;
    } catch (_) {
      return [];
    }
  }

  /// حذف خلفية مرفوعة
  static Future<bool> deleteBackground(BackgroundAsset bg) async {
    if (bg.type != BackgroundType.image || bg.imagePath == null) {
      return false;
    }
    try {
      final file = File(bg.imagePath!);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// كل الخلفيات (مدمج + مرفوع)
  static Future<AllBackgrounds> loadAll() async {
    final builtin = BuiltinBackgrounds.all;
    final uploaded = await loadUploadedBackgrounds();
    return AllBackgrounds(
      builtin: builtin,
      uploaded: uploaded,
    );
  }

  /// البحث
  static Future<List<BackgroundAsset>> search(String query) async {
    final all = await loadAll();
    final list = [...all.builtin, ...all.uploaded];
    if (query.trim().isEmpty) return list;
    final q = query.toLowerCase();
    return list.where((b) => b.name.toLowerCase().contains(q)).toList();
  }
}

/// كل الخلفيات
class AllBackgrounds {
  final List<BackgroundAsset> builtin;
  final List<BackgroundAsset> uploaded;

  const AllBackgrounds({
    required this.builtin,
    required this.uploaded,
  });

  int get total => builtin.length + uploaded.length;
}
