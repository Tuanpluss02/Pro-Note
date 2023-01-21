import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/models/user.dart';
import 'package:pro_note/pages/home_page.dart';
import 'package:pro_note/pages/signup_screen.dart';
import 'package:pro_note/services/auth_method.dart';
import 'package:pro_note/services/data_modify.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserInformation user;
  late String _email;
  late String _password;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void signIn(VoidCallback navigator) async {
    bool isSignInSuccess = false;
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _email,
            password: _password,
          )
          .then((value) => {
                // ignore: unnecessary_null_comparison
                if (value != null)
                  {
                    isSignInSuccess = true,
                  }
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('No user found for that email.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok'))
                  ],
                ));
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Wrong password provided for that user.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok'))
                  ],
                ));
      }
    }
    if (isSignInSuccess) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('UserInformation')
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          user = UserInformation.fromJson(data);
        });
        saveDataToLocal(user);
        markUserSignedIn();
      }, onError: (e) {
        var snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      navigator.call();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                            _email = val!;
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
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            _password = val!;
                          });
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: 'Password',
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
                                onPressed: () => signIn(() =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage(user: user)))),
                                child: const Text('Sign In'),
                              ),
                            ),
                      // const SizedBox(height: 20),
                      // // Row(
                      // //   children: [
                      // Container(
                      //   // width: MediaQuery.of(context).size.width / 2 - 30,
                      //   width: double.infinity,
                      //   height: 50,
                      //   decoration: const BoxDecoration(
                      //     border: Border(),
                      //   ),
                      //   child: ElevatedButton(
                      //     onPressed: () =>
                      //         AuthClass().signInWithGoogle(context),
                      //     child: const Text('Sign In with Google'),
                      //   ),
                      // ),
                      //     const SizedBox(width: 20),
                      //     Container(
                      //       width: MediaQuery.of(context).size.width / 2 - 20,
                      //       height: 50,
                      //       decoration: const BoxDecoration(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(10)),
                      //       ),
                      //       child: ElevatedButton(
                      //         onPressed: () {},
                      //         child: const Text('Sign In with Facebook'),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp())),
                          child: const Text(
                            'Don\'t have an account? Sign Up',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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
