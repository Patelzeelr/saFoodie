import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sa_foodie/src/utils/methods/show_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/recipe/recipe_api.dart';
import '../../../base/api/url_factory.dart';
import '../../../utils/constants/asset_constants.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../utils/methods/field_focus_change.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_header_text_field.dart';
import '../../../widgets/custom_shape_container.dart';
import '../../auth/signin/model/signin_res_model.dart';
import '../../dashboard/model/get_all_recipe_model.dart';
import '../../dashboard/screens/custom_bottom_navigation_bar.dart';
import '../../user/provider/user_provider.dart';
import '../model/add_recipe_req_model.dart';
import '../provider/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  static const String id = "add_recipe_screen";
  final SignInResModel? res;
  final Datum? recipe;

  const AddRecipeScreen({Key? key, this.res, this.recipe}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _preparationTimeController =
      TextEditingController();
  final FocusNode _recipeNameFocusNode = FocusNode();
  final FocusNode _preparationTimeFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late UserProvider userData;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> complexityOfItems = const [
      DropdownMenuItem(child: Text("Easy"), value: "Easy"),
      DropdownMenuItem(child: Text("Normal"), value: "Normal"),
      DropdownMenuItem(child: Text("Hard"), value: "Hard"),
    ];
    return complexityOfItems;
  }

  String? selectedValue = "Easy";
  int _count = 0;
  final double profileHeight = 144;
  String _firstName = "";
  String _lastName = "";
  int _id = 0;
  bool _isElevated = false;
  final _toast = FToast();

  _add() {
    setState(() {
      _count++;
    });
  }

  _minus() {
    setState(() {
      _count--;
    });
  }

  _loadUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    userData = Provider.of<UserProvider>(context, listen: false);
    int? userId = _prefs.getInt(id);
    await userData.getOneUser(context, userId!);
    setState(() {
      if (userData.oneUser?.data.id != null) {
        _firstName = userData.oneUser!.data.firstname;
        _lastName = userData.oneUser!.data.lastname;
        _id = userData.oneUser!.data.id;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    if (widget.recipe != null) {
      _recipeNameController.text = widget.recipe!.name;
      _count = int.parse(widget.recipe!.serves);
      _preparationTimeController.text = widget.recipe!.preparationTime;
      selectedValue = widget.recipe!.complexity;
    } else {
      _recipeNameController.text = "";
      _count = 0;
      _preparationTimeController.text = "";
    }
    _toast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    _recipeNameController.dispose();
    _preparationTimeController.dispose();
    _recipeNameFocusNode.dispose();
    _preparationTimeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customShapeContainer(),
            _deleteRecipeButton(),
            _foodImg(),
            _foodDetail(),
          ],
        ),
      ),
    );
  }

  _deleteRecipeButton() => GestureDetector(
        onTap: () async {
          setState(() {
            _isElevated = !_isElevated;
          });
          await RecipeApi.deleteRecipe(widget.recipe!.id);
          Provider.of<RecipeProvider>(context, listen: false)
              .getRecipeData(context, _id);
          showMessage(kRecipeDeleteMessage);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(100),
                boxShadow: _isElevated
                    ? [
                        const BoxShadow(
                          color: Colors.black26,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                        const BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-4, -4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: const Icon(Icons.delete),
            ),
          ),
        ),
      );

  _foodImg() => SizedBox(
        height: 250,
        child: Stack(
          children: [
            _imageContainer(),
            _imageCircleAvatar(),
          ],
        ),
      );

  _foodDetail() => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.orangeAccent, width: 2),
            right: BorderSide(color: Colors.orangeAccent, width: 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _addRecipeName(),
                _addPreparationTime(),
                _headingTitle(kAddServing),
                _servingRow(),
                _headingTitle(kAddComplexity),
                _complexityDropDownButton(),
                widget.recipe != null
                    ? _updateButton(context)
                    : _addButton(context),
              ],
            ),
          ),
        ),
      );

  _headingTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  _addRecipeName() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headingTitle(kAddRecipeName),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomHeaderTextField(
              hintText: kExRecipeName,
              maxLines: 1,
              controller: _recipeNameController,
              focusNode: _recipeNameFocusNode,
              onSubmit: (String? value) {
                fieldFocusChange(
                  context,
                  _recipeNameFocusNode,
                  _preparationTimeFocusNode,
                );
              },
            ),
          ),
        ],
      );

  _addPreparationTime() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headingTitle(kAddPreparationTime),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomHeaderTextField(
              hintText: kExPreparationTime,
              maxLines: 1,
              controller: _preparationTimeController,
              focusNode: _preparationTimeFocusNode,
              onSubmit: (String? value) {},
            ),
          ),
        ],
      );

  _servingRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: _minus,
                backgroundColor: Colors.orangeAccent,
                child: const Icon(Icons.remove, color: Colors.black),
              ),
            ),
          ),
          Text('$_count', style: const TextStyle(fontSize: 30.0)),
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: _add,
                heroTag: "btn2",
                backgroundColor: Colors.orangeAccent,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      );

  _complexityDropDownButton() => DropdownButtonFormField(
        items: dropdownItems,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0)),
        ),
        onChanged: (String? value) {
          setState(() {
            selectedValue = value!;
          });
        },
        value: selectedValue,
      );

  _addButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: kAddRecipeButton,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await RecipeApi.addRecipe(
                AddRecipeReqModel(
                    name: _recipeNameController.text,
                    photo: '$image$kIceCream',
                    preparationTime: _preparationTimeController.text,
                    serves: _count.toString(),
                    complexity: selectedValue!,
                    firstName: _firstName,
                    lastName: _lastName,
                    userId: _id),
              );
              if (response.code == 200) {
                Provider.of<RecipeProvider>(context, listen: false)
                    .getRecipeData(context, _id);
                showMessage(kRecipeAddMessage);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomBottomNavigation(),
                  ),
                );
              } else {}
            }
          },
        ),
      );

  _updateButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: kUpdateRecipeButton,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await RecipeApi.updateRecipe(
                widget.recipe!.id,
                AddRecipeReqModel(
                    name: _recipeNameController.text,
                    photo: '$image$kIceCream',
                    preparationTime: _preparationTimeController.text,
                    serves: _count.toString(),
                    complexity: selectedValue!,
                    firstName: _firstName,
                    lastName: _lastName,
                    userId: _id),
              );
              if (response.code == 200) {
                Provider.of<RecipeProvider>(context, listen: false)
                    .getRecipeData(context, _id);
                showMessage(kRecipeUpdateMessage);
                Navigator.pop(context);
              } else {}
            }
          },
        ),
      );

  _imageContainer() => Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Container(
                margin:
                    const EdgeInsetsDirectional.only(start: 2, end: 2, top: 2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  _imageCircleAvatar() => Align(
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: Colors.orangeAccent,
          child: const CircleAvatar(
            radius: 68,
            backgroundImage: AssetImage(kIceCream),
            backgroundColor: Colors.white,
          ),
        ),
      );
}
