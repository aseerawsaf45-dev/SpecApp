import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/state/models/event_ops_models.dart';
import '../../../core/state/operations_state.dart';
import '../../../features/roster/domain/team_member.dart';
import '../../../shared/widgets/animated_counter.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/create_event_sheet.dart';
import '../../../shared/widgets/fast_checkin_sheet.dart';
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/live_alert_banner.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/quick_action_speed_dial.dart';
import '../../../shared/widgets/shimmer_sweep.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../../shared/widgets/broadcast_dialog.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  String _selectedSearchCategory = 'ALL';
  final TextEditingController _searchController = TextEditingController();
  String _eventFilter = 'ALL';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final criticalAlert = ops.latestCriticalAlert;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientMeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (criticalAlert != null)
                LiveAlertBanner(
                  alert: criticalAlert,
                  onDismiss: () => ops.acknowledgeAlert(criticalAlert.id),
                ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    _buildHomeTab(context, ops),
                    _buildEventsTab(context, ops),
                    _buildSearchTab(context, ops),
                    _buildAlertsTab(context, ops),
                    _buildProfileTab(context, ops),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (_currentIndex == 0 || _currentIndex == 1)
          ? const QuickActionSpeedDial()
          : null,
      bottomNavigationBar: _buildBottomNav(context, ops),
    );
  }

  // ==========================================
  // TAB 0: HOME / COMMAND CENTER
  // ==========================================
  Widget _buildHomeTab(BuildContext context, OperationsNotifier ops) {
    final event = ops.activeEvent;
    final decisions = ops.decisions;
    final unacknowledgedDecisions = decisions.where((d) => !d.isAcknowledged).toList();

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, title: 'AppSpecs', showLiveStatus: true),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),

                // Live quick metrics strip
                _buildLiveTelemetryRibbon(ops),

                const SizedBox(height: 18),
                StaggeredEntrance(
                  index: 0,
                  child: _buildUpcomingEventCard(context, event, ops),
                ),
                const SizedBox(height: 26),

                // Needs Attention Section
                StaggeredEntrance(
                  index: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('NEEDS ATTENTION', count: unacknowledgedDecisions.length),
                      const SizedBox(height: 12),
                      if (unacknowledgedDecisions.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.charcoal,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.checkCheck, color: Color(0xFF34D399), size: 18),
                              const SizedBox(width: 10),
                              Text(
                                'All operational directives acknowledged & verified.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.mutedWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...unacknowledgedDecisions.map((d) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildAttentionCard(
                              context,
                              title: 'Directive #${d.id} Requires Vote',
                              subtitle: d.title,
                              timeAgo: d.timestamp,
                              priority: d.priority,
                              priorityColor: d.priorityColor,
                              onTap: () => context.push('/decision/${d.id}'),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Recent Activity Timeline
                StaggeredEntrance(
                  index: 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('REAL-TIME ACTIVITY LOG'),
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
                      _buildActivityTimeline(context, ops),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // spacing for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveTelemetryRibbon(OperationsNotifier ops) {
    final event = ops.activeEvent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMiniStat('OFFICERS', '${ops.attendedOfficersCount}/${ops.totalOfficersCount}', LucideIcons.shieldCheck, const Color(0xFF10B981)),
          Container(width: 1, height: 26, color: AppColors.darkBorder),
          _buildMiniStat('ATTENDEES', '${event.checkedInCount}/${event.targetAttendees}', LucideIcons.users, AppColors.primaryYellow),
          Container(width: 1, height: 26, color: AppColors.darkBorder),
          _buildMiniStat('DIRECTIVES', '${ops.decisions.length} ACTIVE', LucideIcons.fileSignature, const Color(0xFF60A5FA)),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite.withValues(alpha: 0.6),
                letterSpacing: 0.8,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // TAB 1: EVENTS ROSTER
  // ==========================================
  Widget _buildEventsTab(BuildContext context, OperationsNotifier ops) {
    final allEvents = ops.events;
    final filtered = allEvents.where((e) {
      if (_eventFilter == 'ACTIVE') return e.isFeatured || e.phase.contains('PREPARATION');
      if (_eventFilter == 'PLANNING') return e.phase.contains('PLANNING') || e.phase.contains('DRAFT');
      return true;
    }).toList();

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
                            'MANAGED DEPLOYMENTS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryYellow,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${allEvents.length} Active Events',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      PressableScale(
                        onTap: () => CreateEventSheet.show(context),
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
                const SizedBox(height: 16),

                // Filter chips
                Row(
                  children: ['ALL', 'ACTIVE', 'PLANNING'].map((f) {
                    final isSelected = _eventFilter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() => _eventFilter = f),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryYellow.withValues(alpha: 0.15)
                                : AppColors.charcoal,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryYellow : AppColors.darkBorder,
                            ),
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? AppColors.primaryYellow : AppColors.mutedWhite,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Event cards list
                ...filtered.map((evt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildEventDeckCard(
                      context,
                      event: evt,
                      isActiveNow: evt.id == ops.activeEventId,
                      onTap: () {
                        ops.setActiveEvent(evt.id);
                        context.push('/event');
                      },
                    ),
                  );
                }),
                const SizedBox(height: 80),
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
  Widget _buildSearchTab(BuildContext context, OperationsNotifier ops) {
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
        code: 'Live Feed',
        subtitle: 'CASESpecs 4.0 primary broadcast channel',
        icon: LucideIcons.megaphone,
        route: '/chat/announcements',
      ),
      _SearchResult(
        title: 'Event Day Live Mode',
        category: 'CONSOLE',
        code: 'READY',
        subtitle: 'CASESpecs 4.0 fast-access schedule & gate scanner',
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
      _SearchResult(
        title: 'Stage Lighting & AV Overhaul',
        category: 'DECISION',
        code: '#025',
        subtitle: 'Redundant 4K line array projectors vote',
        icon: LucideIcons.fileSignature,
        route: '/decision/025',
      ),
    ];

    final filtered = searchTerms.where((item) {
      if (_selectedSearchCategory != 'ALL' &&
          !item.category.toUpperCase().contains(_selectedSearchCategory)) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return item.title.toLowerCase().contains(q) ||
            item.subtitle.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Column(
      children: [
        _buildSimpleHeader(context, 'Command Search'),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
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
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.white),
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

        // Quick Category Filter Pills
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'DECISION', 'CHANNEL', 'CONSOLE', 'DOCUMENT', 'ORGANIZATION'].map((cat) {
                final isSelected = _selectedSearchCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedSearchCategory = cat),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryYellow.withValues(alpha: 0.15)
                            : AppColors.charcoal,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryYellow : AppColors.darkBorder,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? AppColors.primaryYellow : AppColors.mutedWhite,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'No commands or records match "$_searchQuery"',
                    style: GoogleFonts.plusJakartaSans(color: AppColors.mutedWhite, fontSize: 13),
                  ),
                )
              : ListView.separated(
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
  Widget _buildAlertsTab(BuildContext context, OperationsNotifier ops) {
    final alerts = ops.alerts;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TERMINAL DISPATCH',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryYellow,
                        letterSpacing: 1.5,
                      ),
                    ),
                    PressableScale(
                      onTap: () => BroadcastDialog.show(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.megaphone, size: 14, color: AppColors.deepBlack),
                            const SizedBox(width: 6),
                            Text(
                              'TRANSMIT ALERT',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.deepBlack,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...alerts.map((a) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAlertItem(
                      context,
                      badge: a.badge,
                      title: a.title,
                      time: a.time,
                      description: a.description,
                      actionLabel: a.actionLabel,
                      isUrgent: a.isUrgent,
                      priorityColor: a.priorityColor,
                      onAction: () => context.push(a.actionRoute),
                      onDismiss: () => ops.dismissAlert(a.id),
                    ),
                  );
                }),
                const SizedBox(height: 40),
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
  Widget _buildProfileTab(BuildContext context, OperationsNotifier ops) {
    final allMembers = TeamRosterRepository.members;
    final leadMember = allMembers.first;
    final currentStatus = ops.getMemberStatus(leadMember);

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
                // Identity Card with interactive duty toggle
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
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryYellow.withValues(alpha: 0.35),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'SA',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
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
                              ops.currentUserName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ops.currentUserRole,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryYellow,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                    'TIER 1 PANEL',
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.mutedWhite,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PressableScale(
                                  onTap: () => ops.toggleMemberStatus(leadMember.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF064E3B),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        const PulsingBeacon(color: Color(0xFF34D399), dotSize: 4, maxAuraSize: 8),
                                        const SizedBox(width: 4),
                                        Text(
                                          currentStatus,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF34D399),
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
                      _buildInteractiveTelemetryRow(
                        'Mesh Relay Protocol',
                        ops.isMeshConnected ? 'ONLINE (0ms latency)' : 'OFFLINE',
                        ops.isMeshConnected,
                        () => setState(() => ops.isMeshConnected = !ops.isMeshConnected),
                      ),
                      const Divider(color: AppColors.darkBorder, height: 24),
                      _buildInteractiveTelemetryRow(
                        'Offline Cache Store',
                        ops.isOfflineCacheReady ? '52MB SYNCED (100%)' : 'SYNC PAUSED',
                        ops.isOfflineCacheReady,
                        () => setState(() => ops.isOfflineCacheReady = !ops.isOfflineCacheReady),
                      ),
                      const Divider(color: AppColors.darkBorder, height: 24),
                      _buildInteractiveTelemetryRow(
                        'Cryptographic Signatures',
                        ops.isCryptoVerified ? 'AES-256 ACTIVE' : 'BYPASS MODE',
                        ops.isCryptoVerified,
                        () => setState(() => ops.isCryptoVerified = !ops.isCryptoVerified),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('FAST OPERATIONAL TOOLS'),
                const SizedBox(height: 12),
                _buildSettingsOption(
                  icon: LucideIcons.qrCode,
                  title: 'Gate Pass & Scanner Terminal',
                  subtitle: 'Simulate barcode scan and live attendee check-in',
                  onTap: () => FastCheckinSheet.show(context),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.zap,
                  title: 'Launch Event Day Console',
                  subtitle: 'Real-time schedule milestone management',
                  onTap: () => context.push('/event_day'),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.fileSpreadsheet,
                  title: 'Audit Trail & Changelog',
                  subtitle: 'Filter and inspect operational delta timeline',
                  onTap: () => context.push('/what_changed'),
                ),
                const SizedBox(height: 10),
                _buildSettingsOption(
                  icon: LucideIcons.users,
                  title: 'Executive Corps & Roster',
                  subtitle: '43 officers across 4 governance tiers',
                  onTap: () => context.push('/team_roster'),
                ),
                const SizedBox(height: 40),
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
                'SA',
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

  Widget _buildUpcomingEventCard(BuildContext context, OperationalEvent event, OperationsNotifier ops) {
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const PulsingBeacon(dotSize: 4.5, maxAuraSize: 11),
                      const SizedBox(width: 6),
                      Text(
                        event.phase,
                        style: const TextStyle(
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
                    targetValue: event.daysLeft,
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
                event.title,
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
              event.subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedWhite,
              ),
            ),
            const SizedBox(height: 16),
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
                  targetValue: (event.progress * 100).toInt(),
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
                tween: Tween<double>(begin: 0.0, end: event.progress),
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
            PressableScale(
              onTap: () => context.push('/event_day'),
              child: Container(
                margin: const EdgeInsets.only(top: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.shieldCheck, size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OFFICER ATTENDANCE & POST DISPATCH',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${ops.attendedOfficersCount} / ${ops.totalOfficersCount} Present · ${ops.assignedTasksCount} Posts Active',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF10B981)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
    required OperationalEvent event,
    required bool isActiveNow,
    required VoidCallback onTap,
  }) {
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      borderColor: isActiveNow ? AppColors.primaryYellow.withValues(alpha: 0.5) : AppColors.darkBorder,
      borderGradient: isActiveNow ? AppColors.goldBorderGradient : null,
      hasPriorityGlow: isActiveNow,
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
                    color: isActiveNow ? AppColors.primaryYellow.withValues(alpha: 0.3) : AppColors.darkBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isActiveNow) ...[
                      const PulsingBeacon(dotSize: 4, maxAuraSize: 9),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      event.phase,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isActiveNow ? AppColors.primaryYellow : AppColors.mutedWhite,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${event.daysLeft} DAYS LEFT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActiveNow ? AppColors.primaryYellow : AppColors.mutedWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            event.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event.subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.mutedWhite,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: event.progress,
              backgroundColor: AppColors.elevatedSurface,
              valueColor: AlwaysStoppedAnimation<Color>(
                isActiveNow ? AppColors.primaryYellow : const Color(0xFF888888),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Lead: ${event.lead}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedWhite,
                ),
              ),
              const Spacer(),
              Text(
                '${event.membersCount} Officers',
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
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      borderColor: priorityColor.withValues(alpha: 0.35),
      hasPriorityGlow: true,
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
    required Color priorityColor,
    required VoidCallback onAction,
    required VoidCallback onDismiss,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? priorityColor.withValues(alpha: 0.45) : AppColors.darkBorder,
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
                  color: priorityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: priorityColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xFF6E6E6E),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    icon: const Icon(LucideIcons.x, size: 14, color: Color(0xFF6E6E6E)),
                    onPressed: onDismiss,
                  ),
                ],
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

  Widget _buildInteractiveTelemetryRow(String label, String value, bool isOk, VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
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
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isOk ? AppColors.primaryYellow : Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(LucideIcons.refresh, size: 12, color: isOk ? AppColors.primaryYellow : Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
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

  Widget _buildActivityTimeline(BuildContext context, OperationsNotifier ops) {
    final logs = ops.auditLogs.take(4).toList();

    return Column(
      children: List.generate(logs.length, (i) {
        final item = logs[i];
        final isLast = i == logs.length - 1;
        return _buildActivityRow(
          time: item.time,
          description: '${item.title}: ${item.description}',
          isHighlight: item.isHighlight,
          isLast: isLast,
          icon: item.icon,
          onTap: item.route != null ? () => context.push(item.route!) : null,
        );
      }),
    );
  }

  Widget _buildActivityRow({
    required String time,
    required String description,
    bool isHighlight = false,
    bool isLast = false,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
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
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, OperationsNotifier ops) {
    final unreadAlerts = ops.alerts.where((a) => !a.isAcknowledged).length;

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
                  Row(
                    children: [
                      _buildNavItem(0, LucideIcons.home, 'Home', itemWidth),
                      _buildNavItem(1, LucideIcons.calendar, 'Events', itemWidth),
                      _buildNavItem(2, LucideIcons.search, 'Search', itemWidth),
                      _buildNavItem(3, LucideIcons.bell, 'Alerts', itemWidth, badgeCount: unreadAlerts),
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

  Widget _buildNavItem(int index, IconData icon, String label, double width, {int badgeCount = 0}) {
    final isActive = _currentIndex == index;
    return SizedBox(
      width: width,
      height: 54,
      child: PressableScale(
        onTap: () => setState(() => _currentIndex = index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
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
            if (badgeCount > 0)
              Positioned(
                top: 4,
                right: (width / 2) - 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.statusRed,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.statusRed.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    '$badgeCount',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
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
