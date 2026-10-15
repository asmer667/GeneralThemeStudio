import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/animations.dart';

/// خلفية متدرجة متحركة (تتحرك الألوان ببطء)
class AnimatedGradientBackground extends StatefulWidget {
  final Widget? child;
  final List<Color>? colors;
  final Duration duration;
  final double angle;

  const AnimatedGradientBackground({
    super.key,
    this.child,
    this.colors,
    this.duration = AppAnimations.gradient,
    this.angle = 0.0,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ??
        [AppColors.neonCyan, AppColors.neonPurple, AppColors.neonPink];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment(
                -1 + _animation.value * 2,
                -1,
              ),
              end: Alignment(
                1 - _animation.value * 2,
                1,
              ),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// خلفية Aurora متحركة (تدرجات متعددة تتحرك)
class AuroraBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;
  final double speed;

  const AuroraBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF16D9F2),
      Color(0xFF8B5CF6),
      Color(0xFFFF6B9D),
      Color(0xFF10E5A0),
    ],
    this.speed = 1.0,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (8 / widget.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            gradient: RadialGradient(
              center: Alignment(
                -0.7 + t * 1.4,
                -0.5 + t * 1.0,
              ),
              radius: 1.5,
              colors: [
                widget.colors[0].withOpacity(0.20),
                widget.colors[1].withOpacity(0.10),
                AppColors.darkBg,
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  0.7 - t * 1.4,
                  0.5 - t * 1.0,
                ),
                radius: 1.5,
                colors: [
                  widget.colors[2].withOpacity(0.15),
                  widget.colors[3].withOpacity(0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// خلفية متدرجة ثابتة (بدون حركة)
class StaticGradientBackground extends StatelessWidget {
  final Widget? child;
  final List<Color>? colors;
  final Alignment begin;
  final Alignment end;

  const StaticGradientBackground({
    super.key,
    this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [AppColors.darkBg, AppColors.darkBgElevated],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}

/// خلفية شبكية (Mesh gradient) بألوان متعددة
class MeshGradientBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;

  const MeshGradientBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF16D9F2),
      Color(0xFF8B5CF6),
      Color(0xFFFF6B9D),
      Color(0xFF10E5A0),
    ],
  });

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.darkBg,
            gradient: RadialGradient(
              center: Alignment(-0.5 + t * 1.0, -0.5 + t * 0.5),
              radius: 1.8,
              colors: [
                widget.colors[0].withOpacity(0.15),
                widget.colors[1].withOpacity(0.08),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5 - t * 1.0, 0.5 - t * 0.5),
                radius: 1.8,
                colors: [
                  widget.colors[2].withOpacity(0.12),
                  widget.colors[3].withOpacity(0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
