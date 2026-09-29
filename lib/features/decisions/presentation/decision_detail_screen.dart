import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/operations_state.dart';
import '../../../shared/widgets/animated_glowing_border.dart';
import '../../../shared/widgets/gradient_mesh_background.dart';
import '../../../shared/widgets/pressable_scale.dart';
import '../../../shared/widgets/pulsing_beacon.dart';
import '../../../shared/widgets/shimmer_sweep.dart';
import '../../../shared/widgets/staggered_entrance.dart';

class DecisionDetailScreen extends ConsumerStatefulWidget {
  final String decisionId;

  const DecisionDetailScreen({super.key, required this.decisionId});

  @override
  ConsumerState<DecisionDetailScreen> createState() => _DecisionDetailScreenState();
}

class _DecisionDetailScreenState extends ConsumerState<DecisionDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    ref.read(operationsProvider).addDecisionComment(widget.decisionId, text);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final decision = ops.getDecision(widget.decisionId) ?? ops.decisions.first;

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
        title: Row(
          children: [
            Text(
              'DECISION #${decision.id}',
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
                decision.version,
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
            icon: const Icon(LucideIcons.share2, color: AppColors.mutedWhite, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: 'Directive #${decision.id}: ${decision.title}\n${decision.directiveText}'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.charcoal,
                  content: Text('Copied Directive #${decision.id} to clipboard.'),
                ),
              );
            },
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
                // Header Card
                StaggeredEntrance(
                  index: 0,
                  child: AnimatedGlowingBorder(
                    borderRadius: 18,
                    glowColor: decision.priorityColor,
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
                                  color: decision.priorityColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    PulsingBeacon(
                                      color: decision.priorityColor,
                                      dotSize: 4.5,
                                      maxAuraSize: 10,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${decision.priority} DIRECTIVE',
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: decision.priorityColor,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                decision.timestamp,
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
                              decision.title,
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
                            decision.directiveText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedWhite,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: decision.affectedDepartments.map((dept) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.elevatedSurface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.darkBorder),
                                ),
                                child: Text(
                                  dept.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryYellow,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Interactive Voting Section
                StaggeredEntrance(
                  index: 1,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'RATIFICATION BALLOT',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryYellow,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              '${decision.totalVotes} VOTES CAST',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedWhite,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress bar of approvals vs rejections
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 8,
                            color: AppColors.elevatedSurface,
                            child: Builder(
                              builder: (context) {
                                final int appFlex = (decision.approvalPercent * 100).toInt();
                                final int rejFlex = (decision.rejectionPercent * 100).toInt();
                                final int absFlex = (100 - appFlex - rejFlex).clamp(0, 100).toInt();
                                return Row(
                                  children: [
                                    if (appFlex > 0)
                                      Expanded(
                                        flex: appFlex,
                                        child: Container(color: const Color(0xFF10B981)),
                                      ),
                                    if (rejFlex > 0)
                                      Expanded(
                                        flex: rejFlex,
                                        child: Container(color: AppColors.statusRed),
                                      ),
                                    if (absFlex > 0)
                                      Expanded(
                                        flex: absFlex,
                                        child: Container(color: const Color(0xFF64748B)),
                                      ),
                                    if (appFlex == 0 && rejFlex == 0 && absFlex == 0)
                                      Expanded(
                                        child: Container(color: const Color(0xFF64748B)),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${decision.approvals} Approve (${(decision.approvalPercent * 100).toInt()}%)',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            Text(
                              '${decision.rejections} Reject',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.statusRed,
                              ),
                            ),
                            Text(
                              '${decision.abstains} Abstain',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Vote Buttons
                        Row(
                          children: [
                            _buildVoteButton(
                              label: 'APPROVE',
                              isSelected: decision.userVote == 'APPROVE',
                              color: const Color(0xFF10B981),
                              onTap: () => ops.castVote(decision.id, 'APPROVE'),
                            ),
                            const SizedBox(width: 8),
                            _buildVoteButton(
                              label: 'REJECT',
                              isSelected: decision.userVote == 'REJECT',
                              color: AppColors.statusRed,
                              onTap: () => ops.castVote(decision.id, 'REJECT'),
                            ),
                            const SizedBox(width: 8),
                            _buildVoteButton(
                              label: 'ABSTAIN',
                              isSelected: decision.userVote == 'ABSTAIN',
                              color: const Color(0xFF94A3B8),
                              onTap: () => ops.castVote(decision.id, 'ABSTAIN'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Directive Verification & Cryptographic Ledger
                StaggeredEntrance(
                  index: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.shieldCheck, color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'CRYPTOGRAPHIC AUDIT SEAL',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF34D399),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Signed by Executive Convening Panel with immutable SHA-256 seal:',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.mutedWhite),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: decision.sha256Hash));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.charcoal,
                                content: Text('SHA-256 hash copied to clipboard.'),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1117),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.darkBorder),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    decision.sha256Hash,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: AppColors.primaryYellow,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(LucideIcons.copy, size: 12, color: AppColors.mutedWhite),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Discussion / Notes Thread
                StaggeredEntrance(
                  index: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COORDINATION LOG (${decision.comments.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6E6E6E),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...decision.comments.map((c) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.charcoal,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${c.author} · ${c.role}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    c.time,
                                    style: GoogleFonts.jetBrainsMono(
                                      fontSize: 10,
                                      color: const Color(0xFF6E6E6E),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c.text,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.mutedWhite,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Comment input field
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white),
                              decoration: InputDecoration(
                                hintText: 'Add tactical clarification or status...',
                                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF6E6E6E)),
                                filled: true,
                                fillColor: AppColors.charcoal,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.darkBorder),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.darkBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.primaryYellow),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PressableScale(
                            onTap: _submitComment,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.send, size: 16, color: AppColors.deepBlack),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Acknowledge Toggle Button
                PressableScale(
                  onTap: () => ops.toggleAcknowledgeDecision(decision.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: decision.isAcknowledged
                          ? const Color(0xFF064E3B)
                          : AppColors.primaryYellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (decision.isAcknowledged ? const Color(0xFF10B981) : AppColors.primaryYellow)
                              .withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          decision.isAcknowledged ? LucideIcons.checkCheck : LucideIcons.shieldCheck,
                          color: decision.isAcknowledged ? Colors.white : AppColors.deepBlack,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          decision.isAcknowledged
                              ? 'DIRECTIVE ACKNOWLEDGED & RATIFIED'
                              : 'CONFIRM & ACKNOWLEDGE DIRECTIVE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: decision.isAcknowledged ? Colors.white : AppColors.deepBlack,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildVoteButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: PressableScale(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : AppColors.elevatedSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppColors.darkBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isSelected ? color : AppColors.mutedWhite,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
