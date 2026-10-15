import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';

/// حجم الزر
enum NeonButtonSize { small, medium, large }

/// زر Neon متوهج
class NeonButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final NeonButtonSize size;
  final Color? color;
  final Color? textColor;
  final bool outlined;
  final bool fullWidth;

  const NeonButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.size = NeonButtonSize.medium,
    this.color,
    this.textColor,
    this.outlined = false,
    this.fullWidth = false,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
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
    final c = widget.color ?? AppColors.primary;
    final tc = widget.textColor ?? (widget.outlined ? c : AppColors.darkBg);

    double height;
    double fontSize;
    EdgeInsets padding;
    double radius;

    switch (widget.size) {
      case NeonButtonSize.small:
        height = 36;
        fontSize = 12;
        padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
        radius = 12;
        break;
      case NeonButtonSize.medium:
        height = 48;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
        radius = 16;
        break;
      case NeonButtonSize.large:
        height = 56;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        radius = 18;
        break;
    }

    Widget button = AnimatedScale(
      scale: _controller.isAnimating ? 0.96 : 1.0,
      duration: AppAnimations.fast,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        height: height,
        width: widget.fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: widget.outlined
              ? null
              : LinearGradient(
                  colors: [c, c.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: widget.outlined ? Colors.transparent : null,
          border: widget.outlined
              ? Border.all(color: c.withOpacity(0.6), width: 1.5)
              : null,
          boxShadow: widget.outlined || widget.onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: c.withOpacity(0.35),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: c.withOpacity(0.15),
                    blurRadius: 24,
                    spreadRadius: 3,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            onTapDown: widget.onPressed != null
                ? (_) => _controller.forward()
                : null,
            onTapUp: widget.onPressed != null
                ? (_) => _controller.reverse()
                : null,
            onTapCancel: widget.onPressed != null
                ? () => _controller.reverse()
                : null,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize:
                    widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: fontSize + 2,
                      height: fontSize + 2,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(tc),
                      ),
                    )
                  else if (widget.icon != null)
                    Icon(widget.icon, color: tc, size: fontSize + 4),
                  if (widget.isLoading || widget.icon != null)
                    const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: tc,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return button;
  }
}

/// زر أيقونة دائرية بـ neon
class NeonIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final bool filled;
  final String? tooltip;

  const NeonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 40,
    this.filled = false,
    this.tooltip,
  });

  @override
  State<NeonIconButton> createState() => _NeonIconButtonState();
}

class _NeonIconButtonState extends State<NeonIconButton>
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
    final c = widget.color ?? AppColors.primary;

    Widget button = AnimatedScale(
      scale: _controller.isAnimating ? 0.9 : 1.0,
      duration: AppAnimations.fast,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.filled ? c : c.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: c.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: widget.filled
              ? AppColors.glow(c, intensity: 0.5)
              : AppColors.glow(c, intensity: 0.2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onTapDown: widget.onPressed != null
                ? (_) => _controller.forward()
                : null,
            onTapUp: widget.onPressed != null
                ? (_) => _controller.reverse()
                : null,
            onTapCancel: widget.onPressed != null
                ? () => _controller.reverse()
                : null,
            customBorder: const CircleBorder(),
            child: Icon(
              widget.icon,
              color: widget.filled ? AppColors.darkBg : c,
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

/// شريط أزرار (Segmented control) بأسلوب neon
class NeonSegmented extends StatelessWidget {
  final List<String> labels;
  final List<IconData>? icons;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? color;

  const NeonSegmented({
    super.key,
    required this.labels,
    this.icons,
    required this.selectedIndex,
    required this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                curve: AppAnimations.emphasized,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? c.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: c.withOpacity(0.5))
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: c.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icons != null && icons!.length > i) ...[
                      Icon(
                        icons![i],
                        size: 14,
                        color: isSelected ? c : AppColors.textDarkHint,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      labels[i],
                      style: TextStyle(
                        color: isSelected ? c : AppColors.textDarkHint,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// زر صغير جداً (chip button)
class NeonChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  const NeonChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return AnimatedContainer(
      duration: AppAnimations.fast,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? c.withOpacity(0.2) : AppColors.darkContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? c.withOpacity(0.5) : Colors.white.withOpacity(0.08),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: c.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? c : AppColors.textDarkSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? c : AppColors.textDarkPrimary,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
