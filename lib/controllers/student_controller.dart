import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanagement/database/databases.dart';
import 'package:studentmanagement/database/models.dart';

class StudentController extends GetxController {
  late String orderByGender;
  late String orderByName;
  var genderIndex = (-1).obs;
  var nameIndex = (-1).obs;
  var students = <Student>[].obs;
  var isLoading = false.obs;
  var error = "".obs;

  @override
  void onInit() {
    super.onInit();
    initializedData();
  }

  Future<void> initializedData() async {
    await loadToggleState();
    await getStudentsDetails();
  }

  Future<void> getStudentsDetails() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 500));
      await StudentDBHelper.instance
          .getAllStudents(orderByGender, orderByName)
          .then((data) {
        students.assignAll(data);
      });
    } catch (e) {
      error("Error While loading student data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addStudent(Student student) async {
    handleOperation(
      () async {
        await StudentDBHelper.instance.addStudent(student);
      },
      "${student.name} is added successfully!",
      student.gender,
    );
  }

  Future<void> updateStudent(Student student) async {
    handleOperation(
      () async {
        await StudentDBHelper.instance.updateStudent(student);
      },
      "${student.name} is updated successfully!",
      student.gender,
    );
  }

  Future<void> deleteStudent(Student student) async {
    handleOperation(
      () async {
        await StudentDBHelper.instance.deleteStudent(student.id!);
      },
      "${student.name} is deleted successfully!",
      student.gender,
    );
  }

  Future<void> handleOperation(
      Future<void> Function() operation, String message, String gender) async {
    try {
      await operation();
      await getStudentsDetails();
      Get.snackbar(
        "Success",
        message,
        backgroundColor: gender == Gender.boy
            ? Colors.deepPurple.shade50
            : Colors.pink.shade50,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed student operation: ${e.toString()}",
      );
    }
  }

  Future<void> saveToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("genderIndex", genderIndex.value);
    prefs.setInt("nameIndex", nameIndex.value);
  }

  Future<void> loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    genderIndex.value = prefs.getInt("genderIndex") ?? -1;
    orderByGender =
        genderIndex.value < 0 ? "" : Gender.values[genderIndex.value];
    nameIndex.value = prefs.getInt("nameIndex") ?? -1;
    orderByName = nameIndex.value == 0
        ? StudentFields.name
        : nameIndex.value == 1
            ? StudentFields.fatherName
            : "";
  }
}
