import 'dart:convert';

AddRecipeReqModel addRecipeReqModelFromJson(String str) =>
    AddRecipeReqModel.fromJson(json.decode(str));

String addRecipeReqModelToJson(AddRecipeReqModel data) =>
    json.encode(data.toJson());

class AddRecipeReqModel {
  AddRecipeReqModel({
    required this.name,
    required this.photo,
    required this.preparationTime,
    required this.serves,
    required this.complexity,
    required this.firstName,
    required this.lastName,
    required this.userId,
  });

  String name;
  String photo;
  String preparationTime;
  String serves;
  String complexity;
  String firstName;
  String lastName;
  int userId;

  factory AddRecipeReqModel.fromJson(Map<String, dynamic> json) =>
      AddRecipeReqModel(
        name: json["name"],
        photo: json["photo"],
        preparationTime: json["preparationTime"],
        serves: json["serves"],
        complexity: json["complexity"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "photo": photo,
        "preparationTime": preparationTime,
        "serves": serves,
        "complexity": complexity,
        "firstName": firstName,
        "lastName": lastName,
        "userId": userId,
      };
}
