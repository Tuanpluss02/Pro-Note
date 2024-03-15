import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_me/src/features/authentication/domain/auth_service.dart';
import 'package:note_me/src/routing/app_route.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();
  final AuthService authService = AuthService();

  var obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> submit() async {
    Get.snackbar("INFO", "Creating your account...",
        showProgressIndicator: true);
    try {
      if (formKey.currentState!.validate()) {
        final email = controllerEmail.text;
        final password = controllerPassword.text;
        final user =
            await authService.createAccount(email: email, password: password);
        Get.offAllNamed(Routes.HOME, arguments: {"user": user});
      }
    } catch (e) {
      Get.dialog(SimpleDialog(
        title: const Text('Error'),
        contentPadding: const EdgeInsets.all(20),
        children: [Text(e.toString())],
      ));
    }
  }

  @override
  void onClose() {
    controllerPassword.dispose();
    controllerEmail.dispose();
    controllerConfirmPassword.dispose();
    super.onClose();
  }
}
