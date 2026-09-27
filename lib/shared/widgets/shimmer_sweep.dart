import 'dart:async';
import 'package:flutter/material.dart';

/// Sweeps a shimmering metallic light beam across its child widget at regular intervals.
/// Ideal for hero headlines, logo brandmarks, and primary action surfaces.
class ShimmerSweep extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration interval;
  final Color shimmerColor;

  const ShimmerSweep({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.interval = const Duration(milliseconds: 3200),
    this.shimmerColor = const Color(0xFFFFF3B0),
  });

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _timer = Timer(widget.interval, () {
          if (mounted) {
            _controller.forward(from: 0.0);
          }
        });
      }
    });

    _timer = Timer(widget.interval, () {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.value == 0.0 || _controller.value == 1.0) {
          return widget.child;
        }

        final double offset = -1.0 + (_controller.value * 3.0);

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                widget.shimmerColor.withValues(alpha: 0.6),
                Colors.white,
                widget.shimmerColor.withValues(alpha: 0.6),
                Colors.transparent,
              ],
              stops: [
                (offset - 0.25).clamp(0.0, 1.0),
                (offset - 0.1).clamp(0.0, 1.0),
                offset.clamp(0.0, 1.0),
                (offset + 0.1).clamp(0.0, 1.0),
                (offset + 0.25).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
