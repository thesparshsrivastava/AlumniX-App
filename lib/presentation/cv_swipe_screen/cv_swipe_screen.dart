import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/candidate_info_modal.dart';
import './widgets/cv_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/progress_indicator_widget.dart';

/// CV Swipe Screen for recruiters to review and shortlist candidates
class CvSwipeScreen extends StatefulWidget {
  const CvSwipeScreen({super.key});

  @override
  State<CvSwipeScreen> createState() => _CvSwipeScreenState();
}

class _CvSwipeScreenState extends State<CvSwipeScreen>
    with TickerProviderStateMixin {
  late AnimationController _undoAnimationController;
  late Animation<double> _undoAnimation;

  int _currentIndex = 0;
  bool _showUndo = false;
  bool _showCandidateModal = false;
  Map<String, dynamic>? _lastAction;

  // Mock candidate data
  final List<Map<String, dynamic>> _candidates = [
    {
      "id": 1,
      "name": "Sarah Chen",
      "position": "Senior Software Engineer",
      "graduationYear": "2019",
      "profileImage":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "email": "sarah.chen@email.com",
      "phone": "+1 (555) 123-4567",
      "location": "San Francisco, CA",
      "skills": ["React", "Node.js", "Python", "AWS", "Docker", "GraphQL"],
      "experience":
          "5+ years of full-stack development experience at leading tech companies. Led multiple high-impact projects and mentored junior developers. Expertise in modern web technologies and cloud architecture.",
      "education": "BS Computer Science, Stanford University",
      "linkedinUrl": "https://linkedin.com/in/sarahchen"
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "position": "Product Manager",
      "graduationYear": "2020",
      "profileImage":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "email": "michael.rodriguez@email.com",
      "phone": "+1 (555) 234-5678",
      "location": "New York, NY",
      "skills": [
        "Product Strategy",
        "Agile",
        "Data Analysis",
        "User Research",
        "Roadmapping"
      ],
      "experience":
          "3+ years of product management experience in fintech and e-commerce. Successfully launched 5 major product features with 40% user adoption increase.",
      "education": "MBA, Harvard Business School",
      "linkedinUrl": "https://linkedin.com/in/michaelrodriguez"
    },
    {
      "id": 3,
      "name": "Emily Johnson",
      "position": "UX Designer",
      "graduationYear": "2021",
      "profileImage":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "email": "emily.johnson@email.com",
      "phone": "+1 (555) 345-6789",
      "location": "Austin, TX",
      "skills": [
        "Figma",
        "User Research",
        "Prototyping",
        "Design Systems",
        "Usability Testing"
      ],
      "experience":
          "2+ years of UX design experience focusing on mobile and web applications. Redesigned user flows that improved conversion rates by 25%.",
      "education": "BFA Design, Rhode Island School of Design",
      "linkedinUrl": "https://linkedin.com/in/emilyjohnson"
    },
    {
      "id": 4,
      "name": "David Kim",
      "position": "Data Scientist",
      "graduationYear": "2018",
      "profileImage":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "email": "david.kim@email.com",
      "phone": "+1 (555) 456-7890",
      "location": "Seattle, WA",
      "skills": [
        "Python",
        "Machine Learning",
        "SQL",
        "TensorFlow",
        "Statistics",
        "R"
      ],
      "experience":
          "4+ years of data science experience in healthcare and finance. Built predictive models that generated \$2M+ in cost savings.",
      "education": "PhD Statistics, University of Washington",
      "linkedinUrl": "https://linkedin.com/in/davidkim"
    },
    {
      "id": 5,
      "name": "Jessica Martinez",
      "position": "Marketing Manager",
      "graduationYear": "2022",
      "profileImage":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
      "email": "jessica.martinez@email.com",
      "phone": "+1 (555) 567-8901",
      "location": "Los Angeles, CA",
      "skills": [
        "Digital Marketing",
        "SEO",
        "Content Strategy",
        "Analytics",
        "Social Media"
      ],
      "experience":
          "1+ year of marketing experience with focus on digital campaigns. Increased brand awareness by 60% through innovative social media strategies.",
      "education": "BA Marketing, UCLA",
      "linkedinUrl": "https://linkedin.com/in/jessicamartinez"
    }
  ];

  @override
  void initState() {
    super.initState();
    _undoAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _undoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _undoAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _undoAnimationController.dispose();
    super.dispose();
  }

  void _handleSwipeLeft() {
    _performAction('pass');
  }

  void _handleSwipeRight() {
    _performAction('shortlist');
  }

  void _handleBookmark() {
    _performAction('bookmark');
  }

  void _performAction(String action) {
    if (_currentIndex >= _candidates.length) return;

    setState(() {
      _lastAction = {
        'action': action,
        'candidate': _candidates[_currentIndex],
        'index': _currentIndex,
      };
      _currentIndex++;
      _showUndo = true;
    });

    _undoAnimationController.forward();

    // Hide undo button after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showUndo = false;
        });
        _undoAnimationController.reverse();
      }
    });

    // Show success message
    _showActionFeedback(action);
  }

  void _handleUndo() {
    if (_lastAction == null) return;

    setState(() {
      _currentIndex = _lastAction!['index'] as int;
      _showUndo = false;
      _lastAction = null;
    });

    _undoAnimationController.reverse();
    HapticFeedback.mediumImpact();
  }

  void _showActionFeedback(String action) {
    String message;
    Color backgroundColor;
    IconData icon;

    switch (action) {
      case 'shortlist':
        message = 'Candidate shortlisted!';
        backgroundColor = AppTheme.lightTheme.colorScheme.tertiary;
        icon = Icons.check_circle;
        break;
      case 'bookmark':
        message = 'Candidate bookmarked!';
        backgroundColor = AppTheme.lightTheme.colorScheme.primary;
        icon = Icons.bookmark;
        break;
      default:
        message = 'Candidate passed';
        backgroundColor = AppTheme.lightTheme.colorScheme.error;
        icon = Icons.cancel;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showCandidateInfo() {
    if (_currentIndex >= _candidates.length) return;

    setState(() {
      _showCandidateModal = true;
    });

    HapticFeedback.mediumImpact();
  }

  void _closeCandidateModal() {
    setState(() {
      _showCandidateModal = false;
    });
  }

  void _handleViewLinkedIn() {
    _closeCandidateModal();
    // In a real app, this would open the LinkedIn profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening LinkedIn profile...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleContact() {
    _closeCandidateModal();
    Navigator.pushNamed(context, '/messaging-screen');
  }

  void _handleAdjustFilters() {
    // In a real app, this would open filter settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening filter settings...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleRefresh() {
    setState(() {
      _currentIndex = 0;
      _showUndo = false;
      _lastAction = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Candidates refreshed!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getFilterInfo() {
    return 'Software Engineers • San Francisco Bay Area • 2+ years exp';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMoreCandidates = _currentIndex < _candidates.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Review Candidates'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios_new',
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'tune',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
              size: 22,
            ),
            onPressed: _handleAdjustFilters,
            tooltip: 'Filter Settings',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Progress Indicator
              if (hasMoreCandidates)
                ProgressIndicatorWidget(
                  currentIndex: _currentIndex,
                  totalCandidates: _candidates.length,
                  filterInfo: _getFilterInfo(),
                ),

              // Main Content Area
              Expanded(
                child: hasMoreCandidates
                    ? _buildCardStack()
                    : EmptyStateWidget(
                        onAdjustFilters: _handleAdjustFilters,
                        onRefresh: _handleRefresh,
                      ),
              ),

              // Action Buttons
              if (hasMoreCandidates)
                ActionButtonsWidget(
                  onPass: _handleSwipeLeft,
                  onShortlist: _handleSwipeRight,
                  onBookmark: _handleBookmark,
                  onUndo: _handleUndo,
                  showUndo: _showUndo,
                ),
            ],
          ),

          // Candidate Info Modal
          if (_showCandidateModal && hasMoreCandidates)
            GestureDetector(
              onTap: _closeCandidateModal,
              child: CandidateInfoModal(
                candidateData: _candidates[_currentIndex],
                onClose: _closeCandidateModal,
                onViewLinkedIn: _handleViewLinkedIn,
                onContact: _handleContact,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 75.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Next card preview (underneath)
            if (_currentIndex + 1 < _candidates.length)
              Transform.scale(
                scale: 0.95,
                child: Transform.translate(
                  offset: Offset(0, 10),
                  child: Opacity(
                    opacity: 0.7,
                    child: CvCardWidget(
                      candidateData: _candidates[_currentIndex + 1],
                      isTopCard: false,
                    ),
                  ),
                ),
              ),

            // Current card (on top)
            GestureDetector(
              onLongPress: _showCandidateInfo,
              child: CvCardWidget(
                candidateData: _candidates[_currentIndex],
                onSwipeLeft: _handleSwipeLeft,
                onSwipeRight: _handleSwipeRight,
                onBookmark: _handleBookmark,
                isTopCard: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
