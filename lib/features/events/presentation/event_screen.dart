import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.primaryBlack,
              pinned: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
                onPressed: () => context.pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CASESpecs 4.0',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Spectrum · Event Operations',
                    style: GoogleFonts.manrope(
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
                    _buildHero(context),
                    const SizedBox(height: 28),
                    _buildChannelCategory(context, 'INFORMATION', [
                      _ChannelData('announcements', hasUnread: true, isAnnouncement: true, unreadCount: 3),
                      _ChannelData('important-updates', hasUnread: true, unreadCount: 1),
                      _ChannelData('emergency'),
                    ]),
                    const SizedBox(height: 8),
                    _buildChannelCategory(context, 'MANAGEMENT', [
                      _ChannelData('senior-executives'),
                      _ChannelData('coordinators'),
                    ]),
                    const SizedBox(height: 8),
                    _buildChannelCategory(context, 'OPERATIONS', [
                      _ChannelData('registration', hasUnread: true, unreadCount: 2),
                      _ChannelData('logistics'),
                      _ChannelData('hospitality'),
                    ]),
                    const SizedBox(height: 8),
                    _buildChannelCategory(context, 'CREATIVE', [
                      _ChannelData('graphics'),
                      _ChannelData('content'),
                      _ChannelData('promotion'),
                    ]),
                    const SizedBox(height: 8),
                    _buildChannelCategory(context, 'TECH', [
                      _ChannelData('website'),
                      _ChannelData('automation'),
                    ]),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF050505), Color(0xFF161616), Color(0xFF2A2205)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
            ),
            child: Text(
              'PREPARATION PHASE',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryYellow,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'CASE\nSPECS 4.0',
            style: GoogleFonts.manrope(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '23 DAYS LEFT',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.78,
                  backgroundColor: AppColors.primaryYellow.withValues(alpha: 0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryYellow),
                  minHeight: 7,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '78% Milestone Completion',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.charcoal,
                child: Icon(LucideIcons.user, size: 16, color: AppColors.mutedWhite),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENT LEAD',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mutedWhite,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Aseer Awsaf',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '47 Members',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/event_day'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow.withValues(alpha: 0.1),
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
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryYellow,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelCategory(BuildContext context, String title, List<_ChannelData> channels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5A5A5A),
              letterSpacing: 2.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
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
    return InkWell(
      onTap: () => context.push('/chat/${channel.name}'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(
              channel.isAnnouncement ? LucideIcons.megaphone : LucideIcons.hash,
              color: channel.hasUnread ? AppColors.white : const Color(0xFF4A4A4A),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                channel.name,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: channel.hasUnread ? FontWeight.w600 : FontWeight.w500,
                  color: channel.hasUnread ? AppColors.white : AppColors.mutedWhite,
                ),
              ),
            ),
            if (channel.unreadCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${channel.unreadCount}',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepBlack,
                  ),
                ),
              )
            else
              const Icon(LucideIcons.chevronRight, color: Color(0xFF3A3A3A), size: 16),
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
