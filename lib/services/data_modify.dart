import 'package:pro_note/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveDataToLocal(UserInformation user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', user.userId ?? '123456789');
  await prefs.setString('email', user.email ?? 'user@pronote.com');
  await prefs.setString('displayName', user.displayName ?? 'Pro Note User');
  await prefs.setString(
      'profilePicture',
      user.profilePicture ??
          'https://firebasestorage.googleapis.com/v0/b/flutter-to-do-application.appspot.com/o/defaultAvatar.jpg?alt=media&token=e1f98d07-d5e9-481c-8873-8aac1b7ee4f0');
}

Future<UserInformation> getLocalData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final email = prefs.getString('email');
  final displayName = prefs.getString('displayName');
  final profilePicture = prefs.getString('profilePicture');
  return UserInformation(
      userId: userId,
      email: email,
      displayName: displayName,
      profilePicture: profilePicture);
}

Future<void> clearLocalData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<void> markUserSignedIn() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('SignedIn', true);
}
