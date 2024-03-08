import 'package:note_me/src/features/authentication/data/auth_repository.dart';
import 'package:note_me/src/features/authentication/data/model/user.dart';

import '../data/user_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  Future<UserInformation> createAccount(
      {required String email, required String password}) async {
    final userUid =
        await _authRepository.createAccount(email: email, password: password);
    await _userRepository.createUser(uid: userUid, email: email);
    final user = await _userRepository.getUser(uid: userUid);
    return user;
  }

  Future<UserInformation> signIn(
      {required String email, required String password}) async {
    final userUid =
        await _authRepository.signIn(email: email, password: password);
    final user = await _userRepository.getUser(uid: userUid);
    return user;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await _userRepository.terminateFirestore();
  }
}
