import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';
import '../models/key_config.dart';
import '../widgets/glass_card.dart';

/// محرر حجم وأبعاد الزر
class KeySizeEditor extends StatefulWidget {
  final KeyConfig config;
  final ValueChanged<KeyConfig> onChanged;
  final String title;

  const KeySizeEditor({
    super.key,
    required this.config,
    required this.onChanged,
    this.title = 'أبعاد الزر',
  });

  @override
  State<KeySizeEditor> createState() => _KeySizeEditorState();
}

class _KeySizeEditorState extends State<KeySizeEditor> {
  late KeyConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(KeySizeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.id != widget.config.id) {
      _config = widget.config;
    }
  }

  void _update(KeyConfig newConfig) {
    setState(() => _config = newConfig);
    widget.onChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      glowColor: AppColors.neonCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.neonCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.neonCyan.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.aspect_ratio,
                  color: AppColors.neonCyan,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  color: AppColors.textDarkPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ═══ الأبعاد ═══
          _slider(
            label: 'العرض',
            value: _config.width,
            min: 24,
            max: 200,
            unit: 'px',
            onChanged: (v) => _update(_config.copyWith(width: v)),
          ),
          _slider(
            label: 'الارتفاع',
            value: _config.height,
            min: 24,
            max: 120,
            unit: 'px',
            onChanged: (v) => _update(_config.copyWith(height: v)),
          ),
          _slider(
            label: 'حجم الخط',
            value: _config.fontSize,
            min: 8,
            max: 32,
            unit: 'px',
            onChanged: (v) => _update(_config.copyWith(fontSize: v)),
          ),

          const SizedBox(height: 12),

          // ═══ الحدود والزوايا ═══
          _slider(
            label: 'استدارة الزوايا',
            value: _config.borderRadius,
            min: 0,
            max: 40,
            unit: 'px',
            color: AppColors.neonPurple,
            onChanged: (v) => _update(_config.copyWith(borderRadius: v)),
          ),
          _slider(
            label: 'سماكة الحدود',
            value: _config.borderWidth,
            min: 0,
            max: 5,
            unit: 'px',
            color: AppColors.neonPurple,
            onChanged: (v) => _update(_config.copyWith(borderWidth: v)),
          ),

          const SizedBox(height: 12),

          // ═══ الحشو والهوامش ═══
          _paddingEditor(),
          _gapEditor(),

          const SizedBox(height: 12),

          // ═══ الشفافية والتأثير ═══
          _slider(
            label: 'الشفافية',
            value: _config.opacity,
            min: 0.1,
            max: 1.0,
            unit: '%',
            isPercent: true,
            color: AppColors.neonPink,
            onChanged: (v) => _update(_config.copyWith(opacity: v)),
          ),
          _slider(
            label: 'الضبابية (Blur)',
            value: _config.blur,
            min: 0,
            max: 20,
            unit: '',
            color: AppColors.neonPink,
            onChanged: (v) => _update(_config.copyWith(blur: v)),
          ),
        ],
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
    Color color = AppColors.neonCyan,
    bool isPercent = false,
  }) {
    final displayValue = isPercent
        ? '${(value * 100).round()}%'
        : '${value.toStringAsFixed(1)}$unit';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                overlayColor: color.withValues(alpha: 0.2),
                trackHeight: 3,
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              displayValue,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paddingEditor() {
    return _cornerEditor(
      title: 'الحشو الداخلي',
      icon: Icons.padding,
      color: AppColors.neonGreen,
      top: _config.paddingTop,
      right: _config.paddingRight,
      bottom: _config.paddingBottom,
      left: _config.paddingLeft,
      onChanged: (t, r, b, l) => _update(_config.copyWith(
        paddingTop: t,
        paddingRight: r,
        paddingBottom: b,
        paddingLeft: l,
      )),
    );
  }

  Widget _gapEditor() {
    return _cornerEditor(
      title: 'الهوامش (بين الأزرار)',
      icon: Icons.space_bar,
      color: AppColors.neonOrange,
      top: _config.gapTop,
      right: _config.gapRight,
      bottom: _config.gapBottom,
      left: _config.gapLeft,
      onChanged: (t, r, b, l) => _update(_config.copyWith(
        gapTop: t,
        gapRight: r,
        gapBottom: b,
        gapLeft: l,
      )),
    );
  }

  Widget _cornerEditor({
    required String title,
    required IconData icon,
    required Color color,
    required double top,
    required double right,
    required double bottom,
    required double left,
    required void Function(double, double, double, double) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDarkSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _cornerInput('T', top, color, (v) => onChanged(v, right, bottom, left)),
              const SizedBox(width: 6),
              _cornerInput('R', right, color, (v) => onChanged(top, v, bottom, left)),
              const SizedBox(width: 6),
              _cornerInput('B', bottom, color, (v) => onChanged(top, right, v, left)),
              const SizedBox(width: 6),
              _cornerInput('L', left, color, (v) => onChanged(top, right, bottom, v)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cornerInput(
    String label,
    double value,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextFormField(
                initialValue: value.toStringAsFixed(1),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onFieldSubmitted: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null) onChanged(parsed);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
