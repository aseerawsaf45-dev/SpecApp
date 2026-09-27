import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A luxury rotating glowing beam that continuously sweeps along the border of the container.
/// Creates a signature futuristic command-center / high-end hardware aesthetic.
class AnimatedGlowingBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Color glowColor;
  final Duration duration;
  final bool isAnimated;
  final Color? surfaceColor;

  const AnimatedGlowingBorder({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.borderWidth = 1.6,
    this.glowColor = AppColors.primaryYellow,
    this.duration = const Duration(milliseconds: 3500),
    this.isAnimated = true,
    this.surfaceColor,
  });

  @override
  State<AnimatedGlowingBorder> createState() => _AnimatedGlowingBorderState();
}

class _AnimatedGlowingBorderState extends State<AnimatedGlowingBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isAnimated) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedGlowingBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimated != oldWidget.isAnimated) {
      if (widget.isAnimated) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimated) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.glowColor.withValues(alpha: 0.35),
            width: widget.borderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: widget.child,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlowingBorderPainter(
            progress: _controller.value,
            borderRadius: widget.borderRadius,
            borderWidth: widget.borderWidth,
            glowColor: widget.glowColor,
          ),
          child: Container(
            margin: EdgeInsets.all(widget.borderWidth),
            decoration: BoxDecoration(
              color: widget.surfaceColor ?? AppColors.charcoal,
              borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class _GlowingBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double borderWidth;
  final Color glowColor;

  _GlowingBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.borderWidth,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final angle = progress * 2 * math.pi;

    // Moving rotating sweep gradient for neon beam effect
    final sweepGradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      transform: GradientRotation(angle),
      colors: [
        Colors.transparent,
        const Color(0xFF292929),
        glowColor.withValues(alpha: 0.25),
        glowColor,
        glowColor.withValues(alpha: 0.3),
        const Color(0xFF292929),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 0.65, 0.75, 0.85, 0.95, 1.0],
    );

    // Glowing bloom underneath the border beam
    final glowPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(rrect, glowPaint);

    // Crisp high-intensity beam line
    final strokePaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _GlowingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
