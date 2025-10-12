import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_color.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(AppColor.primary),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "UNN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "UNN e-Clearance System",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Welcome back to your clearance portal",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      _buildValidatedField(
                        controller: controller.idCtrl,
                        icon: Icons.person_outline,
                        hint: 'Matric Number or Email',
                        errorTextRx: controller.idError,
                      ),
                      const SizedBox(height: 16),

                      Obx(
                        () => _buildValidatedField(
                          controller: controller.passwordCtrl,
                          icon: Icons.lock_outline,
                          hint: 'Password',
                          errorTextRx: controller.passwordError,
                          obscureText: controller.hidePassword.value,
                          suffixIcon: IconButton(
                            onPressed: controller.togglePassword,
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(AppColor.primary),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              disabledBackgroundColor: const Color(
                                AppColor.primary,
                              ).withValues(alpha: 0.5),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(AppColor.primary),
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Powered by Toochi Natasha 2025",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required RxnString errorTextRx,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: errorTextRx.value == null
                      ? const Color(AppColor.primary)
                      : Colors.red,
                  width: 1.5,
                ),
              ),
              errorText: errorTextRx.value,
              errorStyle: const TextStyle(
                fontSize: 11,
                color: Colors.red,
                height: 0.9,
              ),
            ),
          ),
          if (errorTextRx.value != null) ...[
            const SizedBox(height: 4),
            Text(
              errorTextRx.value!,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
