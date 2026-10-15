import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/apply_target.dart';
import '../providers/theme_provider.dart';
import 'glass_card.dart';
import 'neon_button.dart';

/// ورقة اختيار نطاق التطبيق
class ApplyTargetSheet extends StatefulWidget {
  final bool allowBackground;
  final bool allowKeys;
  final String itemName;
  final Color? previewColor;

  const ApplyTargetSheet({
    super.key,
    this.allowBackground = true,
    this.allowKeys = true,
    required this.itemName,
    this.previewColor,
  });

  static Future<ApplySelection?> show(
    BuildContext context, {
    required String itemName,
    bool allowBackground = true,
    bool allowKeys = true,
    Color? previewColor,
  }) {
    return showModalBottomSheet<ApplySelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplyTargetSheet(
        itemName: itemName,
        allowBackground: allowBackground,
        allowKeys: allowKeys,
        previewColor: previewColor,
      ),
    );
  }

  @override
  State<ApplyTargetSheet> createState() => _ApplyTargetSheetState();
}

class _ApplyTargetSheetState extends State<ApplyTargetSheet> {
  ApplyTarget? _selected;
  ApplyTargetCategory? _activeCategory;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildCategoryTabs(),
              Expanded(
                child: _buildTargets(scrollController),
              ),
              if (_selected != null) _buildApplyButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textDarkHint,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.previewColor ?? AppColors.neonCyan,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppColors.glow(
                widget.previewColor ?? AppColors.neonCyan,
                intensity: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر أين تطبق',
                  style: TextStyle(
                    color: AppColors.textDarkPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    color: AppColors.textDarkHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = <ApplyTargetCategory>[];
    if (widget.allowKeys) {
      categories.add(ApplyTargetCategory.groups);
      categories.add(ApplyTargetCategory.singleKeys);
    }
    if (widget.allowBackground) {
      categories.add(ApplyTargetCategory.backgrounds);
    }
    categories.add(ApplyTargetCategory.custom);

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: categories.map((cat) {
          final isActive = _activeCategory == cat ||
              (_activeCategory == null && categories.first == cat);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeCategory = cat),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? cat.color.withOpacity(0.2)
                      : AppColors.darkContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? cat.color
                        : Colors.white.withOpacity(0.08),
                    width: isActive ? 1.5 : 1,
                  ),
                  boxShadow: isActive
                      ? AppColors.glow(cat.color, intensity: 0.3)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      size: 14,
                      color: isActive ? cat.color : AppColors.textDarkHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.labelAr,
                      style: TextStyle(
                        color: isActive
                            ? cat.color
                            : AppColors.textDarkSecondary,
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTargets(ScrollController controller) {
    final category = _activeCategory ??
        (widget.allowKeys
            ? ApplyTargetCategory.groups
            : ApplyTargetCategory.backgrounds);

    final targets = ApplyTarget.values
        .where((t) => t.category == category)
        .where((t) {
          if (!widget.allowKeys && t.affectsKeyboard) return false;
          if (!widget.allowBackground && t.affectsBackground) return false;
          return true;
        })
        .toList();

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(12),
      itemCount: targets.length,
      itemBuilder: (_, i) => _targetTile(targets[i]),
    );
  }

  Widget _targetTile(ApplyTarget target) {
    final isSelected = _selected == target;
    final cat = target.category;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        onTap: () => setState(() => _selected = target),
        glowColor: isSelected ? cat.color : null,
        borderRadius: 12,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cat.color.withOpacity(isSelected ? 0.25 : 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: cat.color.withOpacity(isSelected ? 0.8 : 0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Icon(target.icon, color: cat.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.labelAr,
                    style: TextStyle(
                      color: isSelected
                          ? cat.color
                          : AppColors.textDarkPrimary,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
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
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cat.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.darkBg,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: NeonButton(
          label: 'تطبيق على ${_selected!.labelAr}',
          icon: Icons.check,
          onPressed: () {
            Navigator.pop(
              context,
              ApplySelection(target: _selected!),
            );
          },
          fullWidth: true,
        ),
      ),
    );
  }
}
