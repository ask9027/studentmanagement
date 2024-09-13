import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/extensions.dart';
import '../database/models.dart';
import 'student_controller.dart';

class AddUpdateController extends GetxController {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController fNameCont = TextEditingController();
  RxString gender = "".obs;
  RxInt toggleIndex = (-1).obs;
  RxBool isBtnEnable = false.obs;

  final StudentController studentController = Get.find<StudentController>();

  void initialize(bool isAdd, Student? student) {
    if (!isAdd && student != null) {
      nameCont.text = student.name;
      fNameCont.text = student.fatherName;
      gender.value = student.gender;
      toggleIndex.value = Gender.values.indexOf(student.gender);
    }
  }

  void checkFields() {
    isBtnEnable.value = nameCont.text.isNotEmpty &&
        fNameCont.text.isNotEmpty &&
        gender.isNotEmpty;
  }

  void toggleGender(int index) {
    if (index == toggleIndex.value) {
      toggleIndex.value = -1;
      gender.value = "";
    } else {
      toggleIndex.value = index;
      gender.value = Gender.values[index];
    }
    checkFields();
  }

  Future<void> saveStudent({Student? existingStudent}) async {
    final student = Student(
      id: existingStudent?.id,
      name: nameCont.text.toTitleCase().trim(),
      fatherName: fNameCont.text.toTitleCase().trim(),
      gender: gender.value,
    );
    Future<void> operation;
    if (existingStudent == null) {
      operation = studentController.addStudent(student);
    } else {
      operation = studentController.updateStudent(student);
    }
    operation.then(
      (_) => Get.back(closeOverlays: true),
    );
  }
}
