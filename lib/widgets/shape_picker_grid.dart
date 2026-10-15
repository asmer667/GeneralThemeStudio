import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/key_shape.dart';
import '../models/shape_category.dart';
import 'shape_widget.dart';

/// شبكة اختيار الأشكال (500+ شكل)
class ShapePickerGrid extends StatelessWidget {
  final KeyShape selected;
  final ValueChanged<KeyShape> onSelected;
  final ShapeCategory? filterCategory;
  final Color previewColor;
  final Color previewBorderColor;
  final int crossAxisCount;

  const ShapePickerGrid({
    super.key,
    required this.selected,
    required this.onSelected,
    this.filterCategory,
    this.previewColor = AppColors.primary,
    this.previewBorderColor = Colors.transparent,
    this.crossAxisCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    final shapes = filterCategory == null
        ? KeyShape.values
        : KeyShape.values.where((s) => s.category == filterCategory).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: shapes.length,
      itemBuilder: (_, i) {
        final shape = shapes[i];
        return _ShapeTile(
          shape: shape,
          isSelected: shape == selected,
          onTap: () => onSelected(shape),
          previewColor: previewColor,
          previewBorderColor: previewBorderColor,
        );
      },
    );
  }
}

class _ShapeTile extends StatefulWidget {
  final KeyShape shape;
  final bool isSelected;
  final VoidCallback onTap;
  final Color previewColor;
  final Color previewBorderColor;

  const _ShapeTile({
    required this.shape,
    required this.isSelected,
    required this.onTap,
    required this.previewColor,
    required this.previewBorderColor,
  });

  @override
  State<_ShapeTile> createState() => _ShapeTileState();
}

class _ShapeTileState extends State<_ShapeTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedScale(
        scale: _controller.isAnimating ? 0.9 : 1.0,
        duration: AppAnimations.fast,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.darkContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : Colors.white.withOpacity(0.08),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.biggest.shortestSide * 0.75;
                      return Center(
                        child: ShapeWidget(
                          shape: widget.shape,
                          color: widget.previewColor,
                          borderColor: widget.previewBorderColor,
                          borderWidth: 1.5,
                          roundedness: 0.5,
                          width: size,
                          height: size,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.shape.label,
                  style: TextStyle(
                    fontSize: 9,
                    color: widget.isSelected
                        ? AppColors.primary
                        : AppColors.textDarkSecondary,
                    fontWeight:
                        widget.isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مرشّح فئات الأشكال (chips أفقي)
class ShapeCategoryFilter extends StatelessWidget {
  final ShapeCategory? selected;
  final ValueChanged<ShapeCategory?> onSelected;

  const ShapeCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _CategoryChip(
              label: 'الكل',
              icon: Icons.apps,
              color: AppColors.neonCyan,
              isSelected: selected == null,
              onTap: () => onSelected(null),
            ),
          ),
          ...ShapeCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _CategoryChip(
                label: cat.labelAr,
                icon: cat.icon,
                color: cat.color,
                isSelected: selected == cat,
                onTap: () => onSelected(cat),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2)
              : AppColors.darkContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? color : AppColors.textDarkSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.textDarkPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
