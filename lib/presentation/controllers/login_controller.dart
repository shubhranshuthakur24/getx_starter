import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_starter/domain/usecases/login_usecase.dart';
import 'package:getx_starter/routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;

  LoginController(this.loginUseCase);

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable state
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    // Clear previous error
    errorMessage.value = '';

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await loginUseCase(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    result.fold((failure) => errorMessage.value = failure.message, (user) {
      Get.snackbar(
        'Welcome back!',
        user.email ?? 'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      Get.offAllNamed(AppRoutes.home);
    });
  }

  /// Validators
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value.trim())) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
