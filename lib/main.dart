import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/main_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp mengaktifkan fitur GetX: state management,
    // route management (Get.to / Get.off / Get.back), dan dependency
    // management (Get.put / Get.find).
    return GetMaterialApp(
      title: 'TokoKamu',
      theme: AppTheme.light,
      // Menyembunyikan pita "DEBUG" di pojok kanan atas.
      // (Pita ini memang hanya muncul di mode debug.)
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
