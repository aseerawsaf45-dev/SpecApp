import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'pressable_scale.dart';

/// A command-center style surface container.
/// Features a dark charcoal core, hairline metallic border, optional yellow ambient glow,
/// and smooth pressable scaling interaction.
class CommandCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool hasPriorityGlow;
  final Color glowColor;
  final double glowSpread;
  final double glowBlur;
  final Gradient? borderGradient;

  const CommandCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.hasPriorityGlow = false,
    this.glowColor = AppColors.primaryYellow,
    this.glowSpread = 0.0,
    this.glowBlur = 20.0,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.charcoal;
    final effectiveBorder = borderColor ?? AppColors.darkBorder;

    Widget cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderGradient == null
            ? Border.all(color: effectiveBorder, width: borderWidth)
            : null,
        boxShadow: hasPriorityGlow
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.12),
                  blurRadius: glowBlur,
                  spreadRadius: glowSpread,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );

    if (borderGradient != null) {
      cardContent = Container(
        margin: margin,
        padding: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: borderGradient,
          boxShadow: hasPriorityGlow
              ? [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.16),
                    blurRadius: glowBlur,
                    spreadRadius: glowSpread,
                  ),
                ]
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - borderWidth),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      );
    }

    if (onTap != null || onLongPress != null) {
      return PressableScale(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
