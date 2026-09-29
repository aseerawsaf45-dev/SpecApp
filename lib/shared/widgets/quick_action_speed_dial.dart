import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import 'broadcast_dialog.dart';
import 'document_viewer_sheet.dart';
import 'fast_checkin_sheet.dart';
import 'pressable_scale.dart';
import 'propose_decision_sheet.dart';

class QuickActionSpeedDial extends StatefulWidget {
  const QuickActionSpeedDial({super.key});

  @override
  State<QuickActionSpeedDial> createState() => _QuickActionSpeedDialState();
}

class _QuickActionSpeedDialState extends State<QuickActionSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _closeAndRun(VoidCallback action) {
    _toggle();
    Future.delayed(const Duration(milliseconds: 150), action);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          ScaleTransition(
            scale: _expandAnimation,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSpeedDialItem(
                    icon: LucideIcons.qrCode,
                    label: 'Fast Gate Check-In',
                    color: const Color(0xFF10B981),
                    onTap: () => _closeAndRun(() => FastCheckinSheet.show(context)),
                  ),
                  const SizedBox(height: 10),
                  _buildSpeedDialItem(
                    icon: LucideIcons.megaphone,
                    label: 'Broadcast Alert',
                    color: AppColors.statusRed,
                    onTap: () => _closeAndRun(() => BroadcastDialog.show(context)),
                  ),
                  const SizedBox(height: 10),
                  _buildSpeedDialItem(
                    icon: LucideIcons.fileSignature,
                    label: 'Propose Directive',
                    color: AppColors.primaryYellow,
                    onTap: () => _closeAndRun(() => ProposeDecisionSheet.show(context)),
                  ),
                  const SizedBox(height: 10),
                  _buildSpeedDialItem(
                    icon: LucideIcons.folder,
                    label: 'Event Day Pack',
                    color: const Color(0xFF60A5FA),
                    onTap: () => _closeAndRun(
                      () => DocumentViewerSheet.show(context, title: 'CASESpecs 4.0 Event Day Pack'),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],

        // Main Trigger Button
        PressableScale(
          onTap: _toggle,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryYellow.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedRotation(
                turns: _isOpen ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isOpen ? LucideIcons.x : LucideIcons.plus,
                  color: AppColors.deepBlack,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.darkBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        PressableScale(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.7), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ],
    );
  }
}
