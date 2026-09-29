import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../constants/app_icons.dart';
import '../../features/roster/domain/team_member.dart';
import 'models/event_ops_models.dart';

class OperationsNotifier extends ChangeNotifier {
  // Current Active Event
  String _activeEventId = 'casespecs-4';
  String get activeEventId => _activeEventId;

  // Telemetry state
  bool isMeshConnected = true;
  bool isOfflineCacheReady = true;
  bool isCryptoVerified = true;
  bool isLiveDayMode = true;

  // Active user identity
  String currentUserName = 'Salman Farshi Alam';
  String currentUserRole = 'Head of Operations · Event Lead';
  String currentUserId = 'SPC-PAN-01';

  // Constructor
  OperationsNotifier() {
    _initTasksAndAttendance();
  }

  // 1. Events list
  List<OperationalEvent> _events = [
    OperationalEvent(
      id: 'casespecs-4',
      title: 'CASESpecs 4.0',
      subtitle: 'Spectrum · Annual National Business Case Competition',
      phase: 'PREPARATION PHASE',
      daysLeft: 23,
      progress: 0.78,
      membersCount: 47,
      lead: 'Salman Farshi Alam',
      isFeatured: true,
      targetAttendees: 520,
      checkedInCount: 342,
      location: 'Central Auditorium & Exhibition Hall',
      date: DateTime(2026, 9, 27),
    ),
    OperationalEvent(
      id: 'mechtech-2026',
      title: 'MechTech Arena 2026',
      subtitle: 'Robotics & Hardware Prototyping Showcase',
      phase: 'LOGISTICS PLANNING',
      daysLeft: 48,
      progress: 0.42,
      membersCount: 31,
      lead: 'Tanvir Hossain',
      isFeatured: false,
      targetAttendees: 300,
      checkedInCount: 0,
      location: 'Engineering Complex Workshop 3',
      date: DateTime(2026, 10, 15),
    ),
    OperationalEvent(
      id: 'roboverse-summit',
      title: 'Roboverse Tech Summit',
      subtitle: 'Autonomous Systems & AI Conclave',
      phase: 'EARLY DRAFT',
      daysLeft: 76,
      progress: 0.18,
      membersCount: 19,
      lead: 'Sadia Rahman',
      isFeatured: false,
      targetAttendees: 400,
      checkedInCount: 0,
      location: 'International Conference Center',
      date: DateTime(2026, 11, 10),
    ),
  ];

  List<OperationalEvent> get events => List.unmodifiable(_events);

  OperationalEvent get activeEvent =>
      _events.firstWhere((e) => e.id == _activeEventId, orElse: () => _events.first);

  void setActiveEvent(String eventId) {
    if (_events.any((e) => e.id == eventId)) {
      _activeEventId = eventId;
      notifyListeners();
    }
  }

