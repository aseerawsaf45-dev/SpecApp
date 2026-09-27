import '../../../shared/widgets/gradient_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/shimmer_sweep.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientMeshBackground(
        child: SafeArea(
          child: CustomScrollView(
          slivers: [
            SliverAppBar(
        backgroundColor: Colors.transparent,
              pinned: true,
              elevation: 0,
              leading: PressableScale(
                onTap: () => context.pop(),
                child: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CASESpecs 4.0',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Spectrum · Event Operations',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedWhite,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.search, color: AppColors.mutedWhite),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(LucideIcons.moreVertical, color: AppColors.mutedWhite),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: AppColors.darkBorder, height: 1),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StaggeredEntrance(
                      index: 0,
                      child: _HeroCard(),
                    ),
                    const SizedBox(height: 28),
                    StaggeredEntrance(
                      index: 1,
                      child: _buildChannelCategory(context, 'INFORMATION', [
                        _ChannelData('announcements', hasUnread: true, isAnnouncement: true, unreadCount: 3),
                        _ChannelData('important-updates', hasUnread: true, unreadCount: 1),
                        _ChannelData('emergency'),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    StaggeredEntrance(
                      index: 2,
                      child: _buildChannelCategory(context, 'MANAGEMENT', [
                        _ChannelData('senior-executives'),
                        _ChannelData('coordinators'),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    StaggeredEntrance(
                      index: 3,
                      child: _buildChannelCategory(context, 'OPERATIONS', [
                        _ChannelData('registration', hasUnread: true, unreadCount: 2),
                        _ChannelData('logistics'),
                        _ChannelData('hospitality'),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    StaggeredEntrance(
                      index: 4,
                      child: _buildChannelCategory(context, 'CREATIVE', [
                        _ChannelData('graphics'),
                        _ChannelData('content'),
                        _ChannelData('promotion'),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    StaggeredEntrance(
                      index: 5,
                      child: _buildChannelCategory(context, 'TECH', [
                        _ChannelData('website'),
                        _ChannelData('automation'),
                      ]),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildChannelCategory(BuildContext context, String title, List<_ChannelData> channels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6E6E6E),
              letterSpacing: 2.0,
            ),
          ),
        ),
        CommandCard(
          padding: EdgeInsets.zero,
          borderRadius: 14,
          child: Column(
            children: List.generate(channels.length, (i) {
              final ch = channels[i];
              final isLast = i == channels.length - 1;
              return Column(
                children: [
                  _buildChannelItem(context, ch),
                  if (!isLast)
                    Container(
                      margin: const EdgeInsets.only(left: 52),
                      height: 1,
                      color: AppColors.darkBorder,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelItem(BuildContext context, _ChannelData channel) {
    return PressableScale(
      onTap: () => context.push('/chat/${channel.name}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: channel.hasUnread
                    ? AppColors.primaryYellow.withValues(alpha: 0.12)
                    : AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                channel.isAnnouncement ? LucideIcons.megaphone : LucideIcons.hash,
                color: channel.hasUnread ? AppColors.primaryYellow : const Color(0xFF6E6E6E),
                size: 16,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                channel.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: channel.hasUnread ? FontWeight.w700 : FontWeight.w500,
                  color: channel.hasUnread ? AppColors.white : AppColors.mutedWhite,
                ),
              ),
            ),
            if (channel.unreadCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepBlack,
                  ),
                ),
              )
            else
              const Icon(LucideIcons.chevronRight, color: Color(0xFF4A4A4A), size: 16),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return AnimatedGlowingBorder(
      borderRadius: 20,
      glowColor: AppColors.primaryYellow,
      borderWidth: 1.5,
      surfaceColor: const Color(0xFF101010),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C0C0C), Color(0xFF161616), Color(0xFF241D06)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.35)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PulsingBeacon(dotSize: 4.5, maxAuraSize: 11),
                      SizedBox(width: 6),
                      Text(
                        'PREPARATION PHASE',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryYellow,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: AnimatedCounter(
                    targetValue: 23,
                    suffix: ' DAYS LEFT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShimmerSweep(
              child: Text(
                'CASE\nSPECS 4.0',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  height: 1.05,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 0.78),
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.elevatedSurface,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryYellow),
                        minHeight: 7,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Milestone Status',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                    AnimatedCounter(
                      targetValue: 78,
                      suffix: '% Completed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 18),
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.elevatedSurface,
                child: Icon(LucideIcons.user, size: 16, color: AppColors.primaryYellow),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENT LEAD',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mutedWhite,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Salman Farshi Alam',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              PressableScale(
                onTap: () => context.push('/team_roster'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.users, size: 12, color: AppColors.primaryYellow),
                      const SizedBox(width: 5),
                      Text(
                        '43 Roster · 4 Tiers',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PressableScale(
            onTap: () => context.push('/event_day'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.zap, size: 16, color: AppColors.primaryYellow),
                  const SizedBox(width: 8),
                  Text(
                    'ENTER EVENT DAY MODE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _ChannelData {
  final String name;
  final bool hasUnread;
  final bool isAnnouncement;
  final int? unreadCount;

  _ChannelData(this.name, {this.hasUnread = false, this.isAnnouncement = false, this.unreadCount});
}
