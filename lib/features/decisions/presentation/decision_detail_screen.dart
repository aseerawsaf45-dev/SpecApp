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
import '../../../shared/widgets/shimmer_sweep.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class DecisionDetailScreen extends StatefulWidget {
  final String decisionId;

  const DecisionDetailScreen({super.key, required this.decisionId});

  @override
  State<DecisionDetailScreen> createState() => _DecisionDetailScreenState();
}

class _DecisionDetailScreenState extends State<DecisionDetailScreen> {
  bool _isAcknowledged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: PressableScale(
          onTap: () => context.pop(),
          child: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Row(
          children: [
            Text(
              'DECISION #${widget.decisionId}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
              ),
              child: Text(
                'v2.0 ACTIVE',
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
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share2, color: AppColors.mutedWhite, size: 20),
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
            // Title Header Card
            StaggeredEntrance(
              index: 0,
              child: AnimatedGlowingBorder(
                borderRadius: 18,
                glowColor: AppColors.primaryYellow,
                borderWidth: 1.5,
                surfaceColor: const Color(0xFF141414),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PulsingBeacon(dotSize: 4.5, maxAuraSize: 10),
                                SizedBox(width: 6),
                                Text(
                                  'OFFICIAL DIRECTIVE',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryYellow,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '27 SEPT 2026',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7A7A7A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ShimmerSweep(
                        child: Text(
                          'REGISTRATION DESK LOCATION',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Primary check-in operation relocated from A-Block Entrance to Auditorium Main Gate.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedWhite,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Directive details container
            StaggeredEntrance(
              index: 1,
              child: CommandCard(
                padding: const EdgeInsets.all(20),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      'CURRENT RESOLUTION',
                      'Auditorium Main Entrance (Gate 2)',
                      isYellow: true,
                      icon: LucideIcons.mapPin,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 28),
                    _buildField(
                      'RATIONALE FOR ADJUSTMENT',
                      'High crowd volume forecast indicated severe choke-point risk at Block A corridor during peak 08:30-09:15 arrival window.',
                      icon: LucideIcons.fileText,
                    ),
                    const Divider(color: AppColors.darkBorder, height: 28),
                    _buildField(
                      'IMPACTED OPERATION TEAMS',
                      'Registration, Logistics Roster, Floor Hospitality, Tech Live-Stream',
                      icon: LucideIcons.users,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Metadata info card
            StaggeredEntrance(
              index: 2,
              child: _buildMetadataCard(context),
            ),

            const SizedBox(height: 24),

            // Acknowledgment Button
            StaggeredEntrance(
              index: 3,
              child: PressableScale(
                onTap: () {
                  setState(() => _isAcknowledged = !_isAcknowledged);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _isAcknowledged ? const Color(0xFF142400) : AppColors.charcoal,
                      content: Row(
                        children: [
                          Icon(
                            _isAcknowledged ? LucideIcons.checkCircle : LucideIcons.info,
                            color: _isAcknowledged ? AppColors.statusGreen : AppColors.primaryYellow,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _isAcknowledged
                                ? 'Decision #${widget.decisionId} marked acknowledged.'
                                : 'Acknowledgment reset.',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 1600),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _isAcknowledged ? const Color(0xFF152A08) : AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isAcknowledged ? AppColors.statusGreen : AppColors.primaryYellow,
                      width: 1.2,
                    ),
                    boxShadow: _isAcknowledged
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.primaryYellow.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isAcknowledged ? LucideIcons.checkCheck : LucideIcons.checkCircle,
                        size: 18,
                        color: _isAcknowledged ? AppColors.statusGreen : AppColors.deepBlack,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isAcknowledged ? 'ACKNOWLEDGED BY YOU' : 'CONFIRM ALIGNMENT & ACKNOWLEDGE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _isAcknowledged ? AppColors.statusGreen : AppColors.deepBlack,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),

            // Revision History
            StaggeredEntrance(
              index: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AUDIT TRAIL & REVISION LOG',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6E6E6E),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryTimeline(context),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  ),
);
}

  Widget _buildField(String label, String value, {bool isYellow = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isYellow ? AppColors.primaryYellow : const Color(0xFF6E6E6E)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isYellow ? AppColors.primaryYellow : const Color(0xFF6E6E6E),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isYellow ? 16 : 14,
            fontWeight: isYellow ? FontWeight.w700 : FontWeight.w500,
            color: isYellow ? AppColors.white : AppColors.mutedWhite,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return CommandCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'F',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepBlack,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BROADCAST LEAD',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6E6E6E),
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Foysal · Operations Coordinator',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '27 SEPT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              Text(
                '09:12 AM',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6E6E6E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(BuildContext context) {
    return Column(
      children: [
        _buildHistoryItem(
          context,
          version: 'VERSION 2 (CURRENT)',
          date: '27 Sept · 09:12 AM',
          content: 'Auditorium Main Entrance (Gate 2)',
          author: 'Foysal · Operations Coordinator',
          isCurrent: true,
        ),
        _buildHistoryItem(
          context,
          version: 'VERSION 1 (SUPERSEDED)',
          date: '26 Sept · 07:42 PM',
          content: 'A Block Central Entrance',
          author: 'Salman Farshi Alam · Event Lead',
          isCurrent: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String version,
    required String date,
    required String content,
    required String author,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              if (isCurrent)
                const PulsingBeacon(dotSize: 7, maxAuraSize: 16)
              else
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF333333),
                    shape: BoxShape.circle,
                  ),
                ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: AppColors.darkBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: CommandCard(
                padding: const EdgeInsets.all(14),
                borderRadius: 12,
                borderColor: isCurrent ? AppColors.primaryYellow.withValues(alpha: 0.35) : AppColors.darkBorder,
                hasPriorityGlow: isCurrent,
                glowColor: AppColors.primaryYellow,
                glowBlur: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          version,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isCurrent ? AppColors.primaryYellow : const Color(0xFF7A7A7A),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          date,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: const Color(0xFF6E6E6E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isCurrent ? AppColors.white : const Color(0xFF7A7A7A),
                        decoration: isCurrent ? TextDecoration.none : TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By $author',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF6E6E6E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
