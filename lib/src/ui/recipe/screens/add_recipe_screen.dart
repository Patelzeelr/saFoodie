import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/recipe/recipe_api.dart';
import '../../../base/api/url_factory.dart';
import '../../../utils/constants/asset_constants.dart';
import '../../../utils/constants/style_constants.dart';
import '../../../utils/localizations/language/languages.dart';
import '../../../utils/methods/field_focus_change.dart';
import '../../../utils/methods/scaffold_extentions.dart';
import '../../../utils/methods/show_message.dart';
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
  late UserProvider _userData;
  List<DropdownMenuItem<String>> get _dropdownItems {
    List<DropdownMenuItem<String>> complexityOfItems = [
      DropdownMenuItem(
          child: Text(Languages.of(context)!.easy),
          value: Languages.of(context)!.easy),
      DropdownMenuItem(
          child: Text(Languages.of(context)!.normal),
          value: Languages.of(context)!.normal),
      DropdownMenuItem(
          child: Text(Languages.of(context)!.hard),
          value: Languages.of(context)!.hard),
    ];
    return complexityOfItems;
  }

  String? _selectedValue = "Easy";
  int _count = 0;
  final double _profileHeight = 144;
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
    _userData = Provider.of<UserProvider>(context, listen: false);
    int? userId = _prefs.getInt(id);
    await _userData.getOneUser(context, userId!);
    setState(() {
      if (_userData.oneUser?.data.id != null) {
        _firstName = _userData.oneUser!.data.firstname;
        _lastName = _userData.oneUser!.data.lastname;
        _id = _userData.oneUser!.data.id;
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
      _selectedValue = widget.recipe!.complexity;
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customShapeContainer(context),
          _deleteRecipeButton(),
          _foodImg(),
          _foodDetail(),
        ],
      ),
    ).containerScaffold(context: context);
  }

  _deleteRecipeButton() => GestureDetector(
        onTap: () async {
          setState(() {
            _isElevated = !_isElevated;
          });
          await RecipeApi.deleteRecipe(widget.recipe!.id);
          Provider.of<RecipeProvider>(context, listen: false)
              .getRecipeData(context, _id);
          showMessage(Languages.of(context)!.recipeDeleteMessage);
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
                _headingTitle(Languages.of(context)!.serving),
                _servingRow(),
                _headingTitle(Languages.of(context)!.complexity),
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
          style: kMediumBoldTextTextStyle,
        ),
      );

  _addRecipeName() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headingTitle(Languages.of(context)!.recipeName),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomHeaderTextField(
              hintText: Languages.of(context)!.recipeExample,
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
          _headingTitle(Languages.of(context)!.preparationTime),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomHeaderTextField(
              hintText: Languages.of(context)!.preparationTime,
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
        items: _dropdownItems,
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
            _selectedValue = value!;
          });
        },
        value: _selectedValue,
      );

  _addButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: Languages.of(context)!.addRecipeButton,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await RecipeApi.addRecipe(
                AddRecipeReqModel(
                    name: _recipeNameController.text,
                    photo: '$image$kIceCream',
                    preparationTime: _preparationTimeController.text,
                    serves: _count.toString(),
                    complexity: _selectedValue!,
                    firstName: _firstName,
                    lastName: _lastName,
                    userId: _id),
              );
              if (response.code == 200) {
                Provider.of<RecipeProvider>(context, listen: false)
                    .getRecipeData(context, _id);
                showMessage(Languages.of(context)!.recipeAddMessage);
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
          label: Languages.of(context)!.updateRecipeButton,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await RecipeApi.updateRecipe(
                widget.recipe!.id,
                AddRecipeReqModel(
                    name: _recipeNameController.text,
                    photo: '$image$kIceCream',
                    preparationTime: _preparationTimeController.text,
                    serves: _count.toString(),
                    complexity: _selectedValue!,
                    firstName: _firstName,
                    lastName: _lastName,
                    userId: _id),
              );
              if (response.code == 200) {
                Provider.of<RecipeProvider>(context, listen: false)
                    .getRecipeData(context, _id);
                showMessage(Languages.of(context)!.recipeUpdateMessage);
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
          radius: _profileHeight / 2,
          backgroundColor: Colors.orangeAccent,
          child: const CircleAvatar(
            radius: 68,
            backgroundImage: AssetImage(kIceCream),
            backgroundColor: Colors.white,
          ),
        ),
      );
}
