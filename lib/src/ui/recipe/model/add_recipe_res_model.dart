import 'dart:convert';

import 'recipe.dart';

AddRecipeResModel addRecipeResModelFromJson(String str) =>
    AddRecipeResModel.fromJson(json.decode(str));

String addRecipeResModelToJson(AddRecipeResModel data) =>
    json.encode(data.toJson());

class AddRecipeResModel {
  AddRecipeResModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  Recipe data;
  String message;

  factory AddRecipeResModel.fromJson(Map<String, dynamic> json) =>
      AddRecipeResModel(
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
