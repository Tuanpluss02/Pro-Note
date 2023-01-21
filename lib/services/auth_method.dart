// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/services/data_modify.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await _auth.signOut();
      await prefs.clear();
      const snackBar = SnackBar(content: Text('Signed out successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool emailValidator(String email) {
    RegExp exp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return exp.hasMatch(email);
  }

  bool passwordValidator(String password) {
    RegExp exp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    return exp.hasMatch(password);
  }

  bool oldPasswordValidator(String oldPassword) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final credential = EmailAuthProvider.credential(
        email: currentUser.email!, password: oldPassword);
    try {
      currentUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return false;
      }
    }
    return true;
  }

  changeDisplayName(String displayName, BuildContext context) async {
    final currentUser = await getLocalData();
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.userId)
          .collection('UserInformation')
          .doc(currentUser.userId)
          .set({
        'displayName': displayName,
      }, SetOptions(merge: true)).then((p) {
        currentUser.displayName = displayName;
        saveDataToLocal(currentUser);
      });
    } on FirebaseAuthException {
      showSnackBar(context, 'Failed to change display name');
    }
    showSnackBar(context, 'Display name changed successfully');
  }

  Future<void> changePassword(
      String newPassword, String currentPassword, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        showSnackBar(context, 'Password changed successfully');
      }).catchError((error) {
        showSnackBar(context, 'Failed to change password');
      });
    }).catchError((err) {
      showSnackBar(context, err.toString());
    });
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
