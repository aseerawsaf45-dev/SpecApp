import '../../../shared/widgets/gradient_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class EventDayScreen extends StatelessWidget {
  const EventDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PressableScale(
          onTap: () => Navigator.of(context).maybePop(),
          child: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Row(
          children: [
            Text(
              'CASESpecs 4.0',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PulsingBeacon(
                    color: Colors.redAccent,
                    dotSize: 5,
                    maxAuraSize: 12,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.redAccent,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search, color: AppColors.mutedWhite),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.darkBorder, height: 1),
        ),
      ),
      body: GradientMeshBackground(
        child: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredEntrance(
                index: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EVENT DAY CONSOLE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mutedWhite,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '27 SEPTEMBER 2026',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryYellow,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Text(
                        'DAY 1 OF 1',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              StaggeredEntrance(
                index: 1,
                child: _buildFastAccessCard(
                  context,
                  title: 'IMPORTANT UPDATES',
                  count: '3 CRITICAL NOTICES',
                  icon: LucideIcons.alertCircle,
                  color: Colors.redAccent,
                  onTap: () => context.push('/chat/important-updates'),
                ),
              ),
              const SizedBox(height: 12),
              
              StaggeredEntrance(
                index: 2,
                child: _buildFastAccessCard(
                  context,
                  title: 'EVENT DAY PACK',
                  count: '8 VERIFIED ASSETS',
                  icon: LucideIcons.folder,
                  color: AppColors.primaryYellow,
                  onTap: () => context.push('/what_changed'),
                ),
              ),
              const SizedBox(height: 28),
              
              StaggeredEntrance(
                index: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LIVE SCHEDULE TIMELINE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6E6E6E),
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'UTC+6 DHAKA',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6E6E6E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              StaggeredEntrance(
                index: 4,
                child: _buildScheduleTimeline(context),
              ),
              
              const SizedBox(height: 28),
              StaggeredEntrance(
                index: 5,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryActionCard(
                        context,
                        title: 'TEAM ROSTER',
                        subtitle: '4 Tiers · 43 Active',
                        icon: LucideIcons.users,
                        onTap: () => context.push('/team_roster'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildSecondaryActionCard(
                        context,
                        title: 'EMERGENCY LINE',
                        subtitle: 'Direct Operations',
                        icon: LucideIcons.phone,
                        isAlert: true,
                        onTap: () => context.push('/chat/emergency'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildFastAccessCard(
    BuildContext context, {
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      borderColor: color.withValues(alpha: 0.35),
      hasPriorityGlow: true,
      glowColor: color,
      glowBlur: 16,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: AppColors.mutedWhite, size: 18),
        ],
      ),
    );
  }

  Widget _buildSecondaryActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isAlert = false,
  }) {
    final color = isAlert ? Colors.redAccent : AppColors.primaryYellow;
    
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: isAlert ? Colors.redAccent.withValues(alpha: 0.3) : AppColors.darkBorder,
      hasPriorityGlow: isAlert,
      glowColor: Colors.redAccent,
      glowBlur: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline(BuildContext context) {
    return Column(
      children: [
        _buildScheduleItem(context, '09:00', 'Registration & Gate Check-in', isCompleted: true),
        _buildScheduleItem(context, '10:00', 'Opening Ceremony & Keynote', isCompleted: true),
        _buildScheduleItem(context, '10:30', 'Case Competition Round 1', isActive: true, statusTag: 'IN PROGRESS'),
        _buildScheduleItem(context, '13:00', 'Executive Lunch & Networking', isUpcoming: true),
        _buildScheduleItem(context, '14:00', 'Finalist Case Presentations', isUpcoming: true),
        _buildScheduleItem(context, '17:00', 'Awards & Closing Gala', isUpcoming: true, isLast: true),
      ],
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String time,
    String title, {
    bool isCompleted = false,
    bool isActive = false,
    bool isUpcoming = false,
    bool isLast = false,
    String? statusTag,
  }) {
    Color getLineColor() {
      if (isActive || isCompleted) return AppColors.primaryYellow.withValues(alpha: 0.4);
      return AppColors.darkBorder;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 52,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                    color: isActive ? AppColors.primaryYellow : AppColors.mutedWhite,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              if (isActive)
                const PulsingBeacon(dotSize: 8, maxAuraSize: 20)
              else
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primaryYellow : AppColors.charcoal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.primaryYellow : AppColors.mutedWhite,
                      width: 1.5,
                    ),
                  ),
                ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: getLineColor(),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: isActive
                  ? AnimatedGlowingBorder(
                      borderRadius: 14,
                      glowColor: AppColors.primaryYellow,
                      borderWidth: 1.4,
                      surfaceColor: const Color(0xFF161616),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.white,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryYellow.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    statusTag ?? 'LIVE',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryYellow,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Main Auditorium · 12 Competing Teams',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w500,
                          color: isCompleted ? AppColors.white : AppColors.mutedWhite,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
