import '../../../shared/widgets/gradient_mesh_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/shimmer_sweep.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientMeshBackground(
        child: SafeArea(
          child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeTab(context),
            _buildEventsTab(context),
            _buildSearchTab(context),
            _buildAlertsTab(context),
            _buildProfileTab(context),
          ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ==========================================
  // TAB 0: HOME / COMMAND CENTER
  // ==========================================
  Widget _buildHomeTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, title: 'AppSpecs', showLiveStatus: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                StaggeredEntrance(
                  index: 0,
                  child: _buildUpcomingEventCard(context),
                ),
                const SizedBox(height: 28),
                StaggeredEntrance(
                  index: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('NEEDS ATTENTION', count: 3),
                      const SizedBox(height: 14),
                      _buildAttentionCard(
                        context,
                        title: 'Decision Required',
                        subtitle: 'Budget allocation for Stage Lighting v2',
                        timeAgo: '12m ago',
                        priority: 'HIGH',
                        priorityColor: const Color(0xFFFF5252),
                        onTap: () => context.push('/decision/024'),
                      ),
                      const SizedBox(height: 10),
                      _buildAttentionCard(
                        context,
                        title: 'Venue Change Pending',
                        subtitle: 'Registration Desk relocated to Auditorium Entrance',
                        timeAgo: '48m ago',
                        priority: 'URGENT',
                        priorityColor: AppColors.primaryYellow,
                        onTap: () => context.push('/decision/024'),
                      ),
                      const SizedBox(height: 10),
                      _buildAttentionCard(
                        context,
                        title: 'Unread Announcements',
                        subtitle: '3 new updates posted in #announcements',
                        timeAgo: '1h ago',
                        priority: 'INFO',
                        priorityColor: const Color(0xFF64B5F6),
                        onTap: () => context.push('/chat/announcements'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                StaggeredEntrance(
                  index: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('RECENT ACTIVITY'),
                          PressableScale(
                            onTap: () => context.push('/what_changed'),
                            child: Text(
                              'WHAT CHANGED?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryYellow,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildActivityTimeline(context),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 1: EVENTS ROSTER
  // ==========================================
  Widget _buildEventsTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, title: 'Operations Portfolio', showLiveStatus: false),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                StaggeredEntrance(
                  index: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MANAGED EVENTS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryYellow,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3 Active Deployments',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      PressableScale(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.charcoal,
                              content: Text(
                                'Event deployment configuration console ready',
                                style: GoogleFonts.plusJakartaSans(color: AppColors.white),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryYellow.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.plus, size: 15, color: AppColors.deepBlack),
                              const SizedBox(width: 6),
                              Text(
                                'NEW EVENT',
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                StaggeredEntrance(
                  index: 1,
                  child: _buildEventDeckCard(
                    context,
                    title: 'CASESpecs 4.0',
                    phase: 'PREPARATION PHASE',
                    daysLeft: '23 DAYS LEFT',
                    progress: 0.78,
                    membersCount: 47,
                    lead: 'Salman Farshi Alam',
                    isFeatured: true,
                    onTap: () => context.push('/event'),
                  ),
                ),
                const SizedBox(height: 14),
                StaggeredEntrance(
                  index: 2,
                  child: _buildEventDeckCard(
                    context,
                    title: 'MechTech Arena 2026',
                    phase: 'LOGISTICS PLANNING',
                    daysLeft: '48 DAYS LEFT',
                    progress: 0.42,
                    membersCount: 31,
                    lead: 'Tanvir Hossain',
                    isFeatured: false,
                    onTap: () => context.push('/event'),
                  ),
                ),
                const SizedBox(height: 14),
                StaggeredEntrance(
                  index: 3,
                  child: _buildEventDeckCard(
                    context,
                    title: 'Roboverse Tech Summit',
                    phase: 'EARLY DRAFT',
                    daysLeft: '76 DAYS LEFT',
                    progress: 0.18,
                    membersCount: 19,
                    lead: 'Sadia Rahman',
                    isFeatured: false,
                    onTap: () => context.push('/event'),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: SEARCH / COMMAND CONSOLE
  // ==========================================
  Widget _buildSearchTab(BuildContext context) {
    final searchTerms = [
      _SearchResult(
        title: 'Registration Desk Location',
        category: 'DECISION',
        code: '#024',
        subtitle: 'Auditorium Entrance change approved',
        icon: LucideIcons.fileSignature,
        route: '/decision/024',
      ),
      _SearchResult(
        title: '#announcements',
        category: 'CHANNEL',
        code: '3 unread',
        subtitle: 'CASESpecs 4.0 primary broadcast channel',
        icon: LucideIcons.megaphone,
        route: '/chat/announcements',
      ),
      _SearchResult(
        title: 'Event Day Live Mode',
        category: 'CONSOLE',
        code: 'READY',
        subtitle: 'CASESpecs 4.0 fast-access schedule & files',
        icon: LucideIcons.zap,
        route: '/event_day',
      ),
      _SearchResult(
        title: '#emergency',
        category: 'CHANNEL',
        code: 'CRITICAL',
        subtitle: 'Direct operational emergency contact line',
        icon: LucideIcons.alertTriangle,
        route: '/chat/emergency',
      ),
      _SearchResult(
        title: 'Participant Master List v3',
        category: 'DOCUMENT',
        code: 'FILE',
        subtitle: 'Updated registration roster with booth allocations',
        icon: LucideIcons.fileSpreadsheet,
        route: '/what_changed',
      ),
      _SearchResult(
        title: 'Executive Corps & Team Roster',
        category: 'ORGANIZATION',
        code: '4 TIERS',
        subtitle: 'Panel, Senior, Junior & Associate Executives with Dept IDs',
        icon: LucideIcons.users,
        route: '/team_roster',
      ),
    ];

    final filtered = _searchQuery.isEmpty
        ? searchTerms
        : searchTerms.where((item) {
            final q = _searchQuery.toLowerCase();
            return item.title.toLowerCase().contains(q) ||
                item.subtitle.toLowerCase().contains(q) ||
                item.category.toLowerCase().contains(q);
          }).toList();

    return Column(
      children: [
        _buildSimpleHeader(context, 'Command Search'),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(LucideIcons.search, size: 20, color: AppColors.primaryYellow),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search decisions, channels, documents...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.mutedWhite.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 16, color: AppColors.mutedWhite),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = filtered[index];
              return InkWell(
                onTap: () => context.push(item.route),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.elevatedSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Icon(item.icon, size: 20, color: AppColors.primaryYellow),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.category,
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
                              item.subtitle,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedWhite),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: ALERTS & BROADCAST FEED
  // ==========================================
  Widget _buildAlertsTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, title: 'Broadcasts & Alerts', showLiveStatus: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildAlertItem(
                  context,
                  badge: 'CRITICAL DECISION',
                  title: 'Registration Relocated to Auditorium Entrance',
                  time: '12m ago',
                  description: 'Traffic flow adjustments require all check-in terminals to operate at Gate 2 entrance.',
                  actionLabel: 'VIEW DECISION #024',
                  isUrgent: true,
                  onAction: () => context.push('/decision/024'),
                ),
                const SizedBox(height: 12),
                _buildAlertItem(
                  context,
                  badge: 'SCHEDULE ADJUSTMENT',
                  title: 'Speaker Arrival Updated to 10:45 AM',
                  time: '34m ago',
                  description: 'Flight delay confirmed. Keynote session shifted forward by 15 minutes.',
                  actionLabel: 'VIEW EVENT DAY TIMELINE',
                  isUrgent: false,
                  onAction: () => context.push('/event_day'),
                ),
                const SizedBox(height: 12),
                _buildAlertItem(
                  context,
                  badge: 'ROSTER UPDATE',
                  title: 'Participant Roster v3 Published',
                  time: '1h ago',
                  description: 'Contains verified badge barcode IDs and emergency medical contacts.',
                  actionLabel: 'OPEN WHAT CHANGED',
                  isUrgent: false,
                  onAction: () => context.push('/what_changed'),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 4: PROFILE & OPS CONSOLE
  // ==========================================
  Widget _buildProfileTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, title: 'Command Console', showLiveStatus: false),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Identity card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'SF',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepBlack,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Salman Farshi Alam',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Head of Operations · Event Lead',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryYellow,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.darkBorder),
                                  ),
                                  child: Text(
                                    'TIER 1 ADMIN',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mutedWhite,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ID: #OPS-9921',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFF6E6E6E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('SYSTEM TELEMETRY'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    children: [
                      _buildTelemetryRow('Mesh Protocol', 'CONNECTED (0ms latency)', true),
                      const Divider(color: AppColors.darkBorder, height: 24),
                      _buildTelemetryRow('Offline Cache Sync', '100% STORED (52MB)', true),
                      const Divider(color: AppColors.darkBorder, height: 24),
                      _buildTelemetryRow('Cryptographic Verification', 'ACTIVE (AES-256)', true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('SYSTEM CONTROLS'),
                const SizedBox(height: 12),
                _buildSettingsOption(
                  icon: LucideIcons.zap,
                  title: 'Launch Event Day Mode',
                  subtitle: 'Direct transition to live event schedule',
                  onTap: () => context.push('/event_day'),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.fileSpreadsheet,
                  title: 'Audit Trail & Changelog',
                  subtitle: 'Review recent modifications and decisions',
                  onTap: () => context.push('/what_changed'),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.users,
                  title: 'Executive Corps & Roster',
                  subtitle: '4 tiers · 43 officers · Department ID verification',
                  onTap: () => context.push('/team_roster'),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.shieldCheck,
                  title: 'Security & Access Keys',
                  subtitle: 'Manage coordinator permissions and tokens',
                  onTap: () {},
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SHARED SUBWIDGETS & HELPERS
  // ==========================================
  Widget _buildAppBar(BuildContext context, {required String title, required bool showLiveStatus}) {
    return SliverAppBar(
        backgroundColor: Colors.transparent,
      floating: true,
      pinned: false,
      elevation: 0,
      toolbarHeight: 64,
      title: Row(
        children: [
          const BrandLogo(size: 32),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (showLiveStatus) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF142400),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const PulsingBeacon(dotSize: 5.5, maxAuraSize: 13),
                  const SizedBox(width: 6),
                  Text(
                    'SYS:ONLINE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryYellow,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          PressableScale(
            onTap: () => setState(() => _currentIndex = 4),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.charcoal,
              child: Text(
                'AA',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.darkBorder, height: 1),
      ),
    );
  }

  Widget _buildSimpleHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.primaryBlack,
        border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
      ),
      child: Row(
        children: [
          const BrandLogo(size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventCard(BuildContext context) {
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
                        'UPCOMING EVENT',
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
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: AnimatedCounter(
                    targetValue: 23,
                    suffix: ' DAYS LEFT',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShimmerSweep(
              child: Text(
                'CASESpecs 4.0',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Spectrum · Annual National Business Case Competition',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedWhite,
              ),
            ),
            const SizedBox(height: 16),
            // Preparation progress bar with spring animation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PREPARATION PROGRESS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mutedWhite,
                    letterSpacing: 1.0,
                  ),
                ),
                AnimatedCounter(
                  targetValue: 68,
                  suffix: '%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 0.68),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: AppColors.elevatedSurface,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryYellow),
                    minHeight: 6,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PressableScale(
                    onTap: () => context.push('/event'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryYellow.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'OPEN EVENT HUB',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepBlack,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                PressableScale(
                  onTap: () => context.push('/event_day'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.45)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.zap, size: 16, color: AppColors.primaryYellow),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE DAY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget _buildEventDeckCard(
    BuildContext context, {
    required String title,
    required String phase,
    required String daysLeft,
    required double progress,
    required int membersCount,
    required String lead,
    required bool isFeatured,
    required VoidCallback onTap,
  }) {
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      borderColor: isFeatured ? AppColors.primaryYellow.withValues(alpha: 0.4) : AppColors.darkBorder,
      borderGradient: isFeatured ? AppColors.goldBorderGradient : null,
      hasPriorityGlow: isFeatured,
      glowColor: AppColors.primaryYellow,
      glowBlur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isFeatured ? AppColors.primaryYellow.withValues(alpha: 0.3) : AppColors.darkBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFeatured) ...[
                      const PulsingBeacon(dotSize: 4, maxAuraSize: 9),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      phase,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isFeatured ? AppColors.primaryYellow : AppColors.mutedWhite,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                daysLeft,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isFeatured ? AppColors.primaryYellow : AppColors.mutedWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.elevatedSurface,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFeatured ? AppColors.primaryYellow : const Color(0xFF888888),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Lead: $lead',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedWhite,
                ),
              ),
              const Spacer(),
              Text(
                '$membersCount Members',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: const Color(0xFF7A7A7A),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedWhite),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String timeAgo,
    required String priority,
    required Color priorityColor,
    required VoidCallback onTap,
  }) {
    final bool isHighPriority = priority == 'HIGH' || priority == 'URGENT';
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      borderColor: isHighPriority ? priorityColor.withValues(alpha: 0.3) : AppColors.darkBorder,
      hasPriorityGlow: isHighPriority,
      glowColor: priorityColor,
      glowBlur: 14,
      child: Row(
        children: [
          Container(
            width: 3.5,
            height: 42,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: priorityColor.withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        priority,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: priorityColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF6E6E6E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedWhite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedWhite),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context, {
    required String badge,
    required String title,
    required String time,
    required String description,
    required String actionLabel,
    required bool isUrgent,
    required VoidCallback onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppColors.primaryYellow.withValues(alpha: 0.4) : AppColors.darkBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? AppColors.primaryYellow.withValues(alpha: 0.15)
                      : AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isUrgent ? AppColors.primaryYellow : AppColors.mutedWhite,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF6E6E6E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedWhite,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryYellow,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.primaryYellow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {int? count}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6E6E6E),
            letterSpacing: 1.5,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.deepBlack,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTelemetryRow(String label, String value, bool isOk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            PulsingBeacon(
              color: isOk ? AppColors.statusGreen : AppColors.statusRed,
              dotSize: 5,
              maxAuraSize: 12,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedWhite,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isOk ? AppColors.primaryYellow : Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.elevatedSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryYellow),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.mutedWhite,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedWhite),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(BuildContext context) {
    return Column(
      children: [
        _buildActivityRow(
          time: '09:20 AM',
          description: 'Participant List v3 published by Registration Team',
          isHighlight: true,
          icon: LucideIcons.fileSpreadsheet,
        ),
        _buildActivityRow(
          time: '09:12 AM',
          description: 'Decision #024: Registration moved to Auditorium Entrance',
          isHighlight: true,
          icon: LucideIcons.fileSignature,
        ),
        _buildActivityRow(
          time: '08:47 AM',
          description: 'Speaker arrival time rescheduled to 10:45 AM',
          icon: LucideIcons.clock,
        ),
        _buildActivityRow(
          time: '08:31 AM',
          description: 'Registration system live check confirmed',
          isLast: true,
          icon: LucideIcons.checkCircle,
        ),
      ],
    );
  }

  Widget _buildActivityRow({
    required String time,
    required String description,
    bool isHighlight = false,
    bool isLast = false,
    IconData? icon,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 66,
            child: Text(
              time,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                color: isHighlight ? AppColors.primaryYellow : const Color(0xFF6E6E6E),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: isHighlight ? AppColors.primaryYellow : AppColors.charcoal,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite,
                    width: 1.5,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: AppColors.darkBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isHighlight ? AppColors.primaryYellow.withValues(alpha: 0.06) : AppColors.charcoal,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isHighlight ? AppColors.primaryYellow.withValues(alpha: 0.35) : AppColors.darkBorder,
                  ),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 14, color: isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
                          color: isHighlight ? AppColors.white : AppColors.mutedWhite,
                        ),
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

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepBlack,
        border: const Border(top: BorderSide(color: AppColors.darkBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = constraints.maxWidth / 5;
              return Stack(
                children: [
                  // Animated Gliding Pill
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    left: _currentIndex * itemWidth + 4,
                    top: 2,
                    width: itemWidth - 8,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryYellow.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryYellow.withValues(alpha: 0.16),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom mini indicator beam under active tab
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    left: _currentIndex * itemWidth + (itemWidth / 2) - 8,
                    bottom: 0,
                    width: 16,
                    height: 2.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.primaryYellow,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 5 Nav Items
                  Row(
                    children: [
                      _buildNavItem(0, LucideIcons.home, 'Home', itemWidth),
                      _buildNavItem(1, LucideIcons.calendar, 'Events', itemWidth),
                      _buildNavItem(2, LucideIcons.search, 'Search', itemWidth),
                      _buildNavItem(3, LucideIcons.bell, 'Alerts', itemWidth),
                      _buildNavItem(4, LucideIcons.user, 'Profile', itemWidth),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, double width) {
    final isActive = _currentIndex == index;
    return SizedBox(
      width: width,
      height: 54,
      child: PressableScale(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.primaryYellow : AppColors.mutedWhite,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? AppColors.primaryYellow : AppColors.mutedWhite,
                letterSpacing: 0.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResult {
  final String title;
  final String category;
  final String code;
  final String subtitle;
  final IconData icon;
  final String route;

  _SearchResult({
    required this.title,
    required this.category,
    required this.code,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
