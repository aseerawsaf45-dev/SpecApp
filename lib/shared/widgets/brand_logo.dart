import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;

  const BrandLogo({
    super.key,
    this.size = 40,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.primaryYellow.withValues(alpha: 0.28),
                  blurRadius: size * 0.35,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/app_icon.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return CustomPaint(
              size: Size(size, size),
              painter: _BrandMarkPainter(),
            );
          },
        ),
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // Glowing bloom behind the main diamond
    final glowPaint = Paint()
      ..color = AppColors.brightYellow.withValues(alpha: 0.28)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.15);
    
    final diamondPath = Path();
    final double dSize = w * 0.38;
    diamondPath.moveTo(cx, cy - dSize);
    diamondPath.lineTo(cx + dSize, cy);
    diamondPath.lineTo(cx, cy + dSize);
    diamondPath.lineTo(cx - dSize, cy);
    diamondPath.close();
    canvas.drawPath(diamondPath, glowPaint);

    // Horizontal dashed alignment line
    final dashPaint = Paint()
      ..color = AppColors.primaryYellow.withValues(alpha: 0.65)
      ..strokeWidth = w * 0.022
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double dashW = w * 0.038;
    final double gapW = w * 0.028;
    double startX = w * 0.12;
    final double endX = w * 0.88;
    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, cy),
        Offset((startX + dashW).clamp(0.0, endX), cy),
        dashPaint,
      );
      startX += dashW + gapW;
    }

    // Outer connected satellite lines
    final linePaint = Paint()
      ..color = AppColors.brightYellow.withValues(alpha: 0.8)
      ..strokeWidth = w * 0.024
      ..style = PaintingStyle.stroke;

    final double orbitDist = w * 0.40;
    final pTop = Offset(cx, cy - orbitDist);
    final pBottom = Offset(cx, cy + orbitDist);
    final pLeft = Offset(cx - orbitDist, cy);
    final pRight = Offset(cx + orbitDist, cy);

    // Connecting diamond ring outline between satellite nodes
    final outerRingPath = Path();
    outerRingPath.moveTo(pTop.dx, pTop.dy);
    outerRingPath.lineTo(pRight.dx, pRight.dy);
    outerRingPath.lineTo(pBottom.dx, pBottom.dy);
    outerRingPath.lineTo(pLeft.dx, pLeft.dy);
    outerRingPath.close();
    canvas.drawPath(outerRingPath, linePaint);

    // Main central yellow diamond
    final yellowPaint = Paint()
      ..color = AppColors.primaryYellow
      ..style = PaintingStyle.fill;
    canvas.drawPath(diamondPath, yellowPaint);

    // Inner black rotated diamond
    final innerBlackPaint = Paint()
      ..color = AppColors.deepBlack
      ..style = PaintingStyle.fill;
    final innerBlackPath = Path();
    final double innerSize = dSize * 0.54;
    innerBlackPath.moveTo(cx, cy - innerSize);
    innerBlackPath.lineTo(cx + innerSize, cy);
    innerBlackPath.lineTo(cx, cy + innerSize);
    innerBlackPath.lineTo(cx - innerSize, cy);
    innerBlackPath.close();
    canvas.drawPath(innerBlackPath, innerBlackPaint);

    // Center yellow circular core
    final corePaint = Paint()
      ..color = AppColors.primaryYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), w * 0.065, corePaint);

    // 4 Satellite orbital nodes with concentric halos
    final nodeBorderPaint = Paint()
      ..color = AppColors.primaryYellow.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02;

    void drawNode(Offset center) {
      canvas.drawCircle(center, w * 0.075, nodeBorderPaint);
      canvas.drawCircle(center, w * 0.045, yellowPaint);
    }

    drawNode(pTop);
    drawNode(pBottom);
    drawNode(pLeft);
    drawNode(pRight);

    // Bottom decorative mini satellite node
    canvas.drawCircle(Offset(cx, cy + orbitDist + w * 0.07), w * 0.022, yellowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
