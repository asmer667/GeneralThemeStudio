import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/theme_provider.dart';
import '../services/font_service.dart';
import '../utils/validators.dart';
import '../widgets/font_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// تبويب الخطوط
class FontsTab extends StatefulWidget {
  const FontsTab({super.key});

  @override
  State<FontsTab> createState() => _FontsTabState();
}

class _FontsTabState extends State<FontsTab> {
  List<dynamic> _all = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final all = await FontService.loadAllFonts();
    if (!mounted) return;
    setState(() {
      _all = [
        ...all.builtIn,
        ...all.downloaded,
        ...all.custom,
      ];
      _loading = false;
    });
  }

  Future<void> _pickFont() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf', 'woff', 'woff2'],
      );

      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) return;

      final file = File(path);
      final validation = await Validators.fontFile(file);
      if (!validation.isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validation.error ?? 'ملف غير صالح')),
        );
        return;
      }

      final info = await FontService.addCustomFont(file);
      await FontService.loadFontForPreview(info.family, info.filePath);
      await _load();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة: ${info.family}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final currentFont = provider.project.fontName;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'الخطوط المتاحة',
                      style: TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  NeonIconButton(
                    icon: Icons.add,
                    color: AppColors.neonCyan,
                    onPressed: _pickFont,
                    tooltip: 'إضافة خط',
                  ),
                ],
              ),
            ),
            if (currentFont != null && currentFont.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  glowColor: AppColors.neonGreen,
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.neonGreen, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'الخط الحالي: $currentFont',
                          style: const TextStyle(
                            color: AppColors.textDarkPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.project.fontName = null;
                          provider.project.fontPath = null;
                          provider.notifyListeners();
                        },
                        child: const Text('إزالة'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _all.isEmpty
                      ? const Center(
                          child: Text(
                            'لا توجد خطوط',
                            style: TextStyle(color: AppColors.textDarkHint),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _all.length,
                          itemBuilder: (_, i) {
                            final font = _all[i];
                            final family = font.family ?? font.displayName;
                            final isSelected = family == currentFont;

                            return LocalFontCard(
                              family: family,
                              displayName: font.displayName,
                              subtitle: font.displayNameAr ??
                                  (font.assetPath != null
                                      ? 'مدمج'
                                      : 'مُحمَّل'),
                              isSelected: isSelected,
                              onTap: () {
                                provider.project.fontName = family;
                                provider.project.fontPath =
                                    font.filePath ?? font.assetPath;
                                provider.notifyListeners();
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}
