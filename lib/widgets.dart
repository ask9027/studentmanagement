import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studentmanagement/main.dart';

showSnack(message) {
  final navigatorState = navigatorKey.currentState;
  final scaffoldMessengerState = scaffoldMessengerKey.currentState;
  if (navigatorState != null) {
    if (scaffoldMessengerState != null) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          duration: const Duration(
            seconds: 5,
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print("ScaffoldMessengerState not ready , cant show snackbar.");
      }
    }
  } else {
    if (kDebugMode) {
      print("NavigatorState not ready , cant show snackbar.");
    }
  }
}
