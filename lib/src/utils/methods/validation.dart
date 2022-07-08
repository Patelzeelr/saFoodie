String? validateUsername(String? username) {
  if (username!.trim().isEmpty) {
    return 'Please enter username';
  } else if (username.length < 3) {
    return 'Username should be at least 3 character';
  }
  return null;
}

String? validateEmail(String? email) {
  var emailValid =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  if (email!.trim().isEmpty) {
    return 'Please enter email';
  } else if (!RegExp(emailValid).hasMatch(email)) {
    return 'Enter valid email';
  } else {
    return null;
  }
}

String? validatePassword(String? password) {
  if (password!.trim().isEmpty) {
    return 'Please enter password';
  } else if (password.length < 6) {
    return 'Password should be at least 6 character';
  }
  return null;
}

String? validateTitle(String? title) {
  if (title!.trim().isEmpty) {
    return 'Please enter title';
  } else if (title.length < 6) {
    return 'Title should be at least 8 character';
  }
  return null;
}

String? validateDescription(String? description) {
  if (description!.trim().isEmpty) {
    return 'Please enter description';
  } else if (description.length < 10) {
    return 'Description should be at lease 10 character';
  }
  return null;
}

String? validateTag(String? tag) {
  if (tag!.trim().isEmpty) {
    return 'Please enter tag';
  }
  return null;
}
