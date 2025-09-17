import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Context menu widget for reel long press actions
class ReelContextMenuWidget extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onReport;
  final VoidCallback? onHide;
  final VoidCallback? onClose;

  const ReelContextMenuWidget({
    super.key,
    this.onSave,
    this.onReport,
    this.onHide,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            width: 80.w,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                  offset: Offset(0, 8),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Reel Options',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 4.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu items
                _buildMenuItem(
                  context,
                  icon: 'bookmark_outline',
                  title: 'Save to Collection',
                  subtitle: 'Save this reel to view later',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSave?.call();
                    onClose?.call();
                  },
                ),

                _buildMenuItem(
                  context,
                  icon: 'visibility_off_outlined',
                  title: 'Hide Similar Content',
                  subtitle: 'See fewer posts like this',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onHide?.call();
                    onClose?.call();
                  },
                ),

                _buildMenuItem(
                  context,
                  icon: 'report_outlined',
                  title: 'Report Content',
                  subtitle: 'Report inappropriate content',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onReport?.call();
                    onClose?.call();
                  },
                  isDestructive: true,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isDestructive
                    ? theme.colorScheme.error.withValues(alpha: 0.1)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDestructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}