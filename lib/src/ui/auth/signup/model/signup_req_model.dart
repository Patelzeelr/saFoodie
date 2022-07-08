import 'dart:convert';

SignUpReqModel signUpReqModelFromJson(String str) =>
    SignUpReqModel.fromJson(json.decode(str));

String signUpReqModelToJson(SignUpReqModel data) => json.encode(data.toJson());

class SignUpReqModel {
  SignUpReqModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.token,
    required this.isActive,
  });

  String firstname;
  String lastname;
  String email;
  String password;
  String token;
  bool isActive;

  factory SignUpReqModel.fromJson(Map<String, dynamic> json) => SignUpReqModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "token": token,
        "isActive": isActive,
      };
}
