import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/apply_target.dart';
import '../models/gradient_preset.dart';
import '../models/theme_project.dart';
import '../models/key_shape.dart';
import '../providers/theme_provider.dart';
import '../services/apply_service.dart';
import 'apply_target_sheet.dart';
import 'glass_card.dart';
import 'keyboard_preview.dart';
import 'neon_button.dart';

/// Bottom Sheet عام للمعاينة الحية والتطبيق
class PreviewBottomSheet extends StatefulWidget {
  final String itemName;
  final Widget previewWidget;
  final Color? previewColor;
  final GradientPreset? previewGradient;
  final KeyShape? previewShape;
  final bool allowBackground;
  final bool allowKeys;
  final ValueChanged<ApplySelection>? onApply;

  const PreviewBottomSheet({
    super.key,
    required this.itemName,
    required this.previewWidget,
    this.previewColor,
    this.previewGradient,
    this.previewShape,
    this.allowBackground = true,
    this.allowKeys = true,
    this.onApply,
  });

  /// عرض كـ Bottom Sheet
  static Future<ApplySelection?> show(
    BuildContext context, {
    required String itemName,
    required Widget previewWidget,
    Color? previewColor,
    GradientPreset? previewGradient,
    KeyShape? previewShape,
    bool allowBackground = true,
    bool allowKeys = true,
  }) {
    return showModalBottomSheet<ApplySelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (_) => PreviewBottomSheet(
        itemName: itemName,
        previewWidget: previewWidget,
        previewColor: previewColor,
        previewGradient: previewGradient,
        previewShape: previewShape,
        allowBackground: allowBackground,
        allowKeys: allowKeys,
      ),
    );
  }

  @override
  State<PreviewBottomSheet> createState() => _PreviewBottomSheetState();
}

class _PreviewBottomSheetState extends State<PreviewBottomSheet> {
  ApplyTarget? _selectedTarget;
  bool _targetsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      snap: true,
      snapSizes: const [0.4, 0.75, 0.95],
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // مؤشر السحب
              _buildHandle(),
              // الرأس
              _buildHeader(),
              // المحتوى القابل للتمرير
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // المعاينة
                      _buildPreview(context),
                      const SizedBox(height: 16),
                      // النطاقات
                      _buildTargetsSection(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // زر التطبيق
              _buildApplyButton(),
            ],
          ),
        );
      },
    );
  }

  // ═══ Handle ═══

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textDarkHint.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ═══ Header ═══

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // معاينة مصغّرة للعنصر
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.previewColor ?? AppColors.neonCyan,
              gradient: widget.previewGradient?.toFlutterGradient(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: AppColors.glow(
                widget.previewColor ?? AppColors.neonCyan,
                intensity: 0.4,
              ),
            ),
            child: widget.previewWidget,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معاينة وتطبيق',
                  style: TextStyle(
                    color: AppColors.textDarkHint,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ═══ Preview ═══

  Widget _buildPreview(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return GlassCard(
          padding: const EdgeInsets.all(12),
          glowColor: widget.previewColor ?? AppColors.neonCyan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.visibility,
                    color: AppColors.neonCyan,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'معاينة حية',
                    style: TextStyle(
                      color: AppColors.textDarkHint,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedTarget != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.neonPurple.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        _selectedTarget!.labelAr,
                        style: const TextStyle(
                          color: AppColors.neonPurple,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // KeyboardPreview مع تطبيق مؤقت
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: KeyboardPreview(
                    project: _buildPreviewProject(provider),
                    scale: 0.65,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ThemeProject _buildPreviewProject(ThemeProvider provider) {
    var result = provider.project;

    if (_selectedTarget == null) return result;

    final selection = ApplySelection(target: _selectedTarget!);

    if (widget.previewGradient != null) {
      result = ApplyService.applyGradient(
        project: result,
        gradient: widget.previewGradient!,
        selection: selection,
      );
    } else if (widget.previewColor != null) {
      result = ApplyService.applyColor(
        project: result,
        color: widget.previewColor!,
        selection: selection,
      );
    } else if (widget.previewShape != null) {
      result = ApplyService.applyShape(
        project: result,
        shape: widget.previewShape!,
        selection: selection,
      );
    }

    return result;
  }

  // ═══ Targets ═══

  Widget _buildTargetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.tune,
              color: AppColors.neonPurple,
              size: 16,
            ),
            const SizedBox(width: 6),
            const Text(
              'اختر النطاق',
              style: TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (_selectedTarget != null)
              TextButton(
                onPressed: () => setState(() => _selectedTarget = null),
                child: const Text('تغيير'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedTarget == null)
          _buildQuickTargets()
        else
          _buildSelectedTargetSummary(),
      ],
    );
  }

  Widget _buildQuickTargets() {
    final quickTargets = <ApplyTarget>[
      ApplyTarget.allKeys,
      ApplyTarget.lettersRow,
      ApplyTarget.functionalKeys,
      ApplyTarget.keyboardBackground,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...quickTargets.map((t) => _quickTargetChip(t)),
        // زر "المزيد"
        GestureDetector(
          onTap: () => _showFullTargetSheet(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.neonCyan.withOpacity(0.4),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.more_horiz,
                  color: AppColors.neonCyan,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'المزيد',
                  style: TextStyle(
                    color: AppColors.neonCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickTargetChip(ApplyTarget target) {
    final isSelected = _selectedTarget == target;
    final cat = target.category;

    return GestureDetector(
      onTap: () => setState(() => _selectedTarget = target),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? cat.color.withOpacity(0.2)
              : AppColors.darkContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? cat.color
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.glow(cat.color, intensity: 0.3)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              target.icon,
              size: 14,
              color: isSelected ? cat.color : AppColors.textDarkHint,
            ),
            const SizedBox(width: 6),
            Text(
              target.labelAr,
              style: TextStyle(
                color: isSelected ? cat.color : AppColors.textDarkPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTargetSummary() {
    final target = _selectedTarget!;
    final cat = target.category;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cat.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cat.color.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cat.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(target.icon, color: cat.color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target.labelAr,
                  style: TextStyle(
                    color: cat.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'selector: ${target.selector}',
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
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => _showFullTargetSheet(),
            tooltip: 'تعديل',
          ),
        ],
      ),
    );
  }

  Future<void> _showFullTargetSheet() async {
    final selection = await ApplyTargetSheet.show(
      context,
      itemName: widget.itemName,
      previewColor: widget.previewColor,
      allowBackground: widget.allowBackground,
      allowKeys: widget.allowKeys,
    );

    if (selection != null) {
      setState(() => _selectedTarget = selection.target);
    }
  }

  // ═══ Apply Button ═══

  Widget _buildApplyButton() {
    final canApply = _selectedTarget != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: NeonButton(
                label: canApply ? 'تطبيق' : 'اختر النطاق أولاً',
                icon: Icons.check,
                onPressed: canApply
                    ? () {
                        Navigator.pop(
                          context,
                          ApplySelection(target: _selectedTarget!),
                        );
                      }
                    : null,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
