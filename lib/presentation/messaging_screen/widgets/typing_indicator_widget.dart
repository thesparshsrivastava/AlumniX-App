import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Typing indicator widget to show when someone is typing
class TypingIndicatorWidget extends StatefulWidget {
  final String userName;
  final String? userAvatar;

  const TypingIndicatorWidget({
    super.key,
    required this.userName,
    this.userAvatar,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.5.w,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: widget.userAvatar != null
                ? NetworkImage(widget.userAvatar!)
                : null,
            child: widget.userAvatar == null
                ? CustomIconWidget(
                    iconName: 'person',
                    color: theme.colorScheme.primary,
                    size: 3.w,
                  )
                : null,
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(1.w),
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.userName} is typing...',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 1.h),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDot(0, theme),
                        SizedBox(width: 1.w),
                        _buildDot(1, theme),
                        SizedBox(width: 1.w),
                        _buildDot(2, theme),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, ThemeData theme) {
    final delay = index * 0.2;
    final animationValue = (_animation.value - delay).clamp(0.0, 1.0);
    final scale = (sin(animationValue * pi) * 0.5 + 0.5).clamp(0.3, 1.0);

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 2.w,
        height: 2.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(1.w),
        ),
      ),
    );
  }
}