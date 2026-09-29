import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/models/event_ops_models.dart';
import '../../core/state/operations_state.dart';
import 'pressable_scale.dart';

class BroadcastDialog extends ConsumerStatefulWidget {
  const BroadcastDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BroadcastDialog(),
    );
  }

  @override
  ConsumerState<BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends ConsumerState<BroadcastDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  AlertPriority _priority = AlertPriority.urgent;
  String _audience = 'ALL OPERATIONAL TERMINALS';

  final List<String> _audiences = [
    'ALL OPERATIONAL TERMINALS',
    'LEAD OFFICERS & PANEL',
    'REGISTRATION & GATE CREW',
    'LOGISTICS & AV CREW',
    'SECURITY & EMERGENCY',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _dispatch() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty) return;

    final alert = BroadcastAlert(
      id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
      badge: _priority == AlertPriority.critical
          ? 'CRITICAL ALERT'
          : _priority == AlertPriority.urgent
              ? 'URGENT BROADCAST'
              : 'OPERATIONS NOTICE',
      title: title,
      time: 'Just now',
      description: body.isEmpty ? 'Action required immediately across stations.' : body,
      actionLabel: 'ACKNOWLEDGE & LOG',
      actionRoute: '/what_changed',
      priority: _priority,
      audience: _audience,
    );

    ref.read(operationsProvider).addBroadcast(alert);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: alert.priorityColor, width: 1.5),
        ),
        content: Row(
          children: [
            Icon(LucideIcons.megaphone, color: alert.priorityColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Broadcast dispatched to "$_audience"',
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
                      'TERMINAL TRANSMISSION',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryYellow,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Broadcast Operational Alert',
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

            // Priority Selector
            Text(
              'SEVERITY LEVEL',
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
                _buildPriorityChip(AlertPriority.info, 'INFO', const Color(0xFF34D399)),
                const SizedBox(width: 8),
                _buildPriorityChip(AlertPriority.routine, 'ROUTINE', const Color(0xFF60A5FA)),
                const SizedBox(width: 8),
                _buildPriorityChip(AlertPriority.urgent, 'URGENT', AppColors.primaryYellow),
                const SizedBox(width: 8),
                _buildPriorityChip(AlertPriority.critical, 'CRITICAL', AppColors.statusRed),
              ],
            ),
            const SizedBox(height: 16),

            // Target Audience
            Text(
              'RECIPIENT SCOPE',
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
              children: _audiences.map((aud) {
                final isSelected = _audience == aud;
                return InkWell(
                  onTap: () => setState(() => _audience = aud),
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
                      aud,
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

            // Alert Title
            Text(
              'ALERT HEADLINE *',
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
                hintText: 'e.g. Relocate Gate 2 scanner battery pack',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.mutedWhite.withValues(alpha: 0.5),
                ),
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

            // Directive details
            Text(
              'DIRECTIVE DETAILS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedWhite,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _bodyController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Provide specific instructions, affected zones or contacts...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.mutedWhite.withValues(alpha: 0.5),
                ),
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

            // Dispatch Button
            PressableScale(
              onTap: _dispatch,
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
                    const Icon(LucideIcons.megaphone, size: 16, color: AppColors.deepBlack),
                    const SizedBox(width: 8),
                    Text(
                      'TRANSMIT OPERATIONAL ALERT',
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

  Widget _buildPriorityChip(AlertPriority priority, String label, Color color) {
    final isSelected = _priority == priority;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = priority),
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
              label,
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
