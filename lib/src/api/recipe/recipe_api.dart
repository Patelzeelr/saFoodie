import 'package:sa_foodie/src/base/api/url_factory.dart';
import 'package:sa_foodie/src/ui/dashboard/model/get_all_recipe_model.dart';
import 'package:sa_foodie/src/ui/recipe/model/delete_recipe_res_model.dart';
import 'package:sa_foodie/src/ui/recipe/model/update_recipe_res_model.dart';

import '../../base/api/base_api.dart';
import '../../ui/recipe/model/add_recipe_req_model.dart';
import '../../ui/recipe/model/add_recipe_res_model.dart';

class RecipeApi {
  static Future<AddRecipeResModel> addRecipe(
      AddRecipeReqModel recipeModel) async {
    final response = await BaseAPI.apiPost(
        body: addRecipeReqModelToJson(recipeModel),
        url: addRecipes,
        isHeaderIncluded: true);
    return addRecipeResModelFromJson(response.body);
  }

  static Future<GetAllRecipeModel> getRecipe(int id) async {
    final response = await BaseAPI.apiGet(url: '$allRecipe$id');
    return getAllRecipeModelFromJson(response.body);
  }

  static Future<UpdateRecipeResModel> updateRecipe(
      int id, AddRecipeReqModel recipeModel) async {
    final response = await BaseAPI.apiPut(
        body: addRecipeReqModelToJson(recipeModel),
        url: '$updateRecipes$id',
        isHeaderIncluded: true);
    return updateRecipeResModelFromJson(response.body);
  }

  static Future<DeleteRecipeResModel> deleteRecipe(int id) async {
    final response = await BaseAPI.apiDelete(url: "$deleteRecipes$id");
    return deleteRecipeResModelFromJson(response.body);
  }
}
