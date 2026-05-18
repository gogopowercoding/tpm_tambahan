import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import '../../data/services/notification_service.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('registered_username') ?? '';
    final savedPassword = prefs.getString('registered_password') ?? '';

    final inputUsername = usernameController.text.trim();
    final inputPassword = passwordController.text.trim();

    if (inputUsername == savedUsername && inputPassword == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', inputUsername);

      isLoading.value = false;
      await NotificationService.showLoginNotification(inputUsername);
      Get.offAllNamed(Routes.HOME, arguments: {'username': inputUsername});
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Login Gagal',
        'Username atau password salah!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
