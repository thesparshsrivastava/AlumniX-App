import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Gamification section displaying streak, points, badges, and ranking
class GamificationSectionWidget extends StatelessWidget {
  final Map<String, dynamic> gamificationData;

  const GamificationSectionWidget({
    super.key,
    required this.gamificationData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStreak = (gamificationData['currentStreak'] as int?) ?? 0;
    final totalPoints = (gamificationData['totalPoints'] as int?) ?? 0;
    final leaderboardRank = (gamificationData['leaderboardRank'] as int?) ?? 0;
    final badges = (gamificationData['badges'] as List?) ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Achievements',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Stats Row
          Row(
            children: [
              // Streak Counter
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  'fire',
                  currentStreak.toString(),
                  'Day Streak',
                  theme.colorScheme.error,
                ),
              ),

              SizedBox(width: 3.w),

              // Total Points
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  'stars',
                  _formatPoints(totalPoints),
                  'Total Points',
                  theme.colorScheme.tertiary,
                ),
              ),

              SizedBox(width: 3.w),

              // Leaderboard Rank
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  'leaderboard',
                  leaderboardRank > 0 ? '#$leaderboardRank' : '--',
                  'Ranking',
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Recent Badges Section
          if (badges.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Badges',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/leaderboard-screen'),
                  child: Text(
                    'View All',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Badge List
            SizedBox(
              height: 12.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: badges.length > 3 ? 3 : badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index] as Map<String, dynamic>;
                  return _buildBadgeCard(context, theme, badge);
                },
              ),
            ),
          ] else ...[
            // No badges placeholder
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'emoji_events',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No badges earned yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Start helping others to earn your first badge!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme,
    String iconName,
    String value,
    String label,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: accentColor,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(
      BuildContext context, ThemeData theme, Map<String, dynamic> badge) {
    final badgeName = (badge['name'] as String?) ?? 'Badge';
    final badgeIcon = (badge['icon'] as String?) ?? 'emoji_events';
    final earnedDate = (badge['earnedDate'] as String?) ?? '';
    final description = (badge['description'] as String?) ?? '';

    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Badge Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: badgeIcon,
              color: theme.colorScheme.onPrimary,
              size: 5.w,
            ),
          ),

          SizedBox(height: 1.h),

          // Badge Name
          Text(
            badgeName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 0.5.h),

          // Earned Date
          if (earnedDate.isNotEmpty)
            Text(
              earnedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1)}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }
}
