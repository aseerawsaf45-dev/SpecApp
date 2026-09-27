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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/what_changed',
        builder: (context, state) => const WhatChangedScreen(),
      ),
      GoRoute(
        path: '/event_day',
        builder: (context, state) => const EventDayScreen(),
      ),
      GoRoute(
        path: '/event',
        builder: (context, state) => const EventScreen(),
      ),
      GoRoute(
        path: '/chat/:channelName',
        builder: (context, state) {
          final channelName = state.pathParameters['channelName']!;
          return ChatScreen(channelName: channelName);
        },
      ),
      GoRoute(
        path: '/decision/:decisionId',
        builder: (context, state) {
          final decisionId = state.pathParameters['decisionId']!;
          return DecisionDetailScreen(decisionId: decisionId);
        },
      ),
      // Additional routes will be added here
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
