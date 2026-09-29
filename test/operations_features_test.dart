import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/core/state/models/event_ops_models.dart';
import 'package:eventos/core/state/operations_state.dart';

void main() {
  group('Operations State & Feature Verification Tests', () {
    late OperationsNotifier notifier;

    setUp(() {
      notifier = OperationsNotifier();
    });

    test('Initial State contains default events and decisions', () {
      expect(notifier.events.isNotEmpty, true);
      expect(notifier.activeEvent.id, 'casespecs-4');
      expect(notifier.decisions.isNotEmpty, true);
      expect(notifier.alerts.isNotEmpty, true);
      expect(notifier.schedule.isNotEmpty, true);
      expect(notifier.auditLogs.isNotEmpty, true);
    });

    test('Deploying a new event updates event portfolio and audit logs', () {
      final initialEventsCount = notifier.events.length;
      final initialLogsCount = notifier.auditLogs.length;

      final newEvent = OperationalEvent(
        id: 'test-event-1',
        title: 'Quantum Hackathon 2026',
        subtitle: 'Quantum Computing Challenge',
        phase: 'LOGISTICS PLANNING',
        daysLeft: 40,
        progress: 0.25,
        membersCount: 15,
        lead: 'Test Officer',
        date: DateTime.now().add(const Duration(days: 40)),
      );

      notifier.addEvent(newEvent);

      expect(notifier.events.length, initialEventsCount + 1);
      expect(notifier.events.first.title, 'Quantum Hackathon 2026');
      expect(notifier.auditLogs.length, initialLogsCount + 1);
      expect(notifier.auditLogs.first.title.contains('Quantum Hackathon 2026'), true);
    });

    test('Casting vote on Directive #025 updates approvals and audit trail', () {
      final decision = notifier.getDecision('025');
      expect(decision, isNotNull);
      final initialApprovals = decision!.approvals;

      notifier.castVote('025', 'APPROVE');

      final updatedDecision = notifier.getDecision('025');
      expect(updatedDecision!.approvals, initialApprovals + 1);
      expect(updatedDecision.userVote, 'APPROVE');
      expect(updatedDecision.isAcknowledged, true);
      expect(notifier.auditLogs.first.title.contains('Directive #025'), true);
    });

    test('Adding a decision comment updates coordination log', () {
      final initialCommentsCount = notifier.getDecision('024')!.comments.length;

      notifier.addDecisionComment('024', 'High-speed fiber drop verified at Station A.');

      final updatedDecision = notifier.getDecision('024');
      expect(updatedDecision!.comments.length, initialCommentsCount + 1);
      expect(updatedDecision.comments.last.text, 'High-speed fiber drop verified at Station A.');
    });

    test('Transmitting broadcast alert updates alerts list', () {
      final initialAlertsCount = notifier.alerts.length;

      final newAlert = BroadcastAlert(
        id: 'test-alert-1',
        badge: 'SECURITY CLEARANCE',
        title: 'Stage Pass Code Rotation',
        time: 'Just now',
        description: 'New security code issued for backstage.',
        actionLabel: 'VIEW AUDIT',
        actionRoute: '/what_changed',
        priority: AlertPriority.urgent,
      );

      notifier.addBroadcast(newAlert);

      expect(notifier.alerts.length, initialAlertsCount + 1);
      expect(notifier.alerts.first.id, 'test-alert-1');

      // Dismiss test
      notifier.dismissAlert('test-alert-1');
      expect(notifier.alerts.length, initialAlertsCount);
    });

    test('Simulating gate check-in increments active event count and scanned list', () {
      final initialCheckedIn = notifier.activeEvent.checkedInCount;
      final initialScannedCount = notifier.scannedParticipants.length;

      notifier.simulateCheckIn('Nafis Ahmed', 'Dhaka University', 'Alpha Squad');

      expect(notifier.activeEvent.checkedInCount, initialCheckedIn + 1);
      expect(notifier.scannedParticipants.length, initialScannedCount + 1);
      expect(notifier.scannedParticipants.first.name, 'Nafis Ahmed');
    });

    test('Schedule milestone state toggling cycles statuses', () {
      final initialStatus = notifier.schedule.first.status;
      expect(initialStatus, 'COMPLETED');
      notifier.toggleScheduleStatus('s1');
      expect(notifier.schedule.first.status, 'DELAYED');

      notifier.toggleScheduleStatus('s1');
      expect(notifier.schedule.first.status, 'UPCOMING');

      notifier.toggleScheduleStatus('s1');
      expect(notifier.schedule.first.status, 'LIVE');
    });

    test('Chat message transmission and emoji reaction tracking', () {
      notifier.sendChatMessage('announcements', 'Test dispatch message');
      final msgs = notifier.getMessagesForChannel('announcements');
      expect(msgs.last.message, 'Test dispatch message');

      // Reaction toggle
      notifier.toggleReaction('announcements', msgs.last.id, '👍');
      final updatedMsgs = notifier.getMessagesForChannel('announcements');
      expect(updatedMsgs.last.reactions['👍'], 1);
      expect(updatedMsgs.last.userReactions.contains('👍'), true);

      // Untoggle reaction
      notifier.toggleReaction('announcements', msgs.last.id, '👍');
      final untoggledMsgs = notifier.getMessagesForChannel('announcements');
      expect(untoggledMsgs.last.reactions.containsKey('👍'), false);
    });

    test('Initial attendance roster contains all 43 officers and operational tasks', () {
      expect(notifier.totalOfficersCount, 43);
      expect(notifier.attendanceList.length, 43);
      expect(notifier.tasks.isNotEmpty, true);
      expect(notifier.attendedOfficersCount > 0, true);
      expect(notifier.assignedTasksCount > 0, true);
    });

    test('Toggling attendance check-in auto-assigns matching department task', () {
      // Find an absent member (e.g. SPC-ASC-OPS-08 Anika Tabassum)
      final absent = notifier.attendanceList.firstWhere((a) => !a.isPresent);
      expect(absent.assignedTask, isNull);

      notifier.toggleAttendance(absent.memberId);

      final updated = notifier.attendanceList.firstWhere((a) => a.memberId == absent.memberId);
      expect(updated.isPresent, true);
      expect(updated.checkInTime, isNotNull);
      expect(updated.assignedTask, isNotNull);
      expect(updated.assignedTask!.status, 'IN PROGRESS');
      expect(updated.assignedTask!.assignedToMemberId, absent.memberId);
      expect(notifier.auditLogs.first.title.contains('Officer Check-in'), true);
    });

    test('Toggling attendance to absent releases assigned task back to pool', () {
      // Mark an officer present
      final absent = notifier.attendanceList.firstWhere((a) => !a.isPresent);
      notifier.toggleAttendance(absent.memberId);

      final checkedIn = notifier.attendanceList.firstWhere((a) => a.memberId == absent.memberId);
      final taskId = checkedIn.assignedTask!.id;

      // Now toggle absent
      notifier.toggleAttendance(absent.memberId);

      final markedAbsent = notifier.attendanceList.firstWhere((a) => a.memberId == absent.memberId);
      expect(markedAbsent.isPresent, false);
      expect(markedAbsent.assignedTask, isNull);

      final taskInPool = notifier.getTask(taskId);
      expect(taskInPool, isNotNull);
      expect(taskInPool!.assignedToMemberId, isNull);
      expect(taskInPool.status, 'UNASSIGNED');
    });

    test('Batch auto-assignment distributes tasks to all unattended present personnel', () {
      // Turn off auto-assign on checkin
      notifier.setAutoAssignOnCheckin(false);

      final absentMembers = notifier.attendanceList.where((a) => !a.isPresent).take(3).toList();
      for (final m in absentMembers) {
        notifier.toggleAttendance(m.memberId);
      }

      // Verify they are present but without tasks
      for (final m in absentMembers) {
        final rec = notifier.attendanceList.firstWhere((a) => a.memberId == m.memberId);
        expect(rec.isPresent, true);
        expect(rec.assignedTask, isNull);
      }

      // Execute batch auto-assignment
      final assignedCount = notifier.autoAssignTasksToAllAttended();
      expect(assignedCount >= 3, true);

      for (final m in absentMembers) {
        final rec = notifier.attendanceList.firstWhere((a) => a.memberId == m.memberId);
        expect(rec.assignedTask, isNotNull);
      }
    });

    test('Task completion updates task status in pool and attendance record', () {
      final attendedWithTask = notifier.attendanceList.firstWhere((a) => a.assignedTask != null);
      final taskId = attendedWithTask.assignedTask!.id;

      notifier.updateTaskStatus(taskId, 'COMPLETED');

      final updatedTask = notifier.getTask(taskId);
      expect(updatedTask!.status, 'COMPLETED');

      final updatedRecord = notifier.attendanceList.firstWhere((a) => a.memberId == attendedWithTask.memberId);
      expect(updatedRecord.assignedTask!.status, 'COMPLETED');
      expect(notifier.auditLogs.first.title.contains('Task Completed'), true);
    });

    test('Manual task assignment links specific task to officer', () {
      final absent = notifier.attendanceList.firstWhere((a) => !a.isPresent);
      final unassignedTask = notifier.tasks.firstWhere((t) => t.assignedToMemberId == null);

      notifier.manualAssignTask(absent.memberId, unassignedTask.id);

      final updated = notifier.attendanceList.firstWhere((a) => a.memberId == absent.memberId);
      expect(updated.isPresent, true);
      expect(updated.assignedTask?.id, unassignedTask.id);

      final updatedTask = notifier.getTask(unassignedTask.id);
      expect(updatedTask?.assignedToMemberId, absent.memberId);
      expect(updatedTask?.status, 'IN PROGRESS');
    });

    test('Reset attendance clears check-ins and unassigns all tasks', () {
      notifier.resetAttendance();

      expect(notifier.attendedOfficersCount, 0);
      expect(notifier.assignedTasksCount, 0);
      for (final a in notifier.attendanceList) {
        expect(a.isPresent, false);
        expect(a.assignedTask, isNull);
      }
      for (final t in notifier.tasks) {
        expect(t.assignedToMemberId, isNull);
        expect(t.status, 'UNASSIGNED');
      }
    });
  });
}

