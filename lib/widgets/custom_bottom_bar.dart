import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom bottom navigation bar variants for different navigation contexts
enum CustomBottomBarVariant {
  /// Standard bottom navigation with 5 main tabs
  standard,

  /// Floating bottom navigation with elevated design
  floating,

  /// Minimal bottom navigation with reduced visual weight
  minimal,
}

/// Navigation item data structure for bottom bar
class BottomBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final bool showBadge;
  final String? badgeText;

  const BottomBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.showBadge = false,
    this.badgeText,
  });
}

/// Production-ready custom bottom navigation bar implementing Academic Authority design
/// with Professional Minimalism styling for alumni networking application.
class CustomBottomBar extends StatelessWidget {
  /// The variant of the bottom bar to display
  final CustomBottomBarVariant variant;

  /// Current selected index
  final int currentIndex;

  /// Callback when tab is selected
  final ValueChanged<int> onTap;

  /// Background color override (optional)
  final Color? backgroundColor;

  /// Elevation override (optional)
  final double? elevation;

  /// Whether to show labels (optional, defaults to true)
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.standard,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.elevation,
    this.showLabels = true,
  });

  /// Standard bottom bar constructor
  const CustomBottomBar.standard({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.elevation,
    this.showLabels = true,
  }) : variant = CustomBottomBarVariant.standard;

  /// Floating bottom bar constructor
  const CustomBottomBar.floating({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.elevation,
    this.showLabels = true,
  }) : variant = CustomBottomBarVariant.floating;

  /// Minimal bottom bar constructor
  const CustomBottomBar.minimal({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.elevation,
    this.showLabels = false,
  }) : variant = CustomBottomBarVariant.minimal;

  /// Predefined navigation items for alumni networking app
  static const List<BottomBarItem> _navigationItems = [
    BottomBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Feed',
      route: '/main-feed-screen',
    ),
    BottomBarItem(
      icon: Icons.swipe_outlined,
      activeIcon: Icons.swipe,
      label: 'Discover',
      route: '/cv-swipe-screen',
    ),
    BottomBarItem(
      icon: Icons.leaderboard_outlined,
      activeIcon: Icons.leaderboard,
      label: 'Rankings',
      route: '/leaderboard-screen',
    ),
    BottomBarItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Messages',
      route: '/messaging-screen',
      showBadge: true,
    ),
    BottomBarItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomBottomBarVariant.standard:
        return _buildStandardBottomBar(context, theme);
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return _buildNavigationItem(
                context,
                theme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                offset: Offset(0, 4),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navigationItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = currentIndex == index;

                  return _buildNavigationItem(
                    context,
                    theme,
                    item,
                    isSelected,
                    index,
                    isFloating: true,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return _buildNavigationItem(
                context,
                theme,
                item,
                isSelected,
                index,
                isMinimal: true,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    ThemeData theme,
    BottomBarItem item,
    bool isSelected,
    int index, {
    bool isFloating = false,
    bool isMinimal = false,
  }) {
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final iconSize = isMinimal ? 22.0 : 24.0;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
          Navigator.pushNamed(context, item.route);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMinimal ? 8 : 6,
            horizontal: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: isFloating && isSelected
                        ? EdgeInsets.all(8)
                        : EdgeInsets.all(4),
                    decoration: isFloating && isSelected
                        ? BoxDecoration(
                            color: selectedColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      size: iconSize,
                      color: isSelected ? selectedColor : unselectedColor,
                    ),
                  ),
                  // Badge
                  if (item.showBadge)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: item.badgeText != null
                            ? Text(
                                item.badgeText!,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onError,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : null,
                      ),
                    ),
                ],
              ),

              // Label
              if (showLabels && !isMinimal) ...[
                SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
