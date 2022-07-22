import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/constants/asset_constants.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/style_constants.dart';
import '../../utils/localizations/language/languages.dart';
import '../../utils/methods/common_method.dart';
import '../../utils/methods/scaffold_extentions.dart';
import '../../widgets/custom_button.dart';
import '../auth/signin/screens/sign_in_screen.dart';
import '../auth/signup/screens/sign_up_screen.dart';

class CreateScreen extends StatelessWidget {
  static const String id = "create_screen";
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kCreateBackground), fit: BoxFit.cover),
        ),
        child: Center(child: _glassBox(context)),
      ),
    ).containerScaffold(context: context);
  }

  _glassBox(BuildContext context) => Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          color: kLightGrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: MediaQuery.of(context).size.width * 30,
                height: MediaQuery.of(context).size.height * 40,
                decoration: BoxDecoration(
                  color: kLightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    const Image(image: AssetImage(kAppLogo)),
                    _headingText(context),
                    _descriptionText(context),
                    _createButton(context),
                    _bottomRichText(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  _headingText(BuildContext context) => Text(
        Languages.of(context)!.appName,
        style: kAppNameTextStyle.copyWith(color: kOrange, fontSize: 30.0),
      );

  _descriptionText(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          Languages.of(context)!.description,
          style: kSmallBoldTextTextStyle,
          textAlign: TextAlign.center,
        ),
      );

  _createButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: CustomButton(
          label: Languages.of(context)!.createAccountButton,
          onPressed: () {
            Navigator.of(context).push(
              createRoute(
                const SignUpScreen(),
              ),
            );
          },
        ),
      );

  _bottomRichText(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            createRoute(
              const SignInScreen(),
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
      );
}
