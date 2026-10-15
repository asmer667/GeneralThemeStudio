import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'google_fonts_api.dart';

/// خدمة تنزيل الخطوط من Google وتخزينها محلياً
class FontDownloadService {
  FontDownloadService._();

  static const String _fontsDir = 'downloaded_fonts';
  static const String _metadataFile = 'metadata.json';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 2),
    ),
  );

  // ═══════════════════════════════════════════
  // Directory Management
  // ═══════════════════════════════════════════

  /// مجلد الخطوط المنزّلة
  static Future<Directory> getFontsDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/$_fontsDir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// مسار ملف خط معيّن
  static Future<File> getFontFile(String family) async {
    final dir = await getFontsDir();
    final safe = family.replaceAll(' ', '_').replaceAll(RegExp(r'[^\w-]'), '');
    return File('${dir.path}/$safe.ttf');
  }

  // ═══════════════════════════════════════════
  // Check / List
  // ═══════════════════════════════════════════

  /// هل الخط مُنزَّل؟
  static Future<bool> isDownloaded(String family) async {
    final f = await getFontFile(family);
    return await f.exists();
  }

  /// قائمة كل الخطوط المنزّلة
  static Future<List<DownloadedFont>> listDownloaded() async {
    final dir = await getFontsDir();
    final files = await dir
        .list()
        .where((e) => e is File && e.path.endsWith('.ttf'))
        .toList();

    final result = <DownloadedFont>[];
    for (final file in files) {
      if (file is File) {
        final stat = await file.stat();
        final name = file.uri.pathSegments.last.replaceAll('.ttf', '').replaceAll('_', ' ');
        result.add(DownloadedFont(
          family: name,
          filePath: file.path,
          sizeBytes: stat.size,
          downloadedAt: stat.modified,
        ));
      }
    }

    result.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
    return result;
  }

  /// حجم كل الخطوط المنزّلة
  static Future<int> getTotalSize() async {
    final list = await listDownloaded();
    return list.fold<int>(0, (sum, f) => sum + f.sizeBytes);
  }

  // ═══════════════════════════════════════════
  // Download
  // ═══════════════════════════════════════════

  /// تنزيل خط واحد
  static Future<DownloadResult> download(
    GoogleFont font, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      // 1. جلب رابط TTF الحقيقي من Google CSS
      final url = await GoogleFontsApi.getFontFileUrl(font);
      if (url == null) {
        return const DownloadResult(success: false, error: 'فشل جلب رابط الخط');
      }

      // 2. تجهيز ملف الهدف
      final target = await getFontFile(font.family);

      // 3. التنزيل
      await _dio.download(
        url,
        target.path,
        onReceiveProgress: onProgress,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
        ),
      );

      // 4. تحقق
      if (!await target.exists()) {
        return const DownloadResult(success: false, error: 'الملف غير موجود بعد التنزيل');
      }

      final size = await target.length();
      if (size < 1024) {
        await target.delete();
        return const DownloadResult(success: false, error: 'الملف تالف');
      }

      return DownloadResult(
        success: true,
        filePath: target.path,
        sizeBytes: size,
      );
    } catch (e) {
      debugPrint('Download error: $e');
      return DownloadResult(success: false, error: e.toString());
    }
  }

  /// تنزيل خط بطريقة بديلة (fallback)
  static Future<DownloadResult> downloadWithFallback(
    GoogleFont font, {
    void Function(int received, int total)? onProgress,
  }) async {
    // المحاولة 1: من Google CSS
    final r1 = await download(font, onProgress: onProgress);
    if (r1.success) return r1;

    // المحاولة 2: من gstatic مباشر
    try {
      final family = font.family.replaceAll(' ', '');
      final url = 'https://fonts.gstatic.com/s/${family.toLowerCase()}/v1/${family}-Regular.ttf';

      final target = await getFontFile(font.family);
      await _dio.download(url, target.path, onReceiveProgress: onProgress);

      if (await target.exists()) {
        final size = await target.length();
        if (size > 1024) {
          return DownloadResult(
            success: true,
            filePath: target.path,
            sizeBytes: size,
          );
        }
      }
    } catch (e) {
      debugPrint('Fallback download error: $e');
    }

    return const DownloadResult(success: false, error: 'فشلت كل المحاولات');
  }

  // ═══════════════════════════════════════════
  // Delete
  // ═══════════════════════════════════════════

  /// حذف خط
  static Future<bool> delete(String family) async {
    try {
      final f = await getFontFile(family);
      if (await f.exists()) {
        await f.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// حذف كل الخطوط
  static Future<void> deleteAll() async {
    final dir = await getFontsDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  // ═══════════════════════════════════════════
  // Read Font Bytes
  // ═══════════════════════════════════════════

  /// قراءة بايتات خط (للاستخدام في FontLoader)
  static Future<List<int>?> readFontBytes(String family) async {
    try {
      final f = await getFontFile(family);
      if (await f.exists()) {
        return await f.readAsBytes();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

/// نتيجة تنزيل
class DownloadResult {
  final bool success;
  final String? filePath;
  final int? sizeBytes;
  final String? error;

  const DownloadResult({
    required this.success,
    this.filePath,
    this.sizeBytes,
    this.error,
  });

  String get sizeFormatted {
    if (sizeBytes == null) return '0 KB';
    if (sizeBytes! < 1024 * 1024) {
      return '${(sizeBytes! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

/// خط منزّل
class DownloadedFont {
  final String family;
  final String filePath;
  final int sizeBytes;
  final DateTime downloadedAt;

  const DownloadedFont({
    required this.family,
    required this.filePath,
    required this.sizeBytes,
    required this.downloadedAt,
  });

  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String get downloadedAgo {
    final diff = DateTime.now().difference(downloadedAt);
    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
    return 'الآن';
  }
}
