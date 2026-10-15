import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/icon_asset.dart';
import '../providers/theme_provider.dart';
import '../utils/validators.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// تبويب الأصول — رفع أيقونات مخصصة
class AssetsTab extends StatelessWidget {
  const AssetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final groups = provider.project.groups;
        final withIcons = groups.where((g) => g.icon != null).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonBlue,
              child: const Row(
                children: [
                  Icon(Icons.info,
                      color: AppColors.neonBlue, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'الأيقونات لأزرار الوظائف (حذف، Enter، Shift). اختر صورة PNG شفافة.',
                      style: TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.neonPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.neonPurple.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.neonPurple,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'الأيقونات المخصصة',
                          style: TextStyle(
                            color: AppColors.textDarkPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${withIcons.length}',
                        style: const TextStyle(
                          color: AppColors.textDarkHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (withIcons.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'لا توجد أيقونات مخصصة بعد',
                          style: TextStyle(
                            color: AppColors.textDarkHint,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ...withIcons.map(
                      (g) => _iconRow(context, provider, g),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إضافة أيقونة لمجموعة',
                    style: TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اختر مجموعة لرفع أيقونة مخصصة لها',
                    style: TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...groups.map((g) => _addIconTile(context, provider, g)),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _iconRow(
      BuildContext context, ThemeProvider provider, dynamic group) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: const Icon(
              Icons.image,
              color: AppColors.textDarkHint,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  group.icon?.name ?? 'بدون اسم',
                  style: const TextStyle(
                    color: AppColors.textDarkHint,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: AppColors.error,
            onPressed: () => provider.setGroupIcon(group.id, null),
          ),
        ],
      ),
    );
  }

  Widget _addIconTile(
      BuildContext context, ThemeProvider provider, dynamic group) {
    final hasIcon = group.icon != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () => _pickIcon(context, provider, group),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasIcon
                      ? AppColors.neonGreen.withValues(alpha: 0.15)
                      : AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(9),
                  border: hasIcon
                      ? Border.all(
                          color: AppColors.neonGreen.withValues(alpha: 0.4))
                      : null,
                ),
                child: Icon(
                  hasIcon ? Icons.check : Icons.add,
                  color:
                      hasIcon ? AppColors.neonGreen : AppColors.textDarkHint,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.textDarkHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickIcon(
    BuildContext context,
    ThemeProvider provider,
    dynamic group,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;
      final path = result.files.first.path;
      if (path == null) return;

      final file = File(path);
      final validation = await Validators.imageFile(file);
      if (!validation.isValid) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validation.error ?? 'ملف غير صالح')),
        );
        return;
      }

      final icon = IconAsset.fromImage(
        name: 'Icon-${group.selector.replaceAll(" ", "_")}.png',
        imagePath: path,
      );

      provider.setGroupIcon(group.id, icon);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الأيقونة')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الاختيار: $e')),
      );
    }
  }
}
