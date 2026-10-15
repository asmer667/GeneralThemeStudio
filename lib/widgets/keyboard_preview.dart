import 'dart:io';

import 'package:flutter/material.dart';

import '../models/background_asset.dart';
import '../models/key_group.dart';
import '../models/key_shape.dart';
import '../models/theme_project.dart';
import 'key_widget.dart';

/// معاينة كاملة للوحة مفاتيح عربية مع تطبيق الثيم
class KeyboardPreview extends StatelessWidget {
  final ThemeProject project;
  final double scale;
  final bool showBorder;
  final EdgeInsets padding;
  final String layout;

  const KeyboardPreview({
    super.key,
    required this.project,
    this.scale = 1.0,
    this.showBorder = true,
    this.padding = const EdgeInsets.all(12),
    this.layout = 'arabic',
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Container(
      padding: padding,
      decoration: showBorder
          ? BoxDecoration(
              color: project.keyboardSurface,
              borderRadius: radius,
              border: Border.all(
                color: project.outline.withOpacity(0.4),
                width: 1,
              ),
            )
          : null,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            Positioned.fill(child: _buildBackgroundLayer()),
            Container(
              color: _hasImageBackground ? project.keyboardSurface.withOpacity(0.28) : Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRow1(),
                  SizedBox(height: 6 * scale),
                  _buildRow2(),
                  SizedBox(height: 6 * scale),
                  _buildRow3(),
                  SizedBox(height: 6 * scale),
                  _buildRow4(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasImageBackground {
    final bg = project.backgroundAsset;
    return bg != null &&
        (bg.type == BackgroundType.image || bg.type == BackgroundType.builtin) &&
        bg.imagePath != null;
  }

  Widget _buildBackgroundLayer() {
    final bg = project.backgroundAsset;
    if (bg == null) return Container(color: project.keyboardSurface);
    if (bg.type == BackgroundType.color) return Container(color: bg.solidColor ?? project.keyboardSurface);
    if (bg.type == BackgroundType.gradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bg.gradientColors ?? [project.keyboardSurface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }
    if (bg.type == BackgroundType.image || bg.type == BackgroundType.builtin) {
      final path = bg.imagePath;
      if (path == null) return Container(color: project.keyboardSurface);
      final Widget image = bg.type == BackgroundType.builtin && path.startsWith('assets/')
          ? Image.asset(path, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: project.keyboardSurface))
          : Image.file(File(path), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: project.keyboardSurface));
      return Opacity(opacity: bg.opacity.clamp(0.0, 1.0).toDouble(), child: image);
    }
    return Container(color: project.keyboardSurface);
  }

  Widget _buildRow1() {
    final letters = ['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح', 'ج'];
    return _row(letters.map((l) => _letter(l, groupSelector: 'normal row 0')).toList());
  }

  Widget _buildRow2() {
    final letters = ['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك', 'ط'];
    return _row(letters.map((l) => _letter(l)).toList());
  }

  Widget _buildRow3() {
    final letters = ['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ', 'د'];
    final keys = <KeyData>[
      _iconKey(Icons.keyboard_arrow_up, 'icon shift_key'),
      ...letters.map((l) => _letter(l)),
      _iconKey(Icons.backspace_outlined, 'icon delete_key'),
    ];
    return _row(keys);
  }

  Widget _buildRow4() {
    return _row([
      _letter('?123', groupSelector: 'functional row -1 col 0', wide: 1.4),
      _letter('،', groupSelector: 'functional row -1 col 1'),
      _iconKey(Icons.emoji_emotions_outlined, 'icon action_emoji'),
      _letter('مسافة', groupSelector: 'spacebar', wide: 4.5),
      _letter('.', groupSelector: 'functional row -1 col -1'),
      _iconKey(Icons.keyboard_return, 'icon enter_key'),
    ]);
  }

  KeyData _letter(
    String label, {
    String groupSelector = 'normal',
    double wide = 1.0,
  }) {
    final group = _findGroup(groupSelector);
    final bg = group?.border?.backgroundTint ?? project.keyboardContainer;
    final fg = group?.border?.foregroundTint ?? project.onKeyboardContainer;
    final border = group?.border?.borderColor ?? project.outline;
    final shape = group?.shape ?? KeyShape.roundedRectangle;
    final bw = group?.border?.borderWidth ?? 1.2;

    return KeyData.letter(
      label: label,
      bg: bg,
      fg: fg,
      shape: shape,
      roundedness: project.roundedness,
      width: 44 * wide * scale,
      height: 48 * scale,
      fontSize: 15 * scale,
      borderColor: border,
      borderWidth: bw,
      backgroundImagePath: group?.border?.customImagePath,
    );
  }

  KeyData _iconKey(IconData icon, String groupSelector) {
    final group = _findGroup(groupSelector);
    final bg = group?.border?.backgroundTint ?? project.keyboardContainer;
    final fg = group?.border?.foregroundTint ?? project.onKeyboardContainer;
    final border = group?.border?.borderColor ?? project.outline;
    final shape = group?.shape ?? KeyShape.roundedRectangle;
    final bw = group?.border?.borderWidth ?? 1.2;

    return KeyData.iconKey(
      icon: icon,
      bg: bg,
      fg: fg,
      shape: shape,
      roundedness: project.roundedness,
      width: 44 * scale,
      height: 48 * scale,
      borderColor: border,
      borderWidth: bw,
      backgroundImagePath: group?.border?.customImagePath,
    );
  }

  KeyGroup? _findGroup(String selector) {
    try {
      return project.groups.firstWhere((g) => g.selector == selector);
    } catch (_) {
      return null;
    }
  }

  Widget _row(List<KeyData> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          KeyWidget(
            label: keys[i].label,
            icon: keys[i].icon,
            shape: keys[i].shape,
            backgroundColor: keys[i].backgroundColor,
            foregroundColor: keys[i].foregroundColor,
            borderColor: keys[i].borderColor,
            borderWidth: keys[i].borderWidth,
            roundedness: keys[i].roundedness,
            width: keys[i].width,
            height: keys[i].height,
            fontSize: keys[i].fontSize,
            fontFamily: project.fontName,
            backgroundImagePath: keys[i].backgroundImagePath,
          ),
          if (i < keys.length - 1) SizedBox(width: 3 * scale),
        ],
      ],
    );
  }
}
