import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Metadata form widget for additional CV information
class MetadataFormWidget extends StatelessWidget {
  final TextEditingController jobPreferencesController;
  final bool isAvailable;
  final ValueChanged<bool> onAvailabilityChanged;
  final bool isPublic;
  final ValueChanged<bool> onVisibilityChanged;
  final String selectedExperience;
  final ValueChanged<String> onExperienceChanged;

  const MetadataFormWidget({
    super.key,
    required this.jobPreferencesController,
    required this.isAvailable,
    required this.onAvailabilityChanged,
    required this.isPublic,
    required this.onVisibilityChanged,
    required this.selectedExperience,
    required this.onExperienceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          Text(
            'Additional Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Job Preferences
          Text(
            'Job Preferences',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: jobPreferencesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Describe your ideal role, industry preferences, location...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Experience Level
          Text(
            'Experience Level',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedExperience,
                isExpanded: true,
                items: [
                  'Fresh Graduate',
                  '0-1 years',
                  '1-3 years',
                  '3-5 years',
                  '5-10 years',
                  '10+ years',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onExperienceChanged(newValue);
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Availability Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available for Opportunities',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Let recruiters know you\'re open to new roles',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isAvailable,
                onChanged: onAvailabilityChanged,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Visibility Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Public Profile',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Make your CV visible to all alumni and recruiters',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isPublic,
                onChanged: onVisibilityChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
