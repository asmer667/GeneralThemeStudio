import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

/// خدمة إدارة ZIP
class ZipService {
  ZipService._();

  /// إنشاء ZIP من Map<اسم, bytes>
  static Future<File> createZip({
    required Map<String, Uint8List> files,
    required String outputName,
  }) async {
    final archive = Archive();

    files.forEach((name, bytes) {
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    });

    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) throw Exception('فشل إنشاء ZIP');

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$outputName');
    await file.writeAsBytes(zipBytes);
    return file;
  }

  /// إنشاء ZIP من مجلد
  static Future<File> createZipFromDirectory({
    required Directory sourceDir,
    required String outputName,
    List<String>? onlyFiles,
  }) async {
    final archive = Archive();

    final entries = sourceDir.listSync(recursive: false);
    for (final entry in entries) {
      if (entry is! File) continue;
      final name = entry.uri.pathSegments.last;
      if (onlyFiles != null && !onlyFiles.contains(name)) continue;
      final bytes = await entry.readAsBytes();
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) throw Exception('فشل إنشاء ZIP');

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$outputName');
    await file.writeAsBytes(zipBytes);
    return file;
  }

  /// قراءة محتوى ZIP
  static Future<Map<String, Uint8List>> readZip(File zipFile) async {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final result = <String, Uint8List>{};

    for (final file in archive) {
      if (file.isFile) {
        result[file.name] = Uint8List.fromList(file.content as List<int>);
      }
    }

    return result;
  }

  /// قراءة ملف نصي من ZIP
  static Future<String?> readTextFile(File zipFile, String fileName) async {
    final contents = await readZip(zipFile);
    final bytes = contents[fileName];
    if (bytes == null) return null;
    return String.fromCharCodes(bytes);
  }

  /// استخراج ZIP إلى مجلد
  static Future<Directory> extractZip(
    File zipFile,
    Directory targetDir,
  ) async {
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      if (file.isFile) {
        final outFile = File('${targetDir.path}/${file.name}');
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }

    return targetDir;
  }

  /// هل ZIP صالح؟
  static Future<bool> isValidZip(File file) async {
    try {
      final bytes = await file.readAsBytes();
      ZipDecoder().decodeBytes(bytes);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// الحجم بـ MB
  static Future<double> getSizeMb(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }
}
