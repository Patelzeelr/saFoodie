import 'dart:convert';

import 'user.dart';

UpdateUserResModel updateUserResModelFromJson(String str) =>
    UpdateUserResModel.fromJson(json.decode(str));

String updateUserResModelToJson(UpdateUserResModel data) =>
    json.encode(data.toJson());

class UpdateUserResModel {
  UpdateUserResModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  User data;
  String message;

  factory UpdateUserResModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserResModel(
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
