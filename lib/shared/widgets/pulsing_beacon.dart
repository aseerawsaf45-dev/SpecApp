import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A live pulsing beacon with an expanding radar wave aura.
/// Used for real-time status indicators like SYS:ONLINE, LIVE, or ACTIVE.
class PulsingBeacon extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double maxAuraSize;
  final Duration duration;
  final String? label;
  final TextStyle? labelStyle;

  const PulsingBeacon({
    super.key,
    this.color = AppColors.primaryYellow,
    this.dotSize = 7.0,
    this.maxAuraSize = 20.0,
    this.duration = const Duration(milliseconds: 1800),
    this.label,
    this.labelStyle,
  });

  @override
  State<PulsingBeacon> createState() => _PulsingBeaconState();
}

class _PulsingBeaconState extends State<PulsingBeacon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _auraAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _auraAnimation = Tween<double>(
      begin: widget.dotSize,
      end: widget.maxAuraSize,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.65,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beacon = SizedBox(
      width: widget.maxAuraSize,
      height: widget.maxAuraSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Expanding radar aura
                Container(
                  width: _auraAnimation.value,
                  height: _auraAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: _opacityAnimation.value),
                  ),
                ),
                // Core solid glowing dot
                Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.8),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          beacon,
          const SizedBox(width: 6),
          Text(
            widget.label!,
            style: widget.labelStyle ??
                TextStyle(
                  color: widget.color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
          ),
        ],
      );
    }

    return beacon;
  }
}
