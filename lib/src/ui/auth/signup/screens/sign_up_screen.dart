import 'package:flutter/material.dart';

import '../../../../api/auth/auth_api.dart';
import '../../../../utils/constants/asset_constants.dart';
import '../../../../utils/constants/style_constants.dart';
import '../../../../utils/localizations/language/languages.dart';
import '../../../../utils/methods/field_focus_change.dart';
import '../../../../utils/methods/navigation_method.dart';
import '../../../../utils/methods/scaffold_extentions.dart';
import '../../../../utils/methods/validation.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../signin/screens/sign_in_screen.dart';
import '../model/signup_req_model.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign_up_screen";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isIndicate = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isIndicate
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
                      _signUpText(),
                      _firstNameTextField(context),
                      _lastNameTextField(context),
                      _emailTextField(context),
                      _passwordTextField(context),
                      _signUpButton(context),
                      _bottomRichText(),
                    ],
                  ),
                ),
              ),
            ),
          ).authScaffold(image: kSignUpImage, context: context);
  }

  _signUpText() =>
      Text(Languages.of(context)!.signUpSlogan, style: kSignInUpTextStyle);

  _firstNameTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: CustomTextFormField(
          hintText: Languages.of(context)!.firstName,
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
          hintText: Languages.of(context)!.lastName,
          controller: _lastNameController,
          focusNode: _lastNameFocusNode,
          onSubmit: (String? value) {
            fieldFocusChange(
              context,
              _lastNameFocusNode,
              _emailFocusNode,
            );
          },
          validator: validateUsername,
          textInputType: TextInputType.text,
        ),
      );

  Padding _emailTextField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
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

  _signUpButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomButton(
          label: Languages.of(context)!.signUp,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isIndicate = true;
              });
              final response = await AuthApi.registerUser(
                SignUpReqModel(
                    firstname: _firstNameController.text,
                    lastname: _lastNameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    token: "",
                    isActive: true),
              );
              if (response.code == 200) {
                Navigator.of(context).pushAndRemoveUntil(
                    createRoute(
                      const SignInScreen(),
                    ),
                    (route) => false);
              } else {}
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
                  builder: (context) => const SignInScreen(),
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Languages.of(context)!.alreadyAccount,
                    style: kSmallTextTextStyle,
                  ),
                  TextSpan(
                    text: Languages.of(context)!.signIn,
                    style: kSmallBoldTextTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
