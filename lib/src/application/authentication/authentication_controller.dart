import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  /// FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() {
    if (_auth.currentUser != null) {
      currentUser.value = _auth.currentUser;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      currentUser.value = userCredential.user;
    } catch (e) {
      Get.snackbar("Error", 'Sign up failed!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      currentUser.value = userCredential.user;
    } catch (e) {
      Get.snackbar("Error", 'Sign in failed!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
    } catch (e) {
      Get.snackbar("Error", 'Sign out failed!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
