import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/state/operations_state.dart';
import 'pressable_scale.dart';
import 'pulsing_beacon.dart';

class FastCheckinSheet extends ConsumerStatefulWidget {
  const FastCheckinSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FastCheckinSheet(),
    );
  }

  @override
  ConsumerState<FastCheckinSheet> createState() => _FastCheckinSheetState();
}

class _FastCheckinSheetState extends ConsumerState<FastCheckinSheet>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _institutionController = TextEditingController();
  final _teamController = TextEditingController();
  late AnimationController _scannerAnim;

  final List<Map<String, String>> _sampleAttendees = [
    {'name': 'Tanvir Mahin', 'inst': 'BUET', 'team': 'Cipher Knights'},
    {'name': 'Sadia Afrin', 'inst': 'IBA, Dhaka University', 'team': 'Apex Core'},
    {'name': 'Zubair Hossain', 'inst': 'North South University', 'team': 'Venture Craft'},
    {'name': 'Maliha Tabassum', 'inst': 'BRAC University', 'team': 'Nexus Alpha'},
    {'name': 'Arifur Rahman', 'inst': 'Islamic University of Tech', 'team': 'Quantum Ops'},
  ];

  @override
  void initState() {
    super.initState();
    _scannerAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _teamController.dispose();
    _scannerAnim.dispose();
    super.dispose();
  }

  void _verifyQuick() {
    final ops = ref.read(operationsProvider);
    final randomSample = _sampleAttendees[Random().nextInt(_sampleAttendees.length)];

    final name = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : randomSample['name']!;
    final inst = _institutionController.text.trim().isNotEmpty
        ? _institutionController.text.trim()
        : randomSample['inst']!;
    final team = _teamController.text.trim().isNotEmpty
        ? _teamController.text.trim()
        : randomSample['team']!;

    ops.simulateCheckIn(name, inst, team);

    _nameController.clear();
    _institutionController.clear();
    _teamController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF022C22),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
        ),
        content: Row(
          children: [
            const Icon(LucideIcons.checkCheck, color: Color(0xFF34D399), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Verified: $name ($team) · Access Granted',
                style: GoogleFonts.plusJakartaSans(color: AppColors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ops = ref.watch(operationsProvider);
    final event = ops.activeEvent;
    final scanned = ops.scannedParticipants;
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
                    Row(
                      children: [
                        const PulsingBeacon(
                          color: Color(0xFF10B981),
                          dotSize: 5,
                          maxAuraSize: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'GATE 2 SCANNER TERMINAL',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF34D399),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Live Participant Check-In',
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
            const SizedBox(height: 18),

            // Live HUD Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'CHECKED IN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mutedWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${event.checkedInCount}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 38, color: AppColors.darkBorder),
                  Column(
                    children: [
                      Text(
                        'CAPACITY TARGET',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mutedWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${event.targetAttendees}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 38, color: AppColors.darkBorder),
                  Column(
                    children: [
                      Text(
                        'INTAKE RATE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mutedWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${((event.checkedInCount / event.targetAttendees) * 100).toInt()}%',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Scanner Simulation Reticle
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _scannerAnim,
                    builder: (context, _) {
                      return Positioned(
                        top: 20 + (_scannerAnim.value * 75),
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF10B981),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withValues(alpha: 0.6),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.qrCode, size: 36, color: Color(0xFF34D399)),
                      const SizedBox(height: 6),
                      Text(
                        'OPTICAL LASER SCANNER ACTIVE',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF34D399),
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Point camera at badge QR or use one-tap simulate below',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppColors.mutedWhite.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Manual Check-In Inputs
            Text(
              'FAST PARTICIPANT VERIFICATION',
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
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Participant Name',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF6E6E6E)),
                      filled: true,
                      fillColor: AppColors.charcoal,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _teamController,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: 'Team Name',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF6E6E6E)),
                      filled: true,
                      fillColor: AppColors.charcoal,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.darkBorder),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // One-tap Verification Action Button
            PressableScale(
              onTap: _verifyQuick,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.checkCheck, size: 18, color: AppColors.white),
                    const SizedBox(width: 8),
                    Text(
                      'VERIFY & GRANT GATE ENTRY',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent scanned feed
            Text(
              'RECENT VERIFIED ENTRIES (${scanned.length})',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6E6E6E),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...scanned.take(4).map((p) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF064E3B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(LucideIcons.check, size: 14, color: Color(0xFF34D399)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            '${p.teamName} · ${p.institution}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.mutedWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          p.timeScanned,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryYellow,
                          ),
                        ),
                        Text(
                          p.id,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: const Color(0xFF6E6E6E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
