import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro_note/models/user.dart';
import 'package:pro_note/pages/home_page.dart';
import 'package:pro_note/pages/signin_creen.dart';
import 'package:pro_note/services/data_modify.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentScreen = const SignIn();
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isSigned = prefs.getBool('SignedIn');
    if (isSigned == true) {
      UserInformation user = await getLocalData();
      setState(() {
        currentScreen = MyHomePage(user: user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // to hide only bottom bar:
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);

    // to hide only status bar:
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);

    // to hide both:
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const (),
      home: currentScreen,
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MaterialApp(home: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Flutter"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     content: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Positioned(
//                           right: -40.0,
//                           top: -40.0,
//                           child: InkResponse(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const CircleAvatar(
//                               backgroundColor: Colors.red,
//                               child: Icon(Icons.close),
//                             ),
//                           ),
//                         ),
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextFormField(),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: TextFormField(),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: ElevatedButton(
//                                   child: const Text("Submitß"),
//                                   onPressed: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       _formKey.currentState!.save();
//                                     }
//                                   },
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 });
//           },
//           child: const Text("Open Popup"),
//         ),
//       ),
//     );
//   }
// }
