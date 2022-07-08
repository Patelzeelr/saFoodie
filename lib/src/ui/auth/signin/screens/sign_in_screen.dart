import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/auth/auth_api.dart';
import '../../../../base/api/url_factory.dart';
import '../../../../utils/constants/asset_constants.dart';
import '../../../../utils/constants/string_constants.dart';
import '../../../../utils/methods/field_focus_change.dart';
import '../../../../utils/methods/navigation_method.dart';
import '../../../../utils/methods/validation.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../dashboard/screens/custom_bottom_navigation_bar.dart';
import '../../signup/screens/sign_up_screen.dart';
import '../model/signin_req_model.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "sign_in_screen";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isIndicate = false;
  final _toast = FToast();

  @override
  void initState() {
    super.initState();
    _toast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(context, kSignInImage),
      body: _isIndicate
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _signInText(),
                        _emailTextField(context),
                        _passwordTextField(context),
                        _forgotPasswordTextButton(),
                        _signInButton(context),
                        _bottomRichText(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Padding _emailTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: CustomTextFormField(
          hintText: kEmail,
          controller: _emailController,
          focusNode: _emailFocusNode,
          onSubmit: (String? value) {
            fieldFocusChange(
              context,
              _emailFocusNode,
              _passwordFocusNode,
            );
          },
          validator: validateEmail,
          textInputType: TextInputType.emailAddress,
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

  Padding _forgotPasswordTextButton() => Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              kForgotPassword,
            ),
          ),
        ),
      );

  _signInButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: kSignIn,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isIndicate = true;
              });
              await AuthApi.loginUser(
                SignInReqModel(
                    email: _emailController.text,
                    password: _passwordController.text),
              ).then((value) async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.setString(token, value.data.token);
                _prefs.setInt(id, value.data.id);
                Navigator.of(context).pushAndRemoveUntil(
                    createRoute(
                      const CustomBottomNavigation(),
                    ),
                    (route) => false);
              });
            }
          },
        ),
      );

  _bottomRichText() => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                  text: kDoNotAccount,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                TextSpan(
                  text: kSignUp,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ]),
            ),
          ),
        ),
      );

  _signInText() => const Text(
        kSignInSlogan,
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 30.0,
        ),
      );
}
