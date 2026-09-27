import 'package:flutter/material.dart';

/// Smooth animated rolling counter for high-tech telemetry and operational metrics.
/// Decelerates gracefully with cubic exponential easing.
class AnimatedCounter extends StatelessWidget {
  final int targetValue;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final Duration duration;
  final Curve curve;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1400),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetValue.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Text(
          '$prefix${value.toInt()}$suffix',
          style: style,
        );
      },
    );
  }
}
