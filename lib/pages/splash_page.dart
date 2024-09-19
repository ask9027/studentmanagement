import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/utils/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(RouteName.dashboardPage);
    });
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "Student Management",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
