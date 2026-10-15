import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// مصدر خلفيات مجاني
enum WallpaperSource {
  picsum,      // Lorem Picsum (بدون API key)
  unsplash,    // Unsplash Source
  placeholder, // Placeholder.com
}

extension WallpaperSourceExt on WallpaperSource {
  String get label {
    switch (this) {
      case WallpaperSource.picsum:
        return 'Picsum Photos';
      case WallpaperSource.unsplash:
        return 'Unsplash';
      case WallpaperSource.placeholder:
        return 'Placeholder';
    }
  }

  String get description {
    switch (this) {
      case WallpaperSource.picsum:
        return 'صور مجانية عالية الجودة';
      case WallpaperSource.unsplash:
        return 'خلفيات احترافية من Unsplash';
      case WallpaperSource.placeholder:
        return 'خلفيات تجريبية متنوعة';
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

  /// نسبة الأبعاد
  double get aspectRatio => width / height;

  /// اسم الملف المقترح
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

  /// جلب قائمة خلفيات
  static Future<List<OnlineWallpaper>> fetchWallpapers({
    WallpaperSource source = WallpaperSource.picsum,
    int count = 30,
    int page = 1,
  }) async {
    switch (source) {
      case WallpaperSource.picsum:
        return _fetchPicsum(count: count, page: page);
      case WallpaperSource.unsplash:
        return _fetchUnsplash(count: count);
      case WallpaperSource.placeholder:
        return _fetchPlaceholder(count: count);
    }
  }

  /// Picsum Photos — API مجاني بدون key
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

  /// Unsplash Source (بدون key — يعطي صورة عشوائية)
  static Future<List<OnlineWallpaper>> _fetchUnsplash({
    int count = 30,
  }) async {
    // Unsplash Source لا يوفر قائمة — نولّد روابط عشوائية
    final result = <OnlineWallpaper>[];
    final categories = [
      'nature',
      'abstract',
      'gradient',
      'space',
      'texture',
      'city',
      'minimal',
      'neon',
      'dark',
      'pattern',
    ];

    for (int i = 0; i < count; i++) {
      final cat = categories[i % categories.length];
      final seed = DateTime.now().millisecondsSinceEpoch + i;
      result.add(OnlineWallpaper(
        id: 'unsplash_$seed',
        url: 'https://source.unsplash.com/1080x1920/?$cat&sig=$seed',
        thumbnailUrl: 'https://source.unsplash.com/300x300/?$cat&sig=$seed',
        author: 'Unsplash',
        source: 'Unsplash',
      ));
    }
    return result;
  }

  /// Placeholder
  static Future<List<OnlineWallpaper>> _fetchPlaceholder({
    int count = 30,
  }) async {
    final result = <OnlineWallpaper>[];
    final colors = [
      ['16D9F2', '8B5CF6'],
      ['FF6B9D', 'E91E63'],
      ['10E5A0', '00BCD4'],
      ['FF9500', 'FFD700'],
      ['3B82F6', '1E40AF'],
      ['8B5CF6', 'FF6B9D'],
    ];

    for (int i = 0; i < count; i++) {
      final pair = colors[i % colors.length];
      final seed = DateTime.now().millisecondsSinceEpoch + i;
      result.add(OnlineWallpaper(
        id: 'ph_$seed',
        url:
            'https://via.placeholder.com/1080x1920/${pair[0]}/${pair[1]}?text=Wallpaper+$i',
        thumbnailUrl:
            'https://via.placeholder.com/300x300/${pair[0]}/${pair[1]}',
        author: 'Placeholder',
        source: 'Placeholder',
      ));
    }
    return result;
  }

  // ═══════════════════════════════════════════
  // Download
  // ═══════════════════════════════════════════

  /// تنزيل خلفية
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
        final size = await file.length();
        if (size > 1024) return file;
      }
      return null;
    } catch (e) {
      debugPrint('Download error: $e');
      return null;
    }
  }

  /// تنزيل صورة من رابط مباشر
  static Future<File?> downloadFromUrl(String url) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${appDir.path}/wallpapers');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final ext = url.split('.').last.split('?').first;
      final fileName =
          'wall_${DateTime.now().millisecondsSinceEpoch}.${ext.isEmpty ? "jpg" : ext}';
      final file = File('${dir.path}/$fileName');

      await _dio.download(url, file.path);

      if (await file.exists()) {
        final size = await file.length();
        if (size > 1024) return file;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// جلب بايتات صورة (للعرض في الذاكرة)
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

      final files = await dir
          .list()
          .where((e) {
            if (e is! File) return false;
            final ext = e.path.split('.').last.toLowerCase();
            return ['png', 'jpg', 'jpeg', 'webp'].contains(ext);
          })
          .toList()
          .cast<File>()
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
