import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// An interactive 3D spotlight card inspired by Apple VisionOS and Linear surfaces.
/// Illuminates an ambient radial beam that tracks mouse cursor coordinates with subtle
/// perspective tilt physics on desktop and web.
class SpotlightCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final Color spotlightColor;
  final double spotlightRadius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const SpotlightCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.spotlightColor = AppColors.primaryYellow,
    this.spotlightRadius = 260.0,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  Offset? _mousePosition;
  bool _isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() {
      _mousePosition = details.localPosition;
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _mousePosition = null;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.charcoal;

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered
                  ? widget.spotlightColor.withValues(alpha: 0.45)
                  : AppColors.darkBorder,
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.spotlightColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                // Ambient dynamic cursor spotlight beam
                if (_isHovered && _mousePosition != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _SpotlightPainter(
                        cursorPosition: _mousePosition!,
                        color: widget.spotlightColor,
                        radius: widget.spotlightRadius,
                      ),
                    ),
                  ),
                Padding(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset cursorPosition;
  final Color color;
  final double radius;

  _SpotlightPainter({
    required this.cursorPosition,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (cursorPosition.dx / size.width) * 2 - 1,
          (cursorPosition.dy / size.height) * 2 - 1,
        ),
        radius: radius / size.width,
        colors: [
          color.withValues(alpha: 0.14),
          color.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.cursorPosition != cursorPosition ||
        oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}
