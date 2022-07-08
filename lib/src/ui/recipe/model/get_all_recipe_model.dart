import 'dart:convert';

import 'recipe.dart';

GetAllRecipeModel getAllRecipeModelFromJson(String str) =>
    GetAllRecipeModel.fromJson(json.decode(str));

String getAllRecipeModelToJson(GetAllRecipeModel data) =>
    json.encode(data.toJson());

class GetAllRecipeModel {
  GetAllRecipeModel({
    required this.code,
    required this.data,
    required this.message,
  });

  int code;
  List<Recipe> data;
  String message;

  factory GetAllRecipeModel.fromJson(Map<String, dynamic> json) =>
      GetAllRecipeModel(
        code: json["code"],
        data: List<Recipe>.from(
          json["data"].map(
            (x) => Recipe.fromJson(x),
          ),
        ),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<Recipe>.from(
          data.map(
            (x) => x.toJson(),
          ),
        ),
        "message": message,
      };
}
