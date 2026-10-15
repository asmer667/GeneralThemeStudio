import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';

/// بطاقة زجاجية بـ blur + gradient + border
///
/// الاستخدام:
/// ```dart
/// GlassCard(
///   child: Text('Hello'),
///   glowColor: AppColors.neonCyan,
///   onTap: () {},
/// )
/// ```
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blurAmount;
  final double opacity;
  final Color? glowColor;
  final bool hasBorder;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final bool animated;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.blurAmount = 20,
    this.opacity = 0.08,
    this.glowColor,
    this.hasBorder = true,
    this.onTap,
    this.gradient,
    this.animated = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
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
    return AnimatedScale(
      scale: widget.animated && _controller.isAnimating ? 0.98 : 1.0,
      duration: AppAnimations.fast,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.emphasized,
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: widget.glowColor != null
              ? AppColors.glow(widget.glowColor!, intensity: 0.5)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: widget.animated && widget.onTap != null
                ? (_) => _controller.forward()
                : null,
            onTapUp: widget.animated && widget.onTap != null
                ? (_) => _controller.reverse()
                : null,
            onTapCancel: widget.animated && widget.onTap != null
                ? () => _controller.reverse()
                : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurAmount,
                  sigmaY: widget.blurAmount,
                ),
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    gradient: widget.gradient ??
                        LinearGradient(
                          colors: [
                            Colors.white.withOpacity(widget.opacity),
                            Colors.white.withOpacity(widget.opacity * 0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: widget.hasBorder
                        ? Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          )
                        : null,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة زجاجية مع توهج علوي
class GlassCardWithGlow extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color glowColor;
  final VoidCallback? onTap;

  const GlassCardWithGlow({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.glowColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                colors: [
                  glowColor.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        GlassCard(
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          glowColor: glowColor,
          onTap: onTap,
          child: child,
        ),
      ],
    );
  }
}

/// حبيبة زجاجية صغيرة (للـ status)
class GlassPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool filled;

  const GlassPill({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? c.withOpacity(0.9) : c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: c.withOpacity(filled ? 0.9 : 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: filled ? AppColors.darkBg : c),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: filled ? AppColors.darkBg : c,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// لوحة معلومات صغيرة زجاجية (stat pill)
class GlassStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const GlassStat({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: 14,
      opacity: 0.06,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textDarkPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textDarkHint,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
