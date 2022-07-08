import 'dart:convert';

import 'recipe.dart';

DeleteRecipeResModel deleteRecipeResModelFromJson(String str) =>
    DeleteRecipeResModel.fromJson(json.decode(str));

String deleteRecipeResModelToJson(DeleteRecipeResModel data) =>
    json.encode(data.toJson());

class DeleteRecipeResModel {
  DeleteRecipeResModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  Recipe data;
  String message;

  factory DeleteRecipeResModel.fromJson(Map<String, dynamic> json) =>
      DeleteRecipeResModel(
        code: json["code"],
        data: Recipe.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
      };
}
