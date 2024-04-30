import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../extensions.dart';
import '../widgets.dart';

class AddUpdateStudent extends StatefulWidget {
  const AddUpdateStudent({super.key, this.isAdd, this.student});

  final bool? isAdd;
  final Student? student;

  @override
  State<AddUpdateStudent> createState() => _AddUpdateStudentState();
}

class _AddUpdateStudentState extends State<AddUpdateStudent> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController fNameCont = TextEditingController();
  SingleValueDropDownController genderCont = SingleValueDropDownController(
    data:
        const DropDownValueModel(name: "Select Gender", value: "Select Gender"),
  );
  SingleValueDropDownController classCont = SingleValueDropDownController(
    data: const DropDownValueModel(name: "Select Class", value: "Select Class"),
  );
  bool isBtnEnable = false;

  @override
  void initState() {
    if (!widget.isAdd!) {
      nameCont.text = widget.student!.name;
      fNameCont.text = widget.student!.fatherName;
      genderCont = SingleValueDropDownController(
        data: DropDownValueModel(
          name: widget.student!.gender.toString(),
          value: widget.student!.gender.toString(),
        ),
      );
      classCont = SingleValueDropDownController(
        data: DropDownValueModel(
          name: widget.student!.className.toString(),
          value: widget.student!.className.toString(),
        ),
      );
    }
    super.initState();
  }

  checkFields() {
    setState(() {
      if (nameCont.text.toString().isNotEmpty &&
          fNameCont.text.toString().isNotEmpty &&
          !genderCont.dropDownValue!.name.contains("Select Gender") &&
          !classCont.dropDownValue!.name.contains("Select Class")) {
        isBtnEnable = true;
      } else {
        isBtnEnable = false;
      }
    });
  }

  @override
  void dispose() {
    nameCont.dispose();
    fNameCont.dispose();
    genderCont.dispose();
    classCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isAdd! ? "Add Student" : "Update ${widget.student!.name}"),
        actions: widget.isAdd!
            ? null
            : [
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            content: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                text: "Do You want to delete",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: " `${widget.student!.name}` ",
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              const TextSpan(
                                text: "?",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ])),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await StudentDBHelper.instance
                                      .deleteStudent(widget.student!.id!)
                                      .onError((error, stackTrace) => showSnack(
                                            context,
                                            error.toString(),
                                          ));
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No")),
                            ],
                          );
                        },
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
                const SizedBox(
                  width: 20,
                )
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameCont,
              decoration: const InputDecoration(
                hintText: "Enter Name",
                label: Text("Name"),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: fNameCont,
              decoration: const InputDecoration(
                hintText: "Enter Father's Name",
                label: Text("Father's Name"),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            DropDownTextField(
              enableSearch: false,
              clearOption: false,
              controller: genderCont,
              textFieldDecoration: const InputDecoration(
                label: Text("Gender"),
              ),
              onChanged: (value) {
                checkFields();
              },
              dropDownList: const [
                DropDownValueModel(name: Gender.boy, value: Gender.boy),
                DropDownValueModel(name: Gender.girl, value: Gender.girl),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            DropDownTextField(
              enableSearch: false,
              clearOption: false,
              controller: classCont,
              textFieldDecoration: const InputDecoration(
                label: Text("Class"),
              ),
              onChanged: (value) {
                checkFields();
              },
              dropDownList: const [
                DropDownValueModel(name: Class.first, value: Class.first),
                DropDownValueModel(name: Class.second, value: Class.second),
                DropDownValueModel(name: Class.third, value: Class.third),
                DropDownValueModel(name: Class.fourth, value: Class.fourth),
                DropDownValueModel(name: Class.fifth, value: Class.fifth),
                DropDownValueModel(name: Class.sixth, value: Class.sixth),
                DropDownValueModel(name: Class.eighth, value: Class.seventh),
                DropDownValueModel(name: Class.eighth, value: Class.eighth),
                DropDownValueModel(name: Class.ninth, value: Class.ninth),
                DropDownValueModel(name: Class.tenth, value: Class.tenth),
                DropDownValueModel(name: Class.eleventh, value: Class.eleventh),
                DropDownValueModel(name: Class.twelfth, value: Class.twelfth),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              onPressed: isBtnEnable
                  ? () async {
                      if (widget.isAdd!) {
                        Student student = await StudentDBHelper.instance
                            .addStudent(
                              Student(
                                name: nameCont.text.toTitleCase().trim(),
                                fatherName: fNameCont.text.toTitleCase().trim(),
                                className: classCont.dropDownValue!.value,
                                gender: genderCont.dropDownValue!.value,
                              ),
                            )
                            .onError(
                              (error, stackTrace) => showSnack(
                                context,
                                "$error Add",
                              ),
                            );

                        if (!context.mounted) return;
                        showSnack(context, "${student.name} Added.");

                        Navigator.pop(context);
                      } else {
                        await StudentDBHelper.instance
                            .updateStudent(
                              Student(
                                id: widget.student!.id,
                                name: nameCont.text.toTitleCase().trim(),
                                fatherName: fNameCont.text.toTitleCase().trim(),
                                className: classCont.dropDownValue!.value,
                                gender: genderCont.dropDownValue!.value,
                              ),
                            )
                            .onError(
                              (error, stackTrace) => showSnack(
                                context,
                                "$error Update",
                              ),
                            );
                        if (!context.mounted) return;
                        showSnack(
                            context, "${nameCont.text.toTitleCase()} Updated.");

                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text(widget.isAdd! ? "Save" : "Update"),
            )
          ],
        ),
      ),
    );
  }
}