  void addEvent(OperationalEvent newEvent) {
    _events = [newEvent, ..._events];
    addAuditLog(
      AuditTrailItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: _formatCurrentTime(),
        category: 'SYSTEM',
        title: 'New Event Initialized: ${newEvent.title}',
        description: 'Assigned Lead: ${newEvent.lead} with target ${newEvent.targetAttendees} participants.',
        icon: LucideIcons.calendar,
        isHighlight: true,
      ),
    );
    notifyListeners();
  }

  // 2. Decisions List
  List<DecisionModel> _decisions = [
    DecisionModel(
      id: '024',
      title: 'REGISTRATION DESK LOCATION',
      directiveText:
          'Primary check-in operation relocated from A-Block Entrance to Auditorium Main Gate due to expected crowd surge from external institutions.',
      category: 'LOGISTICS & OPS',
      priority: 'URGENT',
      status: 'ACTIVE DIRECTIVE',
      proposer: 'Salman Farshi Alam (Supto)',
      approvals: 38,
      rejections: 2,
      abstains: 3,
      userVote: 'APPROVE',
      isAcknowledged: true,
      timestamp: '27 SEPT 2026 · 09:12 AM',
      sha256Hash: '9a4f61b7e2831c0a8e9947fd1b82736b4d3f58a2e4c1973bdf60298a2139e801',
      affectedDepartments: ['Operations', 'Registration', 'Logistics', 'Security'],
      comments: [
        DecisionComment(
          id: 'c1',
          author: 'Foysal',
          role: 'Coordinator',
          text: 'Volunteer allocation sheet and gate signage updated accordingly.',
          time: '09:15 AM',
        ),
        DecisionComment(
          id: 'c2',
          author: 'Tahsina',
          role: 'Logistics Lead',
          text: 'Dedicated high-speed WiFi terminals and extra power cabling installed at Auditorium Lobby.',
          time: '09:22 AM',
        ),
      ],
    ),
    DecisionModel(
      id: '025',
      title: 'STAGE LIGHTING & AUDIO OVERHAUL',
      directiveText:
          'Allocation of emergency buffer funds for secondary 4K projectors and redundant line array microphones for Grand Finale.',
      category: 'PRODUCTION',
      priority: 'HIGH',
      status: 'PENDING REVIEW',
      proposer: 'Soumik Howlader Shuvro',
      approvals: 29,
      rejections: 5,
      abstains: 7,
      userVote: null,
      isAcknowledged: false,
      timestamp: '27 SEPT 2026 · 08:30 AM',
      sha256Hash: '3c8e421098fb54a8b89e2110c7499df193a02798e29a39f604473b98ea120349',
      affectedDepartments: ['Tech', 'Graphics', 'Event Management'],
      comments: [
        DecisionComment(
          id: 'c3',
          author: 'Audrita M. Hasan',
          role: 'Sr VP External',
          text: 'AV partner confirmed redundancy kit is ready for staging at 1:00 PM.',
          time: '08:45 AM',
        ),
      ],
    ),
    DecisionModel(
      id: '026',
      title: 'KEYNOTE SPEAKER PROTOCOL UPDATE',
      directiveText:
          'Flight delay adjustments: Chief Guest arrival shifted to 10:45 AM. Welcome tea relocated to VIP Green Room A.',
      category: 'HOSPITALITY',
      priority: 'ROUTINE',
      status: 'ACTIVE DIRECTIVE',
      proposer: 'Lilatul Barat Siddika Propa',
      approvals: 42,
      rejections: 0,
      abstains: 1,
      userVote: 'APPROVE',
      isAcknowledged: true,
      timestamp: '27 SEPT 2026 · 08:47 AM',
      sha256Hash: '7f918e4726bb0129a0c848d1e0284f1839a9c9b19e7a8310c841029471928374',
      affectedDepartments: ['Hospitality', 'Panel Management', 'Corporate Relations'],
      comments: [],
    ),
  ];

  List<DecisionModel> get decisions => List.unmodifiable(_decisions);

  DecisionModel? getDecision(String id) {
    try {
      return _decisions.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void castVote(String decisionId, String vote) {
    final idx = _decisions.indexWhere((d) => d.id == decisionId);
    if (idx != -1) {
      final current = _decisions[idx];
      int app = current.approvals;
      int rej = current.rejections;
      int abs = current.abstains;

      // Reverse previous vote if any
      if (current.userVote == 'APPROVE') app--;
      if (current.userVote == 'REJECT') rej--;
      if (current.userVote == 'ABSTAIN') abs--;

      // Apply new vote
      if (vote == 'APPROVE') app++;
      if (vote == 'REJECT') rej++;
      if (vote == 'ABSTAIN') abs++;

      _decisions[idx] = current.copyWith(
        approvals: app,
        rejections: rej,
        abstains: abs,
        userVote: vote,
        isAcknowledged: true,
      );

      addAuditLog(
        AuditTrailItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          time: _formatCurrentTime(),
          category: 'DECISIONS',
          title: 'Vote Cast: Directive #$decisionId ($vote)',
          description: '$currentUserName recorded vote on "${current.title}".',
          icon: LucideIcons.fileSignature,
          isHighlight: true,
          route: '/decision/$decisionId',
        ),
      );

      notifyListeners();
    }
  }

  void toggleAcknowledgeDecision(String decisionId) {
    final idx = _decisions.indexWhere((d) => d.id == decisionId);
    if (idx != -1) {
      final current = _decisions[idx];
      _decisions[idx] = current.copyWith(isAcknowledged: !current.isAcknowledged);
      notifyListeners();
    }
  }

  void addDecisionComment(String decisionId, String text) {
    if (text.trim().isEmpty) return;
    final idx = _decisions.indexWhere((d) => d.id == decisionId);
    if (idx != -1) {
      final current = _decisions[idx];
      final newComment = DecisionComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: currentUserName,
        role: currentUserRole,
        text: text.trim(),
        time: _formatCurrentTime(),
      );
      _decisions[idx] = current.copyWith(
        comments: [...current.comments, newComment],
      );
      notifyListeners();
    }
  }

  void createDecision(DecisionModel newDecision) {
    _decisions = [newDecision, ..._decisions];
    addBroadcast(
      BroadcastAlert(
        id: 'alert-${newDecision.id}',
        badge: 'NEW DIRECTIVE #${newDecision.id}',
        title: newDecision.title,
        time: 'Just now',
        description: newDecision.directiveText,
        actionLabel: 'VIEW DIRECTIVE #${newDecision.id}',
        actionRoute: '/decision/${newDecision.id}',
        priority: newDecision.priority == 'URGENT' ? AlertPriority.urgent : AlertPriority.routine,
        audience: 'ALL LEAD OFFICERS',
      ),
    );
    addAuditLog(
      AuditTrailItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: _formatCurrentTime(),
        category: 'DECISIONS',
        title: 'New Directive #${newDecision.id} Formulated',
        description: newDecision.title,
        icon: LucideIcons.fileSignature,
        isHighlight: true,
        route: '/decision/${newDecision.id}',
      ),
    );
    notifyListeners();
  }

  // 3. Broadcast Alerts
  List<BroadcastAlert> _alerts = [
    const BroadcastAlert(
      id: 'a1',
      badge: 'CRITICAL DIRECTIVE',
      title: 'Registration Relocated to Auditorium Entrance',
      time: '12m ago',
      description: 'Traffic flow adjustments require all check-in terminals to operate at Gate 2 entrance.',
      actionLabel: 'VIEW DIRECTIVE #024',
      actionRoute: '/decision/024',
      priority: AlertPriority.critical,
      audience: 'ALL OPERATIONAL TERMINALS',
    ),
    const BroadcastAlert(
      id: 'a2',
      badge: 'SCHEDULE ADJUSTMENT',
      title: 'Speaker Arrival Updated to 10:45 AM',
      time: '34m ago',
      description: 'Flight delay confirmed. Keynote session shifted forward by 30 minutes.',
      actionLabel: 'VIEW EVENT DAY TIMELINE',
      actionRoute: '/event_day',
      priority: AlertPriority.urgent,
      audience: 'HOSPITALITY & STAGE CREW',
    ),
    const BroadcastAlert(
      id: 'a3',
      badge: 'ROSTER UPDATE',
      title: 'Participant Roster v3 Published',
      time: '1h ago',
      description: 'Contains verified badge barcode IDs, table assignments, and medical details.',
      actionLabel: 'OPEN AUDIT TRAIL',
      actionRoute: '/what_changed',
      priority: AlertPriority.info,
      audience: 'REGISTRATION DESK VOLUNTEERS',
    ),
  ];

  List<BroadcastAlert> get alerts => List.unmodifiable(_alerts);

  BroadcastAlert? get latestCriticalAlert {
    try {
      return _alerts.firstWhere((a) => a.isUrgent && !a.isAcknowledged);
    } catch (_) {
      return null;
    }
  }

  void addBroadcast(BroadcastAlert alert) {
    _alerts = [alert, ..._alerts];
    notifyListeners();
  }

  void dismissAlert(String alertId) {
    _alerts = _alerts.where((a) => a.id != alertId).toList();
    notifyListeners();
  }

  void acknowledgeAlert(String alertId) {
    final idx = _alerts.indexWhere((a) => a.id == alertId);
    if (idx != -1) {
      _alerts[idx] = _alerts[idx].copyWith(isAcknowledged: true);
      notifyListeners();
    }
  }

  // 4. Live Schedule Milestones
  final List<ScheduleMilestone> _schedule = [
    const ScheduleMilestone(
      id: 's1',
      time: '08:00 AM',
      title: 'Gate Verification & Volunteer Briefing',
      location: 'Auditorium Quadrangle Gate 1 & 2',
      status: 'COMPLETED',
      leadPerson: 'Salman Farshi Alam',
      notes: 'All 43 coordinators positioned at respective desks with barcode kits.',
    ),
    const ScheduleMilestone(
      id: 's2',
      time: '09:00 AM',
      title: 'Registration Desk & Welcome Kit Distribution',
      location: 'Auditorium Main Lobby Entrance',
      status: 'LIVE',
      leadPerson: 'Foysal (Operations)',
      notes: 'Live crowd intake in progress. 342/520 participants checked in.',
    ),
    const ScheduleMilestone(
      id: 's3',
      time: '10:45 AM',
      title: 'Grand Inaugural Ceremony & Keynote Address',
      location: 'Main Auditorium Hall Stage A',
      status: 'UPCOMING',
      leadPerson: 'Soumik Howlader (VP Events)',
      notes: 'Audio & visual visualizers staged. VIP guest arrival confirmed.',
    ),
    const ScheduleMilestone(
      id: 's4',
      time: '12:30 PM',
      title: 'Round 1 Case Solution Presentations',
      location: 'Breakout Syndicate Rooms 101 - 108',
      status: 'UPCOMING',
      leadPerson: 'Audrita M. Hasan (VP External)',
      notes: 'Judges panel briefing at VIP Green Room at 12:00 PM.',
    ),
    const ScheduleMilestone(
      id: 's5',
      time: '04:00 PM',
      title: 'Grand Finale Showcase & Awards Ceremony',
      location: 'Central Stage & Livestream Deck',
      status: 'UPCOMING',
      leadPerson: 'Lilatul Barat Siddika Propa (GS)',
      notes: 'Champion trophy and partner certificates verified.',
    ),
  ];

  List<ScheduleMilestone> get schedule => List.unmodifiable(_schedule);

  void toggleScheduleStatus(String milestoneId) {
    final idx = _schedule.indexWhere((s) => s.id == milestoneId);
    if (idx != -1) {
      final cur = _schedule[idx];
      String nextStatus;
      switch (cur.status) {
        case 'UPCOMING':
          nextStatus = 'LIVE';
          break;
        case 'LIVE':
          nextStatus = 'COMPLETED';
          break;
        case 'COMPLETED':
          nextStatus = 'DELAYED';
          break;
        default:
          nextStatus = 'UPCOMING';
      }

      _schedule[idx] = cur.copyWith(status: nextStatus);

      addAuditLog(
        AuditTrailItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          time: _formatCurrentTime(),
          category: 'SCHEDULE',
          title: 'Milestone Updated: ${cur.title}',
          description: 'Status shifted to "$nextStatus" by $currentUserName.',
          icon: LucideIcons.clock,
          isHighlight: nextStatus == 'LIVE',
          route: '/event_day',
        ),
      );

      notifyListeners();
    }
  }

  // 5. Scanned Participants & Check-In Simulation
  List<ScannedParticipant> _scannedParticipants = [
    const ScannedParticipant(
      id: 'SPC-2026-342',
      name: 'Nafis Imtiaz',
      institution: 'IBA, University of Dhaka',
      teamName: 'Apex Advisors',
      timeScanned: '09:24 AM',
    ),
    const ScannedParticipant(
      id: 'SPC-2026-341',
      name: 'Abrar Zahin',
      institution: 'BUET',
      teamName: 'Matrix Dynamics',
      timeScanned: '09:22 AM',
    ),
    const ScannedParticipant(
      id: 'SPC-2026-340',
      name: 'Farhan Kabir',
      institution: 'North South University',
      teamName: 'Vanguard Alpha',
      timeScanned: '09:19 AM',
    ),
    const ScannedParticipant(
      id: 'SPC-2026-339',
      name: 'Samira Anjum',
      institution: 'BRAC University',
      teamName: 'Stratagem Co.',
      timeScanned: '09:15 AM',
    ),
  ];

  List<ScannedParticipant> get scannedParticipants => List.unmodifiable(_scannedParticipants);

  void simulateCheckIn(String name, String institution, String teamName) {
    final newId = 'SPC-2026-${activeEvent.checkedInCount + 1}';
    final participant = ScannedParticipant(
      id: newId,
      name: name.trim().isEmpty ? 'Registered Participant' : name.trim(),
      institution: institution.trim().isEmpty ? 'Institution Verified' : institution.trim(),
      teamName: teamName.trim().isEmpty ? 'Autonomous Squad' : teamName.trim(),
      timeScanned: _formatCurrentTime(),
    );

    _scannedParticipants = [participant, ..._scannedParticipants];

    // Update active event check-in count
    final activeIdx = _events.indexWhere((e) => e.id == _activeEventId);
    if (activeIdx != -1) {
      _events[activeIdx] = _events[activeIdx].copyWith(
        checkedInCount: _events[activeIdx].checkedInCount + 1,
      );
    }

    notifyListeners();
  }

  // 6. Audit Trail Items
  List<AuditTrailItem> _auditLogs = [
    const AuditTrailItem(
      id: '1',
      time: '09:20 AM',
      category: 'DOCUMENTS',
      title: 'Participant Master List v3 Published',
      description: 'Registration Team finalized booth allocations, verified QR tokens and participant IDs.',
      icon: LucideIcons.fileSpreadsheet,
      isHighlight: true,
      route: '/what_changed',
    ),
    const AuditTrailItem(
      id: '2',
      time: '09:12 AM',
      category: 'DECISIONS',
      title: 'Directive #024: Venue Check-in Relocation',
      description: 'Registration moved to Auditorium Main Entrance to prevent Gate 1 pedestrian choke point.',
      icon: LucideIcons.fileSignature,
      isHighlight: true,
      route: '/decision/024',
    ),
    const AuditTrailItem(
      id: '3',
      time: '08:47 AM',
      category: 'SCHEDULE',
      title: 'Keynote Speaker Schedule Shift',
      description: 'Flight delay adjustment: Keynote moved from 10:15 AM to 10:45 AM.',
      icon: LucideIcons.clock,
      route: '/event_day',
    ),
    const AuditTrailItem(
      id: '4',
      time: '08:31 AM',
      category: 'SYSTEM',
      title: 'Registration Verification Protocol',
      description: 'Decentralized terminal sync confirmed across all 6 gate scanners with zero packet loss.',
      icon: LucideIcons.checkCircle,
    ),
  ];

  List<AuditTrailItem> get auditLogs => List.unmodifiable(_auditLogs);

  void addAuditLog(AuditTrailItem item) {
    _auditLogs = [item, ..._auditLogs];
    notifyListeners();
  }

  // 7. Channel Chat Messages
  final Map<String, List<ChatMessageModel>> _channelMessages = {
    'announcements': [
      const ChatMessageModel(
        id: 'm1',
        channel: 'announcements',
        sender: 'Salman Farshi Alam',
        role: 'Event Lead',
        time: '09:10 AM',
        message: 'All Coordinators please report to Auditorium Entrance for primary deployment.',
        isUrgent: true,
        reactions: {'👍': 14, '🔥': 6},
      ),
      const ChatMessageModel(
        id: 'm2',
        channel: 'announcements',
        sender: 'Decision Bot',
        role: 'Operations Engine',
        time: '09:12 AM',
        message: 'DIRECTIVE #024 ACTIVATED: Registration relocated to Auditorium Entrance.',
        isDecision: true,
        decisionId: '024',
        reactions: {'✅': 22},
      ),
      const ChatMessageModel(
        id: 'm3',
        channel: 'announcements',
        sender: 'Audrita M. Hasan',
        role: 'Sr VP External',
        time: '09:18 AM',
        message: 'External VIP media crew arriving at Gate 3 parking at 10:15 AM. Escort protocol active.',
        reactions: {'👍': 8},
      ),
    ],
    'important-updates': [
      const ChatMessageModel(
        id: 'iu1',
        channel: 'important-updates',
        sender: 'Operations Engine',
        role: 'Automated Dispatch',
        time: '08:47 AM',
        message: 'Keynote session moved to 10:45 AM due to flight schedule revision.',
        isUrgent: true,
        reactions: {'⚠️': 9, '👍': 12},
      ),
      const ChatMessageModel(
        id: 'iu2',
        channel: 'important-updates',
        sender: 'Lilatul Barat Siddika Propa',
        role: 'General Secretary',
        time: '09:05 AM',
        message: 'Participant badges for teams from Chittagong & Sylhet pre-packaged at Table 4.',
        reactions: {'👍': 5},
      ),
    ],
    'emergency': [
      const ChatMessageModel(
        id: 'em1',
        channel: 'emergency',
        sender: 'Emergency Dispatch',
        role: 'Medical & Security Desk',
        time: '08:00 AM',
        message: 'Emergency line active. First-aid station situated at Room 104 beside East Wing stairs.',
        isUrgent: true,
        reactions: {'🛡️': 18},
      ),
    ],
  };

  List<ChatMessageModel> getMessagesForChannel(String channel) {
    return List.unmodifiable(_channelMessages[channel] ?? [
      ChatMessageModel(
        id: 'init-$channel',
        channel: channel,
        sender: 'Operations Engine',
        role: 'System',
        time: '08:00 AM',
        message: 'Channel #$channel established for CASESpecs 4.0 operations.',
      ),
    ]);
  }

  void sendChatMessage(
    String channel,
    String text, {
    bool isUrgent = false,
    bool isDecision = false,
    String? decisionId,
  }) {
    if (text.trim().isEmpty) return;

    final newMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      channel: channel,
      sender: currentUserName,
      role: currentUserRole,
      time: _formatCurrentTime(),
      message: text.trim(),
      isUrgent: isUrgent,
      isDecision: isDecision,
      decisionId: decisionId,
    );

    final currentList = _channelMessages[channel] ?? [];
    _channelMessages[channel] = [...currentList, newMsg];

    if (isUrgent) {
      addBroadcast(
        BroadcastAlert(
          id: 'chat-alert-${newMsg.id}',
          badge: '#$channel ALERT',
          title: text.length > 40 ? '${text.substring(0, 40)}...' : text,
          time: 'Just now',
          description: text,
          actionLabel: 'OPEN #$channel',
          actionRoute: '/chat/$channel',
          priority: AlertPriority.urgent,
          audience: '#$channel SUBSCRIBERS',
        ),
      );
    }

    notifyListeners();
  }

  void toggleReaction(String channel, String messageId, String emoji) {
    final list = _channelMessages[channel];
    if (list == null) return;

    final idx = list.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      final msg = list[idx];
      final userReactions = Set<String>.from(msg.userReactions);
      final currentReactions = Map<String, int>.from(msg.reactions);

      if (userReactions.contains(emoji)) {
        userReactions.remove(emoji);
        currentReactions[emoji] = (currentReactions[emoji] ?? 1) - 1;
        if (currentReactions[emoji]! <= 0) currentReactions.remove(emoji);
      } else {
        userReactions.add(emoji);
        currentReactions[emoji] = (currentReactions[emoji] ?? 0) + 1;
      }

      list[idx] = msg.copyWith(
        reactions: currentReactions,
        userReactions: userReactions,
      );
      notifyListeners();
    }
  }

  // 8. Roster Member Status Overrides
  final Map<String, String> _memberStatusOverrides = {};

  String getMemberStatus(TeamMember member) {
    return _memberStatusOverrides[member.id] ?? member.status;
  }

  void toggleMemberStatus(String memberId) {
    final current = _memberStatusOverrides[memberId] ?? 'ONLINE';
    String nextStatus;
    if (current == 'ONLINE') {
      nextStatus = 'ON DUTY';
    } else if (current == 'ON DUTY') {
      nextStatus = 'BREAK';
    } else if (current == 'BREAK') {
      nextStatus = 'STANDBY';
    } else {
      nextStatus = 'ONLINE';
    }
    _memberStatusOverrides[memberId] = nextStatus;
    notifyListeners();
  }

  // 9. Officer Attendance & Automated Task Assignment
  bool _autoAssignOnCheckin = true;
  bool get autoAssignOnCheckin => _autoAssignOnCheckin;

  void setAutoAssignOnCheckin(bool value) {
    _autoAssignOnCheckin = value;
    notifyListeners();
  }

  void toggleAutoAssignOnCheckin() {
    _autoAssignOnCheckin = !_autoAssignOnCheckin;
    notifyListeners();
  }

  List<OperationalTask> _tasks = [];
  List<AttendanceRecord> _attendance = [];

  List<OperationalTask> get tasks => List.unmodifiable(_tasks);
  List<AttendanceRecord> get attendanceList => List.unmodifiable(_attendance);

  int get attendedOfficersCount => _attendance.where((a) => a.isPresent).length;
  int get totalOfficersCount => _attendance.length;
  int get assignedTasksCount => _attendance.where((a) => a.assignedTask != null).length;
  int get completedTasksCount => _tasks.where((t) => t.status == 'COMPLETED').length;

  OperationalTask? getTask(String taskId) {
    try {
      return _tasks.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return null;
    }
  }

  void toggleAttendance(String memberId, {bool? forcePresent, bool? autoAssign}) {
    final idx = _attendance.indexWhere((a) => a.memberId == memberId);
    if (idx == -1) return;

    final current = _attendance[idx];
    final targetPresent = forcePresent ?? !current.isPresent;

    if (targetPresent == current.isPresent) return;

    if (targetPresent) {
      final checkinTime = _formatCurrentTime();
      OperationalTask? assigned = current.assignedTask;

      final shouldAutoAssign = autoAssign ?? _autoAssignOnCheckin;
      if (shouldAutoAssign && assigned == null) {
        assigned = _allocateTaskForMember(current);
      }

      _attendance[idx] = current.copyWith(
        isPresent: true,
        checkInTime: checkinTime,
        assignedTask: assigned,
      );

      addAuditLog(
        AuditTrailItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          time: checkinTime,
          category: 'SYSTEM',
          title: 'Officer Check-in: ${current.name}',
          description: assigned != null
              ? 'Present · Auto-assigned: "${assigned.title}" at ${assigned.location}.'
              : 'Present · Awaiting task dispatch.',
          icon: LucideIcons.shieldCheck,
          isHighlight: assigned != null,
          route: '/event_day',
        ),
      );
    } else {
      final previousTask = current.assignedTask;
      if (previousTask != null) {
        final tIdx = _tasks.indexWhere((t) => t.id == previousTask.id);
        if (tIdx != -1) {
          _tasks[tIdx] = _tasks[tIdx].copyWith(
            clearAssignment: true,
            status: 'UNASSIGNED',
          );
        }
      }

      _attendance[idx] = current.copyWith(
        isPresent: false,
        checkInTime: null,
        clearTask: true,
      );

      addAuditLog(
        AuditTrailItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          time: _formatCurrentTime(),
          category: 'SYSTEM',
          title: 'Officer Absent: ${current.name}',
          description: previousTask != null
              ? 'Attendance cleared. Task "${previousTask.title}" returned to unassigned pool.'
              : 'Attendance cleared.',
          icon: LucideIcons.userX,
          route: '/event_day',
        ),
      );
    }

    notifyListeners();
  }

  OperationalTask? _allocateTaskForMember(AttendanceRecord member) {
    // 1. Try to find unassigned task in member's department
    int taskIdx = _tasks.indexWhere((t) =>
        t.assignedToMemberId == null &&
        t.status == 'UNASSIGNED' &&
        t.department.toUpperCase() == member.department.toUpperCase());

    // 2. If none in that department, try OPERATIONS
    if (taskIdx == -1) {
      taskIdx = _tasks.indexWhere((t) =>
          t.assignedToMemberId == null &&
          t.status == 'UNASSIGNED' &&
          t.department.toUpperCase() == 'OPERATIONS');
    }

    // 3. Fallback to any unassigned task
    if (taskIdx == -1) {
      taskIdx = _tasks.indexWhere((t) =>
          t.assignedToMemberId == null &&
          t.status == 'UNASSIGNED');
    }

    if (taskIdx != -1) {
      final allocated = _tasks[taskIdx].copyWith(
        assignedToMemberId: member.memberId,
        assignedToMemberName: member.name,
        assignedAt: _formatCurrentTime(),
        status: 'IN PROGRESS',
      );
      _tasks[taskIdx] = allocated;
      return allocated;
    }
    return null;
  }

  int autoAssignTasksToAllAttended() {
    int count = 0;
    for (int i = 0; i < _attendance.length; i++) {
      final rec = _attendance[i];
      if (rec.isPresent && rec.assignedTask == null) {
        final allocated = _allocateTaskForMember(rec);
        if (allocated != null) {
          _attendance[i] = rec.copyWith(assignedTask: allocated);
          count++;
        }
      }
    }

    if (count > 0) {
      addBroadcast(
        BroadcastAlert(
          id: 'auto-assign-${DateTime.now().millisecondsSinceEpoch}',
          badge: 'TASK DISPATCH ENGINE',
          title: '$count Operational Tasks Auto-Assigned',
          time: 'Just now',
          description: 'Automated task distribution executed across attended personnel based on department & post allocations.',
          actionLabel: 'VIEW EVENT DAY CONSOLE',
          actionRoute: '/event_day',
          priority: AlertPriority.urgent,
          audience: 'ALL DEPLOYED OFFICERS',
        ),
      );

      addAuditLog(
        AuditTrailItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          time: _formatCurrentTime(),
          category: 'SYSTEM',
          title: 'Batch Auto-Assignment: $count Tasks Deployed',
          description: 'Distributed tasks to $count attended officers across departments.',
          icon: LucideIcons.zap,
          isHighlight: true,
          route: '/event_day',
        ),
      );

      notifyListeners();
    }

    return count;
  }

  void updateTaskStatus(String taskId, String newStatus) {
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (tIdx != -1) {
      final updated = _tasks[tIdx].copyWith(status: newStatus);
      _tasks[tIdx] = updated;

      for (int i = 0; i < _attendance.length; i++) {
        if (_attendance[i].assignedTask?.id == taskId) {
          _attendance[i] = _attendance[i].copyWith(assignedTask: updated);
          break;
        }
      }

      if (newStatus == 'COMPLETED') {
        addAuditLog(
          AuditTrailItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            time: _formatCurrentTime(),
            category: 'SYSTEM',
            title: 'Task Completed: ${updated.title}',
            description: 'Marked completed by ${updated.assignedToMemberName ?? 'Assigned Officer'} at ${updated.location}.',
            icon: LucideIcons.checkCheck,
            isHighlight: true,
            route: '/event_day',
          ),
        );
      }

      notifyListeners();
    }
  }

  void manualAssignTask(String memberId, String taskId) {
    final mIdx = _attendance.indexWhere((a) => a.memberId == memberId);
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (mIdx == -1 || tIdx == -1) return;

    final member = _attendance[mIdx];
    final task = _tasks[tIdx];

    if (member.assignedTask != null && member.assignedTask!.id != taskId) {
      final oldTIdx = _tasks.indexWhere((t) => t.id == member.assignedTask!.id);
      if (oldTIdx != -1) {
        _tasks[oldTIdx] = _tasks[oldTIdx].copyWith(
          clearAssignment: true,
          status: 'UNASSIGNED',
        );
      }
    }

    final updatedTask = task.copyWith(
      assignedToMemberId: member.memberId,
      assignedToMemberName: member.name,
      assignedAt: _formatCurrentTime(),
      status: 'IN PROGRESS',
    );
    _tasks[tIdx] = updatedTask;

    _attendance[mIdx] = member.copyWith(
      isPresent: true,
      checkInTime: member.checkInTime ?? _formatCurrentTime(),
      assignedTask: updatedTask,
    );

    addAuditLog(
      AuditTrailItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        time: _formatCurrentTime(),
        category: 'SYSTEM',
        title: 'Manual Dispatch: ${task.title}',
        description: 'Assigned to ${member.name} (${member.department}) at ${task.location}.',
        icon: LucideIcons.fileSignature,
        route: '/event_day',
      ),
    );

    notifyListeners();
  }

  void unassignTask(String taskId) {
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (tIdx != -1) {
      final task = _tasks[tIdx];
      _tasks[tIdx] = task.copyWith(
        clearAssignment: true,
        status: 'UNASSIGNED',
      );

      for (int i = 0; i < _attendance.length; i++) {
        if (_attendance[i].assignedTask?.id == taskId) {
          _attendance[i] = _attendance[i].copyWith(clearTask: true);
          break;
        }
      }

      notifyListeners();
    }
  }

  void resetAttendance() {
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i] = _tasks[i].copyWith(
        clearAssignment: true,
        status: 'UNASSIGNED',
      );
    }
    for (int i = 0; i < _attendance.length; i++) {
      _attendance[i] = _attendance[i].copyWith(
        isPresent: false,
        checkInTime: null,
        clearTask: true,
      );
    }
    notifyListeners();
  }

  String _mapDepartmentName(Department dept) {
    switch (dept) {
      case Department.graphics:
        return 'GRAPHICS';
      case Department.logistics:
        return 'LOGISTICS';
      case Department.tech:
        return 'TECH';
      case Department.operations:
        return 'OPERATIONS';
      case Department.hospitality:
        return 'HOSPITALITY';
      case Department.corporateRelations:
        return 'CORPORATE';
      case Department.panelManagement:
        return 'PANEL';
    }
  }

  void _initTasksAndAttendance() {
    _tasks = [
      // Operations
      const OperationalTask(
        id: 'task-ops-1',
        title: 'Auditorium Main Gate Intake & Choke Point Marshal',
        department: 'OPERATIONS',
        location: 'Auditorium Gate 1 & 2',
        priority: TaskPriority.urgent,
        notes: 'Direct high volume university delegations to scan counters.',
      ),
      const OperationalTask(
        id: 'task-ops-2',
        title: 'Participant ID Badge & Welcome Kit Distribution',
        department: 'OPERATIONS',
        location: 'Registration Counter 1-4',
        priority: TaskPriority.high,
        notes: 'Verify QR barcode before handing over badge kit.',
      ),
      const OperationalTask(
        id: 'task-ops-3',
        title: 'Breakout Syndicate Rooms 101-104 Proctoring',
        department: 'OPERATIONS',
        location: '2nd Floor Syndicate Corridor',
        priority: TaskPriority.high,
        notes: 'Maintain room silence and timekeeper countdown bell.',
      ),
      const OperationalTask(
        id: 'task-ops-4',
        title: 'Lost-and-Found & Participant Info Helpdesk',
        department: 'OPERATIONS',
        location: 'Foyer Central Info Desk',
        priority: TaskPriority.routine,
        notes: 'Record attendee inquiries and lost badge requests.',
      ),
      const OperationalTask(
        id: 'task-ops-5',
        title: 'Auditorium Seating & Block Marshalling',
        department: 'OPERATIONS',
        location: 'Auditorium Block B & C',
        priority: TaskPriority.routine,
        notes: 'Ensure front 3 rows reserved for judges and faculty.',
      ),

      // Logistics
      const OperationalTask(
        id: 'task-log-1',
        title: 'Stage Rigging & Line-Array Audio Console Runner',
        department: 'LOGISTICS',
        location: 'Main Stage Audio Rack Left',
        priority: TaskPriority.urgent,
        notes: 'Monitor wireless mic frequency and battery reserves.',
      ),
      const OperationalTask(
        id: 'task-log-2',
        title: 'Emergency Power Substation & Heavy Cable Runs',
        department: 'LOGISTICS',
        location: 'North Electrical Annex',
        priority: TaskPriority.urgent,
        notes: 'Ensure uninterruptible generator sync with audio switch.',
      ),
      const OperationalTask(
        id: 'task-log-3',
        title: 'Venue Signage & Queue Barrier Stanchion Alignment',
        department: 'LOGISTICS',
        location: 'Quadrangle Outer Courtyard',
        priority: TaskPriority.routine,
        notes: 'Align sponsor tear-drop flags and entrance barricades.',
      ),
      const OperationalTask(
        id: 'task-log-4',
        title: 'Stage Furniture & Podium Relocation Crew',
        department: 'LOGISTICS',
        location: 'Backstage Storage Deck',
        priority: TaskPriority.routine,
        notes: 'Swift transfer of presentation podium between rounds.',
      ),

      // Tech
      const OperationalTask(
        id: 'task-tch-1',
        title: 'Gate 2 Handheld Barcode Scanner Terminal',
        department: 'TECH',
        location: 'Gate 2 Ingress Deck',
        priority: TaskPriority.urgent,
        notes: 'Verify attendee cryptographic QR signatures in offline cache.',
      ),
      const OperationalTask(
        id: 'task-tch-2',
        title: 'Live Stream Telemetry & YouTube RTMP Feeds',
        department: 'TECH',
        location: 'AV Broadcast Deck',
        priority: TaskPriority.high,
        notes: 'Maintain 1080p60 stream and audio leveling for finale.',
      ),
      const OperationalTask(
        id: 'task-tch-3',
        title: 'Scoreboard Display & Timer Screen System',
        department: 'TECH',
        location: 'Control Center Display Rig',
        priority: TaskPriority.high,
        notes: 'Mirror 15-minute presentation countdown timer to podium.',
      ),
      const OperationalTask(
        id: 'task-tch-4',
        title: 'Local Mesh Network & Offline Synchronization',
        department: 'TECH',
        location: 'Server Ops Room 002',
        priority: TaskPriority.routine,
        notes: 'Monitor packet latency between 6 gate terminals.',
      ),

      // Graphics
      const OperationalTask(
        id: 'task-gfx-1',
        title: 'Main Stage LED Visuals & Transition Looper',
        department: 'GRAPHICS',
        location: 'Projection Rig Left',
        priority: TaskPriority.high,
        notes: 'Synchronize keynote slide changes with stage lighting.',
      ),
      const OperationalTask(
        id: 'task-gfx-2',
        title: 'Social Media Live Event Cover & Highlights',
        department: 'GRAPHICS',
        location: 'Media Studio East',
        priority: TaskPriority.routine,
        notes: 'Publish high-resolution photo highlights to official channels.',
      ),
      const OperationalTask(
        id: 'task-gfx-3',
        title: 'Champion Trophy Crest & Winner Certificates',
        department: 'GRAPHICS',
        location: 'Creative Press Suite',
        priority: TaskPriority.routine,
        notes: 'Verify correct typography and spelling of finalists.',
      ),

      // Hospitality
      const OperationalTask(
        id: 'task-hos-1',
        title: 'Chief Guest & VIP Speaker Concierge Escort',
        department: 'HOSPITALITY',
        location: 'VIP Green Room A',
        priority: TaskPriority.urgent,
        notes: 'Welcome keynote speaker and escort to stage podium.',
      ),
      const OperationalTask(
        id: 'task-hos-2',
        title: 'Judges Deliberation Lounge Refreshments & Service',
        department: 'HOSPITALITY',
        location: 'Judge Lounge Room 204',
        priority: TaskPriority.high,
        notes: 'Serve catering and score tally collation sheets.',
      ),
      const OperationalTask(
        id: 'task-hos-3',
        title: 'Catering Coordination & Lunch Packet Distribution',
        department: 'HOSPITALITY',
        location: 'Banquet Hall Floor',
        priority: TaskPriority.high,
        notes: 'Supervise lunch queue for 500+ attendees at 1:30 PM.',
      ),
      const OperationalTask(
        id: 'task-hos-4',
        title: 'Guest Escort & Crest Presentation Protocol',
        department: 'HOSPITALITY',
        location: 'Stage Podium Annex',
        priority: TaskPriority.routine,
        notes: 'Guide guest faculty to honor stage during awards.',
      ),

      // Corporate Relations
      const OperationalTask(
        id: 'task-cr-1',
        title: 'Title Sponsor Expo Booth Activation & Liaison',
        department: 'CORPORATE',
        location: 'Atrium Sponsor Walkway',
        priority: TaskPriority.high,
        notes: 'Coordinate booth traffic and partner representative assistance.',
      ),
      const OperationalTask(
        id: 'task-cr-2',
        title: 'Partner Branding & Backdrop Compliance Audit',
        department: 'CORPORATE',
        location: 'Auditorium Photo Wall',
        priority: TaskPriority.routine,
        notes: 'Ensure partner logos are fully unobstructed in press photos.',
      ),
      const OperationalTask(
        id: 'task-cr-3',
        title: 'VIP Souvenir & Swag Bag Distribution Handover',
        department: 'CORPORATE',
        location: 'Dispatch Hub Room 102',
        priority: TaskPriority.routine,
        notes: 'Handover commemorative gift bags to corporate partners.',
      ),

      // Panel Management
      const OperationalTask(
        id: 'task-pan-1',
        title: 'Overall Event Day Command & Incident Escalation',
        department: 'PANEL',
        location: 'Command Center Main',
        priority: TaskPriority.urgent,
        notes: 'Authorize emergency directives and lead briefing calls.',
      ),
      const OperationalTask(
        id: 'task-pan-2',
        title: 'Inter-departmental Floor Coordination Relay',
        department: 'PANEL',
        location: 'Central Secretariat',
        priority: TaskPriority.urgent,
        notes: 'Liaise between Operations, Tech, and Hospitality teams.',
      ),
      const OperationalTask(
        id: 'task-pan-3',
        title: 'External Dignitaries & Press Media Briefing',
        department: 'PANEL',
        location: 'External Affairs Suite',
        priority: TaskPriority.high,
        notes: 'Brief university journalists and print media correspondents.',
      ),
    ];

    // Initialize attendance records from TeamRosterRepository.members
    _attendance = TeamRosterRepository.members.map((m) {
      final deptStr = _mapDepartmentName(m.department);
      return AttendanceRecord(
        memberId: m.id,
        name: m.name,
        role: m.role,
        department: deptStr,
        tierLabel: m.tierLabel,
        departmentColor: m.departmentColor,
        tierColor: m.tierColor,
        avatarInitials: m.avatarInitials,
        isPresent: false,
        checkInTime: null,
        assignedTask: null,
      );
    }).toList();

    // Pre-seed 8 officers as attended with automated tasks
    final initialCheckIns = [
      {'id': 'SPC-PAN-01', 'time': '07:45 AM', 'taskId': 'task-pan-1'},
      {'id': 'SPC-SNREX-OPS-02', 'time': '08:00 AM', 'taskId': 'task-ops-1'},
      {'id': 'SPC-SNREX-TCH-05', 'time': '08:05 AM', 'taskId': 'task-tch-1'},
      {'id': 'SPC-SNREX-LOG-06', 'time': '08:10 AM', 'taskId': 'task-log-1'},
      {'id': 'SPC-JNREX-TCH-05', 'time': '08:15 AM', 'taskId': 'task-tch-2'},
      {'id': 'SPC-ASC-GFX-01', 'time': '08:20 AM', 'taskId': 'task-gfx-1'},
      {'id': 'SPC-JNREX-HOS-09', 'time': '08:22 AM', 'taskId': 'task-hos-1'},
      {'id': 'SPC-JNREX-CR-11', 'time': '08:25 AM', 'taskId': 'task-cr-1'},
    ];

    for (final item in initialCheckIns) {
      final mId = item['id'] as String;
      final time = item['time'] as String;
      final tId = item['taskId'] as String;

      final mIdx = _attendance.indexWhere((a) => a.memberId == mId);
      final tIdx = _tasks.indexWhere((t) => t.id == tId);

      if (mIdx != -1 && tIdx != -1) {
        final assignedTask = _tasks[tIdx].copyWith(
          assignedToMemberId: mId,
          assignedToMemberName: _attendance[mIdx].name,
          assignedAt: time,
          status: 'IN PROGRESS',
        );
        _tasks[tIdx] = assignedTask;
        _attendance[mIdx] = _attendance[mIdx].copyWith(
          isPresent: true,
          checkInTime: time,
          assignedTask: assignedTask,
        );
      }
    }
  }

  // Helpers
  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}

final operationsProvider = ChangeNotifierProvider<OperationsNotifier>((ref) {
  return OperationsNotifier();
});
