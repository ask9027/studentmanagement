// Student Fields and Model
const studentTable = "students";

class StudentFields {
  static final List<String> values = [
    id,
    name,
    fatherName,
    className,
    rollNumber,
  ];

  static const String id = "_id";
  static const String name = "name";
  static const String fatherName = "fatherName";
  static const String className = "className";
  static const String rollNumber = "rollNumber";
}

class Student {
  final int? id;
  final String name;
  final String fatherName;
  final String className;
  final String rollNumber;

  const Student({
    this.id,
    required this.name,
    required this.fatherName,
    required this.className,
    required this.rollNumber,
  });

  Student copy({
    int? id,
    String? name,
    String? fatherName,
    String? className,
    String? rollNumber,
  }) =>
      Student(
        id: id ?? this.id,
        name: name ?? this.name,
        fatherName: fatherName ?? this.fatherName,
        className: className ?? this.className,
        rollNumber: rollNumber ?? this.rollNumber,
      );

  static Student fromJson(Map<String, Object?> json) => Student(
        id: json[StudentFields.id] as int?,
        name: json[StudentFields.name] as String,
        fatherName: json[StudentFields.fatherName] as String,
        className: json[StudentFields.className] as String,
        rollNumber: json[StudentFields.rollNumber] as String,
      );

  Map<String, Object?> toJson() => {
        StudentFields.id: id,
        StudentFields.name: name,
        StudentFields.fatherName: fatherName,
        StudentFields.className: className,
        StudentFields.rollNumber: rollNumber,
      };
}

// Class Fields and Model

const classTable = "classTable";

class ClassFields {
  static final List<String> value = [
    id,
    className,
    classTeacher,
    isSetup,
  ];

  static const String id = "_id";
  static const String className = "className";
  static const String classTeacher = "classTeacher";
  static const String isSetup = "isSetup";
}

class ClassModel {
  final int? id;
  final String className;
  final String classTeacher;
  final String isSetup;

  const ClassModel({
    this.id,
    required this.className,
    required this.classTeacher,
    required this.isSetup,
  });

  ClassModel copy({
    int? id,
    String? className,
    String? classTeacher,
    String? isSetup,
  }) =>
      ClassModel(
        id: id ?? this.id,
        className: className ?? this.className,
        classTeacher: classTeacher ?? this.classTeacher,
        isSetup: isSetup ?? this.isSetup,
      );

  static ClassModel fromJson(Map<String, Object?> json) => ClassModel(
        id: json[ClassFields.id] as int?,
        className: json[ClassFields.className] as String,
        classTeacher: json[ClassFields.classTeacher] as String,
        isSetup: json[ClassFields.isSetup] as String,
      );

  Map<String, Object?> toJson() => {
        ClassFields.id: id,
        ClassFields.className: className,
        ClassFields.classTeacher: classTeacher,
        ClassFields.isSetup: isSetup,
      };
}
