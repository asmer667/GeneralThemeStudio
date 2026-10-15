import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../data/gradients_catalog.dart';
import '../models/gradient_preset.dart';
import 'glass_card.dart';
import 'neon_button.dart';

/// منتقي التدرجات — عرض 60+ تدرج
class GradientPicker extends StatefulWidget {
  final GradientPreset? selected;
  final ValueChanged<GradientPreset?> onSelected;
  final bool allowCustom;

  const GradientPicker({
    super.key,
    this.selected,
    required this.onSelected,
    this.allowCustom = true,
  });

  @override
  State<GradientPicker> createState() => _GradientPickerState();
}

class _GradientPickerState extends State<GradientPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final gradients = GradientsCatalog.search(_search);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'ابحث في التدرجات...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.allowCustom)
                NeonIconButton(
                  icon: Icons.tune,
                  color: AppColors.neonPurple,
                  onPressed: _showCustomDialog,
                  tooltip: 'مخصص',
                ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            itemCount: gradients.length,
            itemBuilder: (_, i) => _gradientTile(gradients[i]),
          ),
        ),
      ],
    );
  }

  Widget _gradientTile(GradientPreset grad) {
    final isSelected = widget.selected?.id == grad.id;
    return GestureDetector(
      onTap: () => widget.onSelected(grad),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        decoration: BoxDecoration(
          gradient: grad.toFlutterGradient(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.neonCyan
                : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? AppColors.glow(AppColors.neonCyan, intensity: 0.6)
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
                    size: 14,
                    color: AppColors.darkBg,
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
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(13),
                  ),
                ),
                child: Text(
                  grad.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black),
                    ],
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

  void _showCustomDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CustomGradientDialog(
        initial: widget.selected,
        onApply: (grad) {
          widget.onSelected(grad);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// حوار تدرج مخصص
class _CustomGradientDialog extends StatefulWidget {
  final GradientPreset? initial;
  final ValueChanged<GradientPreset> onApply;

  const _CustomGradientDialog({
    this.initial,
    required this.onApply,
  });

  @override
  State<_CustomGradientDialog> createState() =>
      _CustomGradientDialogState();
}

class _CustomGradientDialogState extends State<_CustomGradientDialog> {
  late List<Color> _colors;
  late double _angle;
  GradientType _type = GradientType.linear;

  @override
  void initState() {
    super.initState();
    _colors = widget.initial?.colors ?? [
      const Color(0xFF16D9F2),
      const Color(0xFF8B5CF6),
    ];
    _angle = widget.initial?.angle ?? 45;
    _type = widget.initial?.type ?? GradientType.linear;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'تدرج مخصص',
              style: TextStyle(
                color: AppColors.textDarkPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Preview
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: GradientPreset.create(
                  name: 'preview',
                  colors: _colors,
                  type: _type,
                  angle: _angle,
                ).toFlutterGradient(),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: AppColors.glow(AppColors.neonCyan, intensity: 0.4),
              ),
            ),
            const SizedBox(height: 16),
            // Type selector
            const Text(
              'النوع',
              style: TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: GradientType.values.map((t) {
                final isSelected = _type == t;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => setState(() => _type = t),
                      child: AnimatedContainer(
                        duration: AppAnimations.fast,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.neonCyan.withValues(alpha: 0.2)
                              : AppColors.darkContainer,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.neonCyan
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          _typeLabel(t),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.neonCyan
                                : AppColors.textDarkHint,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Colors
            const Text(
              'الألوان',
              style: TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...List.generate(_colors.length, (i) {
                  return _colorSwatch(i);
                }),
                if (_colors.length < 5) _addColorButton(),
              ],
            ),
            const SizedBox(height: 16),
            // Angle
            if (_type == GradientType.linear) ...[
              Row(
                children: [
                  const Text(
                    'الاتجاه',
                    style: TextStyle(
                      color: AppColors.textDarkSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_angle.round()}°',
                    style: const TextStyle(
                      color: AppColors.neonCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _angle,
                min: 0,
                max: 360,
                divisions: 36,
                label: '${_angle.round()}°',
                onChanged: (v) => setState(() => _angle = v),
              ),
            ],
            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    label: 'تطبيق',
                    icon: Icons.check,
                    onPressed: () {
                      widget.onApply(GradientPreset.create(
                        name: 'مخصص',
                        colors: _colors,
                        type: _type,
                        angle: _angle,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorSwatch(int index) {
    final color = _colors[index];
    return GestureDetector(
      onTap: () => _pickColor(index),
      onLongPress: _colors.length > 2
          ? () => setState(() => _colors.removeAt(index))
          : null,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: AppColors.glow(color, intensity: 0.3),
        ),
        child: const Icon(
          Icons.colorize,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _addColorButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _colors.add(const Color(0xFF10E5A0));
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.darkContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.textDarkHint,
          size: 24,
        ),
      ),
    );
  }

  Future<void> _pickColor(int index) async {
    final current = _colors[index];
    final picked = await _showColorPicker(current);
    if (picked != null) {
      setState(() => _colors[index] = picked);
    }
  }

  Future<Color?> _showColorPicker(Color initial) async {
    double r = initial.r * 255;
    double g = initial.g * 255;
    double b = initial.b * 255;

    return showDialog<Color>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final color = Color.fromRGBO(r.round(), g.round(), b.round(), 1);
          return AlertDialog(
            title: const Text('اختر لوناً'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                _slider('R', r, Colors.red, (v) {
                  setState(() => r = v);
                }),
                _slider('G', g, Colors.green, (v) {
                  setState(() => g = v);
                }),
                _slider('B', b, Colors.blue, (v) {
                  setState(() => b = v);
                }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, color),
                child: const Text('موافق'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    Color color,
    ValueChanged<double> onChange,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              thumbColor: color,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              onChanged: onChange,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.round().toString(),
            style: const TextStyle(
              color: AppColors.textDarkPrimary,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  String _typeLabel(GradientType t) {
    switch (t) {
      case GradientType.linear:
        return 'خطي';
      case GradientType.radial:
        return 'دائري';
      case GradientType.sweep:
        return 'دوّار';
    }
  }
}
