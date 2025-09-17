import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// List widget displaying rankings from 4th position onwards
class RankingListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> rankings;
  final int userRank;
  final int userPoints;
  final VoidCallback? onUserTap;

  const RankingListWidget({
    super.key,
    required this.rankings,
    required this.userRank,
    required this.userPoints,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: rankings.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: theme.colorScheme.outline.withValues(alpha: 0.1),
      ),
      itemBuilder: (context, index) {
        final user = rankings[index];
        final position = (user['rank'] as int?) ?? (index + 4);
        final isCurrentUser = position == userRank;
        final pointDifference = (user['points'] as int?) ?? 0 - userPoints;

        return GestureDetector(
          onTap: onUserTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: isCurrentUser
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Rank number
                Container(
                  width: 10.w,
                  child: Text(
                    '#$position',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                      color: isCurrentUser
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isCurrentUser
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: (user['avatar'] as String?) ?? '',
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (user['name'] as String?) ?? 'Unknown User',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight:
                              isCurrentUser ? FontWeight.w600 : FontWeight.w500,
                          color: isCurrentUser
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            'Class of ${(user['graduationYear'] as int?) ?? 2024}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          if ((user['department'] as String?)?.isNotEmpty ==
                              true) ...[
                            Text(
                              ' • ${user['department']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Points and difference
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(user['points'] as int?) ?? 0}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isCurrentUser
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    if (!isCurrentUser && pointDifference != 0)
                      Text(
                        pointDifference > 0
                            ? '+$pointDifference'
                            : '$pointDifference',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: pointDifference > 0
                              ? Colors.green.shade600
                              : Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 2.w),

                // Arrow icon
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
