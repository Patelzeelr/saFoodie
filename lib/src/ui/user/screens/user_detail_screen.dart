import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sa_foodie/src/utils/methods/show_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/auth/auth_api.dart';
import '../../../base/api/url_factory.dart';
import '../../../utils/constants/asset_constants.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../utils/methods/field_focus_change.dart';
import '../../../utils/methods/validation.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_shape_clipper.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../auth/signin/model/signin_res_model.dart';
import '../../auth/signin/screens/sign_in_screen.dart';
import '../../auth/signup/model/signup_req_model.dart';
import '../provider/user_provider.dart';

class UserDetailScreen extends StatefulWidget {
  static const String id = "user_detail_screen";
  final SignInResModel? res;

  const UserDetailScreen({Key? key, this.res}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final double clipHeight = 280;
  final double profileHeight = 144;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  late bool _isElevated = false;
  late UserProvider userData;
  bool _isLoad = false;
  final _toast = FToast();

  _loadUser() async {
    setState(() {
      _isLoad = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    userData = Provider.of<UserProvider>(context, listen: false);
    int? userId = _prefs.getInt(id);
    await userData.getOneUser(context, userId!);
    setState(() {
      if (userData.oneUser?.data.id != null) {
        _firstNameController.text = userData.oneUser!.data.firstname;
        _lastNameController.text = userData.oneUser!.data.lastname;
        _passwordController.text = userData.oneUser!.data.password;
      }
    });
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _toast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
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
                children: [
                  _userProfileTop(),
                  _userDetail(),
                ],
              ),
            ),
    );
  }

  Widget _userProfileTop() {
    final top = clipHeight - profileHeight / 1.5;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: profileHeight / 3,
          ),
          child: _clipBackground(context),
        ),
        Positioned(
          top: top,
          child: _profileImage(),
        ),
      ],
    );
  }

  _clipBackground(BuildContext context) => ClipPath(
        clipper: CustomShapeClipper(),
        child: Container(
          height: clipHeight,
          decoration: const BoxDecoration(
            color: Colors.orangeAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 36.0),
            child: Align(
              alignment: Alignment.topRight,
              child: _logOutButton(),
            ),
          ),
        ),
      );

  _profileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.black54,
        child: const CircleAvatar(
          radius: 68,
          backgroundImage: AssetImage(kAvatar),
          backgroundColor: Colors.white,
        ),
      );

  _userDetail() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _firstNameTextField(context),
            _lastNameTextField(context),
            _passwordTextField(context),
            _updateUserButton(context),
          ],
        ),
      );

  _firstNameTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: CustomTextFormField(
          hintText: kFirstName,
          controller: _firstNameController,
          focusNode: _firstNameFocusNode,
          onSubmit: (String? value) {
            fieldFocusChange(
              context,
              _firstNameFocusNode,
              _lastNameFocusNode,
            );
          },
          validator: validateUsername,
          textInputType: TextInputType.text,
        ),
      );

  _lastNameTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomTextFormField(
          hintText: kLastName,
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          onSubmit: (String? value) {
            fieldFocusChange(
              context,
              _lastNameFocusNode,
              _passwordFocusNode,
            );
          },
          validator: validateUsername,
          textInputType: TextInputType.text,
        ),
      );

  Padding _passwordTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: CustomTextFormField(
          hintText: kPassword,
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          onSubmit: (String? value) {},
          validator: validatePassword,
          textInputType: TextInputType.visiblePassword,
        ),
      );

  _updateUserButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: CustomButton(
          label: kUpdateButton,
          onPressed: () async {
            await AuthApi.updateUsers(
              userData.oneUser!.data.id,
              SignUpReqModel(
                  firstname: _firstNameController.text,
                  lastname: _lastNameController.text,
                  email: userData.oneUser!.data.email,
                  password: _passwordController.text,
                  token: userData.oneUser!.data.token,
                  isActive: userData.oneUser!.data.isActive),
            );
            Provider.of<UserProvider>(context, listen: false)
                .getOneUser(context, userData.oneUser!.data.id);
            showMessage(kUpdateUserMessage);
          },
        ),
      );

  _logOutButton() => GestureDetector(
        onTap: () async {
          setState(() {
            _isElevated = !_isElevated;
          });
          _logOutAlertDialog();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: const Icon(Icons.logout),
        ),
      );

  _logOutAlertDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(kAppName),
          content: const Text(kLogoutUserMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('LogOut'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("token");
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.id, (route) => false);
              },
            ),
          ],
        ),
      );
}
