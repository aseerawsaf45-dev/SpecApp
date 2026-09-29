import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

enum AlertPriority { info, routine, urgent, critical }

class OperationalEvent {
  final String id;
  final String title;
  final String subtitle;
  final String phase;
  final int daysLeft;
  final double progress;
  final int membersCount;
  final String lead;
  final bool isFeatured;
  final int targetAttendees;
  final int checkedInCount;
  final String location;
  final DateTime date;

  const OperationalEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phase,
    required this.daysLeft,
    required this.progress,
    required this.membersCount,
    required this.lead,
    this.isFeatured = false,
    this.targetAttendees = 500,
    this.checkedInCount = 0,
    this.location = 'Main Auditorium & Exhibition Hall',
    required this.date,
  });

  OperationalEvent copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? phase,
    int? daysLeft,
    double? progress,
    int? membersCount,
    String? lead,
    bool? isFeatured,
    int? targetAttendees,
    int? checkedInCount,
    String? location,
    DateTime? date,
  }) {
    return OperationalEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      phase: phase ?? this.phase,
      daysLeft: daysLeft ?? this.daysLeft,
      progress: progress ?? this.progress,
      membersCount: membersCount ?? this.membersCount,
      lead: lead ?? this.lead,
      isFeatured: isFeatured ?? this.isFeatured,
      targetAttendees: targetAttendees ?? this.targetAttendees,
      checkedInCount: checkedInCount ?? this.checkedInCount,
      location: location ?? this.location,
      date: date ?? this.date,
    );
  }
}

class DecisionComment {
  final String id;
  final String author;
  final String role;
  final String text;
  final String time;

  const DecisionComment({
    required this.id,
    required this.author,
    required this.role,
    required this.text,
    required this.time,
  });
}

class DecisionModel {
  final String id;
  final String title;
  final String directiveText;
  final String category;
  final String priority;
  final String status;
  final String proposer;
  final String version;
  final int approvals;
  final int rejections;
  final int abstains;
  final String? userVote; // 'APPROVE', 'REJECT', 'ABSTAIN', or null
  final bool isAcknowledged;
  final List<DecisionComment> comments;
  final String timestamp;
  final String sha256Hash;
  final List<String> affectedDepartments;

  const DecisionModel({
    required this.id,
    required this.title,
    required this.directiveText,
    required this.category,
    required this.priority,
    required this.status,
    required this.proposer,
    this.version = 'v2.1',
    required this.approvals,
    required this.rejections,
    required this.abstains,
    this.userVote,
    this.isAcknowledged = false,
    this.comments = const [],
    required this.timestamp,
    required this.sha256Hash,
    this.affectedDepartments = const ['Operations', 'Registration', 'Security'],
  });

  int get totalVotes => approvals + rejections + abstains;

  double get approvalPercent => totalVotes == 0 ? 0.0 : (approvals / totalVotes);
  double get rejectionPercent => totalVotes == 0 ? 0.0 : (rejections / totalVotes);

  Color get priorityColor {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
      case 'URGENT':
        return AppColors.statusRed;
      case 'HIGH':
        return AppColors.primaryYellow;
      default:
        return const Color(0xFF64B5F6);
    }
  }

  DecisionModel copyWith({
    String? id,
    String? title,
    String? directiveText,
    String? category,
    String? priority,
    String? status,
    String? proposer,
    String? version,
    int? approvals,
    int? rejections,
    int? abstains,
    String? userVote,
    bool? isAcknowledged,
    List<DecisionComment>? comments,
    String? timestamp,
    String? sha256Hash,
    List<String>? affectedDepartments,
  }) {
    return DecisionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      directiveText: directiveText ?? this.directiveText,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      proposer: proposer ?? this.proposer,
      version: version ?? this.version,
      approvals: approvals ?? this.approvals,
      rejections: rejections ?? this.rejections,
      abstains: abstains ?? this.abstains,
      userVote: userVote ?? this.userVote,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      sha256Hash: sha256Hash ?? this.sha256Hash,
      affectedDepartments: affectedDepartments ?? this.affectedDepartments,
    );
  }
}

