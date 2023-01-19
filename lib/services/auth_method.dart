import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Future<void> googleSignIn(BuildContext context) async {
  //   try {
  //     // GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  //     final prefs = await SharedPreferences.getInstance();
  //     GoogleSignInAccount googleSignInAccount =
  //         await _googleSignIn.signIn() as GoogleSignInAccount;
  //     GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //   UserInformation user = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(userCredential.user!.uid)
  //       .collection('UserInformation')
  //       .doc(userCredential.user!.uid)
  //       .get() as UserInformation;
  //   FirebaseAuth.instance.currentUser as UserInformation;
  //   // storeTokenAndData(userCredential);
  //   await prefs.setBool('SignedIn', true);
  //   await prefs.setString('userId', userCredential.user!.uid);
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (builder) => MyHomePage(user: user)),
  //       (route) => false);

  //   const snackBar = SnackBar(content: Text("Signed in successfully"));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // } catch (e) {
  //   // print("here---->");
  //   final snackBar = SnackBar(content: Text(e.toString()));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
  // // }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  // Once signed in, return the UserCredential
  // UserCredential userCredential =
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  // UserInformation user = FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(userCredential.user!.uid)
  //     .collection('UserInformation')
  //     .doc(userCredential.user!.uid)
  //     .get() as UserInformation;
  // FirebaseAuth.instance.currentUser as UserInformation;
  // // storeTokenAndData(userCredential);
  // await prefs.setBool('SignedIn', true);
  // await prefs.setString('userId', userCredential.user!.uid);
  // Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (builder) => MyHomePage(user: user)),
  //     (route) => false);

  //     const snackBar = SnackBar(content: Text("Signed in successfully"));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } catch (e) {
  //     // print("here---->");
  //     final snackBar = SnackBar(content: Text(e.toString()));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  Future<void> signOut({BuildContext? context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await _googleSignIn.signOut();
      await _auth.signOut();
      await prefs.clear();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
  }

  // void storeTokenAndData(UserCredential userCredential) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("token", userCredential.user!.uid);
  //   await prefs.setString("email", userCredential.user!.email!);
  //   await prefs.setString("name", userCredential.user!.displayName!);
  //   await prefs.setString("photoUrl", userCredential.user!.photoURL!);
  // }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
