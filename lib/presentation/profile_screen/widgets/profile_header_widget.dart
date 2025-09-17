import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Profile header widget displaying user avatar, name, and basic info
class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onEditProfile;
  final VoidCallback? onSettingsTap;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    this.onEditProfile,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userRole = (userData['role'] as String?) ?? 'Student';
    final isVerified = (userData['isVerified'] as bool?) ?? false;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
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
        children: [
          // Header with settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: onSettingsTap,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Profile Avatar and Info
          Column(
            children: [
              // Avatar with verification badge
              Stack(
                children: [
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child:
                          (userData['avatarUrl'] as String?)?.isNotEmpty == true
                              ? CustomImageWidget(
                                  imageUrl: userData['avatarUrl'] as String,
                                  width: 25.w,
                                  height: 25.w,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  child: CustomIconWidget(
                                    iconName: 'person',
                                    color: theme.colorScheme.primary,
                                    size: 12.w,
                                  ),
                                ),
                    ),
                  ),
                  if (isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'verified',
                          color: theme.colorScheme.onPrimary,
                          size: 3.w,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 2.h),

              // Name and Role
              Text(
                (userData['name'] as String?) ?? 'User Name',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 0.5.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getRoleColor(userRole, theme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Text(
                  userRole,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _getRoleColor(userRole, theme),
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              // Graduation details
              if (userData['graduationYear'] != null ||
                  userData['department'] != null)
                Text(
                  '${userData['department'] ?? ''} ${userData['graduationYear'] != null ? '• Class of ${userData['graduationYear']}' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

              SizedBox(height: 2.h),

              // Role-specific action button
              _buildRoleSpecificButton(context, theme, userRole),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificButton(
      BuildContext context, ThemeData theme, String userRole) {
    switch (userRole.toLowerCase()) {
      case 'student':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/cv-upload-screen'),
                icon: CustomIconWidget(
                  iconName: 'upload_file',
                  color: theme.colorScheme.onPrimary,
                  size: 4.w,
                ),
                label: Text('Upload CV'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEditProfile,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        );

      case 'alumni':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'people',
                  color: theme.colorScheme.onPrimary,
                  size: 4.w,
                ),
                label: Text('Mentoring'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEditProfile,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        );

      default: // Admin
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: CustomIconWidget(
                  iconName: 'admin_panel_settings',
                  color: theme.colorScheme.onPrimary,
                  size: 4.w,
                ),
                label: Text('Moderation'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEditProfile,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Color _getRoleColor(String role, ThemeData theme) {
    switch (role.toLowerCase()) {
      case 'student':
        return theme.colorScheme.primary;
      case 'alumni':
        return theme.colorScheme.tertiary;
      case 'admin':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary;
    }
  }
}
