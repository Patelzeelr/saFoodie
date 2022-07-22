import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/api/url_factory.dart';
import '../../../utils/constants/asset_constants.dart';
import '../../../utils/constants/color_constants.dart';
import '../../../utils/constants/style_constants.dart';
import '../../../utils/localizations/language/languages.dart';
import '../../../utils/methods/scaffold_extentions.dart';
import '../../../widgets/custom_container_list.dart';
import '../../../widgets/custom_shape_container.dart';
import '../../auth/signin/model/signin_res_model.dart';
import '../../dashboard/model/get_all_recipe_model.dart';
import '../provider/recipe_provider.dart';
import 'add_recipe_screen.dart';

class RecipeListingScreen extends StatefulWidget {
  static const String id = "recipe_listing_screen";
  final SignInResModel? res;

  const RecipeListingScreen({Key? key, this.res}) : super(key: key);

  @override
  State<RecipeListingScreen> createState() => _RecipeListingScreenState();
}

class _RecipeListingScreenState extends State<RecipeListingScreen> {
  final List<String> _images = [
    kMocktail,
    kSalad,
    kStarter,
    kMenu,
    kDesert,
    kCake,
    kCoffee,
    kIceCream
  ];
  late RecipeProvider _recipeData;
  bool _isLoad = false;

  _loadRecipe() async {
    setState(() {
      _isLoad = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _recipeData = Provider.of<RecipeProvider>(context, listen: false);
    int? userId = _prefs.getInt(id);
    await _recipeData.getRecipeData(context, userId!);
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoad
        ? const Center(
            child: CircularProgressIndicator(
              color: kOrange,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customShapeContainer(context),
                _heading(),
                _staticHorizontalImageListView(),
                _headingRecipe(),
                _recipeListView()
              ],
            ),
          ).containerScaffold(context: context);
  }

  _heading() => Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
        child:
            Text(Languages.of(context)!.homeHeading, style: kRecipeTextStyle),
      );

  _staticHorizontalImageListView() => CustomContainerList(
        ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _images.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                _images[index],
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: const EdgeInsets.all(10),
            );
          },
        ),
        MediaQuery.of(context).size.width,
        0.42,
      );

  _headingRecipe() => Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
        child: Text(
          Languages.of(context)!.homeRecipe,
          style: kRecipeTextStyle,
        ),
      );

  _recipeListView() => Consumer<RecipeProvider>(
        builder: (context, recipeData, child) => Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: recipeData.recipe!.data.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipeData.recipe?.data.length ?? 0,
                  itemBuilder: (context, index) {
                    return _customCard(recipeData.recipe!.data[index]);
                  },
                )
              : _customColumnEmptyData(),
        ),
      );

  _customColumnEmptyData() => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.add_box_sharp,
                color: kOrange,
              ),
              Text(
                'You dont add any recipe yet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Add Now',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );

  _customCard(Datum data) => GestureDetector(
        onTap: () {
          debugPrint("image: $baseUrl${data.photo}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(recipe: data),
            ),
          );
        },
        child: SizedBox(
          height: 200,
          child: Stack(
            children: [
              _backCard(),
              _recipeImage(data),
              _recipeDetail(data),
            ],
          ),
        ),
      );

  _backCard() => Positioned(
        top: 35,
        left: 20,
        child: Material(
          child: Container(
            height: 140.0,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(0.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0),
                ]),
          ),
        ),
      );

  _recipeImage(Datum data) => Positioned(
        top: 0,
        left: 30,
        child: Card(
          elevation: 10.0,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              image: const DecorationImage(
                image: AssetImage(kMenu),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );

  _recipeDetail(Datum data) => Positioned(
        top: 45,
        left: 130,
        child: SizedBox(
          height: 150,
          width: 180,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: kRecipeNameTextStyle.copyWith(color: kOrange),
                ),
                Row(
                  children: [
                    const Icon(Icons.watch_later_outlined),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data.preparationTime,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: kOrange,
                ),
                Row(
                  children: [
                    const Icon(Icons.restaurant_menu_outlined),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${data.serves} ${Languages.of(context)!.people}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
