import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar variants for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// Search-focused app bar with search field
  search,

  /// Profile-focused app bar with user avatar
  profile,

  /// Minimal app bar for immersive content
  minimal,
}

/// Production-ready custom app bar widget implementing Academic Authority design
/// with Professional Minimalism styling for alumni networking application.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The variant of the app bar to display
  final CustomAppBarVariant variant;

  /// The title text to display (required for standard and minimal variants)
  final String? title;

  /// Whether to show the back button (optional, defaults to auto-detect)
  final bool? showBackButton;

  /// Custom leading widget (optional)
  final Widget? leading;

  /// List of action widgets (optional)
  final List<Widget>? actions;

  /// Search query for search variant (optional)
  final String? searchQuery;

  /// Search callback for search variant (optional)
  final ValueChanged<String>? onSearchChanged;

  /// Search submit callback for search variant (optional)
  final ValueChanged<String>? onSearchSubmitted;

  /// User avatar URL for profile variant (optional)
  final String? avatarUrl;

  /// User name for profile variant (optional)
  final String? userName;

  /// Profile tap callback for profile variant (optional)
  final VoidCallback? onProfileTap;

  /// Background color override (optional)
  final Color? backgroundColor;

  /// Elevation override (optional, defaults to 0 for clean design)
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.variant,
    this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.searchQuery,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.avatarUrl,
    this.userName,
    this.onProfileTap,
    this.backgroundColor,
    this.elevation,
  });

  /// Standard app bar constructor
  const CustomAppBar.standard({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation,
  })  : variant = CustomAppBarVariant.standard,
        searchQuery = null,
        onSearchChanged = null,
        onSearchSubmitted = null,
        avatarUrl = null,
        userName = null,
        onProfileTap = null;

  /// Search app bar constructor
  const CustomAppBar.search({
    super.key,
    this.searchQuery,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.actions,
    this.backgroundColor,
    this.elevation,
  })  : variant = CustomAppBarVariant.search,
        title = null,
        showBackButton = null,
        leading = null,
        avatarUrl = null,
        userName = null,
        onProfileTap = null;

  /// Profile app bar constructor
  const CustomAppBar.profile({
    super.key,
    this.avatarUrl,
    this.userName,
    this.onProfileTap,
    this.actions,
    this.backgroundColor,
    this.elevation,
  })  : variant = CustomAppBarVariant.profile,
        title = null,
        showBackButton = null,
        leading = null,
        searchQuery = null,
        onSearchChanged = null,
        onSearchSubmitted = null;

  /// Minimal app bar constructor
  const CustomAppBar.minimal({
    super.key,
    this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation,
  })  : variant = CustomAppBarVariant.minimal,
        searchQuery = null,
        onSearchChanged = null,
        onSearchSubmitted = null,
        avatarUrl = null,
        userName = null,
        onProfileTap = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: _buildLeading(context),
      title: _buildTitle(context),
      actions: _buildActions(context),
      centerTitle: variant == CustomAppBarVariant.minimal,
      titleSpacing: variant == CustomAppBarVariant.search ? 0 : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.minimal:
        if (showBackButton == true ||
            (showBackButton == null && Navigator.of(context).canPop())) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          );
        }
        break;
      case CustomAppBarVariant.search:
        return IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        );
      case CustomAppBarVariant.profile:
        return null;
    }
    return null;
  }

  Widget? _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.minimal:
        return title != null
            ? Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: variant == CustomAppBarVariant.minimal ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: theme.appBarTheme.foregroundColor,
                ),
              )
            : null;

      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            controller: TextEditingController(text: searchQuery),
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Search alumni, companies...',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              suffixIcon: searchQuery?.isNotEmpty == true
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onPressed: () => onSearchChanged?.call(''),
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        );

      case CustomAppBarVariant.profile:
        return Row(
          children: [
            GestureDetector(
              onTap: onProfileTap ??
                  () => Navigator.pushNamed(context, '/profile-screen'),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    backgroundImage: avatarUrl?.isNotEmpty == true
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: avatarUrl?.isEmpty != false
                        ? Icon(
                            Icons.person,
                            size: 20,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        userName ?? 'Alumni',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
    }
    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> actionWidgets = [];

    // Add default actions based on variant
    switch (variant) {
      case CustomAppBarVariant.standard:
        // Add notification icon for main screens
        actionWidgets.add(
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 22),
            onPressed: () => Navigator.pushNamed(context, '/messaging-screen'),
            tooltip: 'Notifications',
          ),
        );
        break;

      case CustomAppBarVariant.search:
        // Add filter icon for search
        actionWidgets.add(
          IconButton(
            icon: Icon(Icons.tune, size: 22),
            onPressed: () {
              // Show filter bottom sheet
              HapticFeedback.lightImpact();
            },
            tooltip: 'Filter',
          ),
        );
        break;

      case CustomAppBarVariant.profile:
        // Add settings icon for profile
        actionWidgets.add(
          IconButton(
            icon: Icon(Icons.settings_outlined, size: 22),
            onPressed: () {
              // Navigate to settings
              HapticFeedback.lightImpact();
            },
            tooltip: 'Settings',
          ),
        );
        break;

      case CustomAppBarVariant.minimal:
        // No default actions for minimal variant
        break;
    }

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
