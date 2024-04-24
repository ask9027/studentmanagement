import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentmanagement/extensions.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../widgets.dart';

class AddUpdateStudent extends StatefulWidget {
  const AddUpdateStudent({super.key, this.isAdd, this.student, this.className});
  final bool? isAdd;
  final Student? student;
  final String? className;

  @override
  State<AddUpdateStudent> createState() => _AddUpdateStudentState();
}

class _AddUpdateStudentState extends State<AddUpdateStudent> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController fNameCont = TextEditingController();
  final TextEditingController rollNCont = TextEditingController();
  bool isBtnEnable = false;

  @override
  void initState() {
    if (!widget.isAdd!) {
      nameCont.text = widget.student!.name;
      fNameCont.text = widget.student!.fatherName;
      rollNCont.text = widget.student!.rollNumber;
    }
    super.initState();
  }

  checkFields() {
    setState(() {
      if (nameCont.text.toString().isNotEmpty &&
          fNameCont.text.toString().isNotEmpty &&
          rollNCont.text.toString().isNotEmpty) {
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
    rollNCont.dispose();
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
            TextFormField(
              controller: rollNCont,
              decoration: const InputDecoration(
                hintText: "Enter Roll Number",
                label: Text("Roll Number"),
              ),
              onChanged: (value) => checkFields(),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                className: widget.className!,
                                rollNumber: rollNCont.text,
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
                                className: widget.className!,
                                rollNumber: rollNCont.text,
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
