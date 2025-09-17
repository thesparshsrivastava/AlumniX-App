import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual CV card widget for swipe interface
class CvCardWidget extends StatefulWidget {
  final Map<String, dynamic> candidateData;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onBookmark;
  final bool isTopCard;

  const CvCardWidget({
    super.key,
    required this.candidateData,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onBookmark,
    this.isTopCard = false,
  });

  @override
  State<CvCardWidget> createState() => _CvCardWidgetState();
}

class _CvCardWidgetState extends State<CvCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  double _dragDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(2.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _dragDistance = _dragOffset.dx.abs();
    });

    // Provide haptic feedback at 30% threshold
    if (_dragDistance > 30.w && !_isDragging) {
      HapticFeedback.lightImpact();
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final threshold = 30.w;

    if (_dragOffset.dx > threshold) {
      // Swipe right - Shortlist
      _animateSwipe(true);
      widget.onSwipeRight?.call();
    } else if (_dragOffset.dx < -threshold) {
      // Swipe left - Pass
      _animateSwipe(false);
      widget.onSwipeLeft?.call();
    } else {
      // Return to center
      _resetCard();
    }
  }

  void _animateSwipe(bool isRight) {
    _animationController.forward().then((_) {
      // Card animation completed
    });
  }

  void _resetCard() {
    setState(() {
      _dragOffset = Offset.zero;
      _dragDistance = 0.0;
      _isDragging = false;
    });
  }

  Color _getSwipeIndicatorColor() {
    if (_dragOffset.dx > 15.w) {
      return AppTheme.lightTheme.colorScheme.tertiary; // Green for shortlist
    } else if (_dragOffset.dx < -15.w) {
      return AppTheme.lightTheme.colorScheme.error; // Red for pass
    }
    return Colors.transparent;
  }

  IconData _getSwipeIndicatorIcon() {
    if (_dragOffset.dx > 15.w) {
      return Icons.check_circle;
    } else if (_dragOffset.dx < -15.w) {
      return Icons.cancel;
    }
    return Icons.help;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rotation = _dragOffset.dx / 100.w * 0.1;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _animationController.isAnimating
              ? _slideAnimation.value * 100.w
              : _dragOffset,
          child: Transform.rotate(
            angle: _animationController.isAnimating
                ? _rotationAnimation.value
                : rotation,
            child: GestureDetector(
              onPanStart: widget.isTopCard ? _onPanStart : null,
              onPanUpdate: widget.isTopCard ? _onPanUpdate : null,
              onPanEnd: widget.isTopCard ? _onPanEnd : null,
              child: Container(
                width: 90.w,
                height: 75.h,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // CV Content
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          // Candidate Header
                          _buildCandidateHeader(theme),

                          // CV Preview
                          Expanded(
                            child: _buildCvPreview(theme),
                          ),
                        ],
                      ),
                    ),

                    // Swipe Indicator Overlay
                    if (_dragDistance > 15.w) _buildSwipeIndicator(),

                    // Bookmark Button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: _buildBookmarkButton(theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCandidateHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.9),
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: (widget.candidateData['profileImage'] as String?)
                        ?.isNotEmpty ==
                    true
                ? NetworkImage(widget.candidateData['profileImage'] as String)
                : null,
            child: (widget.candidateData['profileImage'] as String?)?.isEmpty !=
                    false
                ? CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.primary,
                    size: 24,
                  )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.candidateData['name'] as String? ??
                      'Unknown Candidate',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  '${widget.candidateData['position'] as String? ?? 'Position'} • Class of ${widget.candidateData['graduationYear'] as String? ?? 'N/A'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCvPreview(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills Section
          Text(
            'Key Skills',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ((widget.candidateData['skills'] as List<dynamic>?) ?? [])
                .take(6)
                .map((skill) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),

          SizedBox(height: 16),

          // Experience Section
          Text(
            'Experience',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.candidateData['experience'] as String? ??
                'No experience details available',
            style: theme.textTheme.bodyMedium,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 16),

          // Education Section
          Text(
            'Education',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.candidateData['education'] as String? ??
                'No education details available',
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 16),

          // Location & Contact
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                widget.candidateData['location'] as String? ??
                    'Location not specified',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: _getSwipeIndicatorColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getSwipeIndicatorColor(),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: _getSwipeIndicatorIcon() == Icons.check_circle
                ? 'check_circle'
                : 'cancel',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onBookmark?.call();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: CustomIconWidget(
          iconName: 'bookmark_border',
          color: theme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }
}
