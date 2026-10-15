import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../data/fonts/fonts_catalog.dart';
import 'font_download_service.dart';
import 'google_fonts_api.dart';

/// خدمة إدارة الخطوط الموحّدة
class FontService {
  FontService._();

  // ═══ All Fonts ═══

  static Future<AllFonts> loadAllFonts() async {
    final builtIn = FontsCatalog.fonts;

    final downloadedList = await FontDownloadService.listDownloaded();
    final downloaded = downloadedList
        .map((d) => DownloadedFontInfo(
              family: d.family,
              filePath: d.filePath,
              sizeBytes: d.sizeBytes,
              downloadedAt: d.downloadedAt,
            ))
        .toList();

    final customList = await _loadCustomFonts();

    return AllFonts(
      builtIn: builtIn,
      downloaded: downloaded,
      custom: customList,
    );
  }

  // ═══ Built-in ═══

  static List<BuiltInFont> get builtInFonts => FontsCatalog.fonts;
  static List<BuiltInFont> get arabicBuiltIn => FontsCatalog.arabicFonts;
  static List<BuiltInFont> get englishBuiltIn => FontsCatalog.englishFonts;

  // ═══ Google Fonts (Browse) ═══

  static Future<List<GoogleFont>> loadGoogleFonts({bool refresh = false}) async {
    return GoogleFontsApi.fetchAllFonts(forceRefresh: refresh);
  }

  static Future<List<GoogleFont>> loadGoogleArabicFonts() async {
    return GoogleFontsApi.fetchArabicFonts();
  }

  static Future<List<GoogleFont>> searchGoogle(String query) async {
    return GoogleFontsApi.search(query);
  }

  // ═══ Download ═══

  static Future<DownloadResult> downloadGoogleFont(
    GoogleFont font, {
    void Function(int received, int total)? onProgress,
  }) async {
    final result = await FontDownloadService.downloadWithFallback(
      font,
      onProgress: onProgress,
    );

    if (result.success) {
      await loadFontForPreview(font.family, result.filePath!);
    }

    return result;
  }

  static Future<bool> isFontDownloaded(String family) {
    return FontDownloadService.isDownloaded(family);
  }

  static Future<bool> deleteDownloadedFont(String family) {
    return FontDownloadService.delete(family);
  }

  // ═══ Custom Fonts (User Upload) ═══

  static Future<CustomFontInfo> addCustomFont(File file) async {
    final appDir = await FontDownloadService.getFontsDir();
    final customDir = Directory('${appDir.path}/custom');
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    final fileName = file.uri.pathSegments.last;
    final target = File('${customDir.path}/$fileName');
    await file.copy(target.path);

    final size = await target.length();
    final name = fileName.replaceAll(RegExp(r'\.(ttf|otf|woff2?)$'), '');

    await loadFontForPreview(name, target.path);

    return CustomFontInfo(
      family: name,
      filePath: target.path,
      sizeBytes: size,
      addedAt: DateTime.now(),
    );
  }

