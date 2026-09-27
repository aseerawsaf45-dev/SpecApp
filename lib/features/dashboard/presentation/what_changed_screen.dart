import '../../../shared/widgets/gradient_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class WhatChangedScreen extends StatefulWidget {
  const WhatChangedScreen({super.key});

  @override
  State<WhatChangedScreen> createState() => _WhatChangedScreenState();
}

class _WhatChangedScreenState extends State<WhatChangedScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['ALL', 'DECISIONS', 'DOCUMENTS', 'SCHEDULE'];

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
        title: Text(
          'AUDIT TRAIL',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.darkBorder.withValues(alpha: 0.6), height: 1),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OPERATIONAL DELTA',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mutedWhite,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'WHAT CHANGED?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Verified operational state updates since your last terminal session.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedWhite,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Continuous Gliding Filter Selector
            StaggeredEntrance(
              index: 1,
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth / _filters.length;
                    return Stack(
                      children: [
                        // Gliding Indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          left: _selectedFilterIndex * itemWidth,
                          top: 0,
                          bottom: 0,
                          width: itemWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryYellow.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Filter Buttons
                        Row(
                          children: List.generate(_filters.length, (i) {
                            final isSelected = _selectedFilterIndex == i;
                            return SizedBox(
                              width: itemWidth,
                              child: PressableScale(
                                onTap: () => setState(() => _selectedFilterIndex = i),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected ? AppColors.deepBlack : AppColors.mutedWhite,
                                      letterSpacing: 0.8,
                                    ),
                                    child: Text(_filters[i]),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Timeline Items
            StaggeredEntrance(
              index: 2,
              child: _buildTimelineItem(
                context,
                time: '09:20 AM',
                category: 'DOCUMENTS',
                title: 'Participant Master List v3',
                description: 'Registration Team finalized booth allocations and participant IDs.',
                isHighlight: true,
                icon: LucideIcons.fileSpreadsheet,
              ),
            ),
            
            StaggeredEntrance(
              index: 3,
              child: _buildTimelineItem(
                context,
                time: '09:12 AM',
                category: 'DECISIONS',
                title: 'Directive #024: Venue Check-in Relocation',
                description: 'Registration moved to Auditorium Main Entrance to prevent Gate 1 choke point.',
                isHighlight: true,
                icon: LucideIcons.fileSignature,
                onTap: () => context.push('/decision/024'),
              ),
            ),
            
            StaggeredEntrance(
              index: 4,
              child: _buildTimelineItem(
                context,
                time: '08:47 AM',
                category: 'SCHEDULE',
                title: 'Keynote Speaker Schedule Shift',
                description: 'Flight delay adjustment: Keynote moved from 10:15 AM to 10:45 AM.',
                icon: LucideIcons.clock,
              ),
            ),
            
            StaggeredEntrance(
              index: 5,
              child: _buildTimelineItem(
                context,
                time: '08:31 AM',
                category: 'SYSTEM',
                title: 'Registration Verification Protocol',
                description: 'Decentralized terminal sync confirmed across all 6 gate scanners.',
                icon: LucideIcons.checkCircle,
                isLast: true,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  ),
);
}

  Widget _buildTimelineItem(
    BuildContext context, {
    required String time,
    required String category,
    required String title,
    required String description,
    required IconData icon,
    bool isHighlight = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 64,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w500,
                    color: isHighlight ? AppColors.primaryYellow : const Color(0xFF6E6E6E),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              if (isHighlight)
                const PulsingBeacon(dotSize: 7, maxAuraSize: 16)
              else
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF383838),
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
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CommandCard(
                onTap: onTap,
                padding: const EdgeInsets.all(16),
                borderRadius: 14,
                borderColor: isHighlight ? AppColors.primaryYellow.withValues(alpha: 0.35) : AppColors.darkBorder,
                hasPriorityGlow: isHighlight,
                glowColor: AppColors.primaryYellow,
                glowBlur: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isHighlight
                            ? AppColors.primaryYellow.withValues(alpha: 0.12)
                            : AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: AppColors.elevatedSurface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  category,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              if (onTap != null) ...[
                                const Spacer(),
                                const Icon(LucideIcons.chevronRight, color: AppColors.mutedWhite, size: 14),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedWhite,
                              height: 1.4,
                            ),
                          ),
                        ],
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
