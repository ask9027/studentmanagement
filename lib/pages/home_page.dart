import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/controllers/student_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../database/models.dart';
import '../pages/pdf_and_printing.dart';
import 'add_update.dart';

class HomePage extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
      ),
      body: Obx(
        () {
          if (studentController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (studentController.error.isNotEmpty) {
            return Center(
              child: Text(studentController.error.value),
            );
          } else if (studentController.students.isEmpty) {
            return const Center(
              child: Text(
                "No Student Found",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            final students = studentController.students.toList();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Student List",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => _openSortOptions(context),
                              icon: const Icon(
                                Icons.sort,
                                color: Colors.blueAccent,
                              )),
                          IconButton(
                            onPressed: () {
                              Get.snackbar(
                                "Pdf Genrator",
                                "Pdf creating...",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade400,
                                colorText: Colors.white,
                              );
                              Timer(
                                const Duration(seconds: 3),
                                (() => PdfAndPrinting().createPdf(students)),
                              );
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: studentController.students.toList().length,
                    itemBuilder: (context, index) {
                      final student = students.elementAt(index);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 16),
                        decoration: BoxDecoration(
                          color: student.gender == Gender.boy
                              ? Colors.deepPurple.shade50
                              : Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => AddUpdateStudent(),
                              arguments: {
                                "isAdd": false,
                                "student": student,
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "S.N. ${index + 1} : ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    student.name,
                                    style: TextStyle(
                                      color: student.gender == Gender.boy
                                          ? Colors.deepPurple.shade600
                                          : Colors.pink.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Father's Name : ${student.fatherName}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddUpdateStudent(),
            arguments: {
              "isAdd": true,
              "student": null,
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openSortOptions(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalBottomSheetState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Sort Student List',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16.0),
                  ToggleSwitch(
                    initialLabelIndex: studentController.genderIndex.value,
                    totalSwitches: 2,
                    labels: Gender.values,
                    changeOnTap: true,
                    animate: true,
                    inactiveBgColor: Colors.purple.shade50,
                    animationDuration: 150,
                    cornerRadius: 16,
                    onToggle: (index) {
                      setModalBottomSheetState(() {
                        if (index == studentController.genderIndex.value) {
                          studentController.genderIndex.value = -1;
                        } else {
                          studentController.genderIndex.value = index!;
                        }
                        studentController.saveToggleState();
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ToggleSwitch(
                    initialLabelIndex: studentController.nameIndex.value,
                    totalSwitches: 2,
                    changeOnTap: true,
                    animate: true,
                    inactiveBgColor: Colors.purple.shade50,
                    animationDuration: 150,
                    cornerRadius: 16,
                    labels: [
                      StudentFields.name.capitalizeFirst!,
                      StudentFields.fatherName.capitalizeFirst!,
                    ],
                    onToggle: (index) {
                      setModalBottomSheetState(() {
                        if (index == studentController.nameIndex.value) {
                          studentController.nameIndex.value = -1;
                        } else {
                          studentController.nameIndex.value = index!;
                        }
                        studentController.saveToggleState();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        studentController.orderByGender = studentController
                                    .genderIndex.value <
                                0
                            ? ""
                            : Gender
                                .values[studentController.genderIndex.value];
                        studentController.orderByName =
                            studentController.nameIndex.value == 0
                                ? StudentFields.name
                                : studentController.nameIndex.value == 1
                                    ? StudentFields.fatherName
                                    : "";
                        studentController.getStudentsDetails();
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
