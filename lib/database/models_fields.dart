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
