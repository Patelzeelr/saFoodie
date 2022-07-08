import 'dart:convert';

import '../../../user/model/user.dart';

SignUpResModel signUpResModelFromJson(String str) =>
    SignUpResModel.fromJson(json.decode(str));

String signUpResModelToJson(SignUpResModel data) => json.encode(data.toJson());

class SignUpResModel {
  SignUpResModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  User data;
  String message;

  factory SignUpResModel.fromJson(Map<String, dynamic> json) => SignUpResModel(
        code: json["code"],
        data: User.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}
