import 'dart:convert';

import 'user.dart';

GetAllUsersModel getAllUsersModelFromJson(String str) =>
    GetAllUsersModel.fromJson(json.decode(str));

String getAllUsersModelToJson(GetAllUsersModel data) =>
    json.encode(data.toJson());

class GetAllUsersModel {
  GetAllUsersModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  List<User> data;
  String message;

  factory GetAllUsersModel.fromJson(Map<String, dynamic> json) =>
      GetAllUsersModel(
        code: json["code"],
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<User>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}
