import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/models/event_ops_models.dart';
import '../../../core/state/operations_state.dart';
import '../../../shared/widgets/command_card.dart';
import '../../../shared/widgets/document_viewer_sheet.dart';
import '../../../shared/widgets/fast_checkin_sheet.dart';
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class EventDayScreen extends ConsumerStatefulWidget {
  const EventDayScreen({super.key});

  @override
  ConsumerState<EventDayScreen> createState() => _EventDayScreenState();
}

class _EventDayScreenState extends ConsumerState<EventDayScreen> {
  int _selectedTab = 0; // 0 = Attendance & Tasks, 1 = Schedule Timeline
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'ALL'; // 'ALL', 'PRESENT', 'PENDING', 'ASSIGNED', 'NO_TASK'
  String _selectedDeptFilter = 'ALL'; // 'ALL', 'OPERATIONS', 'LOGISTICS', etc.

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AttendanceRecord> _getFilteredAttendance(List<AttendanceRecord> all) {
    return all.where((record) {
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final nameMatches = record.name.toLowerCase().contains(query);
        final roleMatches = record.role.toLowerCase().contains(query);
        final deptMatches = record.department.toLowerCase().contains(query);
        final taskMatches = record.assignedTask != null &&
            (record.assignedTask!.title.toLowerCase().contains(query) ||
                record.assignedTask!.location.toLowerCase().contains(query));
        if (!nameMatches && !roleMatches && !deptMatches && !taskMatches) {
          return false;
        }
      }

      if (_selectedStatusFilter == 'PRESENT' && !record.isPresent) return false;
      if (_selectedStatusFilter == 'PENDING' && record.isPresent) return false;
      if (_selectedStatusFilter == 'ASSIGNED' && record.assignedTask == null) return false;
      if (_selectedStatusFilter == 'NO_TASK' && (record.assignedTask != null || !record.isPresent)) return false;

      if (_selectedDeptFilter != 'ALL' &&
          record.department.toUpperCase() != _selectedDeptFilter.toUpperCase()) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final event = ops.activeEvent;
    final scheduleItems = ops.schedule;
    final completedCount = scheduleItems.where((s) => s.status == 'COMPLETED').length;

    final attendanceList = ops.attendanceList;
    final attendedCount = ops.attendedOfficersCount;
    final totalCount = ops.totalOfficersCount;
    final assignedCount = ops.assignedTasksCount;
    final unassignedAttendedCount = attendanceList.where((a) => a.isPresent && a.assignedTask == null).length;

    final filteredRecords = _getFilteredAttendance(attendanceList);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PressableScale(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
          child: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Row(
          children: [
            Text(
              event.title,
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
                    'LIVE CONSOLE',
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
            tooltip: 'Fast Attendee Check-in',
            icon: const Icon(LucideIcons.qrCode, color: AppColors.primaryYellow),
            onPressed: () => FastCheckinSheet.show(context),
          ),
          IconButton(
            tooltip: 'Event Day Pack',
            icon: const Icon(LucideIcons.folder, color: AppColors.mutedWhite),
            onPressed: () => DocumentViewerSheet.show(
              context,
              title: '${event.title} Event Day Pack',
            ),
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
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Protocol Header
                StaggeredEntrance(
                  index: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EVENT DAY COMMAND PROTOCOL',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.mutedWhite,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '27 SEPTEMBER 2026',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryYellow,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.elevatedSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Text(
                          '$attendedCount / $totalCount OFFICERS CHECKED IN',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Fast Action Quick Bar (Compact)
                StaggeredEntrance(
                  index: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickActionPill(
                          icon: LucideIcons.qrCode,
                          label: 'GATE SCANNER',
                          value: '${event.checkedInCount}/${event.targetAttendees}',
                          color: const Color(0xFF10B981),
                          onTap: () => FastCheckinSheet.show(context),
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionPill(
                          icon: LucideIcons.alertCircle,
                          label: 'DIRECTIVES',
                          value: '3 ACTIVE',
                          color: AppColors.statusRed,
                          onTap: () => context.push('/chat/important-updates'),
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionPill(
                          icon: LucideIcons.folder,
                          label: 'DAY PACK',
                          value: '8 ASSETS',
                          color: AppColors.primaryYellow,
                          onTap: () => DocumentViewerSheet.show(context, title: '${event.title} Event Day Pack'),
                        ),
                        const SizedBox(width: 8),
                        _buildQuickActionPill(
                          icon: LucideIcons.phone,
                          label: 'EMERGENCY',
                          value: 'ACTIVE SOS',
                          color: Colors.redAccent,
                          onTap: () => context.push('/chat/emergency'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Segmented Tab Selector (ATTENDANCE & TASKS vs SCHEDULE TIMELINE)
                StaggeredEntrance(
                  index: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: PressableScale(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedTab = 0);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTab == 0
                                    ? AppColors.primaryYellow
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.users,
                                    size: 15,
                                    color: _selectedTab == 0
                                        ? Colors.black
                                        : AppColors.mutedWhite,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'OFFICER ATTENDANCE ($attendedCount/$totalCount)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: _selectedTab == 0
                                          ? Colors.black
                                          : AppColors.mutedWhite,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PressableScale(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedTab = 1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTab == 1
                                    ? AppColors.primaryYellow
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.clock,
                                    size: 15,
                                    color: _selectedTab == 1
                                        ? Colors.black
                                        : AppColors.mutedWhite,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'SCHEDULE ($completedCount/${scheduleItems.length})',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: _selectedTab == 1
                                          ? Colors.black
                                          : AppColors.mutedWhite,
                                      letterSpacing: 0.3,
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
                ),
                const SizedBox(height: 18),

                // Main Views
                if (_selectedTab == 0) ...[
                  // ==========================================
                  // 1. ATTENDANCE & AUTOMATIC TASK ASSIGNMENT
                  // ==========================================
                  _buildAttendanceAndTaskSection(
                    context,
                    ops,
                    attendedCount: attendedCount,
                    totalCount: totalCount,
                    assignedCount: assignedCount,
                    unassignedAttendedCount: unassignedAttendedCount,
                    records: filteredRecords,
                  ),
                ] else ...[
                  // ==========================================
                  // 2. SCHEDULE TIMELINE
                  // ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INTERACTIVE SCHEDULE TIMELINE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8E8E8E),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'TAP TO CYCLE STATUS',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleTimeline(context, ops, scheduleItems),
                ],

                const SizedBox(height: 28),

                // Quick Team Roster Navigation
                _buildSecondaryActionCard(
                  context,
                  title: 'GOVERNANCE TEAM ROSTER',
                  subtitle: 'Inspect all 43 officers categorized by 4 leadership tiers & departments',
                  icon: LucideIcons.users,
                  onTap: () => context.push('/team_roster'),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              '$label: ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION: ATTENDANCE & TASK DEPLOYMENT CONSOLE
  // ----------------------------------------------------
  Widget _buildAttendanceAndTaskSection(
    BuildContext context,
    OperationsNotifier ops, {
    required int attendedCount,
    required int totalCount,
    required int assignedCount,
    required int unassignedAttendedCount,
    required List<AttendanceRecord> records,
  }) {
    final attendanceRatio = totalCount == 0 ? 0.0 : (attendedCount / totalCount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Master Dispatch Control Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryYellow.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.zap, size: 14, color: AppColors.primaryYellow),
                          const SizedBox(width: 6),
                          Text(
                            'AUTOMATED TASK DISPATCH ENGINE',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryYellow,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Officer Roll Call & Post Deployment',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(LucideIcons.moreVertical, color: AppColors.mutedWhite, size: 18),
                    color: AppColors.charcoal,
                    onSelected: (val) {
                      if (val == 'reset') {
                        _showResetAttendanceDialog(context, ops);
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'reset',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.trash, color: Colors.redAccent, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Reset Roll Call & Tasks',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // KPI Progress Metrics
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ATTENDANCE',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                            Text(
                              '$attendedCount / $totalCount (${(attendanceRatio * 100).toInt()}%)',
                              style: GoogleFonts.jetBrainsMono(
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
                          child: LinearProgressIndicator(
                            value: attendanceRatio,
                            minHeight: 6,
                            backgroundColor: AppColors.elevatedSurface,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryYellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$assignedCount',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        Text(
                          'POSTS ACTIVE',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Master 1-Tap Auto-Assign Button
              PressableScale(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  final newlyAssigned = ops.autoAssignTasksToAllAttended();
                  if (newlyAssigned > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: [
                            const Icon(LucideIcons.zap, color: Colors.black, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '⚡ $newlyAssigned operational tasks automatically dispatched to attended officers!',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.elevatedSurface,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          unassignedAttendedCount == 0
                              ? 'All currently attended officers already have tasks deployed.'
                              : 'No unassigned tasks remaining in operational pool.',
                          style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontSize: 12),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFDD00), Color(0xFFF59E0B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryYellow.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.zap, color: Colors.black, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        unassignedAttendedCount > 0
                            ? '⚡ AUTO-ASSIGN TASKS TO $unassignedAttendedCount ATTENDED OFFICERS'
                            : '⚡ AUTO-ASSIGN TASKS TO ATTENDED OFFICERS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Auto-Assign on Check-in Switch
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  ops.toggleAutoAssignOnCheckin();
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            ops.autoAssignOnCheckin ? LucideIcons.shieldCheck : LucideIcons.sliders,
                            size: 15,
                            color: ops.autoAssignOnCheckin
                                ? const Color(0xFF10B981)
                                : AppColors.mutedWhite,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Auto-assign departmental task on check-in',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ops.autoAssignOnCheckin ? AppColors.white : AppColors.mutedWhite,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: ops.autoAssignOnCheckin,
                        activeThumbColor: AppColors.primaryYellow,
                        activeTrackColor: AppColors.primaryYellow.withValues(alpha: 0.4),
                        inactiveThumbColor: AppColors.mutedWhite,
                        inactiveTrackColor: AppColors.elevatedSurface,
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          ops.setAutoAssignOnCheckin(val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() {}),
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Search officer name, department, or assigned post...',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.mutedWhite),
              prefixIcon: const Icon(LucideIcons.search, size: 16, color: AppColors.mutedWhite),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: 14, color: AppColors.mutedWhite),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Status Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('ALL', 'ALL (${ops.totalOfficersCount})'),
              _buildFilterChip('PRESENT', 'PRESENT (${ops.attendedOfficersCount})'),
              _buildFilterChip('PENDING', 'ABSENT (${ops.totalOfficersCount - ops.attendedOfficersCount})'),
              _buildFilterChip('ASSIGNED', 'WITH TASKS (${ops.assignedTasksCount})'),
              _buildFilterChip('NO_TASK', 'UNASSIGNED ($unassignedAttendedCount)'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Department Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDeptChip('ALL', 'ALL DEPTS'),
              _buildDeptChip('OPERATIONS', 'OPERATIONS'),
              _buildDeptChip('LOGISTICS', 'LOGISTICS'),
              _buildDeptChip('TECH', 'TECH'),
              _buildDeptChip('GRAPHICS', 'GRAPHICS'),
              _buildDeptChip('HOSPITALITY', 'HOSPITALITY'),
              _buildDeptChip('CORPORATE', 'CORPORATE'),
              _buildDeptChip('PANEL', 'PANEL'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Attendance & Tasks List (Immediate Visibility)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'OFFICER ROSTER (${records.length} SHOWN)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.mutedWhite,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '1-TAP CHECK-IN & AUTO-ASSIGN',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (records.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: [
                const Icon(LucideIcons.userX, size: 32, color: AppColors.mutedWhite),
                const SizedBox(height: 10),
                Text(
                  'No officers match the active filter criteria',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try clearing the search term or switching the status filter.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.mutedWhite,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final record = records[i];
              return _buildOfficerAttendanceCard(context, ops, record);
            },
          ),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedStatusFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PressableScale(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedStatusFilter = key);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryYellow : AppColors.charcoal,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.primaryYellow : AppColors.darkBorder,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : AppColors.mutedWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeptChip(String key, String label) {
    final isSelected = _selectedDeptFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PressableScale(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedDeptFilter = key);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? AppColors.primaryYellow : AppColors.darkBorder.withValues(alpha: 0.6),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryYellow : const Color(0xFF8E8E8E),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // OFFICER ATTENDANCE CARD WITH EMBEDDED TASK STATE
  // ----------------------------------------------------
  Widget _buildOfficerAttendanceCard(
    BuildContext context,
    OperationsNotifier ops,
    AttendanceRecord record,
  ) {
    final isPresent = record.isPresent;
    final task = record.assignedTask;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPresent
              ? (task != null ? const Color(0xFF10B981).withValues(alpha: 0.35) : AppColors.primaryYellow.withValues(alpha: 0.3))
              : AppColors.darkBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Officer Header & Attendance Toggle
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with Tier Color Border
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.elevatedSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: record.tierColor, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        record.avatarInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    if (isPresent)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.charcoal, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),

                // Name, Department & Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              record.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: record.departmentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: record.departmentColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              record.department,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: record.departmentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record.role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedWhite,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        record.tierLabel,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: record.tierColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Attendance Check-in Action Button
                PressableScale(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ops.toggleAttendance(record.memberId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPresent
                          ? const Color(0xFF10B981).withValues(alpha: 0.15)
                          : AppColors.elevatedSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isPresent
                            ? const Color(0xFF10B981)
                            : AppColors.darkBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPresent ? LucideIcons.checkCheck : LucideIcons.user,
                          size: 13,
                          color: isPresent ? const Color(0xFF10B981) : AppColors.mutedWhite,
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPresent ? 'ATTENDED' : 'CHECK IN',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: isPresent ? const Color(0xFF10B981) : AppColors.mutedWhite,
                              ),
                            ),
                            if (isPresent && record.checkInTime != null)
                              Text(
                                record.checkInTime!,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 8,
                                  color: const Color(0xFF10B981).withValues(alpha: 0.8),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Embedded Assigned Task Section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: isPresent
                  ? (task != null ? AppColors.elevatedSurface : AppColors.primaryYellow.withValues(alpha: 0.06))
                  : Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPresent
                    ? (task != null ? AppColors.darkBorder : AppColors.primaryYellow.withValues(alpha: 0.25))
                    : AppColors.darkBorder.withValues(alpha: 0.4),
              ),
            ),
            child: isPresent
                ? (task != null
                    ? _buildAssignedTaskDetails(context, ops, record, task)
                    : _buildUnassignedTaskPrompt(context, ops, record))
                : Row(
                    children: [
                      const Icon(LucideIcons.info, size: 13, color: AppColors.mutedWhite),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mark officer present to automatically dispatch post assignment.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontStyle: FontStyle.italic,
                            color: AppColors.mutedWhite.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedTaskDetails(
    BuildContext context,
    OperationsNotifier ops,
    AttendanceRecord record,
    OperationalTask task,
  ) {
    final isCompleted = task.status == 'COMPLETED';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: task.priorityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: task.priorityColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                task.priority.name.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: task.priorityColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                    : AppColors.primaryYellow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF10B981).withValues(alpha: 0.4)
                      : AppColors.primaryYellow.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                task.status,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: isCompleted ? const Color(0xFF10B981) : AppColors.primaryYellow,
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => _showTaskSelectionSheet(context, record, ops),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  children: [
                    const Icon(LucideIcons.edit2, size: 11, color: AppColors.mutedWhite),
                    const SizedBox(width: 4),
                    Text(
                      'Reassign',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          task.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isCompleted ? AppColors.mutedWhite : AppColors.white,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(LucideIcons.mapPin, size: 11, color: AppColors.primaryYellow),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                task.location,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: AppColors.mutedWhite,
                ),
              ),
            ),
            PressableScale(
              onTap: () {
                HapticFeedback.lightImpact();
                final nextStatus = isCompleted ? 'IN PROGRESS' : 'COMPLETED';
                ops.updateTaskStatus(task.id, nextStatus);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.elevatedSurface
                      : const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCompleted ? AppColors.darkBorder : const Color(0xFF10B981),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted ? LucideIcons.refresh : LucideIcons.check,
                      size: 11,
                      color: isCompleted ? AppColors.mutedWhite : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCompleted ? 'Reopen' : 'Done',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isCompleted ? AppColors.mutedWhite : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (task.notes.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            task.notes,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: AppColors.mutedWhite.withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUnassignedTaskPrompt(
    BuildContext context,
    OperationsNotifier ops,
    AttendanceRecord record,
  ) {
    return Row(
      children: [
        const Icon(LucideIcons.alertTriangle, size: 15, color: AppColors.primaryYellow),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Awaiting Operational Post Deployment',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryYellow,
                ),
              ),
              Text(
                'No task currently allocated for this officer.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: AppColors.mutedWhite,
                ),
              ),
            ],
          ),
        ),
        PressableScale(
          onTap: () {
            HapticFeedback.lightImpact();
            _showTaskSelectionSheet(context, record, ops);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.plus, size: 12, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  'Assign Task',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // TASK SELECTION & REASSIGNMENT MODAL BOTTOM SHEET
  // ----------------------------------------------------
  void _showTaskSelectionSheet(
    BuildContext context,
    AttendanceRecord member,
    OperationsNotifier ops,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1.5)),
          ),
          child: Column(
            children: [
              // Sheet Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.darkBorder)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ASSIGN OPERATIONAL POST',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryYellow,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            member.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '${member.role} · ${member.department}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.mutedWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: AppColors.mutedWhite),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),

              // Unassign Option (if currently assigned)
              if (member.assignedTask != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: PressableScale(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ops.unassignTask(member.assignedTask!.id);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task unassigned from officer.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Clear Current Assignment',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),

              // Task List from Pool
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ops.tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final task = ops.tasks[i];
                    final isCurrentlyThisMember = task.assignedToMemberId == member.memberId;
                    final isAssignedToOther = task.assignedToMemberId != null && !isCurrentlyThisMember;
                    final isDeptMatch = task.department.toUpperCase() == member.department.toUpperCase();

                    return PressableScale(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        ops.manualAssignTask(member.memberId, task.id);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              'Assigned "${task.title}" to ${member.name}.',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrentlyThisMember
                              ? AppColors.primaryYellow.withValues(alpha: 0.1)
                              : AppColors.charcoal,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrentlyThisMember
                                ? AppColors.primaryYellow
                                : (isDeptMatch ? const Color(0xFF60A5FA).withValues(alpha: 0.3) : AppColors.darkBorder),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: task.priorityColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: task.priorityColor.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    task.priority.name.toUpperCase(),
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: task.priorityColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.elevatedSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    task.department,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: isDeptMatch ? const Color(0xFF60A5FA) : AppColors.mutedWhite,
                                    ),
                                  ),
                                ),
                                if (isDeptMatch) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'DEPT MATCH',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                if (isCurrentlyThisMember)
                                  const Icon(LucideIcons.checkCircle, color: AppColors.primaryYellow, size: 16)
                                else if (isAssignedToOther)
                                  Text(
                                    'Assigned to ${task.assignedToMemberName?.split(' ').first}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              task.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(LucideIcons.mapPin, size: 11, color: AppColors.primaryYellow),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task.location,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppColors.mutedWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetAttendanceDialog(BuildContext context, OperationsNotifier ops) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Roll Call & Tasks?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        content: Text(
          'This will clear all check-in timestamps and unassign all operational tasks across the 43 team members.',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.mutedWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.mutedWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ops.resetAttendance();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance roll call and tasks reset.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'CONFIRM RESET',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // SECONDARY ACTION CARD
  // ----------------------------------------------------
  Widget _buildSecondaryActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CommandCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      borderColor: AppColors.darkBorder,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryYellow, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 3),
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
          ),
          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.mutedWhite),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // SCHEDULE TIMELINE
  // ----------------------------------------------------
  Widget _buildScheduleTimeline(
    BuildContext context,
    OperationsNotifier ops,
    List<ScheduleMilestone> items,
  ) {
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isLast = i == items.length - 1;
        return _buildScheduleItem(
          context,
          item: item,
          isLast: isLast,
          onTap: () => ops.toggleScheduleStatus(item.id),
        );
      }),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required ScheduleMilestone item,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    final isLive = item.status == 'LIVE';
    final isCompleted = item.status == 'COMPLETED';
    final isDelayed = item.status == 'DELAYED';

    Color getStatusColor() {
      if (isLive) return AppColors.primaryYellow;
      if (isCompleted) return const Color(0xFF10B981);
      if (isDelayed) return Colors.redAccent;
      return AppColors.mutedWhite;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 56,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    item.time,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: isLive ? FontWeight.w800 : FontWeight.w600,
                      color: isLive ? AppColors.primaryYellow : AppColors.mutedWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                if (isLive)
                  const PulsingBeacon(dotSize: 8, maxAuraSize: 20)
                else
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF10B981) : AppColors.charcoal,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? const Color(0xFF10B981) : AppColors.mutedWhite,
                        width: 1.5,
                      ),
                    ),
                  ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: (isLive || isCompleted)
                          ? AppColors.primaryYellow.withValues(alpha: 0.4)
                          : AppColors.darkBorder,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isLive
                        ? AppColors.primaryYellow.withValues(alpha: 0.08)
                        : AppColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLive
                          ? AppColors.primaryYellow.withValues(alpha: 0.5)
                          : AppColors.darkBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isCompleted
                                    ? AppColors.mutedWhite
                                    : AppColors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: getStatusColor().withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: getStatusColor().withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              item.status,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: getStatusColor(),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.location} · Lead: ${item.leadPerson}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.mutedWhite,
                        ),
                      ),
                      if (item.notes.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.notes,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.mutedWhite.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
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
}
