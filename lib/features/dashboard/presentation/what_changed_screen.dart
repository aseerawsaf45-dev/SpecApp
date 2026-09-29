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
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class WhatChangedScreen extends ConsumerStatefulWidget {
  const WhatChangedScreen({super.key});

  @override
  ConsumerState<WhatChangedScreen> createState() => _WhatChangedScreenState();
}

class _WhatChangedScreenState extends ConsumerState<WhatChangedScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['ALL', 'DECISIONS', 'DOCUMENTS', 'SCHEDULE'];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final allLogs = ops.auditLogs;

    final filtered = allLogs.where((log) {
      if (_selectedFilterIndex != 0) {
        final targetCat = _filters[_selectedFilterIndex];
        if (!log.category.toUpperCase().contains(targetCat)) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return log.title.toLowerCase().contains(q) ||
            log.description.toLowerCase().contains(q) ||
            log.category.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
        title: Text(
          'AUDIT TRAIL',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download, color: AppColors.mutedWhite, size: 20),
            onPressed: () {
              final manifest = allLogs.map((l) => '[${l.time}] (${l.category}) ${l.title}: ${l.description}').join('\n');
              Clipboard.setData(ClipboardData(text: '=== OPERATIONS AUDIT LEDGER ===\n$manifest'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.charcoal,
                  content: Text('Audit ledger export copied to clipboard.'),
                ),
              );
            },
          ),
        ],
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
                const SizedBox(height: 18),

                // Search Box
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search, size: 16, color: AppColors.primaryYellow),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: 'Filter changes by keywords...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF6E6E6E)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                          icon: const Icon(LucideIcons.x, size: 14, color: AppColors.mutedWhite),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

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
                const SizedBox(height: 24),

                // Dynamic Timeline Items
                if (filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No operational updates in this category.',
                        style: GoogleFonts.plusJakartaSans(color: AppColors.mutedWhite, fontSize: 13),
                      ),
                    ),
                  )
                else
                  ...List.generate(filtered.length, (i) {
                    final item = filtered[i];
                    final isLast = i == filtered.length - 1;
                    return StaggeredEntrance(
                      index: i + 2,
                      child: _buildTimelineItem(
                        context,
                        item: item,
                        isLast: isLast,
                        onTap: item.route != null ? () => context.push(item.route!) : null,
                      ),
                    );
                  }),
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
    required AuditTrailItem item,
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
                  item.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: item.isHighlight ? FontWeight.w800 : FontWeight.w500,
                    color: item.isHighlight ? AppColors.primaryYellow : const Color(0xFF6E6E6E),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              if (item.isHighlight)
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
                borderColor: item.isHighlight ? AppColors.primaryYellow.withValues(alpha: 0.35) : AppColors.darkBorder,
                hasPriorityGlow: item.isHighlight,
                glowColor: AppColors.primaryYellow,
                glowBlur: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isHighlight
                            ? AppColors.primaryYellow.withValues(alpha: 0.12)
                            : AppColors.elevatedSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite,
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
                                  item.category,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: item.isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite,
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
                            item.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
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
