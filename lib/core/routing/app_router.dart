import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/what_changed_screen.dart';
import '../../features/event_day/presentation/event_day_screen.dart';
import '../../features/events/presentation/event_screen.dart';
import '../../features/messages/presentation/chat_screen.dart';
import '../../features/decisions/presentation/decision_detail_screen.dart';
import '../../features/roster/presentation/team_roster_screen.dart';

CustomTransitionPage<void> _buildPremiumPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/what_changed',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const WhatChangedScreen(),
        ),
      ),
      GoRoute(
        path: '/event_day',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const EventDayScreen(),
        ),
      ),
      GoRoute(
        path: '/event',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const EventScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:channelName',
        pageBuilder: (context, state) {
          final channelName = state.pathParameters['channelName']!;
          return _buildPremiumPage(
            state: state,
            child: ChatScreen(channelName: channelName),
          );
        },
      ),
      GoRoute(
        path: '/decision/:decisionId',
        pageBuilder: (context, state) {
          final decisionId = state.pathParameters['decisionId']!;
          return _buildPremiumPage(
            state: state,
            child: DecisionDetailScreen(decisionId: decisionId),
          );
        },
      ),
      GoRoute(
        path: '/team_roster',
        pageBuilder: (context, state) => _buildPremiumPage(
          state: state,
          child: const TeamRosterScreen(),
        ),
      ),
    ],
  );
});

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
