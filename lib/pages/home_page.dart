import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_note/models/note_card.dart';
import 'package:pro_note/models/user.dart';
import 'package:pro_note/pages/change_password.dart';
import 'package:pro_note/pages/edit_note.dart';
import 'package:pro_note/pages/signin_creen.dart';
import 'package:pro_note/services/auth_method.dart';
import 'package:pro_note/styles/app_style.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> noteStream;
  final _formKey = GlobalKey<FormState>();
  var currentUser = FirebaseAuth.instance.currentUser;
  UserInformation _user = UserInformation();
  void popNavi() {
    Navigator.of(context).pop();
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('UserInformation')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        _user = UserInformation.fromJson(data);
      });
    }, onError: (e) {
      var snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      noteStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('UserNotes')
          .snapshots();
    });
  }

  void _changeDisplayName(BuildContext context) async {
    late String displayName;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Enter your new display name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a display name";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            displayName = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Change Display Name"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              AuthClass()
                                  .changeDisplayName(displayName, context);
                              _user.displayName = displayName;
                            }
                            popNavi();
                            // popNavi;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void changePicture() async {
    var user = await AuthClass().changeDisplayPicture(context, _user);
    setState(() {
      _user = user;
    });
  }

  void changeEmail() {
    late String email;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Enter your new email"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Change Email"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              AuthClass().changeEmail(email, context);
                              _user.email = email;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    return Scaffold(
      primary: true,
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return TextButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            child: CircleAvatar(
                radius: 20,
                backgroundImage: _user.profilePicture == null
                    ? const NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/flutter-to-do-application.appspot.com/o/defaultAvatar.jpg?alt=media&token=e1f98d07-d5e9-481c-8873-8aac1b7ee4f0')
                    : NetworkImage(_user.profilePicture!)),
          );
        }),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
        title: const Text('Pro Notes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: noteStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((docs) => noteCard(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditNote(
                                        userId: _user.userId,
                                        docs: docs,
                                        isUpdate: true,
                                      ),
                                    ));
                              }, docs, context, _user.userId ?? '131243242343'))
                          .toList());
                }
                return const Center(child: Text('No data'));
              },
            ),
          )
        ],
      ),
      drawer: Container(
        padding: EdgeInsets.only(
            top: statusBarHeight +
                appBarHeight +
                1), //adding one pixel for appbar shadow
        // width: MediaQuery.of(context).size.width,
        child: Drawer(
            child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                color: AppStyle.mainColor.withOpacity(0.4),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _user.profilePicture == null
                          ? const NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/flutter-to-do-application.appspot.com/o/defaultAvatar.jpg?alt=media&token=e1f98d07-d5e9-481c-8873-8aac1b7ee4f0')
                          : NetworkImage(_user.profilePicture!),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _user.displayName ?? 'No name',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: AppStyle.mainColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(_user.email ?? 'user email'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Change picture'),
                onTap: () => changePicture(),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.abc),
                title: const Text('Change display name'),
                onTap: () => _changeDisplayName(context),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Change email'),
                onTap: () => changeEmail(),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('Change password'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  AuthClass().signOut(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const SignIn()));
                },
              )
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditNote(
                        userId: _user.userId ?? '12345',
                        isUpdate: false,
                      )));
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
