import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/apply_target.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import '../widgets/color_picker_dialog.dart';
import '../widgets/glass_card.dart';
import '../widgets/preview_bottom_sheet.dart';

/// تبويب الألوان — محدّث بـ Bottom Sheet
class ColorsTab extends StatelessWidget {
  const ColorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final p = provider.project;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _section(
              title: 'الألوان الأساسية',
              icon: Icons.palette,
              color: AppColors.neonCyan,
              children: [
                _colorTile(context, provider, 'primary', 'اللون الأساسي', p.primary),
                _colorTile(context, provider, 'onPrimary', 'النص على الأساسي', p.onPrimary),
                _colorTile(context, provider, 'primaryContainer', 'حاوية الأساسي', p.primaryContainer),
              ],
            ),
            _section(
              title: 'الألوان الثانوية',
              icon: Icons.palette_outlined,
              color: AppColors.neonPurple,
              children: [
                _colorTile(context, provider, 'secondary', 'اللون الثانوي', p.secondary),
                _colorTile(context, provider, 'onSecondary', 'النص على الثانوي', p.onSecondary),
                _colorTile(context, provider, 'secondaryContainer', 'حاوية الثانوي', p.secondaryContainer),
              ],
            ),
            _section(
              title: 'الخلفيات',
              icon: Icons.wallpaper,
              color: AppColors.neonBlue,
              children: [
                _colorTile(context, provider, 'background', 'الخلفية', p.background),
                _colorTile(context, provider, 'surface', 'السطح', p.surface),
                _colorTile(context, provider, 'onSurface', 'النص على السطح', p.onSurface),
                _colorTile(context, provider, 'surfaceVariant', 'سطح متغير', p.surfaceVariant),
              ],
            ),
            _section(
              title: 'لوحة المفاتيح',
              icon: Icons.keyboard,
              color: AppColors.neonPink,
              children: [
                _colorTile(context, provider, 'keyboardSurface', 'خلفية الكيبورد', p.keyboardSurface),
                _colorTile(context, provider, 'keyboardContainer', 'حاوية المفاتيح', p.keyboardContainer),
                _colorTile(context, provider, 'keyboardContainerVariant', 'حاوية متغيرة', p.keyboardContainerVariant),
                _colorTile(context, provider, 'onKeyboardContainer', 'النص على المفاتيح', p.onKeyboardContainer),
                _colorTile(context, provider, 'keyboardPress', 'لون الضغط', p.keyboardPress),
              ],
            ),
            _section(
              title: 'الأخطاء والحدود',
              icon: Icons.error_outline,
              color: AppColors.error,
              children: [
                _colorTile(context, provider, 'error', 'لون الخطأ', p.error),
                _colorTile(context, provider, 'outline', 'الحدود', p.outline),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        glowColor: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _colorTile(
    BuildContext context,
    ThemeProvider provider,
    String field,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => _onColorTap(context, provider, field, label, color),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textDarkPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _hex(color),
                      style: const TextStyle(
                        color: AppColors.textDarkHint,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.touch_app,
                color: AppColors.textDarkHint,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onColorTap(
    BuildContext context,
    ThemeProvider provider,
    String field,
    String label,
    Color color,
  ) async {
    // 1. اختيار اللون
    final picked = await ColorPickerDialog.show(
      context,
      initialColor: color,
      title: label,
    );

    if (picked == null) return;

    // 2. عرض Bottom Sheet للمعاينة والتطبيق
    if (!context.mounted) return;

    final selection = await PreviewBottomSheet.show(
      context,
      itemName: label,
      previewColor: picked,
      previewWidget: const SizedBox.shrink(),
    );

    if (selection == null) return;

    // 3. تطبيق اللون بناءً على النطاق
    final updated = _applyColorByTarget(
      project: provider.project,
      color: picked,
      field: field,
      selection: selection,
    );

    provider.loadProject(updated);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تطبيق $label على ${selection.target.labelAr}'),
      ),
    );
  }

  dynamic _applyColorByTarget({
    required dynamic project,
    required Color color,
    required String field,
    required ApplySelection selection,
  }) {
    // إذا كان النطاق خلفية أو كل الأزرار
    if (selection.target == ApplyTarget.keyboardBackground ||
        selection.target == ApplyTarget.screenBackground) {
      // تعديل keyboardSurface
      return project.copyWith(
        keyboardSurface: color,
        keyboardContainer: color,
      );
    }

    // غير ذلك → تعديل الحقل المحدد
    switch (field) {
      case 'primary':
        return project.copyWith(primary: color);
      case 'onPrimary':
        return project.copyWith(onPrimary: color);
      case 'secondary':
        return project.copyWith(secondary: color);
      case 'onSecondary':
        return project.copyWith(onSecondary: color);
      case 'background':
        return project.copyWith(background: color);
      case 'surface':
        return project.copyWith(surface: color);
      case 'onSurface':
        return project.copyWith(onSurface: color);
      case 'surfaceVariant':
        return project.copyWith(surfaceVariant: color);
      case 'keyboardSurface':
        return project.copyWith(keyboardSurface: color);
      case 'keyboardContainer':
        return project.copyWith(keyboardContainer: color);
      case 'keyboardContainerVariant':
        return project.copyWith(keyboardContainerVariant: color);
      case 'onKeyboardContainer':
        return project.copyWith(onKeyboardContainer: color);
      case 'keyboardPress':
        return project.copyWith(keyboardPress: color);
      case 'error':
        return project.copyWith(error: color);
      case 'outline':
        return project.copyWith(outline: color);
      default:
        return project;
    }
  }

  String _hex(Color c) {
    final r = (c.red * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (c.green * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (c.blue * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }
}