  static Future<List<CustomFontInfo>> _loadCustomFonts() async {
    try {
      final appDir = await FontDownloadService.getFontsDir();
      final customDir = Directory('${appDir.path}/custom');
      if (!await customDir.exists()) return [];

      final entities = await customDir.list().toList();
      final files = entities.whereType<File>().where((e) {
        final ext = e.path.split('.').last.toLowerCase();
        return ['ttf', 'otf'].contains(ext);
      }).toList();

      final result = <CustomFontInfo>[];
      for (final f in files) {
        final stat = await f.stat();
        final name =
            f.uri.pathSegments.last.replaceAll(RegExp(r'\.(ttf|otf|woff2?)$'), '');
        result.add(CustomFontInfo(
          family: name,
          filePath: f.path,
          sizeBytes: stat.size,
          addedAt: stat.modified,
        ));
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  static Future<List<CustomFontInfo>> loadCustomFonts() => _loadCustomFonts();

  static Future<bool> deleteCustomFont(String family) async {
    try {
      final list = await _loadCustomFonts();
      final font = list.firstWhere((f) => f.family == family);
      final file = File(font.filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ═══ Load for Preview ═══

  static Future<bool> loadFontForPreview(String family, String filePath) async {
    try {
      Uint8List bytes;
      if (filePath.startsWith('assets/')) {
        final data = await rootBundle.load(filePath);
        bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      } else {
        final file = File(filePath);
        if (!await file.exists()) return false;
        bytes = await file.readAsBytes();
      }
      final data = ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes);
      final loader = FontLoader(family);
      loader.addFont(Future.value(data));
      await loader.load();
      return true;
    } catch (e) {
      debugPrint('loadFontForPreview error: $e');
      return false;
    }
  }

  static Future<void> loadAllDownloadedFonts() async {
    final downloaded = await FontDownloadService.listDownloaded();
    for (final d in downloaded) {
      await loadFontForPreview(d.family, d.filePath);
    }
  }

  // ═══ Font File for Export ═══

  static Future<File?> getFontFileForExport(String family) async {
    // 1. خط منزّل
    final downloaded = await FontDownloadService.getFontFile(family);
    if (await downloaded.exists()) return downloaded;

    // 2. خط مخصص
    final custom = await _loadCustomFonts();
    try {
      final c = custom.firstWhere((f) => f.family == family);
      final f = File(c.filePath);
      if (await f.exists()) return f;
    } catch (_) {}

    // 3. خط مدمج
    final builtIn = FontsCatalog.getById(family.toLowerCase()) ??
        FontsCatalog.fonts.firstWhere(
          (f) => f.family.toLowerCase() == family.toLowerCase(),
          orElse: () => FontsCatalog.fonts.first,
        );

    try {
      final bytes = await rootBundle.load(builtIn.assetPath);
      final tempDir = await getTemporaryDirectory();
      final out = File('${tempDir.path}/${builtIn.family}.ttf');
      await out.writeAsBytes(bytes.buffer.asUint8List());
      return out;
    } catch (_) {
      return null;
    }
  }

  // ═══ Stats ═══

  static Future<FontStats> getStats() async {
    final downloaded = await FontDownloadService.listDownloaded();
    final custom = await _loadCustomFonts();

    final downloadedSize = downloaded.fold<int>(0, (s, f) => s + f.sizeBytes);
    final customSize = custom.fold<int>(0, (s, f) => s + f.sizeBytes);

    return FontStats(
      builtInCount: FontsCatalog.fonts.length,
      downloadedCount: downloaded.length,
      customCount: custom.length,
      downloadedSize: downloadedSize,
      customSize: customSize,
    );
  }

  // ═══ Validation ═══

  static bool isValidExtension(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['ttf', 'otf'].contains(ext);
  }

  static bool isValidSize(int bytes) {
    return bytes <= 8 * 1024 * 1024;
  }
}

// ═══ Models ═══

class AllFonts {
  final List<BuiltInFont> builtIn;
  final List<DownloadedFontInfo> downloaded;
  final List<CustomFontInfo> custom;

  const AllFonts({
    required this.builtIn,
    required this.downloaded,
    required this.custom,
  });

  int get total => builtIn.length + downloaded.length + custom.length;
}

class DownloadedFontInfo {
  final String family;
  final String filePath;
  final int sizeBytes;
  final DateTime downloadedAt;

  const DownloadedFontInfo({
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
}

class CustomFontInfo {
  final String family;
  final String filePath;
  final int sizeBytes;
  final DateTime addedAt;

  const CustomFontInfo({
    required this.family,
    required this.filePath,
    required this.sizeBytes,
    required this.addedAt,
  });

  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class FontStats {
  final int builtInCount;
  final int downloadedCount;
  final int customCount;
  final int downloadedSize;
  final int customSize;

  const FontStats({
    required this.builtInCount,
    required this.downloadedCount,
    required this.customCount,
    required this.downloadedSize,
    required this.customSize,
  });

  int get totalCount => builtInCount + downloadedCount + customCount;
  int get totalSize => downloadedSize + customSize;

  String get totalSizeFormatted {
    if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