class BroadcastAlert {
  final String id;
  final String badge;
  final String title;
  final String time;
  final String description;
  final String actionLabel;
  final String actionRoute;
  final AlertPriority priority;
  final String audience;
  final bool isAcknowledged;

  const BroadcastAlert({
    required this.id,
    required this.badge,
    required this.title,
    required this.time,
    required this.description,
    required this.actionLabel,
    required this.actionRoute,
    required this.priority,
    this.audience = 'ALL OPERATIONAL TERMINALS',
    this.isAcknowledged = false,
  });

  bool get isUrgent => priority == AlertPriority.critical || priority == AlertPriority.urgent;

  Color get priorityColor {
    switch (priority) {
      case AlertPriority.critical:
        return AppColors.statusRed;
      case AlertPriority.urgent:
        return AppColors.primaryYellow;
      case AlertPriority.routine:
        return const Color(0xFF60A5FA);
      case AlertPriority.info:
        return const Color(0xFF34D399);
    }
  }

  BroadcastAlert copyWith({
    String? id,
    String? badge,
    String? title,
    String? time,
    String? description,
    String? actionLabel,
    String? actionRoute,
    AlertPriority? priority,
    String? audience,
    bool? isAcknowledged,
  }) {
    return BroadcastAlert(
      id: id ?? this.id,
      badge: badge ?? this.badge,
      title: title ?? this.title,
      time: time ?? this.time,
      description: description ?? this.description,
      actionLabel: actionLabel ?? this.actionLabel,
      actionRoute: actionRoute ?? this.actionRoute,
      priority: priority ?? this.priority,
      audience: audience ?? this.audience,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }
}

class ScheduleMilestone {
  final String id;
  final String time;
  final String title;
  final String location;
  final String status; // 'LIVE', 'COMPLETED', 'UPCOMING', 'DELAYED'
  final String leadPerson;
  final String notes;

  const ScheduleMilestone({
    required this.id,
    required this.time,
    required this.title,
    required this.location,
    required this.status,
    required this.leadPerson,
    this.notes = '',
  });

  ScheduleMilestone copyWith({
    String? id,
    String? time,
    String? title,
    String? location,
    String? status,
    String? leadPerson,
    String? notes,
  }) {
    return ScheduleMilestone(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      location: location ?? this.location,
      status: status ?? this.status,
      leadPerson: leadPerson ?? this.leadPerson,
      notes: notes ?? this.notes,
    );
  }
}

class AuditTrailItem {
  final String id;
  final String time;
  final String category; // 'DECISIONS', 'DOCUMENTS', 'SCHEDULE', 'SYSTEM'
  final String title;
  final String description;
  final IconData icon;
  final bool isHighlight;
  final String? route;

  const AuditTrailItem({
    required this.id,
    required this.time,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    this.isHighlight = false,
    this.route,
  });
}

class ChatMessageModel {
  final String id;
  final String channel;
  final String sender;
  final String role;
  final String time;
  final String message;
  final bool isDecision;
  final String? decisionId;
  final bool isUrgent;
  final Map<String, int> reactions;
  final Set<String> userReactions;

  const ChatMessageModel({
    required this.id,
    required this.channel,
    required this.sender,
    required this.role,
    required this.time,
    required this.message,
    this.isDecision = false,
    this.decisionId,
    this.isUrgent = false,
    this.reactions = const {},
    this.userReactions = const {},
  });

