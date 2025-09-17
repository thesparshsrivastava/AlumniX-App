import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/feed_header_widget.dart';
import './widgets/feed_tab_bar_widget.dart';
import './widgets/reel_card_widget.dart';
import './widgets/reel_context_menu_widget.dart';
import './widgets/reel_creation_fab_widget.dart';
import 'widgets/feed_header_widget.dart';
import 'widgets/feed_tab_bar_widget.dart';
import 'widgets/reel_card_widget.dart';
import 'widgets/reel_context_menu_widget.dart';
import 'widgets/reel_creation_fab_widget.dart';

/// Main Feed Screen - Primary hub for personalized reel-style content
class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _refreshAnimationController;
  late Animation<double> _refreshAnimation;

  int _currentReelIndex = 0;
  int _currentTabIndex = 0;
  int _streakCount = 7;
  int _notificationCount = 3;
  bool _isRefreshing = false;
  bool _showContextMenu = false;
  int _contextMenuReelIndex = -1;

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // Mock reel data
  final List<Map<String, dynamic>> _reelData = [
    {
      "id": 1,
      "contentType": "video",
      "contentUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "caption":
          "Just landed my dream job at Google! Thanks to all the amazing mentors from our alumni network. The journey from campus to Silicon Valley has been incredible! 🚀",
      "creator": {
        "id": 101,
        "name": "Sarah Chen",
        "avatarUrl":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "graduationYear": "2022",
        "department": "Computer Science"
      },
      "likesCount": 1247,
      "commentsCount": 89,
      "sharesCount": 34,
      "isLiked": false,
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      "id": 2,
      "contentType": "image",
      "contentUrl":
          "https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=400&h=800&fit=crop",
      "caption":
          "Throwback to our graduation ceremony! Missing all my classmates. Who's up for a reunion this year? Let's make it happen! 🎓",
      "creator": {
        "id": 102,
        "name": "Michael Rodriguez",
        "avatarUrl":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "graduationYear": "2020",
        "department": "Business Administration"
      },
      "likesCount": 892,
      "commentsCount": 156,
      "sharesCount": 67,
      "isLiked": true,
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      "id": 3,
      "contentType": "video",
      "contentUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "caption":
          "Behind the scenes at our startup! From dorm room idea to \$2M funding. The alumni network connections made all the difference. Keep grinding! 💪",
      "creator": {
        "id": 103,
        "name": "Emily Johnson",
        "avatarUrl":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "graduationYear": "2019",
        "department": "Engineering"
      },
      "likesCount": 2156,
      "commentsCount": 234,
      "sharesCount": 123,
      "isLiked": false,
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
    },
    {
      "id": 4,
      "contentType": "image",
      "contentUrl":
          "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=400&h=800&fit=crop",
      "caption":
          "Mentoring session with current students today. Love giving back to the community that shaped me. The future looks bright! ✨",
      "creator": {
        "id": 104,
        "name": "David Park",
        "avatarUrl":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "graduationYear": "2018",
        "department": "Marketing"
      },
      "likesCount": 743,
      "commentsCount": 67,
      "sharesCount": 28,
      "isLiked": true,
      "timestamp": DateTime.now().subtract(Duration(hours: 12)),
    },
    {
      "id": 5,
      "contentType": "video",
      "contentUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "caption":
          "Campus tour with my kids today! Showing them where mommy studied. The new facilities are amazing! So proud of our alma mater 🏫",
      "creator": {
        "id": 105,
        "name": "Lisa Thompson",
        "avatarUrl":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "graduationYear": "2015",
        "department": "Psychology"
      },
      "likesCount": 1089,
      "commentsCount": 145,
      "sharesCount": 56,
      "isLiked": false,
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeCamera();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _refreshAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        final camera = _cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first,
        );

        _cameraController = CameraController(
          camera,
          ResolutionPreset.high,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: \$e');
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showPermissionDialog('Camera');
    }
  }

  void _showPermissionDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content:
            Text('\$permission permission is required to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshFeed() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.mediumImpact();
    _refreshAnimationController.forward();

    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _streakCount += 1; // Simulate streak increment
      });
      _refreshAnimationController.reverse();
    }
  }

  void _handleReelChange(int index) {
    setState(() {
      _currentReelIndex = index;
    });
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    // Navigate to respective screens based on tab
    switch (index) {
      case 0:
        // Already on Feed tab
        break;
      case 1:
        Navigator.pushNamed(context, '/cv-swipe-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/leaderboard-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }

  void _handleReelCreation() async {
    await _requestCameraPermission();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCreationBottomSheet(),
    );
  }

  Widget _buildCreationBottomSheet() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Create New Reel',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildCreationOption(
                  icon: 'camera_alt',
                  title: 'Camera',
                  subtitle: 'Take photo or video',
                  onTap: _openCamera,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildCreationOption(
                  icon: 'photo_library',
                  title: 'Gallery',
                  subtitle: 'Choose from gallery',
                  onTap: _openGallery,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildCreationOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(6.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    Navigator.pop(context);
    if (_isCameraInitialized && _cameraController != null) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        _showSuccessMessage('Photo captured successfully!');
      } catch (e) {
        _showErrorMessage('Failed to capture photo');
      }
    } else {
      _showErrorMessage('Camera not available');
    }
  }

  Future<void> _openGallery() async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _showSuccessMessage('Image selected successfully!');
      }
    } catch (e) {
      _showErrorMessage('Failed to select image');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleLongPress(int index) {
    HapticFeedback.heavyImpact();
    setState(() {
      _showContextMenu = true;
      _contextMenuReelIndex = index;
    });
  }

  void _closeContextMenu() {
    setState(() {
      _showContextMenu = false;
      _contextMenuReelIndex = -1;
    });
  }

  void _handleSaveReel() {
    _showSuccessMessage('Reel saved to collection!');
  }

  void _handleReportReel() {
    _showSuccessMessage('Content reported successfully');
  }

  void _handleHideContent() {
    _showSuccessMessage('Similar content will be hidden');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              FeedHeaderWidget(
                streakCount: _streakCount,
                notificationCount: _notificationCount,
                onSearchTap: () =>
                    Navigator.pushNamed(context, '/search-screen'),
                onStreakTap: () =>
                    Navigator.pushNamed(context, '/leaderboard-screen'),
                onNotificationTap: () =>
                    Navigator.pushNamed(context, '/messaging-screen'),
              ),

              // Tab bar
              FeedTabBarWidget(
                currentIndex: _currentTabIndex,
                onTabChanged: _handleTabChange,
              ),

              // Reel content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshFeed,
                  color: AppTheme.lightTheme.primaryColor,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: _handleReelChange,
                    itemCount: _reelData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () => _handleLongPress(index),
                        child: ReelCardWidget(
                          reelData: _reelData[index],
                          isActive: index == _currentReelIndex,
                          onLike: () {
                            setState(() {
                              final reel = _reelData[index];
                              final isLiked = reel['isLiked'] as bool? ?? false;
                              reel['isLiked'] = !isLiked;
                              reel['likesCount'] = (reel['likesCount'] as int) +
                                  (isLiked ? -1 : 1);
                            });
                          },
                          onComment: () =>
                              Navigator.pushNamed(context, '/comments-screen'),
                          onShare: () =>
                              _showSuccessMessage('Reel shared successfully!'),
                          onProfileTap: () =>
                              Navigator.pushNamed(context, '/profile-screen'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Floating action button
          ReelCreationFabWidget(
            onPressed: _handleReelCreation,
          ),

          // Context menu overlay
          if (_showContextMenu)
            ReelContextMenuWidget(
              onSave: _handleSaveReel,
              onReport: _handleReportReel,
              onHide: _handleHideContent,
              onClose: _closeContextMenu,
            ),

          // Refresh animation overlay
          if (_isRefreshing)
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _refreshAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _refreshAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'refresh',
                            color: Colors.white,
                            size: 5.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}