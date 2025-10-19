import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withValues(alpha: 0.95),
              scheme.primary.withValues(alpha: 0.85),
              scheme.primary.withValues(alpha: 0.75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "UNN",
                            style: AppFont.titleMedium.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "UNN e-Clearance System",
                          style: AppFont.titleMedium.copyWith(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Welcome back to your clearance portal",
                          style: AppFont.bodySmall.copyWith(
                            color: scheme.onPrimary.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildValidatedField(
                            controller: controller.idCtrl,
                            icon: Icons.person_outline,
                            hint: 'Matric Number or Email',
                            errorTextRx: controller.idError,
                            scheme: scheme,
                          ),
                          const SizedBox(height: 18),

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
                                  color: scheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  size: 20,
                                ),
                              ),
                              scheme: scheme,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.primary,
                                foregroundColor: scheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: AppFont.bodySmall.copyWith(
                                color: scheme.onPrimary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    Text(
                      "Powered by Toochi Natasha 2025",
                      style: AppFont.caption.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    required ColorScheme scheme,
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
              prefixIcon: Icon(
                icon,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: AppFont.bodySmall.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
              filled: true, // keep inputs readable over gradient
              fillColor: scheme.surface.withValues(alpha: 0.95),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: errorTextRx.value == null
                      ? scheme.primary
                      : scheme.error,
                  width: 1.3,
                ),
              ),
            ),
          ),
          if (errorTextRx.value != null) ...[
            const SizedBox(height: 4),
            Text(
              errorTextRx.value!,
              style: TextStyle(color: scheme.error, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
