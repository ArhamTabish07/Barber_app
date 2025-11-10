import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static BuildContext? get context => navigatorKey.currentContext;

  pushReplacementToScreen({required Widget nextScreen}) {
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (navigatorKey) => nextScreen),
    );
  }

  pop() {
    Navigator.pop(navigatorKey.currentContext!);
  }

  navigateToScreen({required Widget nextScreen}) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (navigatorKey) => nextScreen),
    );
  }

  static void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger =
        scaffoldMessengerKey.currentState ??
        (context != null ? ScaffoldMessenger.of(context!) : null);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  showToast(String message, {Duration duration = const Duration(seconds: 2)}) {
    showSnackBar(message, duration: duration);
  }
}
