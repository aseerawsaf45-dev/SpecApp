import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class DecisionDetailScreen extends StatelessWidget {
  final String decisionId;

  const DecisionDetailScreen({super.key, required this.decisionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: Text('DECISION #$decisionId', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(icon: const Icon(LucideIcons.edit2), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REGISTRATION DESK LOCATION',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(context, 'CURRENT DECISION', 'Auditorium Entrance', isHighlighted: true),
            const SizedBox(height: 24),
            
            _buildSection(context, 'REASON FOR CHANGE', 'Expected crowd movement from main gate.'),
            const SizedBox(height: 24),
            
            _buildSection(context, 'AFFECTED TEAMS', 'Registration, Logistics, Hospitality'),
            const SizedBox(height: 32),
            
            _buildMetadata(context),
            
            const SizedBox(height: 48),
            Text(
              'DECISION HISTORY',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryTimeline(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isHighlighted ? AppColors.primaryYellow : AppColors.mutedWhite,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isHighlighted ? AppColors.white : AppColors.mutedWhite,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            fontSize: isHighlighted ? 18 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryBlack,
            child: Text('F', style: Theme.of(context).textTheme.labelSmall),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UPDATED BY', style: Theme.of(context).textTheme.labelSmall),
                Text('Foysal · Event Coordinator', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('27 SEPT', style: Theme.of(context).textTheme.bodyMedium),
              Text('09:12 AM', style: Theme.of(context).textTheme.labelSmall),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(BuildContext context) {
    return Column(
      children: [
        _buildHistoryItem(
          context,
          version: 'VERSION 2',
          date: '27 Sept · 09:12 AM',
          content: 'Auditorium Entrance',
          isCurrent: true,
        ),
        _buildHistoryItem(
          context,
          version: 'VERSION 1',
          date: '26 Sept · 07:42 PM',
          content: 'A Block Entrance',
          isCurrent: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, {
    required String version,
    required String date,
    required String content,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isCurrent ? AppColors.primaryYellow : AppColors.charcoal,
                  shape: BoxShape.circle,
                  border: Border.all(color: isCurrent ? AppColors.primaryYellow : AppColors.mutedWhite, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.darkBorder,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        version,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isCurrent ? AppColors.primaryYellow : AppColors.mutedWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isCurrent ? AppColors.white : AppColors.mutedWhite,
                      decoration: isCurrent ? TextDecoration.none : TextDecoration.lineThrough,
                    ),
                  ),
                  if (isCurrent)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CURRENT',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
