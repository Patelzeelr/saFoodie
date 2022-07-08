import 'dart:convert';

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
  List<Datum> data;
  String message;

  factory GetAllRecipeModel.fromJson(Map<String, dynamic> json) =>
      GetAllRecipeModel(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.photo,
    required this.preparationTime,
    required this.serves,
    required this.complexity,
    required this.firstName,
    required this.lastName,
    required this.userId,
  });

  int id;
  String name;
  String photo;
  String preparationTime;
  String serves;
  String complexity;
  String firstName;
  String lastName;
  int userId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
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
        "id": id,
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
