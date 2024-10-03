import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/database/databases.dart';
import 'package:studentmanagement/database/models.dart';
import 'package:studentmanagement/utils/extensions.dart';

class SchooProfileController extends GetxController {
  var schoolProfile = <SchoolProfile>[].obs;
  var isLoading = false.obs;
  var error = "".obs;
  final TextEditingController schoolNameCont = TextEditingController();
  final TextEditingController addressCont = TextEditingController();
  final TextEditingController contactCont = TextEditingController();
  final TextEditingController recogCont = TextEditingController();

  RxBool isBtnEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  void initialize(bool isAdd, SchoolProfile? profile) {
    if (!isAdd && profile != null) {
      schoolNameCont.text = profile.schoolName;
      addressCont.text = profile.address;
      contactCont.text = profile.contactNumber;
      recogCont.text = profile.schoolRecognition;
    }
  }

  void checkFields() {
    isBtnEnable.value = schoolNameCont.text.isNotEmpty &&
        addressCont.text.isNotEmpty &&
        contactCont.text.isNotEmpty &&
        recogCont.text.isNotEmpty;
  }

  Future<void> initializeData() async {
    await getSchoolProfile();
  }

  Future<void> saveSchoolProfile({SchoolProfile? existingProfile}) async {
    final profile = SchoolProfile(
        schoolName: schoolNameCont.text.toTitleCase(),
        address: addressCont.text.toCapitalized(),
        contactNumber: contactCont.text,
        schoolRecognition: recogCont.text);

    Future<void> operation;
    if (existingProfile == null) {
      operation = StudentDBHelper.instance.saveSchoolProfile(profile);
    } else {
      operation = StudentDBHelper.instance.updateSchoolProfile(profile);
    }
    operation.then(
      (_) => Get.back(),
    );
  }

  Future<void> getSchoolProfile() async {
    try {
      isLoading(true);
      await StudentDBHelper.instance.getSchoolProfile().then((data) {
        schoolProfile.assignAll(data);
      });
    } catch (e) {
      error("Error While loading profile data: $e");
    } finally {
      isLoading(false);
    }
  }
}
