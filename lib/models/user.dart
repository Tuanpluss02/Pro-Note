// ignore_for_file: unnecessary_getters_setters

class UserInformation {
  String? _profilePicture;
  String? _userId;
  String? _email;
  String? _displayName;

  UserInformation(
      {String? profilePicture,
      String? userId,
      String? email,
      String? displayName}) {
    if (profilePicture != null) {
      _profilePicture = profilePicture;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (email != null) {
      _email = email;
    }
    if (displayName != null) {
      _displayName = displayName;
    }
  }

  String? get profilePicture => _profilePicture;
  String? get userId => _userId;
  String? get email => _email;
  String? get displayName => _displayName;

  set profilePicture(String? profilePicture) =>
      _profilePicture = profilePicture;
  set userId(String? userId) => _userId = userId;
  set email(String? email) => _email = email;
  set displayName(String? displayName) => _displayName = displayName;

  UserInformation.fromJson(Map<String, dynamic> json) {
    _profilePicture = json['profilePicture'];
    _userId = json['userId'];
    _email = json['email'];
    _displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profilePicture'] = _profilePicture;
    data['userId'] = _userId;
    data['email'] = _email;
    data['displayName'] = _displayName;
    return data;
  }
}
