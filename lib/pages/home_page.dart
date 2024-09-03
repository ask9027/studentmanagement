import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanagement/main.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../pages/pdf_and_printing.dart';
import '../widgets.dart';
import 'add_update.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _orderByGender;
  late String _orderByName;
  late int _genderIndex;
  late int _nameIndex;

  @override
  void initState() {
    loadToggleState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
      ),
      body: FutureBuilder<List<Student>>(
        future: StudentDBHelper.instance
            .getAllStudents(_orderByGender, _orderByName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            showSnack("While getting Data:\n${snapshot.error}");
            return const Center(
              child: Text(
                "Error eccurred",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
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
            final students = snapshot.data!;
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
                    itemCount: students.toList().length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 16),
                        decoration: BoxDecoration(
                          color: students.elementAt(index).gender == Gender.boy
                              ? Colors.deepPurple.shade50
                              : Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            navigatorKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddUpdateStudent(
                                    isAdd: false,
                                    student: students.elementAt(index),
                                  );
                                },
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          child: students.map(
                            (student) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "S.N. ${index + 1}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ":  ${student.name}",
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   "DOB : ${student.dob}",
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "PEN Number : ${student.penNumber}",
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "S.R. Number : ${student.srNumber}",
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "Class : ${student.className}",
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    "Gender : ${student.gender}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).elementAt(index),
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
          final currentNavigatorState = navigatorKey.currentState;
          if (currentNavigatorState != null) {
            currentNavigatorState
                .push(MaterialPageRoute(
              builder: (context) => const AddUpdateStudent(
                isAdd: true,
              ),
            ))
                .then((_) {
              setState(() {});
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void saveToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("genderIndex", _genderIndex);
    prefs.setInt("nameIndex", _nameIndex);
  }

  void loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _genderIndex = prefs.getInt("genderIndex") ?? -1;
      _orderByGender = _genderIndex < 0 ? "" : Gender.values[_genderIndex];
      _nameIndex = prefs.getInt("nameIndex") ?? -1;
      _orderByName = _nameIndex == 0
          ? StudentFields.name
          : _nameIndex == 1
              ? StudentFields.fatherName
              : "";
    });
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
                    initialLabelIndex: _genderIndex,
                    totalSwitches: 2,
                    labels: Gender.values,
                    changeOnTap: true,
                    animate: true,
                    inactiveBgColor: Colors.purple.shade50,
                    animationDuration: 150,
                    cornerRadius: 16,
                    onToggle: (index) {
                      setModalBottomSheetState(() {
                        if (index == _genderIndex) {
                          _genderIndex = -1;
                        } else {
                          _genderIndex = index!;
                        }
                        saveToggleState();
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ToggleSwitch(
                    initialLabelIndex: _nameIndex,
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
                        if (index == _nameIndex) {
                          _nameIndex = -1;
                        } else {
                          _nameIndex = index!;
                        }
                        saveToggleState();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        navigatorKey.currentState?.pop();
                        setState(() {
                          _orderByGender = _genderIndex < 0
                              ? ""
                              : Gender.values[_genderIndex];
                          _orderByName = _nameIndex == 0
                              ? StudentFields.name
                              : _nameIndex == 1
                                  ? StudentFields.fatherName
                                  : "";
                        });
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
