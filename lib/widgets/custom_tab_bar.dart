import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom tab bar variants for different content contexts
enum CustomTabBarVariant {
  /// Standard tab bar with text labels
  standard,

  /// Icon-based tab bar with icons and labels
  iconBased,

  /// Segmented control style tab bar
  segmented,

  /// Minimal tab bar with underline indicator
  minimal,
}

/// Tab item data structure for custom tab bar
class CustomTabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final bool showBadge;
  final String? badgeText;

  const CustomTabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.showBadge = false,
    this.badgeText,
  });
}

/// Production-ready custom tab bar widget implementing Academic Authority design
/// with Professional Minimalism styling for alumni networking application.
class CustomTabBar extends StatelessWidget {
  /// The variant of the tab bar to display
  final CustomTabBarVariant variant;

  /// List of tab items
  final List<CustomTabItem> tabs;

  /// Current selected index
  final int currentIndex;

  /// Callback when tab is selected
  final ValueChanged<int> onTap;

  /// Background color override (optional)
  final Color? backgroundColor;

  /// Indicator color override (optional)
  final Color? indicatorColor;

  /// Whether tabs are scrollable (optional, defaults to false)
  final bool isScrollable;

  /// Tab alignment for scrollable tabs (optional)
  final TabAlignment? tabAlignment;

  const CustomTabBar({
    super.key,
    this.variant = CustomTabBarVariant.standard,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.tabAlignment,
  });

  /// Standard tab bar constructor
  const CustomTabBar.standard({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.tabAlignment,
  }) : variant = CustomTabBarVariant.standard;

  /// Icon-based tab bar constructor
  const CustomTabBar.iconBased({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.tabAlignment,
  }) : variant = CustomTabBarVariant.iconBased;

  /// Segmented control tab bar constructor
  const CustomTabBar.segmented({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.tabAlignment,
  }) : variant = CustomTabBarVariant.segmented;

  /// Minimal tab bar constructor
  const CustomTabBar.minimal({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.tabAlignment,
  }) : variant = CustomTabBarVariant.minimal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomTabBarVariant.standard:
        return _buildStandardTabBar(context, theme);
      case CustomTabBarVariant.iconBased:
        return _buildIconBasedTabBar(context, theme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, theme);
      case CustomTabBarVariant.minimal:
        return _buildMinimalTabBar(context, theme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildStandardTab(theme, tab, index == currentIndex);
        }).toList(),
        controller: null,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap(index);
        },
      ),
    );
  }

  Widget _buildIconBasedTabBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildIconBasedTab(theme, tab, index == currentIndex);
        }).toList(),
        controller: null,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap(index);
        },
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap(index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (indicatorColor ?? theme.colorScheme.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isFirst ? 11 : 0),
                    right: Radius.circular(isLast ? 11 : 0),
                  ),
                ),
                child: Text(
                  tab.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMinimalTabBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: 32),
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? (indicatorColor ?? theme.colorScheme.primary)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tab.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStandardTab(
      ThemeData theme, CustomTabItem tab, bool isSelected) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(tab.label),
          if (tab.showBadge)
            Positioned(
              right: -12,
              top: -8,
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
                child: tab.badgeText != null
                    ? Text(
                        tab.badgeText!,
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
    );
  }

  Widget _buildIconBasedTab(
      ThemeData theme, CustomTabItem tab, bool isSelected) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tab.customIcon != null)
                tab.customIcon!
              else if (tab.icon != null)
                Icon(tab.icon!, size: 20),
              SizedBox(height: 4),
              Text(tab.label),
            ],
          ),
          if (tab.showBadge)
            Positioned(
              right: -8,
              top: -4,
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
                child: tab.badgeText != null
                    ? Text(
                        tab.badgeText!,
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
    );
  }
}
