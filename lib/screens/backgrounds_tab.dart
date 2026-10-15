import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/background_asset.dart';
import '../models/apply_target.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import '../widgets/background_picker.dart';
import '../widgets/glass_card.dart';
import '../widgets/preview_bottom_sheet.dart';
import 'online_wallpapers_screen.dart';

/// تبويب الخلفيات
class BackgroundsTab extends StatelessWidget {
  const BackgroundsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final current = provider.project.backgroundAsset;

        return Column(
          children: [
            _buildCurrentCard(context, provider, current),
            _buildOnlineButton(context, provider),
            Expanded(
              child: BackgroundPicker(
                selected: current,
                onSelected: (bg) =>
                    _onBackgroundSelected(context, provider, bg),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentCard(
    BuildContext context,
    ThemeProvider provider,
    BackgroundAsset? current,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        glowColor: AppColors.neonPurple,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: current?.type == BackgroundType.gradient
                    ? LinearGradient(colors: current!.gradientColors ?? [])
                    : null,
                color: current?.solidColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: AppColors.glow(
                  AppColors.neonPurple,
                  intensity: 0.4,
                ),
              ),
              child: current?.type == BackgroundType.image &&
                      current?.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(current!.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image, color: Colors.white),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخلفية الحالية',
                    style: TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    current?.name ?? 'لا توجد',
                    style: const TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (current != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                onPressed: () => provider.updateBackground(null),
                tooltip: 'إزالة',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineButton(BuildContext context, ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        glowColor: AppColors.neonGreen,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OnlineWallpapersScreen(
                onWallpaperSelected: (bg) {
                  provider.updateBackground(bg);
                },
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10E5A0), Color(0xFF16D9F2)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppColors.glow(
                  AppColors.neonGreen,
                  intensity: 0.5,
                ),
              ),
              child: const Icon(
                Icons.cloud_download_outlined,
                color: AppColors.darkBg,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تصفح من الإنترنت',
                    style: TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Picsum • Unsplash • Placeholder',
                    style: TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textDarkHint,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onBackgroundSelected(
    BuildContext context,
    ThemeProvider provider,
    BackgroundAsset? bg,
  ) async {
    if (bg == null) return;

    final selection = await PreviewBottomSheet.show(
      context,
      itemName: bg.name,
      previewColor: bg.solidColor,
      previewWidget: const SizedBox.shrink(),
      allowKeys: false,
    );

    if (selection == null) return;

    final updated = ApplyService.applyBackground(
      project: provider.project,
      background: bg,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('تم تطبيق ${bg.name} على ${selection.target.labelAr}'),
      ),
    );
  }
}
