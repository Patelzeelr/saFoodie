import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/auth/auth_api.dart';
import '../../../../base/api/url_factory.dart';
import '../../../../utils/constants/asset_constants.dart';
import '../../../../utils/constants/color_constants.dart';
import '../../../../utils/constants/style_constants.dart';
import '../../../../utils/localizations/language/languages.dart';
import '../../../../utils/methods/common_method.dart';
import '../../../../utils/methods/scaffold_extentions.dart';
import '../../../../utils/methods/validation.dart';
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
    return _isIndicate
        ? const Center(
            child: CircularProgressIndicator(color: kOrange),
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
          ).authScaffold(context: context, image: kSignInImage);
  }

  _signInText() =>
      Text(Languages.of(context)!.signInSlogan, style: kSignInUpTextStyle);

  Padding _emailTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: CustomTextFormField(
          hintText: Languages.of(context)!.email,
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
          hintText: Languages.of(context)!.password,
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
            child: Text(
              Languages.of(context)!.forgotPassword,
            ),
          ),
        ),
      );

  _signInButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: Languages.of(context)!.signIn,
          onPressed: () {
            _signInUser();
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
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Languages.of(context)!.doNotAccount,
                    style: kSmallTextTextStyle,
                  ),
                  TextSpan(
                      text: Languages.of(context)!.signUp,
                      style: kSmallBoldTextTextStyle),
                ],
              ),
            ),
          ),
        ),
      );

  _signInUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isIndicate = true;
      });
      await AuthApi.loginUser(
        SignInReqModel(
            email: _emailController.text, password: _passwordController.text),
      ).then((value) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString(token, value.data.token);
        _prefs.setInt(id, value.data.id);
        Navigator.of(context).pushAndRemoveUntil(
            createRoute(
              const CustomBottomNavigation(),
            ),
            (route) => false);
      });
    }
  }
}
