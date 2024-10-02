import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement/utils/routes.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.1;
    double cardWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    RouteName.schoolProfile,
                    arguments: {
                      "title": "School Profile",
                    },
                  ),
                  child: const Center(
                    child: Text(
                      "School Profile",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    RouteName.staffManageent,
                    arguments: {
                      "title": "Staff Management",
                    },
                  ),
                  child: const Center(
                    child: Text(
                      "Staff Management",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    RouteName.studentsPage,
                    arguments: {
                      "title": "Student Management",
                    },
                  ),
                  child: const Center(
                    child: Text(
                      "Student Management",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(
                    RouteName.resultPage,
                    arguments: {
                      "title": "Results",
                    },
                  ),
                  child: const Center(
                    child: Text(
                      "Results",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
