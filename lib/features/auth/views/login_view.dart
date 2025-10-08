import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final emailOrMatric = TextEditingController();
  final password = TextEditingController();
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 32),
                // Branding
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    FlutterLogo(size: 64),
                    SizedBox(height: 8),
                    Text(
                      'UNN e-Clearance System',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: emailOrMatric,
                  decoration: const InputDecoration(
                    labelText: 'Matric Number or Email Address',
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isBusy
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => isBusy = true);
                          try {
                            // For now we assume email login; later we’ll map matric->email or use DB lookup.
                            await auth.login(
                              emailOrMatric.text.trim(),
                              password.text.trim(),
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Login failed',
                              e.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } finally {
                            setState(() => isBusy = false);
                          }
                        },
                  child: Text(isBusy ? 'Signing in...' : 'Login'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Powered by SwiftJob',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
