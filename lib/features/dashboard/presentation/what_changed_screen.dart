import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class WhatChangedScreen extends StatelessWidget {
  const WhatChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WHAT CHANGED?',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                height: 1.2,
                color: AppColors.primaryYellow,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Since your last visit',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.mutedWhite,
              ),
            ),
            const SizedBox(height: 48),
            
            _buildTimelineItem(
              context,
              time: '09:20 AM',
              title: 'Participant List',
              description: 'Updated to v3',
              isHighlight: true,
              icon: LucideIcons.fileSpreadsheet,
            ),
            
            _buildTimelineItem(
              context,
              time: '09:12 AM',
              title: 'Decision #024',
              description: 'Registration location changed',
              isHighlight: true,
              icon: LucideIcons.fileSignature,
              onTap: () => context.push('/decision/024'),
            ),
            
            _buildTimelineItem(
              context,
              time: '08:47 AM',
              title: 'Speaker arrival',
              description: 'Changed to 10:45 AM',
              icon: LucideIcons.clock,
            ),
            
            _buildTimelineItem(
              context,
              time: '08:31 AM',
              title: 'Registration system',
              description: 'Now LIVE',
              icon: LucideIcons.checkCircle,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, {
    required String time,
    required String title,
    required String description,
    required IconData icon,
    bool isHighlight = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    final color = isHighlight ? AppColors.primaryYellow : AppColors.mutedWhite;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
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
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighlight ? AppColors.primaryYellow.withValues(alpha: 0.3) : AppColors.darkBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 20),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isHighlight ? AppColors.white : AppColors.mutedWhite,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: color,
                                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onTap != null)
                        const Icon(LucideIcons.chevronRight, color: AppColors.mutedWhite, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
