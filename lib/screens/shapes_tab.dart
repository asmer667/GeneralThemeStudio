import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/key_shape.dart';
import '../models/shape_category.dart';
import '../providers/theme_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../widgets/preview_bottom_sheet.dart';
import '../widgets/shape_picker_grid.dart';
import '../widgets/shape_widget.dart';

/// تبويب الأشكال — محدّث بـ Bottom Sheet
class ShapesTab extends StatefulWidget {
  const ShapesTab({super.key});

  @override
  State<ShapesTab> createState() => _ShapesTabState();
}

class _ShapesTabState extends State<ShapesTab> {
  ShapeCategory? _filterCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final groups = provider.project.groups;
        final activeGroup = provider.activeGroup;

        return Column(
          children: [
            // شريط المجموعات
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: groups.map((g) {
                    final isActive = g.id == provider.activeGroupId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: NeonChip(
                        label: g.name,
                        selected: isActive,
                        onTap: () => provider.setActiveGroup(g.id),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // المحتوى
            Expanded(
              child: activeGroup == null
                  ? const Center(
                      child: Text(
                        'اختر مجموعة أولاً',
                        style: TextStyle(color: AppColors.textDarkHint),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        // المعاينة الحالية للمجموعة
                        _buildGroupPreview(activeGroup),
                        const SizedBox(height: 12),
                        // الفلاتر
                        ShapeCategoryFilter(
                          selected: _filterCategory,
                          onSelected: (cat) {
                            setState(() => _filterCategory = cat);
                          },
                        ),
                        const SizedBox(height: 8),
                        // شبكة الأشكال
                        ShapePickerGrid(
                          selected: activeGroup.shape,
                          filterCategory: _filterCategory,
                          previewColor:
                              activeGroup.border?.backgroundTint ??
                                  provider.project.keyboardContainer,
                          previewBorderColor:
                              activeGroup.border?.borderColor ??
                                  provider.project.outline,
                          onSelected: (shape) =>
                              _onShapeSelected(context, provider, shape),
                        ),
                        const SizedBox(height: 16),
                        // الاستدارة
                        if (activeGroup.shape.supportsRoundedness)
                          GlassCard(
                            padding: const EdgeInsets.all(12),
                            glowColor: AppColors.neonCyan,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'درجة الاستدارة',
                                  style: TextStyle(
                                    color: AppColors.textDarkPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('0%',
                                        style: TextStyle(
                                            color: AppColors.textDarkHint,
                                            fontSize: 11)),
                                    Expanded(
                                      child: Slider(
                                        value: provider.project.roundedness,
                                        min: 0.0,
                                        max: 1.0,
                                        divisions: 20,
                                        onChanged: (v) =>
                                            provider.updateRoundedness(v),
                                      ),
                                    ),
                                    const Text('100%',
                                        style: TextStyle(
                                            color: AppColors.textDarkHint,
                                            fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupPreview(dynamic group) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      glowColor: AppColors.neonPurple,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: group.border?.backgroundTint ?? AppColors.darkContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: group.border?.borderColor ?? AppColors.neonCyan,
                width: 1.5,
              ),
            ),
            child: Center(
              child: ShapeWidget(
                shape: group.shape,
                color: group.border?.backgroundTint ?? AppColors.neonCyan,
                width: 36,
                height: 36,
              ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'الشكل: ${group.shape.label}',
                  style: const TextStyle(
                    color: AppColors.textDarkHint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onShapeSelected(
    BuildContext context,
    ThemeProvider provider,
    KeyShape shape,
  ) async {
    // عرض Bottom Sheet
    final selection = await PreviewBottomSheet.show(
      context,
      itemName: shape.label,
      previewShape: shape,
      previewColor: AppColors.neonPurple,
      previewWidget: ShapeWidget(
        shape: shape,
        color: Colors.white.withValues(alpha: 0.9),
        width: 28,
        height: 28,
      ),
      allowBackground: false,
    );

    if (selection == null) return;

    // تطبيق على المجموعة النشطة
    final group = provider.activeGroup;
    if (group != null) {
      provider.changeGroupShape(group.id, shape);
    }
  }
}
