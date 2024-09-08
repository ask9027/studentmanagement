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
    getStudentsDetails();
  }

  Future<void> getStudentsDetails() async {
    try {
      isLoading(true);
      final data = await StudentDBHelper.instance
          .getAllStudents(orderByGender, orderByName);
      students.assignAll(data);
    } catch (e) {
      error("Error While loading student data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      await StudentDBHelper.instance.addStudent(student);
      await getStudentsDetails();
      Get.snackbar(
        "Success",
        "${student.name} is added successfully!",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add student: ${e.toString()}",
      );
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      await StudentDBHelper.instance.updateStudent(student);
      await getStudentsDetails();
      Get.snackbar(
        "Success",
        "${student.name} is updated successfully!",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update student: ${e.toString()}",
      );
    }
  }

  Future<void> deleteStudent(Student student) async {
    try {
      await StudentDBHelper.instance.deleteStudent(student.id!);
      await getStudentsDetails();
      Get.snackbar(
        "Success",
        "${student.name} is deleted successfully!",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete student: ${e.toString()}",
      );
    }
  }

  void saveToggleState() async {
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
