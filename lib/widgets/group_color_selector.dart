import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/gradient_preset.dart';
import '../widgets/gradient_picker.dart';
import '../widgets/gradient_preview.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

/// منتقي لون/تدرج لمجموعة
class GroupColorSelector extends StatelessWidget {
  final String title;
  final Color? solidColor;
  final GradientPreset? gradient;
  final ValueChanged<Color>? onColorChanged;
  final ValueChanged<GradientPreset?>? onGradientChanged;
  final VoidCallback? onClearGradient;

  const GroupColorSelector({
    super.key,
    required this.title,
    this.solidColor,
    this.gradient,
    this.onColorChanged,
    this.onGradientChanged,
    this.onClearGradient,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (hasGradient)
              TextButton.icon(
                onPressed: onClearGradient,
                icon: const Icon(Icons.close, size: 14),
                label: const Text('إزالة التدرج'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // زر اللون الأحادي
            Expanded(
              child: GestureDetector(
                onTap: onColorChanged != null && solidColor != null
                    ? () => _pickSolidColor(context)
                    : null,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: solidColor ?? AppColors.darkContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !hasGradient
                          ? AppColors.neonCyan
                          : Colors.white.withOpacity(0.15),
                      width: !hasGradient ? 2 : 1,
                    ),
                    boxShadow: !hasGradient
                        ? AppColors.glow(
                            solidColor ?? AppColors.neonCyan,
                            intensity: 0.4,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.format_color_fill,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'لون واحد',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // زر التدرج
            Expanded(
              child: GestureDetector(
                onTap: () => _pickGradient(context),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: hasGradient
                        ? gradient!.toFlutterGradient()
                        : const LinearGradient(
                            colors: [
                              Color(0xFF16D9F2),
                              Color(0xFF8B5CF6),
                              Color(0xFFFF6B9D),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasGradient
                          ? AppColors.neonPurple
                          : Colors.white.withOpacity(0.15),
                      width: hasGradient ? 2 : 1,
                    ),
                    boxShadow: hasGradient
                        ? AppColors.glow(
                            AppColors.neonPurple,
                            intensity: 0.5,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.gradient,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasGradient ? gradient!.name : 'تدرج',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickSolidColor(BuildContext context) async {
    if (solidColor == null) return;
    // نستخدم منتقي الألوان الموجود
    final result = await showDialog<Color>(
      context: context,
      builder: (_) => const _SimpleColorDialog(),
    );
    if (result != null) onColorChanged?.call(result);
  }

  void _pickGradient(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.gradient,
                      color: AppColors.neonPurple),
                  const SizedBox(width: 8),
                  const Text(
                    'اختر تدرجاً',
                    style: TextStyle(
                      color: AppColors.textDarkPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GradientPicker(
                selected: gradient,
                onSelected: (g) {
                  onGradientChanged?.call(g);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// حوار لون بسيط (بديل مؤقت)
class _SimpleColorDialog extends StatelessWidget {
  const _SimpleColorDialog();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('اختر لوناً'),
      content: Text('استخدم منتقي الألوان من التبويب الرئيسي'),
      actions: [
        TextButton(
          onPressed: null,
          child: Text('حسناً'),
        ),
      ],
    );
  }
}
