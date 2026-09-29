import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/models/event_ops_models.dart';
import 'pressable_scale.dart';
import 'pulsing_beacon.dart';

class LiveAlertBanner extends StatelessWidget {
  final BroadcastAlert alert;
  final VoidCallback onDismiss;

  const LiveAlertBanner({
    super.key,
    required this.alert,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1F0707),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.statusRed.withValues(alpha: 0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.statusRed.withValues(alpha: 0.25),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const PulsingBeacon(
            color: AppColors.statusRed,
            dotSize: 6,
            maxAuraSize: 14,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      alert.badge,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.statusRed,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· ${alert.time}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppColors.mutedWhite.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alert.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PressableScale(
            onTap: () => context.push(alert.actionRoute),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.statusRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.statusRed),
              ),
              child: Text(
                'VIEW',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            icon: const Icon(LucideIcons.x, size: 14, color: AppColors.mutedWhite),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}
