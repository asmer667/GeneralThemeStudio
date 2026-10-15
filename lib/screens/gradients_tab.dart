import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/gradient_preset.dart';
import '../models/apply_target.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_picker.dart';
import '../widgets/preview_bottom_sheet.dart';
import 'online_palettes_screen.dart';

/// تبويب التدرجات
class GradientsTab extends StatelessWidget {
  const GradientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // زر تصفح الإنترنت
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonGreen,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OnlinePalettesScreen(
                      onGradientSelected: (grad) {
                        if (grad != null) _applyGradient(context, grad);
                      },
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10E5A0), Color(0xFF16D9F2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.glow(
                        AppColors.neonGreen,
                        intensity: 0.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.cloud_download_outlined,
                      color: AppColors.darkBg,
                      size: 22,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Coolors • Colormind • UI Gradients',
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

            const SizedBox(height: 16),

            // منتقي التدرجات المحلي
            GlassCard(
              padding: const EdgeInsets.all(14),
              glowColor: AppColors.neonPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.gradient,
                        color: AppColors.neonPurple,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'مكتبة التدرجات (60+)',
                        style: TextStyle(
                          color: AppColors.textDarkPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 500,
                    child: GradientPicker(
                      selected: null,
                      onSelected: (grad) {
                        if (grad != null) _applyGradient(context, grad);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Future<void> _applyGradient(
    BuildContext context,
    GradientPreset gradient,
  ) async {
    final provider = context.read<ThemeProvider>();

    final selection = await PreviewBottomSheet.show(
      context,
      itemName: gradient.name,
      previewGradient: gradient,
      previewColor: gradient.colors.isNotEmpty
          ? gradient.colors.first
          : AppColors.neonCyan,
      previewWidget: const SizedBox.shrink(),
    );

    if (selection == null) return;

    final updated = ApplyService.applyGradient(
      project: provider.project,
      gradient: gradient,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تطبيق ${gradient.name} على ${selection.target.labelAr}',
        ),
      ),
    );
  }
}
