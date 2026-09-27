import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum ExecutiveTier {
  panel,
  seniorExecutive,
  juniorExecutive,
  associateExecutive,
}

enum Department {
  graphics,
  logistics,
  tech,
  operations,
  hospitality,
  corporateRelations,
  panelManagement,
}

class TeamMember {
  final String id;
  final String name;
  final String role;
  final ExecutiveTier tier;
  final Department department;
  final String departmentLabel;
  final String location;
  final String status;
  final String avatarInitials;
  final String? phone;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.tier,
    required this.department,
    required this.departmentLabel,
    required this.location,
    required this.status,
    required this.avatarInitials,
    this.phone,
  });

  Color get departmentColor {
    switch (department) {
      case Department.graphics:
        return const Color(0xFFC084FC); // Vibrant Purple / Violet
      case Department.logistics:
        return const Color(0xFFFB923C); // Warm Amber / Orange
      case Department.tech:
        return const Color(0xFF38BDF8); // Cyber Cyan
      case Department.operations:
        return const Color(0xFF4ADE80); // Emerald Green
      case Department.hospitality:
        return const Color(0xFFF472B6); // Rose Pink
      case Department.corporateRelations:
        return const Color(0xFF60A5FA); // Sky Blue
      case Department.panelManagement:
        return AppColors.primaryYellow; // Signature Gold
    }
  }

  Color get departmentBgColor {
    switch (department) {
      case Department.graphics:
        return const Color(0xFF2E1065);
      case Department.logistics:
        return const Color(0xFF431407);
      case Department.tech:
        return const Color(0xFF082F49);
      case Department.operations:
        return const Color(0xFF064E3B);
      case Department.hospitality:
        return const Color(0xFF4C0519);
      case Department.corporateRelations:
        return const Color(0xFF172554);
      case Department.panelManagement:
        return const Color(0xFF3D2800);
    }
  }

  String get tierLabel {
    switch (tier) {
      case ExecutiveTier.panel:
        return 'PANEL';
      case ExecutiveTier.seniorExecutive:
        return 'SENIOR EXECUTIVE';
      case ExecutiveTier.juniorExecutive:
        return 'JUNIOR EXECUTIVE';
      case ExecutiveTier.associateExecutive:
        return 'ASSOCIATE EXECUTIVE';
    }
  }

  Color get tierColor {
    switch (tier) {
      case ExecutiveTier.panel:
        return AppColors.primaryYellow;
      case ExecutiveTier.seniorExecutive:
        return const Color(0xFFF59E0B);
      case ExecutiveTier.juniorExecutive:
        return const Color(0xFF38BDF8);
      case ExecutiveTier.associateExecutive:
        return const Color(0xFF94A3B8);
    }
  }
}

