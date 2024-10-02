// Student Fields and Model
const studentTable = "students";

class StudentFields {
  static const String id = "_id";
  static const String name = "name";
  static const String fatherName = "fatherName";
  //static const String className = "className";
  //static const String dob = "dob";
  //static const String penNumber = "penNumber";
  //static const String srNumber = "srNumber";
  static const String gender = "gender";
  static final List<String> values = [
    id,
    name,
    fatherName,
    // className,
    // dob,
    // penNumber,
    // srNumber,
    gender,
  ];
}

class Gender {
  static const String boy = 'boy';
  static const String girl = 'girl';
  static final List<String> values = [
    boy,
    girl,
  ];
}

// class Classess {
//   static const String selectClass = 'Select Class';
//   static const String first = '1st';
//   static const String second = '2nd';
//   static const String third = '3rd';
//   static const String fourth = '4th';
//   static const String fifth = '5th';
//   static const String sixth = '6th';
//   static const String seventh = '7th';
//   static const String eighth = '8th';
//   static const String ninth = '9th';
//   static const String tenth = '10th';
//   static const String eleventh = '11th';
//   static const String twelfth = '12th';
//   static final List<String> values = [
//     selectClass,
//     first,
//     second,
//     third,
//     fourth,
//     fifth,
//     sixth,
//     seventh,
//     eighth,
//     ninth,
//     tenth,
//     eleventh,
//     twelfth,
//   ];
// }

class Student {
  final int? id;
  final String name;
  final String fatherName;
  // final String className;
  // final String dob;
  // final String penNumber;
  // final String srNumber;
  final String gender;

  const Student({
    this.id,
    required this.name,
    required this.fatherName,
    // required this.className,
    // required this.dob,
    // required this.penNumber,
    // required this.srNumber,
    required this.gender,
  });

  Student copy({
    int? id,
    String? name,
    String? fatherName,
    // String? className,
    // String? dob,
    // String? penNumber,
    // String? srNumber,
    String? gender,
  }) =>
      Student(
        id: id ?? this.id,
        name: name ?? this.name,
        fatherName: fatherName ?? this.fatherName,
        // className: className ?? this.className,
        // dob: dob ?? this.dob,
        // penNumber: penNumber ?? this.penNumber,
        // srNumber: srNumber ?? this.srNumber,
        gender: gender ?? this.gender,
      );

  static Student fromJson(Map<String, Object?> json) => Student(
        id: json[StudentFields.id] as int?,
        name: json[StudentFields.name] as String,
        fatherName: json[StudentFields.fatherName] as String,
        // className: json[StudentFields.className] as String,
        // dob: json[StudentFields.dob] as String,
        // penNumber: json[StudentFields.penNumber] as String,
        // srNumber: json[StudentFields.srNumber] as String,
        gender: json[StudentFields.gender] as String,
      );

  Map<String, Object?> toJson() => {
        StudentFields.id: id,
        StudentFields.name: name,
        StudentFields.fatherName: fatherName,
        // StudentFields.className: className,
        // StudentFields.dob: dob,
        // StudentFields.penNumber: penNumber,
        // StudentFields.srNumber: srNumber,
        StudentFields.gender: gender,
      };
}

// Academic Session Model
const academicSessionTable = "academicSessionTable";

class AcademicSessionFields {
  static const String id = "_id";
  static const String name = "name";
  static const String isCurrent = "isCurrent";
  static final List<String> values = [
    id,
    name,
    isCurrent,
  ];
}

class AcademicSession {
  final int? id;
  final String name; // e.g., "2014-2015"
  final bool isCurrent;

  const AcademicSession({
    this.id,
    required this.name,
    this.isCurrent = false,
  });
  AcademicSession copy({
    int? id,
    String? name,
    bool? isCurrent,
  }) =>
      AcademicSession(
        id: id ?? this.id,
        name: name ?? this.name,
        isCurrent: isCurrent ?? this.isCurrent,
      );

  static AcademicSession fromJson(Map<String, Object?> json) => AcademicSession(
        id: json[AcademicSessionFields.id] as int?,
        name: json[AcademicSessionFields.name] as String,
        isCurrent: json[AcademicSessionFields.isCurrent] as bool,
      );

  Map<String, Object?> toJson() => {
        AcademicSessionFields.id: id,
        AcademicSessionFields.name: name,
        AcademicSessionFields.isCurrent: isCurrent,
      };
}

// School Profile Model
const schoolProfileTable = "schoolProfileTable";

class SchoolProfileFields {
  static const String id = "_id";
  static const String schoolName = "schoolName";
  static const String address = "address";
  static const String contactNumber = "contactNumber";
  static const String schoolRecognition = "schoolRecognition";
  static final List<String> values = [
    id,
    schoolName,
    address,
    contactNumber,
    schoolRecognition,
  ];
}

class SchoolProfile {
  final int? id;
  final String schoolName;
  final String address;
  final String contactNumber;
  final String schoolRecognition;

  const SchoolProfile({
    this.id,
    required this.schoolName,
    required this.address,
    required this.contactNumber,
    required this.schoolRecognition,
  });

  SchoolProfile copy({
    int? id,
    String? schoolName,
    String? address,
    String? contactNumber,
    String? schoolRecognition,
  }) =>
      SchoolProfile(
        id: id ?? this.id,
        schoolName: schoolName ?? this.schoolName,
        address: address ?? this.address,
        contactNumber: contactNumber ?? this.contactNumber,
        schoolRecognition: schoolRecognition ?? this.schoolRecognition,
      );

  static SchoolProfile fromJson(Map<String, Object?> json) => SchoolProfile(
        id: json[SchoolProfileFields.id] as int?,
        schoolName: json[SchoolProfileFields.schoolName] as String,
        address: json[SchoolProfileFields.address] as String,
        contactNumber: json[SchoolProfileFields.contactNumber] as String,
        schoolRecognition:
            json[SchoolProfileFields.schoolRecognition] as String,
      );

  Map<String, Object?> toJson() => {
        SchoolProfileFields.id: id,
        SchoolProfileFields.schoolName: schoolName,
        SchoolProfileFields.address: address,
        SchoolProfileFields.contactNumber: contactNumber,
        SchoolProfileFields.schoolRecognition: schoolRecognition,
      };
}

// Class Fields and Model

const classTable = "classTable";

class ClassFields {
  static final List<String> values = [
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
