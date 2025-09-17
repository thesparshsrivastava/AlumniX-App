import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

/// Individual reel card widget for displaying video/image content
class ReelCardWidget extends StatefulWidget {
  final Map<String, dynamic> reelData;
  final bool isActive;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;

  const ReelCardWidget({
    super.key,
    required this.reelData,
    this.isActive = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onProfileTap,
  });

  @override
  State<ReelCardWidget> createState() => _ReelCardWidgetState();
}

class _ReelCardWidgetState extends State<ReelCardWidget>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _showControls = false;
  bool _isLiked = false;
  late AnimationController _likeAnimationController;
  late AnimationController _heartAnimationController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _heartScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeContent();
  }

  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _heartAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));

    _heartScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  void _initializeContent() {
    final contentType = widget.reelData['contentType'] as String? ?? 'image';
    if (contentType == 'video') {
      _initializeVideo();
    }
    _isLiked = widget.reelData['isLiked'] as bool? ?? false;
  }

  void _initializeVideo() {
    final videoUrl = widget.reelData['contentUrl'] as String? ?? '';
    if (videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _videoController!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          if (widget.isActive) {
            _playVideo();
          }
        }
      }).catchError((error) {
        debugPrint('Video initialization error: \$error');
      });

      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _videoController!.value.isPlaying;
          });
        }
      });
    }
  }

  void _playVideo() {
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.play();
      _videoController!.setLooping(true);
    }
  }

  void _pauseVideo() {
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.pause();
    }
  }

  void _togglePlayPause() {
    if (_videoController != null && _isVideoInitialized) {
      if (_isPlaying) {
        _pauseVideo();
      } else {
        _playVideo();
      }
    }
  }

  void _handleDoubleTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLiked = !_isLiked;
    });

    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });

    if (_isLiked) {
      _heartAnimationController.forward().then((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            _heartAnimationController.reverse();
          }
        });
      });
    }

    widget.onLike?.call();
  }

  void _handleSingleTap() {
    final contentType = widget.reelData['contentType'] as String? ?? 'image';
    if (contentType == 'video') {
      setState(() {
        _showControls = !_showControls;
      });
      _togglePlayPause();

      if (_showControls) {
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(ReelCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _playVideo();
      } else {
        _pauseVideo();
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _likeAnimationController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentType = widget.reelData['contentType'] as String? ?? 'image';

    return Container(
      width: 100.w,
      height: 100.h,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Main content
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleSingleTap,
              onDoubleTap: _handleDoubleTap,
              child: _buildContent(contentType),
            ),
          ),

          // Double tap heart animation
          Center(
            child: AnimatedBuilder(
              animation: _heartScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartScaleAnimation.value,
                  child: CustomIconWidget(
                    iconName: 'favorite',
                    color: Colors.white,
                    size: 80,
                  ),
                );
              },
            ),
          ),

          // Video controls overlay
          if (contentType == 'video' && _showControls)
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CustomIconWidget(
                  iconName: _isPlaying ? 'pause' : 'play_arrow',
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

          // Creator info overlay (top)
          Positioned(
            top: 12.h,
            left: 4.w,
            right: 4.w,
            child: _buildCreatorInfo(),
          ),

          // Engagement overlay (bottom)
          Positioned(
            bottom: 12.h,
            left: 4.w,
            right: 4.w,
            child: _buildEngagementOverlay(),
          ),

          // Action buttons (right side)
          Positioned(
            right: 4.w,
            bottom: 20.h,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String contentType) {
    if (contentType == 'video') {
      return _buildVideoContent();
    } else {
      return _buildImageContent();
    }
  }

  Widget _buildVideoContent() {
    if (!_isVideoInitialized || _videoController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    final imageUrl = widget.reelData['contentUrl'] as String? ?? '';

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomImageWidget(
        imageUrl: imageUrl,
        width: 100.w,
        height: 100.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCreatorInfo() {
    final creator = widget.reelData['creator'] as Map<String, dynamic>? ?? {};
    final name = creator['name'] as String? ?? 'Unknown User';
    final graduationYear = creator['graduationYear'] as String? ?? '';
    final department = creator['department'] as String? ?? '';
    final avatarUrl = creator['avatarUrl'] as String? ?? '';

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (graduationYear.isNotEmpty || department.isNotEmpty)
                  Text(
                    '${department.isNotEmpty ? department : ''} ${graduationYear.isNotEmpty ? '• Class of \$graduationYear' : ''}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementOverlay() {
    final caption = widget.reelData['caption'] as String? ?? '';
    final likesCount = widget.reelData['likesCount'] as int? ?? 0;
    final commentsCount = widget.reelData['commentsCount'] as int? ?? 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (caption.isNotEmpty) ...[
            Text(
              caption,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
          ],
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                _formatCount(likesCount),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(width: 16),
              CustomIconWidget(
                iconName: 'chat_bubble_outline',
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                _formatCount(commentsCount),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _likeScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _likeScaleAnimation.value,
              child: GestureDetector(
                onTap: _handleDoubleTap,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: CustomIconWidget(
                    iconName: _isLiked ? 'favorite' : 'favorite_border',
                    color: _isLiked ? Colors.red : Colors.white,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onComment?.call();
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onShare?.call();
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}