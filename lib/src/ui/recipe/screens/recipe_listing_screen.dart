import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/api/url_factory.dart';
import '../../../utils/constants/asset_constants.dart';
import '../../../utils/constants/string_constants.dart';
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
  final TextEditingController _searchController = TextEditingController();
  late RecipeProvider recipeData;
  bool _isLoad = false;

  _loadRecipe() async {
    setState(() {
      _isLoad = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    recipeData = Provider.of<RecipeProvider>(context, listen: false);
    int? userId = _prefs.getInt(id);
    await recipeData.getRecipeData(context, userId!);
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
    return Scaffold(
      body: _isLoad
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customShapeContainer(),
                  _heading(),
                  _staticHorizontalImageListView(),
                  _headingRecipe(),
                  _recipeListView(),
                ],
              ),
            ),
    );
  }

  _heading() => const Padding(
        padding: EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
        child: Text(
          kHomeHeading,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  _searchAndFilterRow() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _searchBar(),
            const SizedBox(
              width: 8.0,
            ),
            _filter(),
          ],
        ),
      );

  _searchBar() => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.20),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: TextField(
            cursorColor: Colors.orangeAccent,
            controller: _searchController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 34.0,
              ),
              hintText: 'Search For Recipe',
              helperStyle: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );

  _filter() => Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.20),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: const Icon(
          Icons.filter_alt,
          size: 24,
        ),
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

  _headingRecipe() => const Padding(
        padding: EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
        child: Text(
          kHomeRecipe,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  _recipeListView() => Consumer<RecipeProvider>(
        builder: (context, recipeData, child) => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipeData.recipe?.data.length ?? 0,
          itemBuilder: (context, index) {
            return _customCard(recipeData.recipe!.data[index]);
          },
        ),
      );

  _customCard(Datum data) => GestureDetector(
        onTap: () {
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
              Positioned(
                top: 35,
                left: 20,
                child: Material(
                  child: Container(
                    height: 140.0,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
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
              ),
              Positioned(
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
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                          fit: BoxFit.fill, image: AssetImage(kIceCream)),
                    ),
                  ),
                ),
              ),
              Positioned(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.orangeAccent,
                          ),
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
                          color: Colors.orangeAccent,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.restaurant_menu_outlined),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${data.serves} $kPeople",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
