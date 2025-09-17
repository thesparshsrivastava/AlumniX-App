import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// File preview widget showing selected file details
class FilePreviewWidget extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String fileType;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  const FilePreviewWidget({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.onRemove,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // File type icon
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getFileTypeColor(fileType, theme).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getFileTypeIcon(fileType),
              color: _getFileTypeColor(fileType, theme),
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),

          // File details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      fileSize,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getFileTypeColor(fileType, theme)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fileType.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getFileTypeColor(fileType, theme),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onPreview,
                icon: CustomIconWidget(
                  iconName: 'visibility',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'Preview',
              ),
              IconButton(
                onPressed: onRemove,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.error,
                  size: 5.w,
                ),
                tooltip: 'Remove',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getFileTypeColor(String fileType, ThemeData theme) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      default:
        return theme.colorScheme.primary;
    }
  }
}
