class UserInformation {
  late String userId;
  late String username;
  late String email;
  late String password;
  late String? profilePicture;
  UserInformation({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    this.profilePicture,
  });
}
