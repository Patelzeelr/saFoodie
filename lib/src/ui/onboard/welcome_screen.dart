import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/api/url_factory.dart';
import '../../utils/constants/asset_constants.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/style_constants.dart';
import '../../utils/localizations/language/languages.dart';
import '../../utils/methods/common_method.dart';
import '../../utils/methods/scaffold_extentions.dart';
import '../../widgets/custom_button.dart';
import '../dashboard/screens/custom_bottom_navigation_bar.dart';
import 'create_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(kStarterBackground), fit: BoxFit.cover),
      ),
      child: _gradientBackground(
        _bottomWidgets(),
      ),
    ).containerScaffold(context: context);
  }

  Container _gradientBackground(Widget widget) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.8),
            Colors.black.withOpacity(.2),
          ], begin: Alignment.bottomCenter),
        ),
        child: Padding(padding: const EdgeInsets.all(20.0), child: widget),
      );
  Column _bottomWidgets() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            Languages.of(context)!.appName,
            style: kAppNameTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              Languages.of(context)!.appSlogan,
              style: kMediumTextTextStyle.copyWith(color: kWhite),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: CustomButton(
              onPressed: () {
                _welcomeUser();
              },
              label: Languages.of(context)!.startButton,
            ),
          ),
        ],
      );
  _welcomeUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? authToken = _prefs.getString(token);
    if (authToken != null) {
      Navigator.of(context).pushAndRemoveUntil(
          createRoute(
            const CustomBottomNavigation(),
          ),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          createRoute(
            const CreateScreen(),
          ),
          (route) => false);
    }
  }
}
