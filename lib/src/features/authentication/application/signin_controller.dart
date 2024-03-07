import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_me/src/features/authentication/domain/auth_service.dart';

class SigninScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey();
  final FocusNode focusNodePassword = FocusNode();
  final AuthService authService = AuthService();
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  var obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> submit() async {
    Get.snackbar("INFO", "Signing you in...", showProgressIndicator: true);
    if (formKey.currentState!.validate()) {
      final email = controllerUsername.text;
      final password = controllerPassword.text;
      final data = await authService.signIn(email: email, password: password);
      if (data is String) {
        Get.dialog(SimpleDialog(
          title: const Text('Error'),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(data)],
        ));
      } else {
        Get.offAllNamed('/home');
      }
    }
  }
}
