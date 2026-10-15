import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/gradient_preset.dart';

/// بطاقة معاينة تدرج واحد
class GradientPreviewCard extends StatelessWidget {
  final GradientPreset gradient;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final double height;

  const GradientPreviewCard({
    super.key,
    required this.gradient,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        decoration: BoxDecoration(
          gradient: gradient.toFlutterGradient(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.neonCyan
                : Colors.white.withOpacity(0.15),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.glow(AppColors.neonCyan, intensity: 0.5)
              : null,
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.glow(
                      AppColors.neonCyan,
                      intensity: 0.6,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: AppColors.darkBg,
                  ),
                ),
              ),
            if (onDelete != null)
              Positioned(
                top: 6,
                left: 6,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(13),
                  ),
                ),
                child: Text(
                  gradient.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// خلفية مع تدرج (تستخدم كخلفية للـ widget)
class GradientBackground extends StatelessWidget {
  final GradientPreset? gradient;
  final Color? fallbackColor;
  final Widget child;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const GradientBackground({
    super.key,
    this.gradient,
    this.fallbackColor,
    required this.child,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient?.toFlutterGradient(),
        color: gradient == null ? (fallbackColor ?? Colors.transparent) : null,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// شريط صغير للتدرج (للعرض في القوائم)
class GradientMiniBar extends StatelessWidget {
  final GradientPreset gradient;
  final double width;
  final double height;

  const GradientMiniBar({
    super.key,
    required this.gradient,
    this.width = 60,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient.toFlutterGradient(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

/// عجلة تدرجات (اختيار سريع)
class GradientWheel extends StatelessWidget {
  final List<GradientPreset> gradients;
  final GradientPreset? selected;
  final ValueChanged<GradientPreset> onSelected;
  final double itemSize;

  const GradientWheel({
    super.key,
    required this.gradients,
    this.selected,
    required this.onSelected,
    this.itemSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemSize + 8,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: gradients.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final g = gradients[i];
          final isSelected = selected?.id == g.id;
          return GestureDetector(
            onTap: () => onSelected(g),
            child: Container(
              width: itemSize,
              height: itemSize,
              decoration: BoxDecoration(
                gradient: g.toFlutterGradient(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.neonCyan
                      : Colors.white.withOpacity(0.2),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? AppColors.glow(AppColors.neonCyan, intensity: 0.5)
                    : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
