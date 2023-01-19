import 'package:pro_note/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveDataToLocal(UserInformation user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', user.userId);
  await prefs.setString('email', user.email);
  await prefs.setString('username', user.username);
  await prefs.setString('profilePicture', user.profilePicture!);
}

Future<UserInformation> getLocalData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final email = prefs.getString('email');
  final username = prefs.getString('username');
  final profilePicture = prefs.getString('profilePicture');
  return UserInformation(
      userId: userId!,
      email: email!,
      username: username!,
      profilePicture: profilePicture!);
}

Future<void> clearLocalData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<void> markUserSignedIn() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('SignedIn', true);
}
