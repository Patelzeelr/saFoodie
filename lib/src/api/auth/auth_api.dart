import '../../base/api/base_api.dart';
import '../../base/api/url_factory.dart';
import '../../ui/auth/signin/model/signin_req_model.dart';
import '../../ui/auth/signin/model/signin_res_model.dart';
import '../../ui/auth/signup/model/signup_req_model.dart';
import '../../ui/auth/signup/model/signup_res_model.dart';
import '../../ui/user/model/get_all_users_model.dart';
import '../../ui/user/model/update_user_res_model.dart';
import '../../ui/user/model/user_model.dart';

class AuthApi {
  static Future<SignUpResModel> registerUser(
      SignUpReqModel registerModel) async {
    final response = await BaseAPI.apiPost(
        body: signUpReqModelToJson(registerModel),
        url: register,
        isHeaderIncluded: false);
    return signUpResModelFromJson(response.body);
  }

  static Future<SignInResModel> loginUser(SignInReqModel loginModel) async {
    final response = await BaseAPI.apiPost(
        body: signInReqModelToJson(loginModel),
        url: login,
        isHeaderIncluded: false);
    return signInResModelFromJson(response.body);
  }

  static Future<GetAllUsersModel> getUsers(context) async {
    final response = await BaseAPI.apiGet(url: getUser);
    return getAllUsersModelFromJson(response.body);
  }

  static Future<UserModel> getUserById(context, int id) async {
    final response = await BaseAPI.apiGet(url: '$getOneUser$id');
    return userModelFromJson(response.body);
  }

  static Future<UpdateUserResModel> updateUsers(
      int id, SignUpReqModel updateUserModel) async {
    final response = await BaseAPI.apiPut(
        body: signUpReqModelToJson(updateUserModel),
        url: "$updateUser$id",
        isHeaderIncluded: true);
    return updateUserResModelFromJson(response.body);
  }
}
