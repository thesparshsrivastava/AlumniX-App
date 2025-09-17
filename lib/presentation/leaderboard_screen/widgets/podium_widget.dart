import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Podium widget displaying top 3 users with gold, silver, bronze styling
class PodiumWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topThreeUsers;
  final VoidCallback? onUserTap;

  const PodiumWidget({
    super.key,
    required this.topThreeUsers,
    this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (topThreeUsers.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second place (left)
          if (topThreeUsers.length > 1)
            _buildPodiumItem(
              context,
              theme,
              topThreeUsers[1],
              2,
              Colors.grey.shade400,
              20.w,
            ),

          // First place (center)
          _buildPodiumItem(
            context,
            theme,
            topThreeUsers[0],
            1,
            Colors.amber.shade400,
            25.w,
          ),

          // Third place (right)
          if (topThreeUsers.length > 2)
            _buildPodiumItem(
              context,
              theme,
              topThreeUsers[2],
              3,
              Colors.orange.shade300,
              18.w,
            ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> user,
    int position,
    Color medalColor,
    double avatarSize,
  ) {
    final isFirst = position == 1;

    return GestureDetector(
      onTap: onUserTap,
      child: Column(
        children: [
          // Crown for first place
          if (isFirst) ...[
            CustomIconWidget(
              iconName: 'emoji_events',
              color: Colors.amber.shade600,
              size: 24,
            ),
            SizedBox(height: 1.h),
          ],

          // Avatar with medal
          Stack(
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: medalColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: medalColor.withValues(alpha: 0.3),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: (user['avatar'] as String?) ?? '',
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Position badge
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: medalColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      position.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // User name
          Text(
            (user['name'] as String?) ?? 'Unknown',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 0.5.h),

          // Graduation year
          Text(
            'Class of ${(user['graduationYear'] as int?) ?? 2024}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Points
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: medalColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${(user['points'] as int?) ?? 0} pts',
              style: theme.textTheme.labelMedium?.copyWith(
                color: medalColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
