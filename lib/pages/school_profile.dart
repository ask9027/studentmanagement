import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolProfile extends StatelessWidget {
  final String title = Get.arguments["title"];
  SchoolProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Text(
          title,
        ),
      ),
    );
  }
}
