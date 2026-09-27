import 'package:flutter/material.dart';
import '../../../../shared/models/event.dart';
import '../../data/event_repository.dart';

class EventNotifier extends ChangeNotifier {
  final EventRepository _repository = EventRepository();
  String _currentOrgId = 'demo_org_id';
  List<Event> _events = [];
  bool _isLoading = false;

  EventNotifier() {
    loadEvents();
  }

  String get currentOrgId => _currentOrgId;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  void setOrgId(String orgId) {
    _currentOrgId = orgId;
    loadEvents();
  }

  void loadEvents() {
    _isLoading = true;
    notifyListeners();
    _repository.watchEvents(_currentOrgId).listen((data) {
      _events = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> setEventLive(String eventId) async {
    await _repository.updateEventStatus(_currentOrgId, eventId, EventStatus.live);
    loadEvents();
  }
}

final eventNotifier = EventNotifier();
