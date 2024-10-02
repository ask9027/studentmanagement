import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSchoolProfile extends StatelessWidget {
  final title = Get.arguments["title"];
  final profile = Get.arguments["profile"];
  AddSchoolProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
