import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;
  String get appSlogan;
  String get startButton;
  String get description;
  String get createAccountButton;
  String get alreadyAccount;
  String get doNotAccount;
  String get signIn;
  String get signUp;
  String get forgotPassword;
  String get email;
  String get password;
  String get recipeExample;
  String get recipeTime;
  String get firstName;
  String get lastName;
  String get signInSlogan;
  String get signUpSlogan;
  String get updateUserButton;
  String get serving;
  String get complexity;
  String get recipeName;
  String get preparationTime;
  String get addRecipeButton;
  String get updateRecipeButton;
  String get homeHeading;
  String get homeRecipe;
  String get people;
  String get updateUserMessage;
  String get logOutUserMessage;
  String get recipeUpdateMessage;
  String get recipeDeleteMessage;
  String get recipeAddMessage;
  String get easy;
  String get normal;
  String get hard;
  String get bottomRecipe;
  String get bottomAddRecipe;
  String get bottomUsers;
  String get bottomUser;
}
