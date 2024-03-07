import 'package:note_me/src/features/authentication/data/auth_repository.dart';

import '../data/user_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  Future<dynamic> createAccount(
      {required String email, required String password}) async {
    final data =
        await _authRepository.createAccount(email: email, password: password);
    if (data is String) {
      return data;
    }
    await _userRepository.createUser(uid: data.user!.uid, email: email);
    return data;
  }

  Future<dynamic> signIn(
      {required String email, required String password}) async {
    final data = await _authRepository.signIn(email: email, password: password);
    if (data is String) {
      return data;
    }
    return data;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await _userRepository.terminateFirestore();
  }
}
