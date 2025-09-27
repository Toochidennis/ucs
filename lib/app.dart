import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/routes/app_pages.dart';
import 'package:ucs/core/routes/app_routes.dart';
import 'package:ucs/core/theme/app_theme.dart';
import 'package:ucs/global/app_binding.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNN e-Clearance System',
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: AppTheme.light,
    );
  }
}
