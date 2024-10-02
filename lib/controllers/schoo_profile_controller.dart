import 'package:get/get.dart';
import 'package:studentmanagement/database/databases.dart';
import 'package:studentmanagement/database/models.dart';

class SchooProfileController extends GetxController {
  late SchoolProfile schoolProfile;
  var isLoading = false.obs;
  var error = "".obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    await getSchoolProfile();
  }

  Future<void> getSchoolProfile() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(milliseconds: 300));
      await StudentDBHelper.instance.getSchoolProfile().then((data) {
        schoolProfile = data!;
      });
    } catch (e) {
      error("Error While loading profile data: $e");
    } finally {
      isLoading(false);
    }
  }
}
