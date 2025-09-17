import 'package:flutter/material.dart';
import '../presentation/leaderboard_screen/leaderboard_screen.dart';
import '../presentation/cv_upload_screen/cv_upload_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/main_feed_screen/main_feed_screen.dart';
import '../presentation/cv_swipe_screen/cv_swipe_screen.dart';
import '../presentation/messaging_screen/messaging_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String leaderboard = '/leaderboard-screen';
  static const String cvUpload = '/cv-upload-screen';
  static const String profile = '/profile-screen';
  static const String mainFeed = '/main-feed-screen';
  static const String cvSwipe = '/cv-swipe-screen';
  static const String messaging = '/messaging-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LeaderboardScreen(),
    leaderboard: (context) => const LeaderboardScreen(),
    cvUpload: (context) => const CvUploadScreen(),
    profile: (context) => const ProfileScreen(),
    mainFeed: (context) => const MainFeedScreen(),
    cvSwipe: (context) => const CvSwipeScreen(),
    messaging: (context) => const MessagingScreen(),
    // TODO: Add your other routes here
  };
}
