class UserInformation {
  String userId;
  String username;
  String email;
  String? profilePicture;
  UserInformation({
    required this.userId,
    required this.username,
    required this.email,
    this.profilePicture,
  });

  static UserInformation fromJson(Map<String, dynamic> map) {
    return UserInformation(
      profilePicture: map['profilePicture'],
      email: map['email'],
      userId: map['userId'],
      username: map['username'],
    );
  }
}
