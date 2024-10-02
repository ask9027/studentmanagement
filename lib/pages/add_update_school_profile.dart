import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/controllers/schoo_profile_controller.dart';

class AddUpdateSchoolProfile extends StatelessWidget {
  AddUpdateSchoolProfile({super.key});
  final title = Get.arguments["title"];
  final profile = Get.arguments["profile"];
  final SchooProfileController controller = Get.find<SchooProfileController>();
  final isAdd = Get.arguments["isAdd"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? "Add Profile" : "Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.schoolNameCont,
                decoration: const InputDecoration(
                  hintText: "Enter School Name",
                  label: Text("School Name"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.addressCont,
                decoration: const InputDecoration(
                  hintText: "Enter address",
                  label: Text("address"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: controller.contactCont,
                decoration: const InputDecoration(
                  hintText: "Enter Contect Number",
                  label: Text("Contect Number"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.recogCont,
                decoration: const InputDecoration(
                  hintText: "Enter School Recognition",
                  label: Text("School Recognition"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 30),
              Obx(
                () => OutlinedButton(
                  onPressed: controller.isBtnEnable.value
                      ? () {
                          controller.saveSchoolProfile(
                              existingProfile: profile);
                        }
                      : null,
                  child: Text(isAdd ? "Save" : "Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
