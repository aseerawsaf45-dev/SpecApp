import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/models/event_ops_models.dart';
import '../../core/state/operations_state.dart';
import 'pressable_scale.dart';

class ProposeDecisionSheet extends ConsumerStatefulWidget {
  const ProposeDecisionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProposeDecisionSheet(),
    );
  }

  @override
  ConsumerState<ProposeDecisionSheet> createState() => _ProposeDecisionSheetState();
}

class _ProposeDecisionSheetState extends ConsumerState<ProposeDecisionSheet> {
  final _titleController = TextEditingController();
  final _directiveController = TextEditingController();
  String _priority = 'URGENT';
  String _category = 'LOGISTICS & OPS';

  final List<String> _categories = [
    'LOGISTICS & OPS',
    'SECURITY & CROWD',
    'AV & PRODUCTION',
    'HOSPITALITY',
    'FINANCE & ASSETS',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _directiveController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final directive = _directiveController.text.trim();
    if (title.isEmpty || directive.isEmpty) return;

    final ops = ref.read(operationsProvider);
    final nextNumber = (ops.decisions.length + 24).toString().padLeft(3, '0');

    final newDecision = DecisionModel(
      id: nextNumber,
      title: title.toUpperCase(),
      directiveText: directive,
      category: _category,
      priority: _priority,
      status: 'PENDING REVIEW',
      proposer: ops.currentUserName,
      approvals: 1, // proposer automatically approves
      rejections: 0,
      abstains: 0,
      userVote: 'APPROVE',
      isAcknowledged: true,
      timestamp: 'Today · Just now',
      sha256Hash: '${DateTime.now().millisecondsSinceEpoch}c8e421098fb54a8b89e2110c7499df193',
      affectedDepartments: [_category],
      comments: [
        DecisionComment(
          id: 'c-init',
          author: ops.currentUserName,
          role: ops.currentUserRole,
          text: 'Directive proposed for operational review and ratification.',
          time: 'Just now',
        ),
      ],
    );

    ops.createDecision(newDecision);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.primaryYellow, width: 1.5),
        ),
        content: Row(
          children: [
            const Icon(LucideIcons.fileSignature, color: AppColors.primaryYellow, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Directive #$nextNumber created and published for team voting.',
                style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1.5)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mutedWhite.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONVENE DIRECTIVE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryYellow,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Propose Decision Directive',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: AppColors.mutedWhite),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Priority Selection
            Text(
              'PRIORITY LEVEL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPriorityChip('ROUTINE', const Color(0xFF60A5FA)),
                const SizedBox(width: 8),
                _buildPriorityChip('HIGH', AppColors.primaryYellow),
                const SizedBox(width: 8),
                _buildPriorityChip('URGENT', AppColors.statusRed),
              ],
            ),
            const SizedBox(height: 16),

            // Department Category
            Text(
              'DEPARTMENT DOMAIN',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _category == cat;
                return InkWell(
                  onTap: () => setState(() => _category = cat),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      cat,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.primaryYellow : AppColors.mutedWhite,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Directive Title
            Text(
              'DIRECTIVE TITLE *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'e.g. VIP Green Room Relocation to Hall B',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF6E6E6E)),
                filled: true,
                fillColor: AppColors.charcoal,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            const SizedBox(height: 14),

            // Full description
            Text(
              'OPERATIONAL DIRECTIVE TEXT *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _directiveController,
              maxLines: 4,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'State rationale, required coordination, timing and operational impact...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF6E6E6E)),
                filled: true,
                fillColor: AppColors.charcoal,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            const SizedBox(height: 24),

            // Submit Button
            PressableScale(
              onTap: _submit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.fileSignature, size: 16, color: AppColors.deepBlack),
                    const SizedBox(width: 8),
                    Text(
                      'CONVENE & OPEN VOTING',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
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
    );
  }

  Widget _buildPriorityChip(String p, Color color) {
    final isSelected = _priority == p;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = p),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.18) : AppColors.charcoal,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppColors.darkBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              p,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isSelected ? color : AppColors.mutedWhite,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
