import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/features/auth/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
