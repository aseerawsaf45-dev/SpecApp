import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/models/event_ops_models.dart';
import '../../core/state/operations_state.dart';
import 'pressable_scale.dart';

class CreateEventSheet extends ConsumerStatefulWidget {
  const CreateEventSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateEventSheet(),
    );
  }

  @override
  ConsumerState<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends ConsumerState<CreateEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _leadController = TextEditingController(text: 'Salman Farshi Alam');
  final _daysController = TextEditingController(text: '30');
  final _attendeesController = TextEditingController(text: '450');

  String _selectedPhase = 'PREPARATION PHASE';
  final List<String> _phases = [
    'PREPARATION PHASE',
    'LOGISTICS PLANNING',
    'EARLY DRAFT',
    'LIVE EXECUTION',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _leadController.dispose();
    _daysController.dispose();
    _attendeesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final days = int.tryParse(_daysController.text.trim()) ?? 30;
    final attendees = int.tryParse(_attendeesController.text.trim()) ?? 400;

    final newEvent = OperationalEvent(
      id: 'event-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim().isEmpty
          ? 'Spectrum · Operations Deployment'
          : _subtitleController.text.trim(),
      phase: _selectedPhase,
      daysLeft: days,
      progress: 0.15,
      membersCount: 24,
      lead: _leadController.text.trim(),
      isFeatured: false,
      targetAttendees: attendees,
      checkedInCount: 0,
      date: DateTime.now().add(Duration(days: days)),
    );

    ref.read(operationsProvider).addEvent(newEvent);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.primaryYellow, width: 1),
        ),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: AppColors.primaryYellow, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Event "${newEvent.title}" deployed to Operations Portfolio.',
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill handle
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
                        'NEW EVENT DEPLOYMENT',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryYellow,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Configure Operational Event',
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

              // Title input
              _buildInputLabel('EVENT NAME *'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _titleController,
                hintText: 'e.g. MechTech Arena 2026',
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter event name' : null,
              ),
              const SizedBox(height: 14),

              // Subtitle
              _buildInputLabel('SHORT DESCRIPTION / TAGLINE'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _subtitleController,
                hintText: 'e.g. Robotics & Hardware Prototyping Showcase',
              ),
              const SizedBox(height: 14),

              // Phase selector
              _buildInputLabel('OPERATIONAL PHASE'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _phases.map((p) {
                  final isSelected = _selectedPhase == p;
                  return InkWell(
                    onTap: () => setState(() => _selectedPhase = p),
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
                        p,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppColors.primaryYellow : AppColors.mutedWhite,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Row with Days Left and Target Attendees
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('DAYS REMAINING'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _daysController,
                          hintText: '30',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('TARGET ATTENDEES'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _attendeesController,
                          hintText: '500',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Lead
              _buildInputLabel('ASSIGNED LEAD OFFICER'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _leadController,
                hintText: 'e.g. Salman Farshi Alam',
              ),
              const SizedBox(height: 24),

              // Submit button
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
                  child: Center(
                    child: Text(
                      'DEPLOY EVENT TO PORTFOLIO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepBlack,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.mutedWhite,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.white),
      decoration: InputDecoration(
        hintText: hintText,
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
    );
  }
}