  ChatMessageModel copyWith({
    String? id,
    String? channel,
    String? sender,
    String? role,
    String? time,
    String? message,
    bool? isDecision,
    String? decisionId,
    bool? isUrgent,
    Map<String, int>? reactions,
    Set<String>? userReactions,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      channel: channel ?? this.channel,
      sender: sender ?? this.sender,
      role: role ?? this.role,
      time: time ?? this.time,
      message: message ?? this.message,
      isDecision: isDecision ?? this.isDecision,
      decisionId: decisionId ?? this.decisionId,
      isUrgent: isUrgent ?? this.isUrgent,
      reactions: reactions ?? this.reactions,
      userReactions: userReactions ?? this.userReactions,
    );
  }
}

class ScannedParticipant {
  final String id;
  final String name;
  final String institution;
  final String teamName;
  final String timeScanned;
  final String gateName;
  final bool isVerified;

  const ScannedParticipant({
    required this.id,
    required this.name,
    required this.institution,
    required this.teamName,
    required this.timeScanned,
    this.gateName = 'Gate 2 (Auditorium)',
    this.isVerified = true,
  });
}

enum TaskPriority { urgent, high, routine }

class OperationalTask {
  final String id;
  final String title;
  final String department;
  final String location;
  final TaskPriority priority;
  final String? assignedToMemberId;
  final String? assignedToMemberName;
  final String? assignedAt;
  final String status; // 'UNASSIGNED', 'IN PROGRESS', 'COMPLETED'
  final String notes;

  const OperationalTask({
    required this.id,
    required this.title,
    required this.department,
    required this.location,
    this.priority = TaskPriority.high,
    this.assignedToMemberId,
    this.assignedToMemberName,
    this.assignedAt,
    this.status = 'UNASSIGNED',
    this.notes = '',
  });

  bool get isAssigned => assignedToMemberId != null;

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.urgent:
        return AppColors.statusRed;
      case TaskPriority.high:
        return AppColors.primaryYellow;
      case TaskPriority.routine:
        return const Color(0xFF60A5FA);
    }
  }

  OperationalTask copyWith({
    String? id,
    String? title,
    String? department,
    String? location,
    TaskPriority? priority,
    String? assignedToMemberId,
    String? assignedToMemberName,
    String? assignedAt,
    String? status,
    String? notes,
    bool clearAssignment = false,
  }) {
    return OperationalTask(
      id: id ?? this.id,
      title: title ?? this.title,
      department: department ?? this.department,
      location: location ?? this.location,
      priority: priority ?? this.priority,
      assignedToMemberId: clearAssignment ? null : (assignedToMemberId ?? this.assignedToMemberId),
      assignedToMemberName: clearAssignment ? null : (assignedToMemberName ?? this.assignedToMemberName),
      assignedAt: clearAssignment ? null : (assignedAt ?? this.assignedAt),
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class AttendanceRecord {
  final String memberId;
  final String name;
  final String role;
  final String department;
  final String tierLabel;
  final Color departmentColor;
  final Color tierColor;
  final String avatarInitials;
  final bool isPresent;
  final String? checkInTime;
  final OperationalTask? assignedTask;

  const AttendanceRecord({
    required this.memberId,
    required this.name,
    required this.role,
    required this.department,
    required this.tierLabel,
    required this.departmentColor,
    required this.tierColor,
    required this.avatarInitials,
    this.isPresent = false,
    this.checkInTime,
    this.assignedTask,
  });

  AttendanceRecord copyWith({
    String? memberId,
    String? name,
    String? role,
    String? department,
    String? tierLabel,
    Color? departmentColor,
    Color? tierColor,
    String? avatarInitials,
    bool? isPresent,
    String? checkInTime,
    OperationalTask? assignedTask,
    bool clearTask = false,
  }) {
    return AttendanceRecord(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      tierLabel: tierLabel ?? this.tierLabel,
      departmentColor: departmentColor ?? this.departmentColor,
      tierColor: tierColor ?? this.tierColor,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      isPresent: isPresent ?? this.isPresent,
      checkInTime: checkInTime ?? this.checkInTime,
      assignedTask: clearTask ? null : (assignedTask ?? this.assignedTask),
    );
  }
}
