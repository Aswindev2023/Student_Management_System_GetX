import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:students_getx/getX_services/home_getx.dart';
import 'package:students_getx/getX_services/student_controller.dart';
import 'package:students_getx/getX_services/user_image_getx.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<StudentController>(StudentController());
  Get.put<UserImageGetx>(UserImageGetx());
  Get.put<HomeGetx>(HomeGetx());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 251, 244, 43)),
      ),
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
