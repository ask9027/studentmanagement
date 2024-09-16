import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffManagement extends StatelessWidget {
  final String title = Get.arguments["title"];
  StaffManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
