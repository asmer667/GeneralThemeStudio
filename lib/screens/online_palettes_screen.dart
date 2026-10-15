import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/gradient_preset.dart';
import '../services/palette_api.dart';
import '../widgets/glass_card.dart';
import '../widgets/online_palettes.dart';

/// شاشة تصفح Palettes من الإنترنت
class OnlinePalettesScreen extends StatefulWidget {
  final bool asGradients;
  final ValueChanged<GradientPreset>? onGradientSelected;

  const OnlinePalettesScreen({
    super.key,
    this.asGradients = true,
    this.onGradientSelected,
  });

  @override
  State<OnlinePalettesScreen> createState() => _OnlinePalettesScreenState();
}

class _OnlinePalettesScreenState extends State<OnlinePalettesScreen> {
  PaletteSource _source = PaletteSource.uigradients;

  void _handleSelection(OnlinePalette palette) {
    if (widget.onGradientSelected != null) {
      final grad = GradientPreset.create(
        name: palette.name,
        colors: palette.colors,
        angle: 135,
      );
      widget.onGradientSelected!(grad);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم اختيار: ${palette.name}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          widget.asGradients ? 'تدرجات من الإنترنت' : 'ألوان من الإنترنت',
        ),
      ),
      body: Column(
        children: [
          _buildSources(),
          Expanded(
            child: OnlinePalettesGrid(
              source: _source,
              onSelected: _handleSelection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSources() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المصدر',
            style: TextStyle(
              color: AppColors.textDarkSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: PaletteSource.values.map((s) {
                final isSelected = _source == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _source = s),
                    child: AnimatedContainer(
                      duration: AppAnimations.fast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? s.color.withValues(alpha: 0.15)
                            : AppColors.darkContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? s.color
                              : Colors.white.withValues(alpha: 0.08),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? AppColors.glow(s.color, intensity: 0.3)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            s.icon,
                            size: 16,
                            color: isSelected
                                ? s.color
                                : AppColors.textDarkHint,
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? s.color
                                      : AppColors.textDarkPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                s.description,
                                style: const TextStyle(
                                  color: AppColors.textDarkHint,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
