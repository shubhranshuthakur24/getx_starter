import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_starter/domain/usecases/register_usecase.dart';
import 'package:getx_starter/routes/app_routes.dart';

class RegisterController extends GetxController {
  final RegisterUseCase registerUseCase;

  RegisterController(this.registerUseCase);

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable state
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> register() async {
    errorMessage.value = '';

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await registerUseCase(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    result.fold((failure) => errorMessage.value = failure.message, (user) {
      Get.snackbar(
        'Account created!',
        'Welcome, ${user.email ?? 'new user'}',
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

  // ── Validators ──────────────────────────────────────────────────────────

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }
}
