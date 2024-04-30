import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String _orderByGender = "";
  String _orderByName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
      ),
      body: FutureBuilder<List<Student>>(
        future: StudentDBHelper.instance
            .getAllStudents(_orderByGender, _orderByName)
            .onError((error, stackTrace) => showSnack(
                  context,
                  error.toString(),
                )),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text(
                    "No Student Found",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Column(
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
                                    (() => PdfAndPrinting()
                                        .createPdf(snapshot.data!)),
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
                        itemCount: snapshot.data!.toList().length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 16),
                            decoration: BoxDecoration(
                              color: snapshot.data!.elementAt(index).gender ==
                                      Gender.boy
                                  ? Colors.deepPurple.shade50
                                  : Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddUpdateStudent(
                                        isAdd: false,
                                        student:
                                            snapshot.data!.elementAt(index),
                                      );
                                    },
                                  ),
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                              child: snapshot.data!.map(
                                (student) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                        "Class : ${student.className}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const AddUpdateStudent(
              isAdd: true,
            ),
          ))
              .then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openSortOptions(BuildContext context) {
    String orderByGender = "";
    String orderByName = "";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Sort Student List',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Expanded(
                child: ToggleSwitch(
                  cornerRadius: 50.0,
                  initialLabelIndex: _orderByGender == Gender.boy
                      ? 0
                      : _orderByGender == Gender.girl
                          ? 1
                          : 2,
                  totalSwitches: 3,
                  labels: [
                    Gender.boy.capitalizeFirst!,
                    Gender.girl.capitalizeFirst!,
                    "Clear",
                  ],
                  icons: const [
                    Icons.male,
                    Icons.female,
                    Icons.clear,
                  ],
                  onToggle: (index) {
                    setState(() {
                      if (index == 0) {
                        orderByGender = Gender.boy;
                      } else if (index == 1) {
                        orderByGender = Gender.girl;
                      } else if (index == 2) {
                        orderByGender = "";
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ToggleSwitch(
                  cornerRadius: 50.0,
                  initialLabelIndex: _orderByName == StudentFields.name
                      ? 0
                      : _orderByName == StudentFields.fatherName
                          ? 1
                          : 2,
                  totalSwitches: 3,
                  labels: [
                    StudentFields.name.capitalizeFirst!,
                    StudentFields.fatherName.capitalizeFirst!,
                    "Clear",
                  ],
                  icons: const [
                    Icons.person,
                    Icons.person_4,
                    Icons.clear,
                  ],
                  onToggle: (index) {
                    setState(() {
                      if (index == 0) {
                        orderByName = StudentFields.name;
                      } else if (index == 1) {
                        orderByName = StudentFields.fatherName;
                      } else if (index == 2) {
                        orderByName = "";
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _orderByGender = orderByGender;
                      _orderByName = orderByName;
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
  }
}
