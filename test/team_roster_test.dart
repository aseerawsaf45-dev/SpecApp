import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/features/roster/domain/team_member.dart';
import 'package:eventos/features/roster/presentation/team_roster_screen.dart';

void main() {
  group('Executive Corps Roster Domain & Integrity Tests', () {
    test('Verifies all 4 tiers exist in roster', () {
      final members = TeamRosterRepository.members;
      expect(members.isNotEmpty, isTrue);

      final panel = members.where((m) => m.tier == ExecutiveTier.panel).toList();
      final senior = members.where((m) => m.tier == ExecutiveTier.seniorExecutive).toList();
      final junior = members.where((m) => m.tier == ExecutiveTier.juniorExecutive).toList();
      final associate = members.where((m) => m.tier == ExecutiveTier.associateExecutive).toList();

      expect(panel.length, equals(9), reason: 'Tier 1 Panel must have 9 members');
      expect(senior.length, equals(8), reason: 'Tier 2 Senior Executives must have 8 members');
      expect(junior.length, equals(12), reason: 'Tier 3 Junior Executives must have 12 members');
      expect(associate.length, equals(14), reason: 'Tier 4 Associate Executives must have 14 members');
      expect(members.length, equals(43), reason: 'Total roster must be 43 members');
    });

    test('Verifies every officer has a unique individual ID', () {
      final members = TeamRosterRepository.members;
      final ids = members.map((m) => m.id).toSet();
      expect(ids.length, equals(members.length), reason: 'All member IDs must be strictly unique');
    });

    test('Verifies department IDs correspond to respective departments', () {
      final members = TeamRosterRepository.members;
      for (final member in members) {
        if (member.tier == ExecutiveTier.panel) {
          expect(member.id.startsWith('SPC-PAN-'), isTrue);
        } else if (member.department == Department.graphics) {
          expect(member.id.contains('GFX') || member.id.contains('PUB'), isTrue,
              reason: '${member.name} in graphics should have GFX or PUB in ID');
        } else if (member.department == Department.logistics) {
          expect(member.id.contains('LOG'), isTrue, reason: '${member.name} in logistics should have LOG in ID');
        } else if (member.department == Department.tech) {
          expect(member.id.contains('TCH'), isTrue, reason: '${member.name} in tech should have TCH in ID');
        }
      }
    });

    testWidgets('TeamRosterScreen renders 4 sections and filter bar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpWidget(
        const MaterialApp(
          home: TeamRosterScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('EXECUTIVE CORPS'), findsOneWidget);
      expect(find.text('4 TIERS'), findsOneWidget);
      expect(find.text('1. PANEL'), findsWidgets);
      expect(find.text('2. SENIOR EXEC'), findsWidgets);
      expect(find.text('3. JUNIOR EXEC'), findsWidgets);
      expect(find.text('4. ASSOCIATE'), findsWidgets);

      // Advance timer so StaggeredEntrance timers are completed
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('SPC-PAN-01'), findsOneWidget);
      expect(find.text('Salman Farshi Alam (Supto)'), findsOneWidget);
      expect(find.text('SPC-PAN-04'), findsOneWidget);
      expect(find.text('Vacant (TBD)'), findsOneWidget);
    });
  });
}
