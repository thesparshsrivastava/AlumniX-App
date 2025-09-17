import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// File upload zone widget with drag and drop functionality
class FileUploadZoneWidget extends StatelessWidget {
  final bool hasFile;
  final VoidCallback onTap;
  final bool isUploading;
  final double uploadProgress;

  const FileUploadZoneWidget({
    super.key,
    required this.hasFile,
    required this.onTap,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 25.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: hasFile
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : theme.colorScheme.surface,
          border: Border.all(
            color: hasFile
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: hasFile ? 2 : 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            isUploading ? _buildUploadProgress(theme) : _buildUploadZone(theme),
      ),
    );
  }

  Widget _buildUploadZone(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomIconWidget(
            iconName: hasFile ? 'check_circle' : 'description',
            color: theme.colorScheme.primary,
            size: 12.w,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          hasFile ? 'File Selected' : 'Tap to select file',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          hasFile
              ? 'Ready to upload'
              : 'Supported formats: PDF, DOCX\nMax size: 10MB',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadProgress(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomIconWidget(
            iconName: 'cloud_upload',
            color: theme.colorScheme.primary,
            size: 12.w,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Uploading...',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: 60.w,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: uploadProgress,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '${(uploadProgress * 100).toInt()}%',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}