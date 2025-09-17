import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/leaderboard_header_widget.dart';
import './widgets/leaderboard_tab_bar_widget.dart';
import './widgets/podium_widget.dart';
import './widgets/ranking_list_widget.dart';

/// Leaderboard screen displaying gamified alumni engagement rankings
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _currentBottomIndex = 2; // Leaderboard tab active
  bool _isLoading = false;
  bool _isRefreshing = false;
  Map<String, dynamic> _currentFilters = {
    'graduationYear': 'All Years',
    'department': 'All Departments',
    'role': 'All Roles',
  };

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _mockLeaderboardData = [
    {
      "id": 1,
      "name": "Sarah Chen",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "points": 2850,
      "rank": 1,
      "graduationYear": 2020,
      "department": "Computer Science",
      "role": "Alumni",
      "streakDays": 45,
      "achievements": ["Mentor Champ", "Career Guide"],
      "helpedCount": 28,
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "points": 2720,
      "rank": 2,
      "graduationYear": 2019,
      "department": "Engineering",
      "role": "Alumni",
      "streakDays": 32,
      "achievements": ["Networking Pro"],
      "helpedCount": 24,
    },
    {
      "id": 3,
      "name": "Emily Johnson",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "points": 2580,
      "rank": 3,
      "graduationYear": 2021,
      "department": "Business",
      "role": "Alumni",
      "streakDays": 28,
      "achievements": ["Rising Star"],
      "helpedCount": 22,
    },
    {
      "id": 4,
      "name": "David Kim",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "points": 2420,
      "rank": 4,
      "graduationYear": 2022,
      "department": "Computer Science",
      "role": "Alumni",
      "streakDays": 21,
      "achievements": ["Tech Mentor"],
      "helpedCount": 19,
    },
    {
      "id": 5,
      "name": "Jessica Wang",
      "avatar":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
      "points": 2280,
      "rank": 5,
      "graduationYear": 2020,
      "department": "Medicine",
      "role": "Alumni",
      "streakDays": 18,
      "achievements": ["Healthcare Hero"],
      "helpedCount": 17,
    },
    {
      "id": 6,
      "name": "Alex Thompson",
      "avatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
      "points": 2150,
      "rank": 6,
      "graduationYear": 2023,
      "department": "Arts",
      "role": "Student",
      "streakDays": 15,
      "achievements": ["Creative Mind"],
      "helpedCount": 15,
    },
    {
      "id": 7,
      "name": "Lisa Martinez",
      "avatar":
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face",
      "points": 2020,
      "rank": 7,
      "graduationYear": 2019,
      "department": "Business",
      "role": "Alumni",
      "streakDays": 12,
      "achievements": ["Business Leader"],
      "helpedCount": 13,
    },
    {
      "id": 8,
      "name": "James Wilson",
      "avatar":
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face",
      "points": 1890,
      "rank": 8,
      "graduationYear": 2021,
      "department": "Engineering",
      "role": "Alumni",
      "streakDays": 9,
      "achievements": ["Problem Solver"],
      "helpedCount": 11,
    },
  ];

  // Current user data (mock)
  final Map<String, dynamic> _currentUser = {
    "id": 9,
    "name": "You",
    "avatar":
        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&h=150&fit=crop&crop=face",
    "points": 1750,
    "rank": 12,
    "graduationYear": 2022,
    "department": "Computer Science",
    "role": "Alumni",
    "streakDays": 7,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadLeaderboardData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboardData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    setState(() => _isLoading = false);
    _animationController.forward();
  }

  Future<void> _refreshLeaderboard() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();

    // Simulate refresh
    await Future.delayed(Duration(milliseconds: 1200));

    setState(() => _isRefreshing = false);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leaderboard updated!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTabIndex = index);
    HapticFeedback.selectionClick();
    _animationController.reset();
    _animationController.forward();
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomIndex = index);
  }

  void _showFilterBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _currentFilters,
        onFiltersChanged: (filters) {
          setState(() => _currentFilters = filters);
          _loadLeaderboardData();
        },
      ),
    );
  }

  void _onUserProfileTap() {
    HapticFeedback.lightImpact();
    // Show user profile modal or navigate to profile
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserProfileModal(),
    );
  }

  void _onStartContributing() {
    Navigator.pushNamed(context, '/main-feed-screen');
  }

  List<Map<String, dynamic>> _getFilteredData() {
    List<Map<String, dynamic>> filteredData = List.from(_mockLeaderboardData);

    // Apply filters
    if (_currentFilters['graduationYear'] != 'All Years') {
      final year = int.tryParse(_currentFilters['graduationYear'] as String);
      if (year != null) {
        filteredData = filteredData
            .where((user) => (user['graduationYear'] as int?) == year)
            .toList();
      }
    }

    if (_currentFilters['department'] != 'All Departments') {
      filteredData = filteredData
          .where((user) =>
              (user['department'] as String?) == _currentFilters['department'])
          .toList();
    }

    if (_currentFilters['role'] != 'All Roles') {
      filteredData = filteredData
          .where((user) => (user['role'] as String?) == _currentFilters['role'])
          .toList();
    }

    return filteredData;
  }

  String _getTabTitle() {
    switch (_selectedTabIndex) {
      case 0:
        return 'Daily Rankings';
      case 1:
        return 'Weekly Rankings';
      case 2:
        return 'All-Time Rankings';
      default:
        return 'Rankings';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredData = _getFilteredData();
    final topThree = filteredData.take(3).toList();
    final remainingRankings = filteredData.skip(3).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.standard(
        title: 'Leaderboard',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
            onPressed: _refreshLeaderboard,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(theme)
          : RefreshIndicator(
              onRefresh: _refreshLeaderboard,
              color: theme.colorScheme.primary,
              child: CustomScrollView(
                slivers: [
                  // Sticky header with user rank
                  SliverToBoxAdapter(
                    child: LeaderboardHeaderWidget(
                      userRank: (_currentUser['rank'] as int?) ?? 0,
                      userPoints: (_currentUser['points'] as int?) ?? 0,
                      streakDays: (_currentUser['streakDays'] as int?) ?? 0,
                      userName: (_currentUser['name'] as String?) ?? 'User',
                      userAvatar: (_currentUser['avatar'] as String?) ?? '',
                      onFilterTap: _showFilterBottomSheet,
                    ),
                  ),

                  // Tab bar
                  SliverToBoxAdapter(
                    child: LeaderboardTabBarWidget(
                      selectedIndex: _selectedTabIndex,
                      onTabChanged: _onTabChanged,
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: filteredData.isEmpty
                          ? EmptyStateWidget(
                              onStartContributing: _onStartContributing,
                            )
                          : Column(
                              children: [
                                // Podium for top 3
                                if (topThree.isNotEmpty)
                                  PodiumWidget(
                                    topThreeUsers: topThree,
                                    onUserTap: _onUserProfileTap,
                                  ),

                                SizedBox(height: 2.h),

                                // Rankings list
                                if (remainingRankings.isNotEmpty) ...[
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.shadow
                                              .withValues(alpha: 0.05),
                                          offset: Offset(0, 2),
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: RankingListWidget(
                                      rankings: remainingRankings,
                                      userRank:
                                          (_currentUser['rank'] as int?) ?? 0,
                                      userPoints:
                                          (_currentUser['points'] as int?) ?? 0,
                                      onUserTap: _onUserProfileTap,
                                    ),
                                  ),
                                ],

                                SizedBox(
                                    height: 10.h), // Bottom padding for FAB
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: filteredData.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _onStartContributing,
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Contribute',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading rankings...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileModal() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Profile content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Avatar and basic info
                CircleAvatar(
                  radius: 15.w,
                  backgroundImage: NetworkImage(
                    (_currentUser['avatar'] as String?) ?? '',
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  (_currentUser['name'] as String?) ?? 'User',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  'Class of ${(_currentUser['graduationYear'] as int?) ?? 2024} • ${(_currentUser['department'] as String?) ?? 'Unknown'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 3.h),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(theme, 'Rank',
                        '#${(_currentUser['rank'] as int?) ?? 0}'),
                    _buildStatItem(theme, 'Points',
                        '${(_currentUser['points'] as int?) ?? 0}'),
                    _buildStatItem(theme, 'Streak',
                        '${(_currentUser['streakDays'] as int?) ?? 0} days'),
                  ],
                ),

                SizedBox(height: 4.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile-screen');
                        },
                        child: Text('View Profile'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
