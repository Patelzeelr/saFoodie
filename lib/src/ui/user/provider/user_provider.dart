import 'package:flutter/material.dart';

import '../../../api/auth/auth_api.dart';
import '../model/get_all_users_model.dart';
import '../model/user_model.dart';

class UserProvider with ChangeNotifier {
  GetAllUsersModel? user;
  UserModel? oneUser;

  getUserData(BuildContext context) async {
    user = await AuthApi.getUsers(context);
    notifyListeners();
  }

  getOneUser(BuildContext context, int id) async {
    oneUser = await AuthApi.getUserById(context, id);
    notifyListeners();
  }
}
