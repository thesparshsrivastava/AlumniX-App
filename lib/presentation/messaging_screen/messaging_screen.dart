import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_context_menu_widget.dart';
import './widgets/typing_indicator_widget.dart';

/// Messaging Screen for real-time mentorship conversations and professional networking
class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = 'user_001';

  bool _isTyping = false;
  bool _showContextMenu = false;
  Map<String, dynamic>? _selectedMessage;
  Offset _contextMenuPosition = Offset.zero;

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 'msg_001',
      'senderId': 'user_002',
      'senderName': 'Sarah Chen',
      'senderAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'content':
          'Hi! I saw your profile and I\'m really interested in the software engineering mentorship program. Could you tell me more about your experience at Google?',
      'type': 'text',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'isRead': true,
    },
    {
      'id': 'msg_002',
      'senderId': 'user_001',
      'senderName': 'Current User',
      'content':
          'Hello Sarah! I\'d be happy to help. I\'ve been at Google for about 5 years now, working primarily on Android development and machine learning projects. What specific areas are you most interested in?',
      'type': 'text',
      'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
      'isRead': true,
    },
    {
      'id': 'msg_003',
      'senderId': 'user_002',
      'senderName': 'Sarah Chen',
      'senderAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'content':
          'That\'s amazing! I\'m particularly interested in mobile development and AI/ML. I\'ve been working on some personal projects but would love guidance on breaking into the industry.',
      'type': 'text',
      'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
      'isRead': true,
    },
    {
      'id': 'msg_004',
      'senderId': 'user_002',
      'senderName': 'Sarah Chen',
      'senderAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'imageUrl':
          'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=800&h=600&fit=crop',
      'caption':
          'Here\'s one of my recent Flutter projects - a task management app with AI recommendations',
      'type': 'image',
      'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
      'isRead': true,
    },
    {
      'id': 'msg_005',
      'senderId': 'user_001',
      'senderName': 'Current User',
      'content':
          'Impressive work! The UI looks very clean and professional. I can see you have a good eye for design. Let me share some resources that might help you.',
      'type': 'text',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
      'isRead': true,
    },
    {
      'id': 'msg_006',
      'senderId': 'user_001',
      'senderName': 'Current User',
      'fileName': 'Google_Interview_Guide.pdf',
      'fileSize': '2.4 MB',
      'type': 'document',
      'timestamp': DateTime.now().subtract(Duration(minutes: 45)),
      'isRead': true,
    },
    {
      'id': 'msg_007',
      'senderId': 'user_002',
      'senderName': 'Sarah Chen',
      'senderAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'content':
          'Thank you so much! This is exactly what I needed. Would you be available for a quick call this week to discuss career paths?',
      'type': 'text',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
      'isRead': true,
    },
    {
      'id': 'msg_008',
      'senderId': 'user_002',
      'senderName': 'Sarah Chen',
      'senderAvatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'duration': '0:45',
      'type': 'voice',
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
      'isRead': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate typing indicator
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSendMessage(String message) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'Current User',
      'content': message,
      'type': 'text',
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onSendImage(String imagePath, String? caption) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'Current User',
      'imageUrl': imagePath,
      'caption': caption,
      'type': 'image',
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onSendDocument(String filePath, String fileName) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'Current User',
      'fileName': fileName,
      'fileSize': '1.2 MB',
      'type': 'document',
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onSendVoice(String voicePath, String duration) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'Current User',
      'duration': duration,
      'type': 'voice',
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showMessageContextMenu(Map<String, dynamic> message, Offset position) {
    setState(() {
      _selectedMessage = message;
      _contextMenuPosition = position;
      _showContextMenu = true;
    });
  }

  void _hideContextMenu() {
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _onCopyMessage() {
    // Copy functionality handled in context menu widget
  }

  void _onDeleteMessage() {
    if (_selectedMessage != null) {
      setState(() {
        _messages.removeWhere((msg) => msg['id'] == _selectedMessage!['id']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message deleted'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onReportMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Message reported. Thank you for keeping our community safe.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _refreshMessages() async {
    // Simulate loading more messages
    await Future.delayed(Duration(seconds: 1));

    final olderMessages = [
      {
        'id': 'msg_old_001',
        'senderId': 'user_002',
        'senderName': 'Sarah Chen',
        'senderAvatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'content':
            'Hi there! I hope you\'re doing well. I wanted to reach out about potential mentorship opportunities.',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(days: 1)),
        'isRead': true,
      },
    ];

    setState(() {
      _messages.insertAll(0, olderMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.profile(
        userName: 'Sarah Chen',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        onProfileTap: () {
          Navigator.pushNamed(context, '/profile-screen');
        },
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'videocam',
              color: theme.colorScheme.primary,
              size: 6.w,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Video call feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Video Call',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'call',
              color: theme.colorScheme.primary,
              size: 5.w,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Voice call feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Voice Call',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Messages list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshMessages,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return TypingIndicatorWidget(
                          userName: 'Sarah Chen',
                          userAvatar:
                              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                        );
                      }

                      final message = _messages[index];
                      final isCurrentUser =
                          message['senderId'] == _currentUserId;

                      return GestureDetector(
                        onLongPressStart: (details) {
                          _showMessageContextMenu(
                              message, details.globalPosition);
                        },
                        child: MessageBubbleWidget(
                          message: message,
                          isCurrentUser: isCurrentUser,
                          onLongPress: () {
                            _showMessageContextMenu(
                                message, Offset(50.w, 50.h));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Chat input
              ChatInputWidget(
                onSendMessage: _onSendMessage,
                onSendImage: _onSendImage,
                onSendDocument: _onSendDocument,
                onSendVoice: _onSendVoice,
                isTyping: _isTyping,
              ),
            ],
          ),

          // Context menu overlay
          if (_showContextMenu && _selectedMessage != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideContextMenu,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Stack(
                    children: [
                      Positioned(
                        left: _contextMenuPosition.dx - 40.w,
                        top: _contextMenuPosition.dy - 20.h,
                        child: MessageContextMenuWidget(
                          message: _selectedMessage!,
                          isCurrentUser:
                              _selectedMessage!['senderId'] == _currentUserId,
                          onCopy: _onCopyMessage,
                          onDelete: _onDeleteMessage,
                          onReport: _onReportMessage,
                          onClose: _hideContextMenu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.standard(
        currentIndex: 3, // Messages tab
        onTap: (index) {
          final routes = [
            '/main-feed-screen',
            '/cv-swipe-screen',
            '/leaderboard-screen',
            '/messaging-screen',
            '/profile-screen',
          ];

          if (index != 3) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}
