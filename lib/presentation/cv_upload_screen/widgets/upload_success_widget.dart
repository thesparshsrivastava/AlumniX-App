import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Success state widget after successful CV upload
class UploadSuccessWidget extends StatelessWidget {
  final VoidCallback onShareProfile;
  final VoidCallback onReturnToFeed;
  final VoidCallback onViewProfile;

  const UploadSuccessWidget({
    super.key,
    required this.onShareProfile,
    required this.onReturnToFeed,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success animation placeholder
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'check_circle',
              color: theme.colorScheme.tertiary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 4.h),

          Text(
            'CV Uploaded Successfully!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),

          Text(
            'Your CV has been uploaded and is now visible to recruiters and alumni in your network.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),

          // Action buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onViewProfile,
                  icon: CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  label: Text('View My Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onShareProfile,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text('Share Profile'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: onReturnToFeed,
                child: Text(
                  'Return to Feed',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
