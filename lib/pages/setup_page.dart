import 'package:flutter/material.dart';
import 'package:studentmanagement/main.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../extensions.dart';
import '../widgets.dart';
import 'home_page.dart';

class Setup extends StatefulWidget {
  const Setup({super.key, this.isAdd, this.classModel});

  final bool? isAdd;
  final ClassModel? classModel;

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  String classCont = "";
  TextEditingController classTeachCont = TextEditingController();

  bool isBtnEnable = false;

  @override
  void initState() {
    if (!widget.isAdd!) {
      classCont = widget.classModel!.className.toString();

      classTeachCont.text = widget.classModel!.classTeacher.toString();
    }
    super.initState();
  }

  checkFields() {
    setState(() {
      if (!classCont.contains("Select Class") &&
          classTeachCont.text.toString().isNotEmpty) {
        isBtnEnable = true;
      } else {
        isBtnEnable = false;
      }
    });
  }

  @override
  void dispose() {
    classTeachCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdd!
            ? "Add Class Detail"
            : "Update ${widget.classModel!.className} Class"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: classCont,
                items: ClassFields.values.map((items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    classCont = value!;
                  });
                  checkFields();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: classTeachCont,
                decoration: const InputDecoration(
                  hintText: "Enter Class Teacher's Name",
                  label: Text("Class Teacher"),
                ),
                onChanged: (value) {
                  checkFields();
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 30,
              ),
              OutlinedButton(
                onPressed: isBtnEnable
                    ? () async {
                        if (widget.isAdd!) {
                          ClassModel classModel = await StudentDBHelper.instance
                              .addClassDetails(
                                ClassModel(
                                  className: classCont,
                                  classTeacher:
                                      classTeachCont.text.toTitleCase().trim(),
                                  isSetup: "1",
                                ),
                              )
                              .onError(
                                (error, stackTrace) => showSnack(
                                  "$error Add",
                                ),
                              );
                          showSnack("${classModel.className} Added.");
                          navigatorKey.currentState?.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else {
                          await StudentDBHelper.instance
                              .updateClass(
                                ClassModel(
                                  id: widget.classModel!.id,
                                  className: classCont,
                                  classTeacher:
                                      classTeachCont.text.toTitleCase().trim(),
                                  isSetup: widget.classModel!.isSetup.trim(),
                                ),
                              )
                              .onError(
                                (error, stackTrace) => showSnack(
                                  "$error Update",
                                ),
                              );
                          showSnack("$classCont Updated.");
                          navigatorKey.currentState?.pop();
                        }
                      }
                    : null,
                child: Text(widget.isAdd! ? "Save" : "Update"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
