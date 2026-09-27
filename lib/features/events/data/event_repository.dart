import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/event.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

class EventRepository {
  // In-memory / Mock implementation ready to swap with CloudFirestore
  final List<Event> _mockEvents = [
    Event(
      id: 'casespecs-4',
      organizationId: 'demo_org_id',
      name: 'CASESpecs 4.0',
      description: 'Annual flagship case competition',
      startDate: DateTime.now().add(const Duration(days: 23)),
      endDate: DateTime.now().add(const Duration(days: 24)),
      status: EventStatus.preparation,
      progress: 0.78,
      leadUserId: 'Aseer Awsaf',
      memberIds: ['aseer', 'foysal', 'yousuf', 'ridoy'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  ];

  Stream<List<Event>> watchEvents(String organizationId) {
    return Stream.value(_mockEvents);
  }

  Future<Event> getEvent(String organizationId, String eventId) async {
    return _mockEvents.firstWhere(
      (e) => e.id == eventId,
      orElse: () => _mockEvents.first,
    );
  }

  Future<void> updateEventStatus(String organizationId, String eventId, EventStatus status) async {
    final index = _mockEvents.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final old = _mockEvents[index];
      _mockEvents[index] = Event(
        id: old.id,
        organizationId: old.organizationId,
        name: old.name,
        description: old.description,
        startDate: old.startDate,
        endDate: old.endDate,
        status: status,
        progress: old.progress,
        leadUserId: old.leadUserId,
        memberIds: old.memberIds,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }
}
