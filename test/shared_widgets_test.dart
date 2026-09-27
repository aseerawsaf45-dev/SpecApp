import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventos/shared/widgets/command_card.dart';
import 'package:eventos/shared/widgets/pressable_scale.dart';
import 'package:eventos/shared/widgets/pulsing_beacon.dart';
import 'package:eventos/shared/widgets/staggered_entrance.dart';

import 'package:eventos/shared/widgets/animated_counter.dart';
import 'package:eventos/shared/widgets/animated_glowing_border.dart';
import 'package:eventos/shared/widgets/gradient_mesh_background.dart';
import 'package:eventos/shared/widgets/shimmer_sweep.dart';
import 'package:eventos/shared/widgets/spotlight_card.dart';

void main() {
  group('Shared Widgets Tests', () {
    testWidgets('PressableScale triggers onTap callback and animates', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableScale(
              onTap: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      expect(find.text('Tap Me'), findsOneWidget);
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('PulsingBeacon renders with label and auras', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PulsingBeacon(
              label: 'LIVE',
              dotSize: 6,
              maxAuraSize: 16,
            ),
          ),
        ),
      );

      expect(find.text('LIVE'), findsOneWidget);
      // Advance animation timer
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('LIVE'), findsOneWidget);
    });

    testWidgets('CommandCard renders with priority glow and child', (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommandCard(
              hasPriorityGlow: true,
              onTap: () => clicked = true,
              child: const Text('Priority Action'),
            ),
          ),
        ),
      );

      expect(find.text('Priority Action'), findsOneWidget);
      await tester.tap(find.text('Priority Action'));
      await tester.pumpAndSettle();
      expect(clicked, isTrue);
    });

    testWidgets('StaggeredEntrance fades and slides child into view', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StaggeredEntrance(
              index: 0,
              child: Text('Cascading Element'),
            ),
          ),
        ),
      );

      expect(find.text('Cascading Element'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Cascading Element'), findsOneWidget);
    });

    testWidgets('AnimatedGlowingBorder renders child content and animates frame', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedGlowingBorder(
              glowColor: Colors.amber,
              child: Text('Glowing Directive'),
            ),
          ),
        ),
      );

      expect(find.text('Glowing Directive'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Glowing Directive'), findsOneWidget);
    });

    testWidgets('ShimmerSweep renders child with shader mask animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerSweep(
              child: Text('Metallic Header'),
            ),
          ),
        ),
      );

      expect(find.text('Metallic Header'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Metallic Header'), findsOneWidget);

      // Cleanly unmount to cancel repeating timers
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('AnimatedCounter rolls up to target number', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCounter(
              targetValue: 42,
              prefix: '\$',
              suffix: ' K',
            ),
          ),
        ),
      );

      // Fast-forward to completion
      await tester.pumpAndSettle();
      expect(find.text('\$42 K'), findsOneWidget);
    });

    testWidgets('SpotlightCard renders child and triggers tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SpotlightCard(
              onTap: () => tapped = true,
              child: const Text('Spotlight Content'),
            ),
          ),
        ),
      );

      expect(find.text('Spotlight Content'), findsOneWidget);
      await tester.tap(find.text('Spotlight Content'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('GradientMeshBackground renders child with animated ambient mesh', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientMeshBackground(
              child: Text('Mesh Content'),
            ),
          ),
        ),
      );

      expect(find.text('Mesh Content'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Mesh Content'), findsOneWidget);

      // Cleanly unmount to cancel repeating animation controller
      await tester.pumpWidget(const SizedBox());
    });
  });
}
