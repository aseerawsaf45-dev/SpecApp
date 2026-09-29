import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import 'pressable_scale.dart';

class DocumentViewerSheet extends StatefulWidget {
  final String title;
  final String documentType;

  const DocumentViewerSheet({
    super.key,
    required this.title,
    this.documentType = 'OFFICIAL DOCUMENT',
  });

  static Future<void> show(BuildContext context, {required String title, String documentType = 'OFFICIAL DOCUMENT'}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DocumentViewerSheet(title: title, documentType: documentType),
    );
  }

  @override
  State<DocumentViewerSheet> createState() => _DocumentViewerSheetState();
}

class _DocumentViewerSheetState extends State<DocumentViewerSheet> {
  int _activeTabIndex = 0;
  final List<String> _tabs = ['ATTENDEES', 'GATES & VENUE', 'EMERGENCY PROTOCOL'];

  final List<Map<String, String>> _rosterData = [
    {'id': 'CAS-001', 'team': 'Apex Advisors', 'lead': 'Farhan Ahmed', 'booth': 'B-12', 'status': 'VERIFIED'},
    {'id': 'CAS-002', 'team': 'Cipher Knights', 'lead': 'Tanvir Mahin', 'booth': 'B-14', 'status': 'VERIFIED'},
    {'id': 'CAS-003', 'team': 'Matrix Dynamics', 'lead': 'Abrar Zahin', 'booth': 'C-01', 'status': 'CHECKED IN'},
    {'id': 'CAS-004', 'team': 'Stratagem Co.', 'lead': 'Samira Anjum', 'booth': 'C-04', 'status': 'CHECKED IN'},
    {'id': 'CAS-005', 'team': 'Vanguard Alpha', 'lead': 'Farhan Kabir', 'booth': 'D-09', 'status': 'PENDING'},
    {'id': 'CAS-006', 'team': 'Nexus Alpha', 'lead': 'Maliha Tabassum', 'booth': 'D-11', 'status': 'VERIFIED'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.darkBorder, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
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
                    widget.documentType,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryYellow,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
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
          const SizedBox(height: 16),

          // Tabs
          Container(
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final isSelected = _activeTabIndex == i;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _activeTabIndex = i),
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryYellow.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: isSelected ? Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.4)) : null,
                      ),
                      child: Center(
                        child: Text(
                          _tabs[i],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? AppColors.primaryYellow : AppColors.mutedWhite,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Tab content
          Expanded(
            child: _activeTabIndex == 0
                ? _buildAttendeesTab()
                : _activeTabIndex == 1
                    ? _buildGatesTab()
                    : _buildEmergencyTab(),
          ),

          const SizedBox(height: 12),
          // Export / Share action
          Row(
            children: [
              Expanded(
                child: PressableScale(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: 'Exported: ${widget.title} (Verified Master List)'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.charcoal,
                        content: Text('Document link and manifest copied to clipboard.'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.download, size: 16, color: AppColors.deepBlack),
                        const SizedBox(width: 8),
                        Text(
                          'EXPORT VERIFIED MANIFEST',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesTab() {
    return ListView.separated(
      itemCount: _rosterData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final item = _rosterData[i];
        final isChecked = item['status'] == 'CHECKED IN';
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['id']!,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['team']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      'Lead: ${item['lead']} · Booth ${item['booth']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.mutedWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isChecked ? const Color(0xFF064E3B) : AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  item['status']!,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isChecked ? const Color(0xFF34D399) : AppColors.mutedWhite,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGatesTab() {
    return ListView(
      children: [
        _buildVenueCard('GATE 1 (NORTH)', 'VIP, Judges & Faculty Entrance', '2 Scanners Active · Clearance Zone A', AppColors.primaryYellow),
        const SizedBox(height: 10),
        _buildVenueCard('GATE 2 (AUDITORIUM MAIN)', 'Primary Participant & Delegate Check-In', '6 Optical Scanners · Kit Distribution', const Color(0xFF34D399)),
        const SizedBox(height: 10),
        _buildVenueCard('GATE 3 (SERVICE / REAR)', 'Logistics, Staging Crew & Equipment Load-In', 'Heavy Freight Access · Clearance Zone C', const Color(0xFF60A5FA)),
        const SizedBox(height: 10),
        _buildVenueCard('AUDITORIUM GREEN ROOM', 'Chief Guest Welcome & Jury Private Deliberation', 'High Security · Dedicated Liaison Desk', const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildEmergencyTab() {
    return ListView(
      children: [
        _buildVenueCard('FIRST AID STATION', 'Room 104 Beside East Wing Stairwell', 'Doctor on Call · Trauma Kit & Oxygen', AppColors.statusRed),
        const SizedBox(height: 10),
        _buildVenueCard('EVACUATION QUADRANGLE', 'Central Open Field (Assembly Point Alpha)', 'Clear path from Auditorium exits 1, 2, 3, 4', const Color(0xFF34D399)),
        const SizedBox(height: 10),
        _buildVenueCard('CAMPUS SECURITY CONTROL', 'Admin Building Desk 02', 'Direct Hotline: ext 4499 / Mobile +880 1711-999999', AppColors.primaryYellow),
      ],
    );
  }

  Widget _buildVenueCard(String title, String subtitle, String status, Color accent) {
    return Container(
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
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.mutedWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
