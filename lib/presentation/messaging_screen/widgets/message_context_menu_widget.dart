import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Context menu widget for message actions
class MessageContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final VoidCallback onClose;

  const MessageContextMenuWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.15),
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Copy option (for text messages)
            if (message['type'] == 'text')
              _buildMenuItem(
                context: context,
                icon: 'content_copy',
                label: 'Copy',
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: message['content'] as String));
                  HapticFeedback.lightImpact();
                  onCopy();
                  onClose();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message copied to clipboard'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

            // Delete option (only for current user)
            if (isCurrentUser)
              _buildMenuItem(
                context: context,
                icon: 'delete_outline',
                label: 'Delete',
                color: AppTheme.errorLight,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onDelete();
                  onClose();
                },
              ),

            // Report option (only for other users)
            if (!isCurrentUser)
              _buildMenuItem(
                context: context,
                icon: 'report_outlined',
                label: 'Report',
                color: AppTheme.warningLight,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onReport();
                  onClose();
                },
              ),

            // Cancel option
            _buildMenuItem(
              context: context,
              icon: 'close',
              label: 'Cancel',
              onTap: () {
                HapticFeedback.lightImpact();
                onClose();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: itemColor,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}