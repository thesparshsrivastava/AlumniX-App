import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/file_preview_widget.dart';
import './widgets/file_upload_zone_widget.dart';
import './widgets/metadata_form_widget.dart';
import './widgets/upload_success_widget.dart';

/// CV Upload Screen for students and alumni to submit professional documents
class CvUploadScreen extends StatefulWidget {
  const CvUploadScreen({super.key});

  @override
  State<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends State<CvUploadScreen>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _jobPreferencesController =
      TextEditingController();
  late AnimationController _uploadAnimationController;
  late Animation<double> _uploadAnimation;

  // File upload state
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _uploadComplete = false;

  // Form state
  bool _isAvailable = true;
  bool _isPublic = false;
  String _selectedExperience = 'Fresh Graduate';
  int _currentBottomBarIndex = 0;

  // Mock existing CVs data
  final List<Map<String, dynamic>> _existingCVs = [
    {
      "id": 1,
      "fileName": "Sarah_Johnson_Resume_2024.pdf",
      "uploadDate": "2024-12-10",
      "fileSize": "2.4 MB",
      "fileType": "pdf",
      "isActive": true,
      "downloadCount": 15,
      "viewCount": 47,
    },
    {
      "id": 2,
      "fileName": "Sarah_Johnson_CV_Tech.docx",
      "uploadDate": "2024-11-28",
      "fileSize": "1.8 MB",
      "fileType": "docx",
      "isActive": false,
      "downloadCount": 8,
      "viewCount": 23,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _jobPreferencesController.text =
        "Looking for software engineering roles in fintech or healthcare. Open to remote work and willing to relocate for the right opportunity.";
  }

  void _initializeAnimations() {
    _uploadAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _uploadAnimation = CurvedAnimation(
      parent: _uploadAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _jobPreferencesController.dispose();
    _uploadAnimationController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
          _showErrorToast('File size must be less than 10MB');
          return;
        }

        setState(() {
          _selectedFile = file;
        });

        HapticFeedback.lightImpact();
        _showSuccessToast('File selected successfully');
      }
    } catch (e) {
      _showErrorToast('Failed to select file. Please try again.');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      _showErrorToast('Please select a file first');
      return;
    }

    if (_jobPreferencesController.text.trim().isEmpty) {
      _showErrorToast('Please fill in your job preferences');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    _uploadAnimationController.forward();

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 100.0;
        });
      }
    }

    // Simulate processing time
    await Future.delayed(Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isUploading = false;
        _uploadComplete = true;
      });

      HapticFeedback.mediumImpact();
      _showSuccessToast('CV uploaded successfully!');
    }
  }

  void _previewFile() {
    if (_selectedFile != null) {
      HapticFeedback.lightImpact();
      _showInfoToast('Opening file preview...');
      // In a real app, this would open a document viewer
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
    });
    HapticFeedback.lightImpact();
    _showInfoToast('File removed');
  }

  void _shareProfile() {
    HapticFeedback.lightImpact();
    _showSuccessToast('Profile link copied to clipboard');
    // In a real app, this would generate and share a profile link
  }

  void _viewProfile() {
    Navigator.pushNamed(context, '/profile-screen');
  }

  void _returnToFeed() {
    Navigator.pushNamed(context, '/main-feed-screen');
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }

  void _showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Upload CV',
        showBackButton: true,
      ),
      body: _uploadComplete ? _buildSuccessView() : _buildUploadView(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomBarIndex,
        onTap: (index) {
          setState(() {
            _currentBottomBarIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSuccessView() {
    return UploadSuccessWidget(
      onShareProfile: _shareProfile,
      onReturnToFeed: _returnToFeed,
      onViewProfile: _viewProfile,
    );
  }

  Widget _buildUploadView() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Progress indicator
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                _buildProgressStep(1, 'Select', _selectedFile != null),
                Expanded(child: _buildProgressLine(_selectedFile != null)),
                _buildProgressStep(
                    2,
                    'Details',
                    _selectedFile != null &&
                        _jobPreferencesController.text.isNotEmpty),
                Expanded(child: _buildProgressLine(false)),
                _buildProgressStep(3, 'Upload', false),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // Upload zone
          FileUploadZoneWidget(
            hasFile: _selectedFile != null,
            onTap: _selectFile,
            isUploading: _isUploading,
            uploadProgress: _uploadProgress,
          ),
          SizedBox(height: 3.h),

          // File preview
          if (_selectedFile != null && !_isUploading)
            FilePreviewWidget(
              fileName: _selectedFile!.name,
              fileSize: _formatFileSize(_selectedFile!.size),
              fileType: _getFileExtension(_selectedFile!.name),
              onRemove: _removeFile,
              onPreview: _previewFile,
            ),

          SizedBox(height: 3.h),

          // Metadata form
          if (_selectedFile != null && !_isUploading)
            MetadataFormWidget(
              jobPreferencesController: _jobPreferencesController,
              isAvailable: _isAvailable,
              onAvailabilityChanged: (value) {
                setState(() {
                  _isAvailable = value;
                });
              },
              isPublic: _isPublic,
              onVisibilityChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
              },
              selectedExperience: _selectedExperience,
              onExperienceChanged: (value) {
                setState(() {
                  _selectedExperience = value;
                });
              },
            ),

          SizedBox(height: 4.h),

          // Existing CVs section
          if (!_isUploading) _buildExistingCVsSection(theme),

          SizedBox(height: 4.h),

          // Upload button
          if (_selectedFile != null && !_isUploading)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploadFile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
                child: Text(
                  'Upload CV',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isCompleted) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check',
                    color: theme.colorScheme.onPrimary,
                    size: 4.w,
                  )
                : Text(
                    step.toString(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isCompleted) {
    final theme = Theme.of(context);

    return Container(
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildExistingCVsSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your CVs',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _existingCVs.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final cv = _existingCVs[index];
              return _buildExistingCVCard(cv, theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExistingCVCard(Map<String, dynamic> cv, ThemeData theme) {
    final isActive = cv["isActive"] as bool;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cv["fileName"] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Uploaded on ${cv["uploadDate"]} • ${cv["fileSize"]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'visibility',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${cv["viewCount"]} views',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'download',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${cv["downloadCount"]} downloads',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'download':
                      _showInfoToast('Downloading CV...');
                      break;
                    case 'replace':
                      _selectFile();
                      break;
                    case 'delete':
                      _showErrorToast('CV deleted');
                      break;
                    case 'activate':
                      _showSuccessToast(
                          isActive ? 'CV deactivated' : 'CV activated');
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: theme.colorScheme.onSurface,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Text('Download'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'replace',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'swap_horiz',
                          color: theme.colorScheme.onSurface,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Text('Replace'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'activate',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: isActive ? 'visibility_off' : 'visibility',
                          color: theme.colorScheme.onSurface,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(isActive ? 'Deactivate' : 'Activate'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: theme.colorScheme.error,
                          size: 4.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Delete',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
