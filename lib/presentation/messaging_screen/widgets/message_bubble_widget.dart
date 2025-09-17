import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

/// Message bubble widget for displaying individual messages in chat
class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messageType = message['type'] as String? ?? 'text';
    final timestamp = message['timestamp'] as DateTime;
    final isRead = message['isRead'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              backgroundImage: message['senderAvatar'] != null
                  ? NetworkImage(message['senderAvatar'] as String)
                  : null,
              child: message['senderAvatar'] == null
                  ? CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.primary,
                      size: 3.w,
                    )
                  : null,
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: onLongPress,
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft: Radius.circular(isCurrentUser ? 4.w : 1.w),
                    bottomRight: Radius.circular(isCurrentUser ? 1.w : 4.w),
                  ),
                  border: !isCurrentUser
                      ? Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMessageContent(context, messageType),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(timestamp),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: isCurrentUser
                                ? theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7)
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                          ),
                        ),
                        if (isCurrentUser) ...[
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: isRead ? 'done_all' : 'done',
                            color: isRead
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.7),
                            size: 3.w,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isCurrentUser) SizedBox(width: 2.w),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, String messageType) {
    final theme = Theme.of(context);

    switch (messageType) {
      case 'text':
        return Text(
          message['content'] as String,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isCurrentUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        );

      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomImageWidget(
                imageUrl: message['imageUrl'] as String,
                width: 50.w,
                height: 30.h,
                fit: BoxFit.cover,
              ),
            ),
            if (message['caption'] != null) ...[
              SizedBox(height: 1.h),
              Text(
                message['caption'] as String,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isCurrentUser
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ],
        );

      case 'document':
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isCurrentUser
                ? theme.colorScheme.onPrimary.withValues(alpha: 0.1)
                : theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: isCurrentUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['fileName'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isCurrentUser
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      message['fileSize'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: isCurrentUser
                            ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 'voice':
        return Container(
          padding: EdgeInsets.all(2.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'play_arrow',
                color: isCurrentUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Container(
                width: 30.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? theme.colorScheme.onPrimary.withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 10.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                message['duration'] as String,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: isCurrentUser
                      ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );

      default:
        return Text(
          'Unsupported message type',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: isCurrentUser
                ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}