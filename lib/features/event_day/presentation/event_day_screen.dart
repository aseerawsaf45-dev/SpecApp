import 'package:flutter/material.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';

class EventDayScreen extends StatelessWidget {
  const EventDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            Text(
              'CASESpecs 4.0',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '27 SEPTEMBER',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryYellow,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildFastAccessCard(
                context,
                title: 'IMPORTANT UPDATES',
                count: '3',
                icon: LucideIcons.alertCircle,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              
              _buildFastAccessCard(
                context,
                title: 'EVENT DAY PACK',
                count: '8 FILES',
                icon: LucideIcons.folder,
                color: AppColors.primaryYellow,
              ),
              const SizedBox(height: 32),
              
              Text(
                'LIVE SCHEDULE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildScheduleTimeline(context),
              
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryActionCard(
                      context,
                      title: 'TEAM',
                      subtitle: '47 MEMBERS',
                      icon: LucideIcons.users,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSecondaryActionCard(
                      context,
                      title: 'EMERGENCY',
                      subtitle: 'Contacts',
                      icon: LucideIcons.phone,
                      isAlert: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFastAccessCard(BuildContext context, {
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: AppColors.mutedWhite),
        ],
      ),
    );
  }

  Widget _buildSecondaryActionCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    bool isAlert = false,
  }) {
    final color = isAlert ? Colors.redAccent : AppColors.primaryYellow;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline(BuildContext context) {
    return Column(
      children: [
        _buildScheduleItem(context, '09:00', 'Registration', isCompleted: true),
        _buildScheduleItem(context, '10:00', 'Opening', isCompleted: true),
        _buildScheduleItem(context, '10:30', 'Competition', isActive: true),
        _buildScheduleItem(context, '13:00', 'Lunch', isUpcoming: true),
        _buildScheduleItem(context, '14:00', 'Final Round', isUpcoming: true),
        _buildScheduleItem(context, '17:00', 'Closing', isUpcoming: true, isLast: true),
      ],
    );
  }

  Widget _buildScheduleItem(BuildContext context, String time, String title, {
    bool isCompleted = false,
    bool isActive = false,
    bool isUpcoming = false,
    bool isLast = false,
  }) {
    Color getLineColor() {
      if (isActive || isCompleted) return AppColors.primaryYellow;
      return AppColors.darkBorder;
    }
    
    Color getDotColor() {
      if (isActive) return AppColors.primaryYellow;
      if (isCompleted) return AppColors.primaryYellow.withValues(alpha: 0.5);
      return AppColors.darkBorder;
    }
    
    Color getTextColor() {
      if (isActive) return AppColors.white;
      if (isCompleted) return AppColors.mutedWhite;
      return AppColors.mutedWhite;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 50,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: getTextColor(),
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: getDotColor(),
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: AppColors.deepBlack, width: 2) : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: getLineColor(),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: getTextColor(),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
