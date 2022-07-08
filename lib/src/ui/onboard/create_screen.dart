import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/constants/asset_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../widgets/custom_button.dart';
import '../auth/signin/screens/sign_in_screen.dart';
import '../auth/signup/screens/sign_up_screen.dart';

class CreateScreen extends StatelessWidget {
  static const String id = "create_screen";
  const CreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kCreateBackground), fit: BoxFit.cover),
        ),
        child: Center(child: _glassBox(context)),
      ),
    );
  }

  _glassBox(BuildContext context) => ClipRect(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white24,
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
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: [
                      const Image(image: AssetImage(kAppLogo)),
                      _headingText(),
                      _descriptionText(),
                      _createButton(context),
                      _bottomRichText(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _headingText() => const Text(
        kAppName,
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      );

  _descriptionText() => const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          kDescription,
          style: TextStyle(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      );

  _createButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: CustomButton(
          label: kCreateAccountButton,
          onPressed: () {
            Navigator.pushNamed(context, SignUpScreen.id);
          },
        ),
      );

  _bottomRichText(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, SignInScreen.id);
        },
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: kAlreadyAccount,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              TextSpan(
                text: kSignIn,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      );
}
