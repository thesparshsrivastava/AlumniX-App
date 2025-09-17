import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Social proof section displaying connections, mentorships, and testimonials
class SocialProofSectionWidget extends StatelessWidget {
  final Map<String, dynamic> socialData;
  final String userRole;

  const SocialProofSectionWidget({
    super.key,
    required this.socialData,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connectionCount = (socialData['connectionCount'] as int?) ?? 0;
    final mentorshipCount = (socialData['mentorshipCount'] as int?) ?? 0;
    final testimonials = (socialData['testimonials'] as List?) ?? [];

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
                iconName: 'people',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Network & Impact',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Stats Row
          Row(
            children: [
              // Connections
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  'group',
                  connectionCount.toString(),
                  'Connections',
                  theme.colorScheme.primary,
                ),
              ),

              SizedBox(width: 3.w),

              // Mentorships/Helped
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  userRole.toLowerCase() == 'student' ? 'school' : 'handshake',
                  mentorshipCount.toString(),
                  userRole.toLowerCase() == 'student' ? 'Mentors' : 'Helped',
                  theme.colorScheme.tertiary,
                ),
              ),

              SizedBox(width: 3.w),

              // Success Rate
              Expanded(
                child: _buildStatCard(
                  context,
                  theme,
                  'trending_up',
                  '${_calculateSuccessRate(mentorshipCount)}%',
                  'Success Rate',
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Testimonials Section
          if (testimonials.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Testimonials',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${testimonials.length} reviews',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Testimonial Cards
            SizedBox(
              height: 20.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: testimonials.length > 3 ? 3 : testimonials.length,
                itemBuilder: (context, index) {
                  final testimonial =
                      testimonials[index] as Map<String, dynamic>;
                  return _buildTestimonialCard(context, theme, testimonial);
                },
              ),
            ),
          ] else ...[
            // No testimonials placeholder
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
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
                    iconName: 'rate_review',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No testimonials yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    userRole.toLowerCase() == 'student'
                        ? 'Connect with mentors to get your first testimonial!'
                        : 'Help others to receive testimonials!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme,
    String iconName,
    String value,
    String label,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: accentColor,
            size: 5.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(
      BuildContext context, ThemeData theme, Map<String, dynamic> testimonial) {
    final authorName = (testimonial['authorName'] as String?) ?? 'Anonymous';
    final authorRole = (testimonial['authorRole'] as String?) ?? '';
    final content = (testimonial['content'] as String?) ?? '';
    final rating = (testimonial['rating'] as int?) ?? 5;
    final authorAvatar = (testimonial['authorAvatar'] as String?) ?? '';

    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            children: [
              // Avatar
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: authorAvatar.isNotEmpty
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: authorAvatar,
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'person',
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
              ),

              SizedBox(width: 3.w),

              // Author Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (authorRole.isNotEmpty)
                      Text(
                        authorRole,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < rating ? 'star' : 'star_border',
                    color: index < rating
                        ? Colors.amber
                        : theme.colorScheme.outline,
                    size: 3.w,
                  );
                }),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Testimonial Content
          Expanded(
            child: Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSuccessRate(int mentorshipCount) {
    if (mentorshipCount == 0) return 0;
    // Simple calculation based on mentorship count
    if (mentorshipCount >= 10) return 95;
    if (mentorshipCount >= 5) return 88;
    if (mentorshipCount >= 3) return 82;
    if (mentorshipCount >= 1) return 75;
    return 0;
  }
}
