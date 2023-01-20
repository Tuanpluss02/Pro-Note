// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pro_note/models/user.dart';

// class TestPage extends StatelessWidget {
//   const TestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: 'tuan@gmail.com',
//       password: 'Tuan2002',
//     );

//     User? currentUser = FirebaseAuth.instance.currentUser;

//     final docRef = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUser!.uid)
//         .collection('UserInformation')
//         .doc(currentUser.uid);
//     docRef.get().then((DocumentSnapshot doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       user = UserInformation.fromJson(data);
//       print(user.email);
//     });

//     return Container();
//   }
// }
