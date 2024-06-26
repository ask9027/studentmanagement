import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  final TextEditingController dobCont = TextEditingController();
  final TextEditingController penNumberCont = TextEditingController();
  final TextEditingController srNumberCont = TextEditingController();
  String genderCont = "";
  int _toggleIndex = -1;
  String classCont = "Select Class";
  bool isBtnEnable = false;
  final DateFormat format = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    if (!widget.isAdd!) {
      nameCont.text = widget.student!.name;
      fNameCont.text = widget.student!.fatherName;
      dobCont.text = widget.student!.dob;
      penNumberCont.text = widget.student!.penNumber;
      srNumberCont.text = widget.student!.srNumber;
      genderCont = widget.student!.gender.toString();
      _toggleIndex = Gender.values.indexOf(genderCont);
      classCont = widget.student!.className.toString();
    }
    super.initState();
  }

  checkFields() {
    setState(() {
      if (nameCont.text.toString().isNotEmpty &&
          fNameCont.text.toString().isNotEmpty &&
          dobCont.text.toString().isNotEmpty &&
          penNumberCont.text.toString().isNotEmpty &&
          srNumberCont.text.toString().isNotEmpty &&
          genderCont.isNotEmpty &&
          !classCont.contains("Select Class")) {
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
    dobCont.dispose();
    penNumberCont.dispose();
    srNumberCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAdd! ? "Add Student" : "Update ${widget.student!.name}",
        ),
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
                              text: TextSpan(
                                children: [
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await StudentDBHelper.instance
                                      .deleteStudent(widget.student!.id!)
                                      .onError(
                                        (error, stackTrace) => showSnack(
                                          context,
                                          error.toString(),
                                        ),
                                      );
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
                                child: const Text("No"),
                              ),
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
                label: Text(
                  "Name",
                ),
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
                label: Text(
                  "Father's Name",
                ),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: dobCont,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Enter DOB(yyyy-MM-dd)",
                label: const Text(
                  "Date Of Birth",
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  onPressed: () {
                    showDatePickerDialog(
                      context: context,
                      maxDate: DateTime.now(),
                      minDate: DateTime(1900),
                      selectedDate: dobCont.text.isNotEmpty
                          ? format.parse(dobCont.text)
                          : DateTime.now(),
                    ).then(
                      (value) {
                        setState(() {
                          dobCont.text = format.format(value!);
                          checkFields();
                        });
                      },
                    );
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: penNumberCont,
              maxLength: 11,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Enter PEN Number",
                helperText: "digits only",
                counter: Text(
                  "${penNumberCont.text.length}",
                ),
                label: const Text("PEN Number"),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: srNumberCont,
              decoration: const InputDecoration(
                hintText: "Enter SR Number",
                label: Text("SR Number"),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10,
            ),
            ToggleSwitch(
              initialLabelIndex: _toggleIndex,
              totalSwitches: 2,
              labels: Gender.values,
              changeOnTap: true,
              animate: true,
              inactiveBgColor: Colors.purple.shade50,
              animationDuration: 150,
              cornerRadius: 16,
              onToggle: (index) {
                setState(() {
                  if (index == _toggleIndex) {
                    _toggleIndex = -1;
                    genderCont = "";
                  } else {
                    _toggleIndex = index!;
                    genderCont = Gender.values[index];
                  }
                  checkFields();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButton(
              value: classCont,
              onChanged: (value) {
                setState(() {
                  classCont = value!;
                });
                checkFields();
              },
              items: ClassFields.values.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
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
                                dob: dobCont.text.trim(),
                                penNumber: penNumberCont.text.trim(),
                                srNumber: srNumberCont.text.trim(),
                                className: classCont,
                                gender: genderCont,
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
                                dob: dobCont.text.trim(),
                                penNumber: penNumberCont.text.trim(),
                                srNumber: srNumberCont.text.trim(),
                                className: classCont,
                                gender: genderCont,
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
