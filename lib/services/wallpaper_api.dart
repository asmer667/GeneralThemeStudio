import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// مصدر خلفيات مجاني
enum WallpaperSource {
  picsum,
}

extension WallpaperSourceExt on WallpaperSource {
  String get label {
    switch (this) {
      case WallpaperSource.picsum:
        return 'Picsum Photos';
    }
  }

  String get description {
    switch (this) {
      case WallpaperSource.picsum:
        return 'صور فعلية مجانية يمكن تنزيلها واستخدامها';
    }
  }
}

/// نموذج خلفية من الإنترنت
class OnlineWallpaper {
  final String id;
  final String url;
  final String thumbnailUrl;
  final String author;
  final String source;
  final int width;
  final int height;

  const OnlineWallpaper({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    this.author = 'Unknown',
    this.source = 'Unknown',
    this.width = 1080,
    this.height = 1920,
  });

  double get aspectRatio => width / height;

  String get suggestedName =>
      'wallpaper_${id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
}

/// خدمة جلب الخلفيات من الإنترنت
class WallpaperApi {
  WallpaperApi._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // ═══════════════════════════════════════════
  // Fetch
  // ═══════════════════════════════════════════

  static Future<List<OnlineWallpaper>> fetchWallpapers({
    WallpaperSource source = WallpaperSource.picsum,
    int count = 30,
    int page = 1,
  }) async {
    return _fetchPicsum(count: count, page: page);
  }

  static Future<List<OnlineWallpaper>> _fetchPicsum({
    int count = 30,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'https://picsum.photos/v2/list',
        queryParameters: {
          'page': page,
          'limit': count,
        },
      );

      if (response.statusCode == 200) {
        final list = response.data as List;
        return list.map((item) {
          final id = item['id'].toString();
          final width = item['width'] as int? ?? 1080;
          final height = item['height'] as int? ?? 1920;

          return OnlineWallpaper(
            id: id,
            url: 'https://picsum.photos/id/$id/$width/$height',
            thumbnailUrl: 'https://picsum.photos/id/$id/300/300',
            author: item['author']?.toString() ?? 'Unknown',
            source: 'Picsum',
            width: width,
            height: height,
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Picsum error: $e');
    }
    return [];
  }

  // ═══════════════════════════════════════════
  // Download
  // ═══════════════════════════════════════════

  static Future<File?> downloadWallpaper({
    required OnlineWallpaper wallpaper,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/wallpapers');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('${dir.path}/${wallpaper.suggestedName}');

      await _dio.download(
        wallpaper.url,
        file.path,
        onReceiveProgress: onProgress,
      );

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 1024 && img.decodeImage(bytes) != null) return file;
        await file.delete();
      }
      return null;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  static Future<File?> downloadFromUrl(String url) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/wallpapers');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final uri = Uri.parse(url);
      final pathExt = uri.pathSegments.isEmpty
          ? ''
          : uri.pathSegments.last.split('.').last.toLowerCase();
      final ext = const {'jpg', 'jpeg', 'png', 'webp'}.contains(pathExt)
          ? (pathExt == 'jpeg' ? 'jpg' : pathExt)
          : 'jpg';
      final fileName = 'wall_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final file = File('${dir.path}/$fileName');

      await _dio.download(url, file.path);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 1024 && img.decodeImage(bytes) != null) return file;
        await file.delete();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Uint8List?> fetchImageBytes(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data as List<int>);
    } catch (_) {
      return null;
    }
  }
}

/// كل الخلفيات المنزّلة
class DownloadedWallpapers {
  DownloadedWallpapers._();

  static Future<List<File>> loadAll() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/wallpapers');
      if (!await dir.exists()) return [];

      final entities = await dir.list().toList();
      final files = entities
          .whereType<File>()
          .where((e) {
            final ext = e.path.split('.').last.toLowerCase();
            return ['png', 'jpg', 'jpeg', 'webp'].contains(ext);
          })
          .toList();

      files.sort((a, b) =>
          b.statSync().modified.compareTo(a.statSync().modified));
      return files;
    } catch (_) {
      return [];
    }
  }

  static Future<void> delete(File file) async {
    if (await file.exists()) await file.delete();
  }

  static Future<int> count() async {
    return (await loadAll()).length;
  }
}
