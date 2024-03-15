class UserInformation {
  final String uid;
  final String email;
  final String displayName;
  final String profilePicture;

  UserInformation({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profilePicture =
        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
    };
  }
}
