import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ucs/core/constants/app_font.dart';
import 'package:ucs/features/auth/controllers/auth_controller.dart';
import 'package:ucs/data/services/settings_service.dart';
import 'package:ucs/data/models/settings.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header
                      Column(
                        children: [
                          FutureBuilder<Settings?>(
                            future: SettingsService().getSettings(),
                            builder: (context, snapshot) {
                              final logoUrl = (snapshot.data?.logoUrl ?? '')
                                  .trim();
                              return Container(
                                width: 112,
                                height: 112,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      scheme.primaryContainer.withOpacity(0.9),
                                      scheme.primaryContainer.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: scheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: logoUrl.isNotEmpty
                                      ? Image.network(
                                          logoUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.school_rounded,
                                            size: 48,
                                            color: scheme.onPrimaryContainer,
                                          ),
                                        )
                                      : Icon(
                                          Icons.school_rounded,
                                          size: 48,
                                          color: scheme.onPrimaryContainer,
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "UNN e-Clearance System",
                            style: AppFont.titleMedium.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Welcome back to your clearance portal",
                            style: AppFont.bodySmall.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Form
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
                                    color: scheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                                scheme: scheme,
                              ),
                            ),

                            const SizedBox(height: 20),

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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: controller.isLoading.value
                                    ? SpinKitChasingDots(
                                        color: scheme.onPrimary,
                                        size: 20,
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Footer
                      Text(
                        "Powered by Toochi Natasha 2025",
                        style: AppFont.caption.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
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
              prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: AppFont.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              filled: true,
              fillColor: Theme.of(Get.context!).colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: scheme.outlineVariant),
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
