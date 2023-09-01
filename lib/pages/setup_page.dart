import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:student_list/extensions.dart';

import '../database/databases.dart';
import '../database/models.dart';
import '../widgets.dart';
import 'home_page.dart';

class Setup extends StatefulWidget {
  const Setup({Key? key, this.isAdd, this.classModel}) : super(key: key);
  final bool? isAdd;
  final ClassModel? classModel;
  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  SingleValueDropDownController classCont = SingleValueDropDownController(
    data: const DropDownValueModel(name: "Select Class", value: "Select Class"),
  );
  TextEditingController classTeachCont = TextEditingController();

  bool isBtnEnable = false;

  @override
  void initState() {
    if (!widget.isAdd!) {
      classCont = SingleValueDropDownController(
          data: DropDownValueModel(
              name: widget.classModel!.className.toString(),
              value: widget.classModel!.className.toString()));

      classTeachCont.text = widget.classModel!.classTeacher.toString();
    }
    super.initState();
  }

  checkFields() {
    setState(() {
      if (!classCont.dropDownValue!.name.contains("Select Class") &&
          classTeachCont.text.toString().isNotEmpty) {
        isBtnEnable = true;
      } else {
        isBtnEnable = false;
      }
    });
  }

  @override
  void dispose() {
    classCont.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropDownTextField(
              enableSearch: false,
              clearOption: false,
              controller: classCont,
              dropDownList: const [
                DropDownValueModel(name: "1st", value: '1st'),
                DropDownValueModel(name: "2nd", value: '2nd'),
                DropDownValueModel(name: "3rd", value: '3rd'),
                DropDownValueModel(name: "4th", value: '4th'),
                DropDownValueModel(name: "5th", value: '5th'),
                DropDownValueModel(name: "6th", value: '6th'),
                DropDownValueModel(name: "7th", value: '7th'),
                DropDownValueModel(name: "8th", value: '8th'),
                DropDownValueModel(name: "9th", value: '9th'),
                DropDownValueModel(name: "10th", value: '10th'),
				DropDownValueModel(name: "11th", value: '11th'),
				DropDownValueModel(name: "12th", value: '12th'),
              ],
              textFieldDecoration: const InputDecoration(
                label: Text("Class"),
              ),
              onChanged: (value) {
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
                                className: classCont.dropDownValue!.name,
                                classTeacher:
                                    classTeachCont.text.toTitleCase().trim(),
                                isSetup: "1",
                              ),
                            )
                            .onError(
                              (error, stackTrace) => showSnack(
                                context,
                                "$error Add",
                              ),
                            );

                        if (!mounted) return;
                        showSnack(context, "${classModel.className} Added.");

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        await StudentDBHelper.instance
                            .updateClass(
                              ClassModel(
                                id: widget.classModel!.id,
                                className:
                                    classCont.dropDownValue!.name.toString(),
                                classTeacher:
                                    classTeachCont.text.toTitleCase().trim(),
                                isSetup: widget.classModel!.isSetup.trim(),
                              ),
                            )
                            .onError(
                              (error, stackTrace) => showSnack(
                                context,
                                "$error Update",
                              ),
                            );
                        if (!mounted) return;
                        showSnack(context,
                            "${classCont.dropDownValue!.name} Updated.");

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
