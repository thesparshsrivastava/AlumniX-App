import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Bottom action buttons for manual CV selection
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onPass;
  final VoidCallback? onShortlist;
  final VoidCallback? onBookmark;
  final VoidCallback? onUndo;
  final bool showUndo;

  const ActionButtonsWidget({
    super.key,
    this.onPass,
    this.onShortlist,
    this.onBookmark,
    this.onUndo,
    this.showUndo = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 12.w,
              height: 4,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pass Button
                _buildActionButton(
                  context: context,
                  icon: 'close',
                  label: 'Pass',
                  color: theme.colorScheme.error,
                  onTap: onPass,
                ),

                // Bookmark Button
                _buildActionButton(
                  context: context,
                  icon: 'bookmark_border',
                  label: 'Bookmark',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  onTap: onBookmark,
                ),

                // Shortlist Button
                _buildActionButton(
                  context: context,
                  icon: 'check',
                  label: 'Shortlist',
                  color: theme.colorScheme.tertiary,
                  onTap: onShortlist,
                ),
              ],
            ),

            // Undo Button (appears briefly after actions)
            if (showUndo) ...[
              SizedBox(height: 2.h),
              _buildUndoButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUndoButton(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: showUndo ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onUndo?.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'undo',
                color: theme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Undo Last Action',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
