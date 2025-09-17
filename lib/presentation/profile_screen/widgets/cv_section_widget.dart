import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// CV section widget for displaying CV upload status and actions
class CvSectionWidget extends StatelessWidget {
  final Map<String, dynamic> cvData;
  final String userRole;

  const CvSectionWidget({
    super.key,
    required this.cvData,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCV = (cvData['hasCV'] as bool?) ?? false;
    final fileName = (cvData['fileName'] as String?) ?? '';
    final uploadDate = (cvData['uploadDate'] as String?) ?? '';
    final fileSize = (cvData['fileSize'] as String?) ?? '';
    final fileType = (cvData['fileType'] as String?) ?? '';

    // Only show for Students and Alumni
    if (userRole.toLowerCase() == 'admin') {
      return SizedBox.shrink();
    }

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
                iconName: 'description',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Resume/CV',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          hasCV
              ? _buildCVUploaded(
                  context, theme, fileName, uploadDate, fileSize, fileType)
              : _buildNoCVUploaded(context, theme),
        ],
      ),
    );
  }

  Widget _buildCVUploaded(
    BuildContext context,
    ThemeData theme,
    String fileName,
    String uploadDate,
    String fileSize,
    String fileType,
  ) {
    return Column(
      children: [
        // CV File Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // File Icon
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: fileType.toLowerCase() == 'pdf'
                      ? 'picture_as_pdf'
                      : 'description',
                  color: theme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),

              SizedBox(width: 4.w),

              // File Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.isNotEmpty ? fileName : 'Resume.pdf',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        if (fileSize.isNotEmpty) ...[
                          Text(
                            fileSize,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                        Text(
                          uploadDate.isNotEmpty
                              ? 'Updated $uploadDate'
                              : 'Recently updated',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // View/Download Icon
              GestureDetector(
                onTap: () {
                  // Handle CV view/download
                  _showCVOptions(context, theme);
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'visibility',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/cv-upload-screen'),
                icon: CustomIconWidget(
                  iconName: 'upload',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Update CV'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showCVOptions(context, theme);
                },
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: theme.colorScheme.onPrimary,
                  size: 4.w,
                ),
                label: Text('Share CV'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoCVUploaded(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // No CV Placeholder
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(6.w),
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
                iconName: 'upload_file',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 12.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'No CV uploaded yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Upload your resume to get discovered by recruiters and mentors',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Upload Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/cv-upload-screen'),
            icon: CustomIconWidget(
              iconName: 'upload_file',
              color: theme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text('Upload CV'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCVOptions(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),

            SizedBox(height: 3.h),

            // Options
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('View CV'),
              onTap: () {
                Navigator.pop(context);
                // Handle view CV
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Download CV'),
              onTap: () {
                Navigator.pop(context);
                // Handle download CV
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Share CV'),
              onTap: () {
                Navigator.pop(context);
                // Handle share CV
              },
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
