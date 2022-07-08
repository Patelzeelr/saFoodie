import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  Data data;
  String message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.token,
    required this.isActive,
  });

  int id;
  String firstname;
  String lastname;
  String email;
  String password;
  String token;
  bool isActive;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "token": token,
        "isActive": isActive,
      };
}
