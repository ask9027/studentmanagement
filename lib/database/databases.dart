import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../database/models.dart';

class StudentDBHelper {
  static final StudentDBHelper instance = StudentDBHelper._init();
  static Database? _database;
  StudentDBHelper._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("student.db");
    return _database!;
  }

  Future<Database> _initDB(String dbPath) async {
    final path = join(await getDatabasesPath(), dbPath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY";
    const textType = "TEXT NOT NULL";
    await db.execute("""
CREATE TABLE $studentTable(
  ${StudentFields.id} $idType,
  ${StudentFields.name} $textType,
  ${StudentFields.fatherName} $textType,
  ${StudentFields.className} $textType,
  ${StudentFields.dob} $textType,
  ${StudentFields.penNumber} $textType,
  ${StudentFields.srNumber} $textType,
  ${StudentFields.gender} $textType
)
""");
    await db.execute("""
CREATE TABLE $classTable(
  ${ClassFields.id} $idType,
  ${ClassFields.className} $textType,
  ${ClassFields.classTeacher} $textType,
  ${ClassFields.isSetup} $textType
)
""");
  }

  Future<Student> addStudent(Student student) async {
    final db = await instance.database;
    final id = await db.insert(studentTable, student.toJson());
    return student.copy(id: id);
  }

  Future<ClassModel> addClassDetails(ClassModel classModel) async {
    final db = await instance.database;
    final id = await db.insert(classTable, classModel.toJson());
    return classModel.copy(id: id);
  }

  Future<List<Student>> getAllStudents(String gender, String name) async {
    final db = await instance.database;

    String orderBy = "";
    if (gender == Gender.girl) {
      orderBy +=
          "CASE ${StudentFields.gender} WHEN '${Gender.girl}' THEN 0 WHEN '${Gender.boy}' THEN 1 END, ";
    } else if (gender == Gender.boy) {
      orderBy +=
          "CASE ${StudentFields.gender} WHEN '${Gender.boy}' THEN 0 WHEN '${Gender.girl}' THEN 1 END, ";
    }

    if (name == StudentFields.name) {
      orderBy +=
          "${StudentFields.name}, ${StudentFields.fatherName} COLLATE NOCASE";
    } else if (name == StudentFields.fatherName) {
      orderBy +=
          "${StudentFields.fatherName}, ${StudentFields.name} COLLATE NOCASE";
    } else {
      orderBy +=
          "${StudentFields.name}, ${StudentFields.fatherName} COLLATE NOCASE";
    }

    final result = await db.query(studentTable, orderBy: orderBy);
    return result.map((json) => Student.fromJson(json)).toList();
  }

  Future<List<ClassModel>> getClass() async {
    final db = await instance.database;

    final result = await db.query(classTable);
    return result.map((json) => ClassModel.fromJson(json)).toList();
    // final result = await db.query(
    //   classTable,
    //   columns: ClassFields.value,
    //   where: "${ClassFields.id} = ?",
    //   whereArgs: [1],
    // );
    // if (result.isNotEmpty) {
    //   return ClassModel.fromJson(result.first);
    // } else {
    //   throw Exception("Student ID = 1 not found!");
    // }
  }

  Future<Student> getStudent(int id) async {
    final db = await instance.database;
    final result = await db.query(
      studentTable,
      columns: StudentFields.values,
      where: "${StudentFields.id} = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Student.fromJson(result.first);
    } else {
      throw Exception("Student ID = $id not found!");
    }
  }

  Future<int> updateClass(ClassModel classModel) async {
    final db = await instance.database;
    return db.update(
      classTable,
      classModel.toJson(),
      where: "${ClassFields.id} = ?",
      whereArgs: [classModel.id],
    );
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return db.update(
      studentTable,
      student.toJson(),
      where: "${StudentFields.id} = ?",
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return db.delete(
      studentTable,
      where: "${StudentFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
