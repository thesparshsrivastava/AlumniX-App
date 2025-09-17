import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/cv_section_widget.dart';
import './widgets/gamification_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/social_proof_section_widget.dart';

/// Profile Screen displaying comprehensive user information with role-specific features
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock user data - replace with actual data source
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@university.edu",
    "role": "Student", // Student, Alumni, Admin
    "avatarUrl":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "isVerified": true,
    "graduationYear": 2024,
    "department": "Computer Science",
    "university": "Tech University",
    "bio":
        "Passionate computer science student with interests in AI and machine learning. Looking for mentorship opportunities in tech industry.",
    "location": "San Francisco, CA",
    "linkedinUrl": "https://linkedin.com/in/sarahjohnson",
    "githubUrl": "https://github.com/sarahjohnson",
    "skills": [
      "Python",
      "Machine Learning",
      "React",
      "Node.js",
      "Data Science"
    ],
    "interests": [
      "Artificial Intelligence",
      "Web Development",
      "Data Analytics",
      "Startups"
    ],
    "joinDate": "January 2023",
  };

  final Map<String, dynamic> _gamificationData = {
    "currentStreak": 15,
    "totalPoints": 2450,
    "leaderboardRank": 23,
    "badges": [
      {
        "id": 1,
        "name": "Mentor Champ",
        "icon": "school",
        "description": "Helped 5+ students with career guidance",
        "earnedDate": "Dec 10, 2024",
        "rarity": "rare"
      },
      {
        "id": 2,
        "name": "Career Guide",
        "icon": "work",
        "description": "Provided valuable career advice to peers",
        "earnedDate": "Nov 28, 2024",
        "rarity": "common"
      },
      {
        "id": 3,
        "name": "Network Builder",
        "icon": "people",
        "description": "Connected with 20+ alumni",
        "earnedDate": "Nov 15, 2024",
        "rarity": "uncommon"
      }
    ],
    "weeklyProgress": {"currentWeek": 180, "targetWeek": 200, "weeklyStreak": 3}
  };

  final Map<String, dynamic> _cvData = {
    "hasCV": true,
    "fileName": "Sarah_Johnson_Resume.pdf",
    "uploadDate": "Dec 5, 2024",
    "fileSize": "2.3 MB",
    "fileType": "PDF",
    "lastViewed": "Dec 12, 2024",
    "viewCount": 47,
    "downloadCount": 12
  };

  final Map<String, dynamic> _socialData = {
    "connectionCount": 156,
    "mentorshipCount": 8,
    "testimonials": [
      {
        "id": 1,
        "authorName": "Michael Chen",
        "authorRole": "Senior Software Engineer at Google",
        "authorAvatar":
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
        "content":
            "Sarah is an exceptional student with great potential. Her dedication to learning and problem-solving skills are impressive. I'm confident she'll excel in her career.",
        "rating": 5,
        "date": "Dec 8, 2024"
      },
      {
        "id": 2,
        "authorName": "Emily Rodriguez",
        "authorRole": "Product Manager at Microsoft",
        "authorAvatar":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "content":
            "Working with Sarah on the mentorship program was fantastic. She asks thoughtful questions and implements feedback quickly. Highly recommended!",
        "rating": 5,
        "date": "Nov 22, 2024"
      },
      {
        "id": 3,
        "authorName": "David Park",
        "authorRole": "Alumni • Data Scientist at Netflix",
        "authorAvatar":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
        "content":
            "Sarah's passion for data science is evident in every conversation. She's always eager to learn and contribute meaningfully to discussions.",
        "rating": 4,
        "date": "Nov 10, 2024"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = 4; // Set Profile tab as active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: false,
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: theme.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
                statusBarBrightness: theme.brightness,
              ),
              leading: null,
              automaticallyImplyLeading: false,
              title: null,
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeaderWidget(
                    userData: _userData,
                    onEditProfile: _showEditProfileModal,
                    onSettingsTap: _showSettingsModal,
                  ),

                  // Gamification Section
                  GamificationSectionWidget(
                    gamificationData: _gamificationData,
                  ),

                  // CV Section (Students & Alumni only)
                  CvSectionWidget(
                    cvData: _cvData,
                    userRole: (_userData['role'] as String?) ?? 'Student',
                  ),

                  // Social Proof Section
                  SocialProofSectionWidget(
                    socialData: _socialData,
                    userRole: (_userData['role'] as String?) ?? 'Student',
                  ),

                  // Additional Profile Information
                  _buildAdditionalInfoSection(context, theme),

                  // Bottom spacing for navigation
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 4, // Profile tab
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context, ThemeData theme) {
    final skills = (_userData['skills'] as List?) ?? [];
    final interests = (_userData['interests'] as List?) ?? [];

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
          // Bio Section
          if ((_userData['bio'] as String?)?.isNotEmpty == true) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'About',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              _userData['bio'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Skills Section
          if (skills.isNotEmpty) ...[
            Text(
              'Skills',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: skills
                  .map((skill) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          skill as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 3.h),
          ],

          // Interests Section
          if (interests.isNotEmpty) ...[
            Text(
              'Interests',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: interests
                  .map((interest) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                            color: theme.colorScheme.tertiary
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          interest as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _refreshProfile() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Add haptic feedback
    HapticFeedback.lightImpact();

    setState(() => _isLoading = false);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/main-feed-screen');
        break;
      case 1:
        Navigator.pushNamed(context, '/cv-swipe-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/leaderboard-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/messaging-screen');
        break;
      case 4:
        // Already on profile screen
        break;
    }
  }

  void _showEditProfileModal() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
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

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Edit form placeholder
            Expanded(
              child: Center(
                child: Text(
                  'Edit profile form will be implemented here',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsModal() {
    final theme = Theme.of(context);

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

            // Settings Options
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Notification Settings'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle notification settings
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'privacy_tip',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Privacy Controls'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle privacy settings
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_circle',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Account Management'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle account management
              },
            ),

            ListTile(
              leading: CustomIconWidget(
                iconName: 'help',
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Help & Support'),
              trailing: CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle help & support
              },
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
