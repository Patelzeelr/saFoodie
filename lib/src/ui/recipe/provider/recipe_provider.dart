import 'package:flutter/cupertino.dart';

import '../../../api/recipe/recipe_api.dart';
import '../../dashboard/model/get_all_recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  GetAllRecipeModel? recipe;

  getRecipeData(BuildContext context, int id) async {
    recipe = await RecipeApi.getRecipe(id);
    notifyListeners();
  }
}
