import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// خلفية Aurora كاملة بـ mesh gradient متحرك
/// تُستخدم كخلفية رئيسية للتطبيق
class AuroraFullBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;
  final bool animated;
  final double intensity;

  const AuroraFullBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF16D9F2),
      Color(0xFF8B5CF6),
      Color(0xFFFF6B9D),
      Color(0xFF10E5A0),
      Color(0xFF3B82F6),
    ],
    this.animated = true,
    this.intensity = 1.0,
  });

  @override
  State<AuroraFullBackground> createState() => _AuroraFullBackgroundState();
}

class _AuroraFullBackgroundState extends State<AuroraFullBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    if (widget.animated) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark
        Container(color: AppColors.darkBg),

        // Aurora waves
        if (widget.animated)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _AuroraPainter(
                  colors: widget.colors,
                  progress: _controller.value,
                  intensity: widget.intensity,
                ),
                child: const SizedBox.expand(),
              );
            },
          )
        else
          CustomPaint(
            painter: _AuroraPainter(
              colors: widget.colors,
              progress: 0.5,
              intensity: widget.intensity,
            ),
            child: const SizedBox.expand(),
          ),

        // Content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final List<Color> colors;
  final double progress;
  final double intensity;

  _AuroraPainter({
    required this.colors,
    required this.progress,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ارسم 4 موجات Aurora
    for (int i = 0; i < colors.length; i++) {
      final color = colors[i];
      final t = (progress + i * 0.25) % 1.0;

      // موقع الموجة
      final cx = w * (0.3 + 0.4 * math.sin(t * math.pi * 2 + i));
      final cy = h * (0.3 + 0.4 * math.cos(t * math.pi * 2 + i));
      final radius = math.max(w, h) * 0.5;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.15 * intensity),
            color.withValues(alpha: 0.05 * intensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(
          Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        )
        ..blendMode = BlendMode.plus;

      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }

    // طبقة إضافية من الألوان الباردة
    for (int i = 0; i < 2; i++) {
      final color = colors[(i + 1) % colors.length];
      final t = (progress + 0.5 + i * 0.3) % 1.0;

      final cx = w * (0.5 + 0.4 * math.cos(t * math.pi * 2));
      final cy = h * (0.5 + 0.4 * math.sin(t * math.pi * 2));

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.10 * intensity),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(cx, cy),
            radius: math.max(w, h) * 0.4,
          ),
        )
        ..blendMode = BlendMode.plus;

      canvas.drawCircle(Offset(cx, cy), math.max(w, h) * 0.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) {
    return old.progress != progress || old.intensity != intensity;
  }
}

/// موجات Aurora أفقية (شكل موجي)
class AuroraWavesBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;

  const AuroraWavesBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF16D9F2),
      Color(0xFF8B5CF6),
      Color(0xFFFF6B9D),
    ],
  });

  @override
  State<AuroraWavesBackground> createState() => _AuroraWavesBackgroundState();
}

class _AuroraWavesBackgroundState extends State<AuroraWavesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.darkBg),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _WavesPainter(
                colors: widget.colors,
                progress: _controller.value,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _WavesPainter extends CustomPainter {
  final List<Color> colors;
  final double progress;

  _WavesPainter({required this.colors, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < colors.length; i++) {
      final color = colors[i];
      final phase = progress * 2 * math.pi + i * math.pi / 2;
      final yOffset = size.height * (0.3 + 0.15 * i);

      final path = Path();
      path.moveTo(0, yOffset);

      const segments = 6;
      for (int j = 0; j <= segments; j++) {
        final x = (size.width / segments) * j;
        final y = yOffset +
            math.sin(phase + (j / segments) * math.pi * 2) * size.height * 0.1;
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.02),
          ],
        ).createShader(Rect.fromLTWH(0, yOffset, size.width, size.height - yOffset))
        ..blendMode = BlendMode.plus;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavesPainter old) =>
      old.progress != progress;
}

/// خلفية نقاط متحركة (grid dots)
class DottedGridBackground extends StatefulWidget {
  final Widget? child;
  final Color? dotColor;

  const DottedGridBackground({
    super.key,
    this.child,
    this.dotColor,
  });

  @override
  State<DottedGridBackground> createState() => _DottedGridBackgroundState();
}

class _DottedGridBackgroundState extends State<DottedGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.darkBg),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _DotsPainter(
                color: widget.dotColor ?? AppColors.primary,
                progress: _controller.value,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _DotsPainter extends CustomPainter {
  final Color color;
  final double progress;

  _DotsPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 32.0;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.08);

    final offsetX = (progress * spacing) % spacing;
    final offsetY = (progress * spacing * 0.7) % spacing;

    for (double x = -spacing + offsetX; x < size.width + spacing; x += spacing) {
      for (double y = -spacing + offsetY; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter old) =>
      old.progress != progress;
}
