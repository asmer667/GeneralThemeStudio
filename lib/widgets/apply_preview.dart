import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/apply_target.dart';
import '../models/border_asset.dart';
import '../models/gradient_preset.dart';
import '../models/key_shape.dart';
import '../models/theme_project.dart';
import 'keyboard_preview.dart';

/// معاينة حية قبل التطبيق
class ApplyPreview extends StatelessWidget {
  final ThemeProject project;
  final Color? previewColor;
  final GradientPreset? previewGradient;
  final KeyShape? previewShape;
  final ApplyTarget target;
  final double scale;

  const ApplyPreview({
    super.key,
    required this.project,
    this.previewColor,
    this.previewGradient,
    this.previewShape,
    required this.target,
    this.scale = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    final previewProject = _buildPreviewProject();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.neonCyan.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.neonCyan.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility, size: 14, color: AppColors.neonCyan),
              const SizedBox(width: 6),
              Text(
                'معاينة: ${target.labelAr}',
                style: const TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: SingleChildScrollView(
            child: KeyboardPreview(
              project: previewProject,
              scale: scale,
            ),
          ),
        ),
      ],
    );
  }

  ThemeProject _buildPreviewProject() {
    var result = project;

    if (previewColor != null) {
      result = _previewApplyColor(result, previewColor!);
    }

    if (previewGradient != null) {
      result = _previewApplyGradient(result, previewGradient!);
    }

    if (previewShape != null) {
      result = _previewApplyShape(result, previewShape!);
    }

    return result;
  }

  ThemeProject _previewApplyColor(ThemeProject project, Color color) {
    switch (target) {
      case ApplyTarget.keyboardBackground:
      case ApplyTarget.keyBackground:
      case ApplyTarget.screenBackground:
        return project.copyWith(
          keyboardSurface: color,
          keyboardContainer: color,
        );
      case ApplyTarget.allKeys:
        final updated = project.groups.map((g) {
          final border = g.border ?? _defaultBorder(g.selector, g.shape);
          return g.copyWith(border: border.copyWith(backgroundTint: color));
        }).toList();
        return project.copyWith(groups: updated);
      default:
        final selector = ApplySelection(target: target).effectiveSelector;
        final updated = project.groups.map((g) {
          if (g.selector == selector) {
            final border = g.border ?? _defaultBorder(g.selector, g.shape);
            return g.copyWith(border: border.copyWith(backgroundTint: color));
          }
          return g;
        }).toList();
        return project.copyWith(groups: updated);
    }
  }

  ThemeProject _previewApplyGradient(
    ThemeProject project,
    GradientPreset gradient,
  ) {
    final selector = ApplySelection(target: target).effectiveSelector;
    final updated = project.groups.map((g) {
      if (target == ApplyTarget.allKeys || g.selector == selector) {
        return g.copyWith(gradient: gradient);
      }
      return g;
    }).toList();
    return project.copyWith(groups: updated);
  }

  ThemeProject _previewApplyShape(ThemeProject project, KeyShape shape) {
    final selector = ApplySelection(target: target).effectiveSelector;
    final updated = project.groups.map((g) {
      if (target == ApplyTarget.allKeys || g.selector == selector) {
        return g.copyWith(shape: shape);
      }
      return g;
    }).toList();
    return project.copyWith(groups: updated);
  }

  BorderAsset _defaultBorder(String selector, KeyShape shape) {
    return BorderAsset.createDefault(
      name: 'Button-${selector.replaceAll(" ", "_")}.png',
      shape: shape,
      backgroundTint: project.keyboardContainer,
    );
  }
}
