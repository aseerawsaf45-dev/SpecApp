import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A luxury multi-node ambient gradient mesh backdrop.
/// Provides rich, luminous depth with gently drifting gold, indigo, and cyan
/// radial glow orbs, subtle cybernetic hairline grid, and edge vignette.
class GradientMeshBackground extends StatefulWidget {
  final Widget? child;
  final bool animate;
  final bool showGrid;
  final bool showVignette;
  final double intensity;

  const GradientMeshBackground({
    super.key,
    this.child,
    this.animate = true,
    this.showGrid = true,
    this.showVignette = true,
    this.intensity = 1.0,
  });

  @override
  State<GradientMeshBackground> createState() => _GradientMeshBackgroundState();
}

class _GradientMeshBackgroundState extends State<GradientMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant GradientMeshBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat(reverse: true);
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
    final background = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _GradientMeshPainter(
              progress: widget.animate ? _controller.value : 0.5,
              showGrid: widget.showGrid,
              showVignette: widget.showVignette,
              intensity: widget.intensity,
            ),
            size: Size.infinite,
          );
        },
      ),
    );

    if (widget.child == null) {
      return background;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        background,
        widget.child!,
      ],
    );
  }
}

class _GradientMeshPainter extends CustomPainter {
  final double progress;
  final bool showGrid;
  final bool showVignette;
  final double intensity;

  _GradientMeshPainter({
    required this.progress,
    required this.showGrid,
    required this.showVignette,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;

    // 1. Deep Obsidian Base
    final basePaint = Paint()..color = const Color(0xFF070709);
    canvas.drawRect(rect, basePaint);

    if (w <= 0 || h <= 0) return;

    // Calculate subtle organic motion offsets
    final t = progress * 2 * math.pi;
    final driftX1 = math.sin(t) * (w * 0.05);
    final driftY1 = math.cos(t) * (h * 0.04);
    final driftX2 = math.cos(t * 0.8) * (w * 0.04);
    final driftY2 = math.sin(t * 0.8) * (h * 0.05);

    // 2. Mesh Node 1: Amber Gold Bloom (Top-Right / Behind Hero)
    final orb1Center = Offset(w * 0.72 + driftX1, h * 0.16 + driftY1);
    final orb1Radius = (w * 0.52).clamp(240.0, 560.0);
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          AppColors.primaryYellow.withValues(alpha: 0.14 * intensity),
          const Color(0xFFE5BE72).withValues(alpha: 0.08 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: orb1Center, radius: orb1Radius));
    canvas.drawCircle(orb1Center, orb1Radius, orb1Paint);

    // 3. Mesh Node 2: Cyber Midnight Indigo (Mid-Left)
    final orb2Center = Offset(w * 0.12 - driftX2, h * 0.44 + driftY2);
    final orb2Radius = (w * 0.65).clamp(280.0, 680.0);
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          const Color(0xFF1E284A).withValues(alpha: 0.28 * intensity),
          const Color(0xFF0F172A).withValues(alpha: 0.14 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb2Center, radius: orb2Radius));
    canvas.drawCircle(orb2Center, orb2Radius, orb2Paint);

    // 4. Mesh Node 3: Deep Cyber Cyan Accent (Bottom-Right)
    final orb3Center = Offset(w * 0.88 + driftX2, h * 0.78 - driftY1);
    final orb3Radius = (w * 0.48).clamp(200.0, 480.0);
    final orb3Paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          const Color(0xFF0D324D).withValues(alpha: 0.20 * intensity),
          const Color(0xFF081E2E).withValues(alpha: 0.08 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: orb3Center, radius: orb3Radius));
    canvas.drawCircle(orb3Center, orb3Radius, orb3Paint);

    // 5. Mesh Node 4: Soft Solar Warmth (Top-Left / Header)
    final orb4Center = Offset(w * 0.25 + driftX1, h * 0.08 - driftY2);
    final orb4Radius = (w * 0.38).clamp(160.0, 360.0);
    final orb4Paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          const Color(0xFFD4AF37).withValues(alpha: 0.09 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: orb4Center, radius: orb4Radius));
    canvas.drawCircle(orb4Center, orb4Radius, orb4Paint);

    // 6. Hairline Cyber Grid (Subtle Linear Precision)
    if (showGrid) {
      final gridPaint = Paint()
        ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.022)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;

      const double gridSize = 56.0;
      for (double x = 0; x < w; x += gridSize) {
        canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
      }
      for (double y = 0; y < h; y += gridSize) {
        canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      }
    }

    // 7. Edge Vignette Falloff
    if (showVignette) {
      final vignettePaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 1.25,
          colors: [
            Colors.transparent,
            Colors.transparent,
            const Color(0xFF050507).withValues(alpha: 0.65),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect);
      canvas.drawRect(rect, vignettePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GradientMeshPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.intensity != intensity ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showVignette != showVignette;
  }
}
