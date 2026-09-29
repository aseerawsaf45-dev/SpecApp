import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/operations_state.dart';
import '../../features/roster/domain/team_member.dart';
import 'pressable_scale.dart';
import 'pulsing_beacon.dart';

class MemberProfileSheet extends ConsumerWidget {
  final TeamMember member;

  const MemberProfileSheet({super.key, required this.member});

  static Future<void> show(BuildContext context, TeamMember member) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberProfileSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ops = ref.watch(operationsProvider);
    final status = ops.getMemberStatus(member);

    Color statusColor;
    switch (status) {
      case 'ON DUTY':
        statusColor = const Color(0xFF10B981);
        break;
      case 'ONLINE':
        statusColor = AppColors.primaryYellow;
        break;
      case 'BREAK':
        statusColor = const Color(0xFFF59E0B);
        break;
      default:
        statusColor = const Color(0xFF94A3B8);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedWhite.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header with Avatar and Clearance
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: member.departmentBgColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: member.tierColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: member.tierColor.withValues(alpha: 0.25),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    member.avatarInitials,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: member.tierColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: member.tierColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: member.tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            member.tierLabel,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: member.tierColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: member.departmentBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            member.departmentLabel,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: member.departmentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Operational Identity Matrix Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: [
                _buildInfoRow('OPERATIONAL ID', member.id, isMono: true, copyable: true, context: context),
                const Divider(color: AppColors.darkBorder, height: 20),
                _buildInfoRow('PRIMARY POST', member.location, icon: LucideIcons.mapPin),
                const Divider(color: AppColors.darkBorder, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        PulsingBeacon(
                          color: statusColor,
                          dotSize: 5,
                          maxAuraSize: 11,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DUTY STATUS',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedWhite,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    PressableScale(
                      onTap: () {
                        ops.toggleMemberStatus(member.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              status,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: statusColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(LucideIcons.refresh, size: 12, color: statusColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (member.phone != null) ...[
                  const Divider(color: AppColors.darkBorder, height: 20),
                  _buildInfoRow('SECURE PHONE', member.phone!, icon: LucideIcons.phone, isMono: true, copyable: true, context: context),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: PressableScale(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/chat/senior-executives');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryYellow.withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.messageSquare, size: 16, color: AppColors.deepBlack),
                        const SizedBox(width: 8),
                        Text(
                          'MESSAGE OFFICER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepBlack,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              PressableScale(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: member.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.charcoal,
                      content: Text('Copied officer ID ${member.id} to clipboard!'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: const Icon(LucideIcons.copy, size: 18, color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    bool isMono = false,
    bool copyable = false,
    BuildContext? context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.mutedWhite),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedWhite,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: copyable
              ? () {
                  Clipboard.setData(ClipboardData(text: value));
                  if (context != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.charcoal,
                        content: Text('Copied $value'),
                      ),
                    );
                  }
                }
              : null,
          child: Row(
            children: [
              Text(
                value,
                style: isMono
                    ? GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      )
                    : GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
              ),
              if (copyable) ...[
                const SizedBox(width: 6),
                const Icon(LucideIcons.copy, size: 12, color: AppColors.mutedWhite),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
