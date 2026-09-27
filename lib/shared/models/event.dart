enum EventStatus {
  upcoming,
  preparation,
  live,
  completed,
  archived,
}

class Event {
  final String id;
  final String organizationId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final EventStatus status;
  final double progress;
  final String leadUserId;
  final List<String> memberIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progress,
    required this.leadUserId,
    this.memberIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.preparation,
      ),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      leadUserId: json['leadUserId'] as String? ?? '',
      memberIds: (json['memberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'progress': progress,
      'leadUserId': leadUserId,
      'memberIds': memberIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
