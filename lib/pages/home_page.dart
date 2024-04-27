import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../pages/pdf_and_printing.dart';
import '../widgets.dart';
import 'add_update.dart';
import 'setup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClassModel>>(
      future: StudentDBHelper.instance.getClass(),
      builder: (context, classSnap) {
        if (!classSnap.hasData) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return classSnap.data!.isEmpty
            ? const Setup(isAdd: true)
            : Scaffold(
                appBar: AppBar(
                  actions: [
                    Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Setup(
                                  isAdd: false,
                                  classModel: classSnap.data!.elementAt(0),
                                ),
                              )).then((_) {
                            setState(() {});
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit_note,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Class : ${classSnap.data!.elementAt(0).className}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Teacher : Mr. ${classSnap.data!.elementAt(0).classTeacher}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                body: FutureBuilder<List<Student>>(
                  future: StudentDBHelper.instance
                      .getAllStudents()
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Student List",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                        color: Colors.deepPurple.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return AddUpdateStudent(
                                                  isAdd: false,
                                                  student: snapshot.data!
                                                      .elementAt(index),
                                                  className: classSnap.data!
                                                      .elementAt(0)
                                                      .className,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "  ${student.name}",
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "Class. ${student.className}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Gender. ${student.gender}",
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
                      builder: (context) => AddUpdateStudent(
                        isAdd: true,
                        className: classSnap.data!.elementAt(0).className,
                      ),
                    ))
                        .then((_) {
                      setState(() {});
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              );
      },
    );
  }
}
