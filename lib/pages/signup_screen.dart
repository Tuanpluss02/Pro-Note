import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_note/models/user.dart';
import 'package:pro_note/pages/home_page.dart';
import 'package:pro_note/services/auth_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // ignore: prefer_final_fields
  UserInformation _user = UserInformation(
      userId: '', email: '', profilePicture: '', displayName: '');
  String password = '';
  final String _confirmPassword = '';
  var isLoading = false;
  File? _image;
  final _formKey = GlobalKey<FormState>();

  void takePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> signUp(BuildContext context, VoidCallback onSuccess) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_image == null) {
      return;
    }
    if (password != _confirmPassword) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _user.email!,
      password: password,
    );

    _user.userId = userCredential.user!.uid;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${userCredential.user!.uid}.jpg');

    UploadTask uploadTask = ref.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => null);
    _user.profilePicture = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user!.uid)
        .collection('UserInformation')
        .doc(userCredential.user!.uid)
        .set({
      'userId': _user.userId,
      'displayName': _user.displayName,
      'email': _user.email,
      'profilePicture': _user.profilePicture,
    });
    prefs.setBool('SignedIn', true);
    // await saveDataToLocal(_user);
    // await markUserSignedIn();
    onSuccess.call();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController pass = TextEditingController();
    final TextEditingController confirmPass = TextEditingController();
    return Scaffold(
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
                      CircleAvatar(
                        backgroundImage:
                            _image == null ? null : FileImage(_image!),
                        radius: 60,
                      ),
                      TextButton.icon(
                        onPressed: takePicture,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take a picture'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter display name';
                          }
                          return null;
                        },
                        onSaved: (p) {
                          setState(() {
                            _user.displayName = p!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Display Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixIcon: const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!AuthClass().emailValidator(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            _user.email = val!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            suffixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: pass,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (AuthClass().passwordValidator(value)) {
                            return 'Password must be at least 6 characters, at least one letter and one number';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            password = val!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPass,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please re-enter your password';
                          }
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
                      isLoading
                          ? const CircularProgressIndicator()
                          : Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ElevatedButton(
                                onPressed: () => signUp(context, () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage()),
                                      (route) => false);
                                }),
                                child: const Text('Sign Up'),
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
