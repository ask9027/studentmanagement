import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/controllers/add_update_controller.dart';
import 'package:studentmanagement/controllers/student_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../database/models.dart';

class AddUpdateStudent extends StatelessWidget {
  final AddUpdateController controller = Get.put(AddUpdateController());
  final StudentController studentController = Get.find<StudentController>();

  AddUpdateStudent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdd = Get.arguments['isAdd'];
    final Student? student = Get.arguments['student'];

    controller.initialize(isAdd, student);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdd ? "Add Student" : "Update ${student!.name}"),
        actions: isAdd
            ? null
            : [
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          content: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Do You want to delete",
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: " `${student!.name}` ",
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                const TextSpan(
                                  text: "?",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                studentController.deleteStudent(student);
                                Get.back();
                                Get.back();
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("No"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.nameCont,
                decoration: const InputDecoration(
                  hintText: "Enter Name",
                  label: Text("Name"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller.fNameCont,
                decoration: const InputDecoration(
                  hintText: "Enter Father's Name",
                  label: Text("Father's Name"),
                ),
                onChanged: (value) => controller.checkFields(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              Obx(
                () => ToggleSwitch(
                  initialLabelIndex: controller.toggleIndex.value,
                  totalSwitches: 2,
                  labels: Gender.values,
                  changeOnTap: true,
                  animate: true,
                  inactiveBgColor: Colors.purple.shade50,
                  animationDuration: 150,
                  cornerRadius: 16,
                  onToggle: (index) => controller.toggleGender(index!),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => OutlinedButton(
                  onPressed: controller.isBtnEnable.value
                      ? () {
                          controller.saveStudent(existingStudent: student);
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
