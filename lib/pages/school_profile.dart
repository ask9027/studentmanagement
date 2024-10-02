import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/controllers/schoo_profile_controller.dart';
import 'package:studentmanagement/utils/routes.dart';

class SchoolProfile extends StatelessWidget {
  final SchooProfileController schooProfileController =
      Get.put(SchooProfileController());
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
      body: Obx(
        () {
          if (schooProfileController.error.isNotEmpty) {
            return Center(
              child: Text(schooProfileController.error.value),
            );
          } else if (schooProfileController.schoolProfile.schoolName.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed(
                    RouteName.addSchoolProfile,
                    arguments: {
                      "title": "Add School Profile",
                      "profile": schooProfileController.schoolProfile
                    },
                  );
                },
                child: Text("add Profile Details"),
              ),
            );
          } else {
            final profile = schooProfileController.schoolProfile;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "School Name : ${profile.schoolName}",
                ),
                Text(
                  "Address : ${profile.address}",
                ),
                Text(
                  "Contect Number : ${profile.contactNumber}",
                ),
                Text(
                  "Recognition : ${profile.schoolRecognition}",
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
