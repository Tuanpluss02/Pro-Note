bool emailValidator(String email) {
  RegExp exp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return exp.hasMatch(email);
}

bool passwordValidator(String password) {
  RegExp exp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
  return exp.hasMatch(password);
}