class TeamRosterRepository {
  static const List<TeamMember> members = [
    // ----------------------------------------------------
    // 1. PANEL
    // ----------------------------------------------------
    TeamMember(
      id: 'SPC-PAN-01',
      name: 'Salman Farshi Alam (Supto)',
      role: 'President',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'PRESIDENCY',
      location: 'Command Center Main',
      status: 'ONLINE',
      avatarInitials: 'SA',
      phone: '+880 1711-000001',
    ),
    TeamMember(
      id: 'SPC-PAN-02',
      name: 'Lilatul Barat Siddika Propa',
      role: 'General Secretary (Internal)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'GEN SECRETARIAT',
      location: 'Central Secretariat',
      status: 'ONLINE',
      avatarInitials: 'LP',
      phone: '+880 1711-000002',
    ),
    TeamMember(
      id: 'SPC-PAN-03',
      name: 'Md. Rezwanur Rahman Utshaw',
      role: 'General Secretary (External)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'GEN SECRETARIAT',
      location: 'External Affairs Suite',
      status: 'ONLINE',
      avatarInitials: 'RU',
      phone: '+880 1711-000003',
    ),
    TeamMember(
      id: 'SPC-PAN-04',
      name: 'Vacant (TBD)',
      role: 'Senior Vice-President (Internal)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'SR VICE PRESIDENCY',
      location: 'Operations Control Deck',
      status: 'STANDBY',
      avatarInitials: 'TB',
      phone: null,
    ),
    TeamMember(
      id: 'SPC-PAN-05',
      name: 'Audrita M. Hasan',
      role: 'Senior Vice-President (External)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'SR VICE PRESIDENCY',
      location: 'Liaison Headquarters',
      status: 'ONLINE',
      avatarInitials: 'AH',
      phone: '+880 1711-000005',
    ),
    TeamMember(
      id: 'SPC-PAN-06',
      name: 'Jeba Mimuna Zerin',
      role: 'Vice-President (Administration)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'ADMIN VP',
      location: 'Admin Operations Hub',
      status: 'ONLINE',
      avatarInitials: 'JZ',
      phone: '+880 1711-000006',
    ),
    TeamMember(
      id: 'SPC-PAN-07',
      name: 'Soumik Howlader Shuvro',
      role: 'Vice-President (Event & Workshop)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'EVENTS VP',
      location: 'Auditorium Operations',
      status: 'ONLINE',
      avatarInitials: 'SS',
      phone: '+880 1711-000007',
    ),
    TeamMember(
      id: 'SPC-PAN-08',
      name: 'Asif Karim Sifat',
      role: 'Vice President (Branding & Communication)',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'BRANDING VP',
      location: 'Creative Headquarters',
      status: 'ONLINE',
      avatarInitials: 'AS',
      phone: '+880 1711-000008',
    ),
    TeamMember(
      id: 'SPC-PAN-09',
      name: 'Mohaimen Zaman',
      role: 'Treasurer',
      tier: ExecutiveTier.panel,
      department: Department.panelManagement,
      departmentLabel: 'TREASURY',
      location: 'Finance Station',
      status: 'ON DECK',
      avatarInitials: 'MZ',
      phone: '+880 1711-000009',
    ),

    // ----------------------------------------------------
    // 2. SENIOR EXECUTIVES
    // ----------------------------------------------------
    TeamMember(
      id: 'SPC-SNREX-ADM-01',
      name: 'Tasnim Sadia',
      role: 'Joint Secretary (Administration)',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.operations,
      departmentLabel: 'ADMINISTRATION',
      location: 'Admin Directorate',
      status: 'ONLINE',
      avatarInitials: 'TS',
      phone: '+880 1812-101001',
    ),
    TeamMember(
      id: 'SPC-SNREX-OPS-02',
      name: 'Nazmoon Nahar Nabila',
      role: 'Joint Secretary (Event & Workshop)',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.operations,
      departmentLabel: 'EVENT & WORKSHOP',
      location: 'Workshop Floor & Hall A',
      status: 'ONLINE',
      avatarInitials: 'NN',
      phone: '+880 1812-101002',
    ),
    TeamMember(
      id: 'SPC-SNREX-GFX-03',
      name: 'Shadman Shakib Prodhan (Sayor)',
      role: 'Joint Secretary (Branding & Communication)',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.graphics,
      departmentLabel: 'BRANDING & COMM',
      location: 'Media Studio East',
      status: 'ONLINE',
      avatarInitials: 'SP',
      phone: '+880 1812-101003',
    ),
    TeamMember(
      id: 'SPC-SNREX-PUB-04',
      name: 'Monirun Nahar Tabassum',
      role: 'Head of Publication',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.graphics,
      departmentLabel: 'PUBLICATION',
      location: 'Creative Press Suite',
      status: 'ONLINE',
      avatarInitials: 'MT',
      phone: '+880 1812-101004',
    ),
    TeamMember(
      id: 'SPC-SNREX-TCH-05',
      name: 'Mushfiqur Rahman',
      role: 'Head of IT',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.tech,
      departmentLabel: 'TECH & IT',
      location: 'Server Operations Room',
      status: 'ONLINE',
      avatarInitials: 'MR',
      phone: '+880 1812-101005',
    ),
    TeamMember(
      id: 'SPC-SNREX-LOG-06',
      name: 'Md. Sadmon Alam Nihal',
      role: 'Head of Logistics',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'Central Logistics Depot',
      status: 'DISPATCHED',
      avatarInitials: 'SN',
      phone: '+880 1812-101006',
    ),
    TeamMember(
      id: 'SPC-SNREX-HR-07',
      name: 'Nusrat Jahan (Nisa)',
      role: 'Human Resource Secretary',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.hospitality,
      departmentLabel: 'HUMAN RESOURCES',
      location: 'HR Secretariat Room',
      status: 'ONLINE',
      avatarInitials: 'NJ',
      phone: '+880 1812-101007',
    ),
    TeamMember(
      id: 'SPC-SNREX-PR-08',
      name: 'Moontaha Sharmin Moon',
      role: 'Public Relations Secretary',
      tier: ExecutiveTier.seniorExecutive,
      department: Department.corporateRelations,
      departmentLabel: 'PUBLIC RELATIONS',
      location: 'PR & Media Lounge',
      status: 'ON DECK',
      avatarInitials: 'MM',
      phone: '+880 1812-101008',
    ),

    // ----------------------------------------------------
    // 3. JUNIOR EXECUTIVES
    // ----------------------------------------------------
    TeamMember(
      id: 'SPC-JNREX-GFX-01',
      name: 'Emon Sarker',
      role: 'Motion Graphics & Screen Visuals Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.graphics,
      departmentLabel: 'GRAPHICS',
      location: 'AV Control Deck',
      status: 'ONLINE',
      avatarInitials: 'ES',
      phone: '+880 1913-202001',
    ),
    TeamMember(
      id: 'SPC-JNREX-GFX-02',
      name: 'Lamia Haque',
      role: 'Social Media & Live Cover Design Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.graphics,
      departmentLabel: 'GRAPHICS',
      location: 'Media Desk East',
      status: 'ONLINE',
      avatarInitials: 'LH',
      phone: '+880 1913-202002',
    ),
    TeamMember(
      id: 'SPC-JNREX-LOG-03',
      name: 'Imtiaz Khan',
      role: 'Venue Ingress / Egress Coordinator',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'North Access Gate',
      status: 'DISPATCHED',
      avatarInitials: 'IK',
      phone: '+880 1913-202003',
    ),
    TeamMember(
      id: 'SPC-JNREX-LOG-04',
      name: 'Zubair Ahmed',
      role: 'Audio-Visual Rigging & Cable Coordinator',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'Stage Wing Left',
      status: 'ONLINE',
      avatarInitials: 'ZA',
      phone: '+880 1913-202004',
    ),
    TeamMember(
      id: 'SPC-JNREX-TCH-05',
      name: 'Samiul Bashar',
      role: 'Barcode Gate Scanner & Terminal Lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.tech,
      departmentLabel: 'TECH & IT',
      location: 'Auditorium Gate 2 Pod',
      status: 'ONLINE',
      avatarInitials: 'SB',
      phone: '+880 1913-202005',
    ),
    TeamMember(
      id: 'SPC-JNREX-TCH-06',
      name: 'Adnan Sami',
      role: 'Live Stream Telemetry & Output Lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.tech,
      departmentLabel: 'TECH & IT',
      location: 'Broadcast Station',
      status: 'ONLINE',
      avatarInitials: 'AS',
      phone: '+880 1913-202006',
    ),
    TeamMember(
      id: 'SPC-JNREX-OPS-07',
      name: 'Tasmia Noor',
      role: 'Participant Registration Desk Coordinator',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.operations,
      departmentLabel: 'OPERATIONS',
      location: 'Main Registration Booth',
      status: 'ONLINE',
      avatarInitials: 'TN',
      phone: '+880 1913-202007',
    ),
    TeamMember(
      id: 'SPC-JNREX-OPS-08',
      name: 'Rashedul Bari',
      role: 'Stage Lineup & Timekeeper Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.operations,
      departmentLabel: 'OPERATIONS',
      location: 'Backstage Prompt Desk',
      status: 'ONLINE',
      avatarInitials: 'RB',
      phone: '+880 1913-202008',
    ),
    TeamMember(
      id: 'SPC-JNREX-HOS-09',
      name: 'Mehnaz Kabir',
      role: 'Judge & Speaker Concierge',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.hospitality,
      departmentLabel: 'HOSPITALITY',
      location: 'Judge Deliberation Room',
      status: 'ON DECK',
      avatarInitials: 'MK',
      phone: '+880 1913-202009',
    ),
    TeamMember(
      id: 'SPC-JNREX-HOS-10',
      name: 'Faiaz Mahmud',
      role: 'Catering & Dining Logistics Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.hospitality,
      departmentLabel: 'HOSPITALITY',
      location: 'Banquet Hall Floor',
      status: 'ONLINE',
      avatarInitials: 'FM',
      phone: '+880 1913-202010',
    ),
    TeamMember(
      id: 'SPC-JNREX-CR-11',
      name: 'Tahmid Alam',
      role: 'Sponsor Booth Activation Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.corporateRelations,
      departmentLabel: 'CORPORATE',
      location: 'Sponsor Expo Center',
      status: 'STANDBY',
      avatarInitials: 'TA',
      phone: '+880 1913-202011',
    ),
    TeamMember(
      id: 'SPC-JNREX-CR-12',
      name: 'Shreya Sen',
      role: 'Partner Brand Compliance Co-lead',
      tier: ExecutiveTier.juniorExecutive,
      department: Department.corporateRelations,
      departmentLabel: 'CORPORATE',
      location: 'Branding Hallway',
      status: 'ONLINE',
      avatarInitials: 'SS',
      phone: '+880 1913-202012',
    ),

    // ----------------------------------------------------
    // 4. ASSOCIATE EXECUTIVES
    // ----------------------------------------------------
    TeamMember(
      id: 'SPC-ASC-GFX-01',
      name: 'Nahid Hasan',
      role: 'Poster & Vinyl Print Specialist',
      tier: ExecutiveTier.associateExecutive,
      department: Department.graphics,
      departmentLabel: 'GRAPHICS',
      location: 'Print Dispatch Station',
      status: 'ONLINE',
      avatarInitials: 'NH',
      phone: '+880 1614-303001',
    ),
    TeamMember(
      id: 'SPC-ASC-GFX-02',
      name: 'Priyanka Roy',
      role: 'Presentation Deck & Lower-Thirds Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.graphics,
      departmentLabel: 'GRAPHICS',
      location: 'Projection Rig Left',
      status: 'ONLINE',
      avatarInitials: 'PR',
      phone: '+880 1614-303002',
    ),
    TeamMember(
      id: 'SPC-ASC-LOG-03',
      name: 'Kabir Hossain',
      role: 'Stage Props & Furniture Dispatcher',
      tier: ExecutiveTier.associateExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'Stage Storage Annex',
      status: 'DISPATCHED',
      avatarInitials: 'KH',
      phone: '+880 1614-303003',
    ),
    TeamMember(
      id: 'SPC-ASC-LOG-04',
      name: 'Mustafa Kamal',
      role: 'Microphone & Wireless Audio Runner',
      tier: ExecutiveTier.associateExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'Backstage Audio Rack',
      status: 'ONLINE',
      avatarInitials: 'MK',
      phone: '+880 1614-303004',
    ),
    TeamMember(
      id: 'SPC-ASC-LOG-05',
      name: 'Arifur Rahman',
      role: 'Entry Barrier & Queue Marshal',
      tier: ExecutiveTier.associateExecutive,
      department: Department.logistics,
      departmentLabel: 'LOGISTICS',
      location: 'Entrance Gate 1',
      status: 'DISPATCHED',
      avatarInitials: 'AR',
      phone: '+880 1614-303005',
    ),
    TeamMember(
      id: 'SPC-ASC-TCH-06',
      name: 'Sohanur Rahman',
      role: 'Gate 2 Handheld Scanner Operator',
      tier: ExecutiveTier.associateExecutive,
      department: Department.tech,
      departmentLabel: 'TECH & IT',
      location: 'Gate 2 Checkpoint',
      status: 'ONLINE',
      avatarInitials: 'SR',
      phone: '+880 1614-303006',
    ),
    TeamMember(
      id: 'SPC-ASC-TCH-07',
      name: 'Nayeem Islam',
      role: 'Scoreboard & Timer Screen Operator',
      tier: ExecutiveTier.associateExecutive,
      department: Department.tech,
      departmentLabel: 'TECH & IT',
      location: 'Control Center Display Rig',
      status: 'ONLINE',
      avatarInitials: 'NI',
      phone: '+880 1614-303007',
    ),
    TeamMember(
      id: 'SPC-ASC-OPS-08',
      name: 'Anika Tabassum',
      role: 'ID Badge & Welcome Kit Distribution Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.operations,
      departmentLabel: 'OPERATIONS',
      location: 'Registration Counter 3',
      status: 'ONLINE',
      avatarInitials: 'AT',
      phone: '+880 1614-303008',
    ),
    TeamMember(
      id: 'SPC-ASC-OPS-09',
      name: 'Bilal Ahmed',
      role: 'Auditorium Seating Marshal',
      tier: ExecutiveTier.associateExecutive,
      department: Department.operations,
      departmentLabel: 'OPERATIONS',
      location: 'Auditorium Block C',
      status: 'ONLINE',
      avatarInitials: 'BA',
      phone: '+880 1614-303009',
    ),
    TeamMember(
      id: 'SPC-ASC-OPS-10',
      name: 'Sumaiya Khan',
      role: 'Information & Lost-and-Found Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.operations,
      departmentLabel: 'OPERATIONS',
      location: 'Foyer Information Desk',
      status: 'ONLINE',
      avatarInitials: 'SK',
      phone: '+880 1614-303010',
    ),
    TeamMember(
      id: 'SPC-ASC-HOS-11',
      name: 'Joy Dutta',
      role: 'Judge Lounge Refreshments Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.hospitality,
      departmentLabel: 'HOSPITALITY',
      location: 'Judge Lounge Pantry',
      status: 'ONLINE',
      avatarInitials: 'JD',
      phone: '+880 1614-303011',
    ),
    TeamMember(
      id: 'SPC-ASC-HOS-12',
      name: 'Farzana Yasmin',
      role: 'Guest Escort & Crest Presentation Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.hospitality,
      departmentLabel: 'HOSPITALITY',
      location: 'Stage Podium Annex',
      status: 'ON DECK',
      avatarInitials: 'FY',
      phone: '+880 1614-303012',
    ),
    TeamMember(
      id: 'SPC-ASC-CR-13',
      name: 'Riyad Mahmud',
      role: 'Sponsor Standee & Flyer Custodian',
      tier: ExecutiveTier.associateExecutive,
      department: Department.corporateRelations,
      departmentLabel: 'CORPORATE',
      location: 'Atrium Sponsor Walkway',
      status: 'STANDBY',
      avatarInitials: 'RM',
      phone: '+880 1614-303013',
    ),
    TeamMember(
      id: 'SPC-ASC-CR-14',
      name: 'Tanha Akter',
      role: 'VIP Souvenir Packing & Dispatch Associate',
      tier: ExecutiveTier.associateExecutive,
      department: Department.corporateRelations,
      departmentLabel: 'CORPORATE',
      location: 'Dispatch Hub Room 102',
      status: 'STANDBY',
      avatarInitials: 'TA',
      phone: '+880 1614-303014',
    ),
  ];
}
