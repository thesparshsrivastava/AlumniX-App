import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Chat input widget for sending messages, images, documents, and voice notes
class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String, String?) onSendImage;
  final Function(String, String) onSendDocument;
  final Function(String, String) onSendVoice;
  final bool isTyping;

  const ChatInputWidget({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendDocument,
    required this.onSendVoice,
    this.isTyping = false,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _showAttachmentOptions = false;
  String _recordingPath = '';
  Duration _recordingDuration = Duration.zero;

  late AnimationController _recordingAnimationController;
  late AnimationController _attachmentAnimationController;
  late Animation<double> _recordingAnimation;
  late Animation<double> _attachmentAnimation;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _attachmentAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _recordingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));

    _attachmentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _attachmentAnimationController,
      curve: Curves.easeInOut,
    ));

    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _recordingAnimationController.dispose();
    _attachmentAnimationController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  Future<void> _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onSendImage(image.path, null);
        _hideAttachmentOptions();
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        widget.onSendImage(photo.path, null);
        _hideAttachmentOptions();
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo');
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileName = file.name;
        final filePath = file.path ?? '';

        if (filePath.isNotEmpty) {
          widget.onSendDocument(filePath, fileName);
          _hideAttachmentOptions();
          HapticFeedback.lightImpact();
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick document');
    }
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) {
        _showErrorSnackBar('Microphone permission required');
        return;
      }

      final tempDir = Directory.systemTemp;
      _recordingPath =
          '${tempDir.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _recordingPath,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _recordingAnimationController.repeat(reverse: true);
      _startRecordingTimer();
      HapticFeedback.mediumImpact();
    } catch (e) {
      _showErrorSnackBar('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      _recordingAnimationController.stop();
      _recordingAnimationController.reset();

      if (path != null && _recordingDuration.inSeconds >= 1) {
        final durationText =
            '${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}';
        widget.onSendVoice(path, durationText);
        HapticFeedback.lightImpact();
      } else {
        _showErrorSnackBar('Recording too short');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording');
    }
  }

  void _startRecordingTimer() {
    Future.doWhile(() async {
      if (!_isRecording) return false;

      await Future.delayed(Duration(seconds: 1));
      if (_isRecording) {
        setState(() {
          _recordingDuration =
              Duration(seconds: _recordingDuration.inSeconds + 1);
        });
      }

      return _isRecording;
    });
  }

  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _toggleAttachmentOptions() {
    setState(() {
      _showAttachmentOptions = !_showAttachmentOptions;
    });

    if (_showAttachmentOptions) {
      _attachmentAnimationController.forward();
    } else {
      _attachmentAnimationController.reverse();
    }
  }

  void _hideAttachmentOptions() {
    setState(() {
      _showAttachmentOptions = false;
    });
    _attachmentAnimationController.reverse();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Attachment options
        AnimatedBuilder(
          animation: _attachmentAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _attachmentAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttachmentOption(
                      icon: 'photo_library',
                      label: 'Gallery',
                      color: theme.colorScheme.primary,
                      onTap: _pickImage,
                    ),
                    _buildAttachmentOption(
                      icon: 'camera_alt',
                      label: 'Camera',
                      color: AppTheme.successLight,
                      onTap: _takePhoto,
                    ),
                    _buildAttachmentOption(
                      icon: 'description',
                      label: 'Document',
                      color: AppTheme.warningLight,
                      onTap: _pickDocument,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Main input area
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Attachment button
                GestureDetector(
                  onTap: _toggleAttachmentOptions,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _showAttachmentOptions
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: CustomIconWidget(
                      iconName:
                          _showAttachmentOptions ? 'close' : 'attach_file',
                      color: theme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Text input field
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 20.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(6.w),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                      ),
                      onSubmitted: (_) => _sendTextMessage(),
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Send/Voice button
                GestureDetector(
                  onTap: _textController.text.trim().isNotEmpty
                      ? _sendTextMessage
                      : null,
                  onLongPressStart: _textController.text.trim().isEmpty
                      ? (_) => _startRecording()
                      : null,
                  onLongPressEnd: _textController.text.trim().isEmpty
                      ? (_) => _stopRecording()
                      : null,
                  child: AnimatedBuilder(
                    animation: _recordingAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isRecording ? _recordingAnimation.value : 1.0,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? AppTheme.errorLight
                                : _textController.text.trim().isNotEmpty
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary
                                        .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          child: CustomIconWidget(
                            iconName: _isRecording
                                ? 'stop'
                                : _textController.text.trim().isNotEmpty
                                    ? 'send'
                                    : 'mic',
                            color: theme.colorScheme.onPrimary,
                            size: 5.w,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Recording indicator
        if (_isRecording)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            color: AppTheme.errorLight.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'fiber_manual_record',
                  color: AppTheme.errorLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Recording... ${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.errorLight,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAttachmentOption({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}