import '../constants/string_constants.dart';

String? validateUsername(String? username) {
  if (username!.trim().isEmpty) {
    return kEmptyUserName;
  } else if (username.length < 3) {
    return kValidateUserName;
  }
  return null;
}

String? validateEmail(String? email) {
  var emailValid = kEmailRegex;
  if (email!.trim().isEmpty) {
    return kEmptyEmail;
  } else if (!RegExp(emailValid).hasMatch(email)) {
    return kValidateEmail;
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password!.trim().isEmpty) {
    return kEmptyPassword;
  } else if (password.length < 6) {
    return kValidatePassword;
  }
  return null;
}
