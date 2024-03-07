class UserInformation {
  final String uid;
  final String email;
  final String displayName;
  final String profilePicture;

  UserInformation({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.profilePicture,
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
