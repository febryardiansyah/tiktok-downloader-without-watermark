import 'package:flutter/material.dart';
import 'package:tiktok_downloader/ui/history/history_screen.dart';
import 'package:tiktok_downloader/ui/home/home_screen.dart';
import 'package:tiktok_downloader/ui/splash_screen.dart';

class BaseString {
  static String downloadUrl = 'https://downloader-api.kaedenoki.net/api/tiktok';
  static String serverError = 'Server is down right now, try it later';
  static String errorNoInternet = 'Check your internet!';
  static String adBannerId = 'Banner_Android';
  static String adInterstitialId = 'Interstitial_Android';
  static String gameId = '5219966';
}

class ImageConstants {
  static String icon = 'assets/icon.png';
  static String iconSmall = 'assets/icon_small.png';
}

class RouteConstants {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String history = '/history';
}

MaterialPageRoute _pageRoute(Widget body, RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => body,
    settings: settings,
  );
}

Route generateRoute(RouteSettings settings) {
  final name = settings.name;
  switch (name) {
    case RouteConstants.splash:
      return _pageRoute(const SplashScreen(), settings);
    case RouteConstants.home:
      return _pageRoute(const HomeScreen(), settings);
    case RouteConstants.history:
      return _pageRoute(const HistoryScreen(), settings);
    default:
      return _pageRoute(const Scaffold(), settings);
  }
}
