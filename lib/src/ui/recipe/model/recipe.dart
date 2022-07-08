import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());

class Recipe {
  Recipe({
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

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
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
