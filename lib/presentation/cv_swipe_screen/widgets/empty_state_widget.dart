import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget when no more candidates are available
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAdjustFilters;
  final VoidCallback? onRefresh;

  const EmptyStateWidget({
    super.key,
    this.onAdjustFilters,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty State Illustration
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
              size: 20.w,
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            'No More Candidates',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            'You\'ve reviewed all candidates matching your current filters. Try adjusting your search criteria to discover more talent.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          Column(
            children: [
              // Adjust Filters Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAdjustFilters,
                  icon: CustomIconWidget(
                    iconName: 'tune',
                    color: theme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text('Adjust Filters'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Refresh Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text('Refresh Candidates'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Tips Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Tips to find more candidates:',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildTipItem(
                  context,
                  'Expand location radius',
                  'Include nearby cities and remote workers',
                ),
                _buildTipItem(
                  context,
                  'Broaden skill requirements',
                  'Consider related or transferable skills',
                ),
                _buildTipItem(
                  context,
                  'Adjust experience level',
                  'Include junior or senior level candidates',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String description) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: 1.h, right: 3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
