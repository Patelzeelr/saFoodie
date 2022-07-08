import 'dart:convert';

import 'recipe.dart';

UpdateRecipeResModel updateRecipeResModelFromJson(String str) =>
    UpdateRecipeResModel.fromJson(json.decode(str));

String updateRecipeResModelToJson(UpdateRecipeResModel data) =>
    json.encode(data.toJson());

class UpdateRecipeResModel {
  UpdateRecipeResModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  Recipe data;
  String message;

  factory UpdateRecipeResModel.fromJson(Map<String, dynamic> json) =>
      UpdateRecipeResModel(
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
