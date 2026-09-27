import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../domain/team_member.dart';

class TeamRosterScreen extends StatefulWidget {
  const TeamRosterScreen({super.key});

  @override
  State<TeamRosterScreen> createState() => _TeamRosterScreenState();
}

class _TeamRosterScreenState extends State<TeamRosterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ExecutiveTier? _selectedTier; // null means 'ALL'
  Department? _selectedDepartment; // null means 'All'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TeamMember> _filterMembers(List<TeamMember> members) {
    return members.where((m) {
      if (_selectedTier != null && m.tier != _selectedTier) {
        return false;
      }
      if (_selectedDepartment != null && m.department != _selectedDepartment) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = m.name.toLowerCase().contains(q);
        final matchId = m.id.toLowerCase().contains(q);
        final matchRole = m.role.toLowerCase().contains(q);
        final matchDept = m.departmentLabel.toLowerCase().contains(q);
        final matchLocation = m.location.toLowerCase().contains(q);
        return matchName || matchId || matchRole || matchDept || matchLocation;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allMembers = TeamRosterRepository.members;
    final filtered = _filterMembers(allMembers);

    // Grouping by tiers
    final panelMembers = filtered.where((m) => m.tier == ExecutiveTier.panel).toList();
    final seniorMembers = filtered.where((m) => m.tier == ExecutiveTier.seniorExecutive).toList();
    final juniorMembers = filtered.where((m) => m.tier == ExecutiveTier.juniorExecutive).toList();
    final associateMembers = filtered.where((m) => m.tier == ExecutiveTier.associateExecutive).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: PressableScale(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go('/dashboard');
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.charcoal.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: const Icon(LucideIcons.arrowLeft, size: 18, color: AppColors.white),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'EXECUTIVE CORPS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '4 TIERS',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${allMembers.length} VERIFIED OFFICERS · DEPT IDS ACTIVE',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: AppColors.mutedWhite,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF022C22).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PulsingBeacon(
                  color: Color(0xFF10B981),
                  dotSize: 6,
                  maxAuraSize: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'ROSTER SYNCED',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF34D399),
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GradientMeshBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Sticky Filter Header
              _buildFilterSection(allMembers),

              // Scrollable Content
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                        children: [
                          // 1. PANEL SECTION
                          if (panelMembers.isNotEmpty) ...[
                            _buildSectionHeader(
                              sectionNumber: '01',
                              tierTitle: 'PANEL',
                              tierRole: 'CHIEF GOVERNANCE & OVERALL CONVENING',
                              description: 'Governing board & convening officers with supreme operational clearance.',
                              count: panelMembers.length,
                              accentColor: AppColors.primaryYellow,
                              icon: LucideIcons.crown,
                            ),
                            const SizedBox(height: 12),
                            ...panelMembers.asMap().entries.map((entry) => _buildMemberCard(entry.value, entry.key)),
                            const SizedBox(height: 28),
                          ],

                          // 2. SENIOR EXECUTIVES SECTION
                          if (seniorMembers.isNotEmpty) ...[
                            _buildSectionHeader(
                              sectionNumber: '02',
                              tierTitle: 'SENIOR EXECUTIVES',
                              tierRole: 'DEPARTMENT DIRECTORS & STRATEGY LEADS',
                              description: 'Departmental leads commanding Graphics, Logistics, Tech, Operations, and Hospitality.',
                              count: seniorMembers.length,
                              accentColor: const Color(0xFFF59E0B),
                              icon: LucideIcons.award,
                            ),
                            const SizedBox(height: 12),
                            ...seniorMembers.asMap().entries.map((entry) => _buildMemberCard(entry.value, entry.key)),
                            const SizedBox(height: 28),
                          ],

                          // 3. JUNIOR EXECUTIVES SECTION
                          if (juniorMembers.isNotEmpty) ...[
                            _buildSectionHeader(
                              sectionNumber: '03',
                              tierTitle: 'JUNIOR EXECUTIVES',
                              tierRole: 'UNIT COORDINATORS & LOGISTICAL LEADS',
                              description: 'Operational co-leads spearheading gate scanners, motion graphics, stage prompt & concierge.',
                              count: juniorMembers.length,
                              accentColor: const Color(0xFF38BDF8),
                              icon: LucideIcons.zap,
                            ),
                            const SizedBox(height: 12),
                            ...juniorMembers.asMap().entries.map((entry) => _buildMemberCard(entry.value, entry.key)),
                            const SizedBox(height: 28),
                          ],

                          // 4. ASSOCIATE EXECUTIVES SECTION
                          if (associateMembers.isNotEmpty) ...[
                            _buildSectionHeader(
                              sectionNumber: '04',
                              tierTitle: 'ASSOCIATE EXECUTIVES',
                              tierRole: 'FIELD MARSHALS & APPARATUS OPERATORS',
                              description: 'Field specialists managing barcode terminals, audio runners, print dispatch & hospitality.',
                              count: associateMembers.length,
                              accentColor: const Color(0xFF94A3B8),
                              icon: LucideIcons.layers,
                            ),
                            const SizedBox(height: 12),
                            ...associateMembers.asMap().entries.map((entry) => _buildMemberCard(entry.value, entry.key)),
                            const SizedBox(height: 20),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(List<TeamMember> allMembers) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepBlack.withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _searchQuery.isNotEmpty
                    ? AppColors.primaryYellow.withValues(alpha: 0.6)
                    : AppColors.darkBorder,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.search,
                  size: 16,
                  color: _searchQuery.isNotEmpty ? AppColors.primaryYellow : AppColors.mutedWhite,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by officer name, ID (#SPC-...), or role...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.mutedWhite.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.x, size: 12, color: AppColors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tier Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildTierChip(
                  label: 'ALL',
                  count: allMembers.length,
                  isSelected: _selectedTier == null,
                  onTap: () => setState(() => _selectedTier = null),
                  color: AppColors.primaryYellow,
                ),
                const SizedBox(width: 8),
                _buildTierChip(
                  label: '1. PANEL',
                  count: allMembers.where((m) => m.tier == ExecutiveTier.panel).length,
                  isSelected: _selectedTier == ExecutiveTier.panel,
                  onTap: () => setState(() => _selectedTier = ExecutiveTier.panel),
                  color: AppColors.primaryYellow,
                ),
                const SizedBox(width: 8),
                _buildTierChip(
                  label: '2. SENIOR EXEC',
                  count: allMembers.where((m) => m.tier == ExecutiveTier.seniorExecutive).length,
                  isSelected: _selectedTier == ExecutiveTier.seniorExecutive,
                  onTap: () => setState(() => _selectedTier = ExecutiveTier.seniorExecutive),
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 8),
                _buildTierChip(
                  label: '3. JUNIOR EXEC',
                  count: allMembers.where((m) => m.tier == ExecutiveTier.juniorExecutive).length,
                  isSelected: _selectedTier == ExecutiveTier.juniorExecutive,
                  onTap: () => setState(() => _selectedTier = ExecutiveTier.juniorExecutive),
                  color: const Color(0xFF38BDF8),
                ),
                const SizedBox(width: 8),
                _buildTierChip(
                  label: '4. ASSOCIATE',
                  count: allMembers.where((m) => m.tier == ExecutiveTier.associateExecutive).length,
                  isSelected: _selectedTier == ExecutiveTier.associateExecutive,
                  onTap: () => setState(() => _selectedTier = ExecutiveTier.associateExecutive),
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Department Quick Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildDeptFilterBadge(
                  label: 'All Depts',
                  isSelected: _selectedDepartment == null,
                  onTap: () => setState(() => _selectedDepartment = null),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Graphics',
                  deptColor: const Color(0xFFC084FC),
                  isSelected: _selectedDepartment == Department.graphics,
                  onTap: () => setState(() => _selectedDepartment = Department.graphics),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Logistics',
                  deptColor: const Color(0xFFFB923C),
                  isSelected: _selectedDepartment == Department.logistics,
                  onTap: () => setState(() => _selectedDepartment = Department.logistics),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Tech & IT',
                  deptColor: const Color(0xFF38BDF8),
                  isSelected: _selectedDepartment == Department.tech,
                  onTap: () => setState(() => _selectedDepartment = Department.tech),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Operations',
                  deptColor: const Color(0xFF4ADE80),
                  isSelected: _selectedDepartment == Department.operations,
                  onTap: () => setState(() => _selectedDepartment = Department.operations),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Hospitality',
                  deptColor: const Color(0xFFF472B6),
                  isSelected: _selectedDepartment == Department.hospitality,
                  onTap: () => setState(() => _selectedDepartment = Department.hospitality),
                ),
                const SizedBox(width: 6),
                _buildDeptFilterBadge(
                  label: 'Corporate',
                  deptColor: const Color(0xFF60A5FA),
                  isSelected: _selectedDepartment == Department.corporateRelations,
                  onTap: () => setState(() => _selectedDepartment = Department.corporateRelations),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierChip({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : AppColors.charcoal,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppColors.darkBorder,
            width: isSelected ? 1.4 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color : AppColors.mutedWhite,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? color : AppColors.mutedWhite.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptFilterBadge({
    required String label,
    Color? deptColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final effectiveColor = deptColor ?? AppColors.primaryYellow;
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? effectiveColor.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? effectiveColor : AppColors.darkBorder.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (deptColor != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: deptColor,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? effectiveColor : AppColors.mutedWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String sectionNumber,
    required String tierTitle,
    required String tierRole,
    required String description,
    required int count,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.12),
            AppColors.charcoal.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                ),
                child: Icon(icon, size: 18, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'SECTION $sectionNumber · ',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          tierTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tierRole,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedWhite,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$count OFFICERS',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              color: AppColors.mutedWhite.withValues(alpha: 0.8),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member, int index) {
    final statusColor = member.status == 'ONLINE'
        ? const Color(0xFF10B981)
        : member.status == 'DISPATCHED'
            ? const Color(0xFF38BDF8)
            : const Color(0xFFF59E0B);

    return StaggeredEntrance(
      index: index % 6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: PressableScale(
          onTap: () => _showMemberCredentials(member),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.charcoal.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: member.tier == ExecutiveTier.panel
                    ? AppColors.primaryYellow.withValues(alpha: 0.35)
                    : AppColors.darkBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with department accent
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        member.departmentColor.withValues(alpha: 0.35),
                        member.departmentBgColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: member.departmentColor.withValues(alpha: 0.6)),
                  ),
                  child: Center(
                    child: Text(
                      member.avatarInitials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Core Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Monospace ID Badge + Department Chip
                      Row(
                        children: [
                          // Separate ID Badge formatted prominently
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: member.departmentColor.withValues(alpha: 0.7),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.fingerprint,
                                  size: 11,
                                  color: member.departmentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  member.id,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: member.departmentColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Department Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: member.departmentBgColor.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              member.departmentLabel,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: member.departmentColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Member Name
                      Text(
                        member.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Member Role
                      Text(
                        member.role,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.mutedWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Telemetry strip: Status + Location
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  member.status,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.mapPin,
                                  size: 11,
                                  color: AppColors.mutedWhite,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    member.location,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppColors.mutedWhite.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Action
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 6.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.elevatedSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: const Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: AppColors.mutedWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMemberCredentials(TeamMember member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          decoration: BoxDecoration(
            color: AppColors.deepBlack,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: member.departmentColor.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: member.departmentColor.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.shieldCheck, size: 16, color: member.departmentColor),
                      const SizedBox(width: 8),
                      Text(
                        'SPECTRUM CORPS IDENTITY VERIFICATION',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: member.departmentColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18, color: AppColors.mutedWhite),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.darkBorder, height: 20),

              // Officer Hero
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          member.departmentColor.withValues(alpha: 0.4),
                          member.departmentBgColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: member.departmentColor, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        member.avatarInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
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
                            fontSize: 13,
                            color: AppColors.mutedWhite,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: member.tierColor.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: member.tierColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            member.tierLabel,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: member.tierColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Digital ID Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: member.departmentColor.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DEPARTMENT OPERATIONAL ID',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mutedWhite,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'SECURE CREDENTIAL',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.id,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: member.departmentColor,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const Divider(color: AppColors.darkBorder, height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetaField('DEPARTMENT', member.departmentLabel),
                        ),
                        Expanded(
                          child: _buildMetaField('LOCATION', member.location),
                        ),
                        Expanded(
                          child: _buildMetaField('STATUS', member.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: PressableScale(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        context.push('/chat/coordinators');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: member.departmentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.messageSquare, size: 16, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              'OPEN COMM-LINK',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (member.phone != null) ...[
                    const SizedBox(width: 10),
                    PressableScale(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.charcoal,
                            content: Text(
                              'Connecting direct phone radio to ${member.name} (${member.phone})...',
                              style: GoogleFonts.plusJakartaSans(color: AppColors.white),
                            ),
                            behavior: SnackBarBehavior.floating,
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
                        child: const Icon(LucideIcons.phoneCall, size: 18, color: AppColors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetaField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: AppColors.mutedWhite.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Icon(LucideIcons.userX, size: 36, color: AppColors.mutedWhite),
            ),
            const SizedBox(height: 16),
            Text(
              'NO OFFICERS FOUND',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No personnel matched your search query or department filters.\nTry resetting filters to view all 38 roster records.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.mutedWhite,
              ),
            ),
            const SizedBox(height: 20),
            PressableScale(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedTier = null;
                  _selectedDepartment = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'RESET ALL FILTERS',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
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
