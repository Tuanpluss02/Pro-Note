// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:pro_note/services/auth_method.dart';
import 'package:pro_note/styles/app_style.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  var _oldPassword;
  var _newPassword;

  Future<void> _changePassword() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    await AuthClass().changePassword(_oldPassword, _newPassword, context);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController pass = TextEditingController();
    final TextEditingController confirmPass = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
        title: const Text('Pro Notes'),
      ),
      body: Center(
          child: Card(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter old password';
                          }
                          // if (!passwordValidator(value!)) {
                          //   return 'Password must be at least 8 characters, contain at least one uppercase letter, one lowercase letter and one number';
                          // }
                          if (!AuthClass().oldPasswordValidator(value!)) {
                            return 'Old password is incorrect';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          setState(() {
                            _oldPassword = newValue!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Old Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixIcon: const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: pass,
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter new password';
                          }
                          // if (!passwordValidator(value)) {
                          //   return 'Password must be at least 8 characters, contain at least one uppercase letter, one lowercase letter and one number';
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            _newPassword = val!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'New Password',
                            suffixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: confirmPass,
                        obscureText: true,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please re-enter new password';
                          }
                          // if (!passwordValidator(value)) {
                          //   return 'Password must be at least 8 characters, contain at least one uppercase letter, one lowercase letter and one number';
                          // }
                          if (value != pass.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Re-enter Password',
                            suffixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text('Change Password'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )),
            )),
      )),
    );
  }
}
