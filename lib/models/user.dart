// ignore_for_file: unnecessary_getters_setters

class UserInformation {
  String? _profilePicture;
  String? _userId;
  String? _email;
  String? _username;

  UserInformation(
      {String? profilePicture,
      String? userId,
      String? email,
      String? username}) {
    if (profilePicture != null) {
      _profilePicture = profilePicture;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (email != null) {
      _email = email;
    }
    if (username != null) {
      _username = username;
    }
  }

  String? get profilePicture => _profilePicture;

  String? get userImage => _profilePicture;
  String? get userId => _userId;
  String? get email => _email;
  String? get username => _username;

  set profilePicture(String? profilePicture) =>
      _profilePicture = profilePicture;
  set userId(String? userId) => _userId = userId;

  set email(String? email) => _email = email;
  set username(String? username) => _username = username;

  UserInformation.fromJson(Map<String, dynamic> json) {
    _profilePicture = json['profilePicture'];
    _userId = json['userId'];
    _email = json['email'];
    _username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profilePicture'] = _profilePicture;
    data['userId'] = _userId;
    data['email'] = _email;
    data['username'] = _username;
    return data;
  }
}
