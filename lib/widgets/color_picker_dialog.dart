import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../utils/color_utils.dart';

/// منتقي ألوان احترافي
class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String? title;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    this.title,
  });

  static Future<Color?> show(
    BuildContext context, {
    required Color initialColor,
    String? title,
  }) {
    return showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: initialColor,
        title: title,
      ),
    );
  }

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late double _r;
  late double _g;
  late double _b;
  late double _a;
  late TextEditingController _hexController;
  String? _hexError;

  @override
  void initState() {
    super.initState();
    _r = widget.initialColor.red.toDouble();
    _g = widget.initialColor.green.toDouble();
    _b = widget.initialColor.blue.toDouble();
    _a = widget.initialColor.alpha.toDouble();
    _hexController =
        TextEditingController(text: ColorUtils.toHex(_currentColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  Color get _currentColor => Color.fromARGB(
        _a.round(),
        _r.round(),
        _g.round(),
        _b.round(),
      );

  void _updateFromHex(String hex) {
    final parsed = ColorUtils.fromHex(hex);
    setState(() {
      _r = parsed.red.toDouble();
      _g = parsed.green.toDouble();
      _b = parsed.blue.toDouble();
      _a = parsed.alpha.toDouble();
      _hexError = null;
    });
  }

  void _applyPreset(Color color) {
    setState(() {
      _r = color.red.toDouble();
      _g = color.green.toDouble();
      _b = color.blue.toDouble();
      _a = color.alpha.toDouble();
      _hexController.text = ColorUtils.toHex(color);
      _hexError = null;
    });
  }

  void _syncHexField() {
    _hexController.text = ColorUtils.toHex(_currentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildPreview(),
                const SizedBox(height: 16),
                _buildPresets(),
                const SizedBox(height: 20),
                _buildSliders(),
                const SizedBox(height: 16),
                _buildHexInput(),
                const SizedBox(height: 20),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedContainer(
          duration: AppAnimations.fast,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _currentColor.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.title ?? 'اختر لوناً',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDarkPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textDarkSecondary),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return AnimatedContainer(
      duration: AppAnimations.fast,
      height: 80,
      decoration: BoxDecoration(
        color: _currentColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _currentColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          ColorUtils.toArabicName(_currentColor),
          style: TextStyle(
            color: ColorUtils.getContrastingColor(_currentColor),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPresets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ألوان جاهزة',
          style: TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: AppColors.colorPresets.length,
          itemBuilder: (_, i) {
            final c = AppColors.colorPresets[i];
            final isSelected = _currentColor.value == c.value;
            return GestureDetector(
              onTap: () => _applyPreset(c),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: c.withOpacity(0.6),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSliders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RGB',
          style: TextStyle(
            color: AppColors.textDarkPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _slider('R', _r, AppColors.neonRed, (v) {
          setState(() => _r = v);
          _syncHexField();
        }),
        _slider('G', _g, AppColors.neonGreen, (v) {
          setState(() => _g = v);
          _syncHexField();
        }),
        _slider('B', _b, AppColors.neonBlue, (v) {
          setState(() => _b = v);
          _syncHexField();
        }),
        _slider('A', _a, AppColors.primary, (v) {
          setState(() => _a = v);
          _syncHexField();
        }),
      ],
    );
  }

  Widget _buildHexInput() {
    return TextField(
      controller: _hexController,
      style: const TextStyle(
        fontFamily: 'monospace',
        color: AppColors.textDarkPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: '#RRGGBBAA',
        errorText: _hexError,
        prefixIcon: const Icon(Icons.tag, size: 18),
        suffixIcon: IconButton(
          icon: const Icon(Icons.check, size: 18),
          onPressed: () {
            _updateFromHex(_hexController.text);
          },
        ),
      ),
      onSubmitted: _updateFromHex,
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, _currentColor),
            child: const Text('اختيار'),
          ),
        ),
      ],
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
          width: 24,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              thumbColor: color,
              overlayColor: color.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              divisions: 255,
              onChanged: onChange,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.round().toString(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.textDarkPrimary,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

/// زر عرض لون صغير قابل للنقر
class ColorSwatchButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final String? label;
  final double size;

  const ColorSwatchButton({
    super.key,
    required this.color,
    required this.onTap,
    this.label,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 6),
          Text(
            label!,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textDarkSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
