import 'package:get/get.dart';
import 'package:studentmanagement/pages/add_update.dart';
import 'package:studentmanagement/pages/dashboard.dart';
import 'package:studentmanagement/pages/school_profile.dart';
import 'package:studentmanagement/pages/splash_page.dart';
import 'package:studentmanagement/pages/staff_management.dart';
import 'package:studentmanagement/pages/students_page.dart';

class RouteName {
  static const String splashPage = "/";
  static const String dashboardPage = "/dashboard";
  static const String studentsPage = "/studentsPage";
  static const String addUpdatePage = "/addUpdatePage";
  static const String schoolProfile = "/schoolProfile";
  static const String staffManageent = "/staffManagement";
}

class Routes {
  static final routes = [
    GetPage(
      name: RouteName.splashPage,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: RouteName.dashboardPage,
      page: () => const Dashboard(),
    ),
    GetPage(
      name: RouteName.studentsPage,
      page: () => StudentsPage(),
    ),
    GetPage(
      name: RouteName.addUpdatePage,
      page: () => AddUpdateStudent(),
    ),
    GetPage(
      name: RouteName.schoolProfile,
      page: () => SchoolProfile(),
    ),
    GetPage(
      name: RouteName.staffManageent,
      page: () => StaffManagement(),
    ),
  ];
}
