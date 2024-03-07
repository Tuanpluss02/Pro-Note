import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user.dart';

class UserRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> createUser({required String uid, required String email}) async {
    await _fireStore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      "profilePicture":
          "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
      "createdAt": DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  Future<UserInformation> getUser({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> data =
        await _fireStore.collection('users').doc(uid).get();
    UserInformation userInformation = UserInformation.fromJson(data.data()!);
    return userInformation;
  }

  Future<void> updateUser({required UserInformation userInformation}) async {
    await _fireStore.collection('users').doc(userInformation.uid).update({
      'displayName': userInformation.displayName,
      'profilePicture': userInformation.profilePicture,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteUser({required String uid}) async {
    await _fireStore.collection('users').doc(uid).delete();
  }

  Future<void> terminateFirestore() async {
    await _fireStore.terminate();
  }
}
