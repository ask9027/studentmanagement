import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/utils/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAllNamed(RouteName.dashboardPage);
    });
    return const Scaffold(
      body: Center(
        child: Text("Student Management"),
      ),
    );
  }
}
