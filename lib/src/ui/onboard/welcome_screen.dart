import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/api/url_factory.dart';
import '../../utils/constants/asset_constants.dart';
import '../../utils/constants/string_constants.dart';
import '../../utils/methods/navigation_method.dart';
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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kStarterBackground), fit: BoxFit.cover),
        ),
        child: _gradientBackground(
          _bottomWidgets(),
        ),
      ),
    );
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
          const Text(
            kAppName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              kAppSlogan,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: CustomButton(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
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
              },
              label: kStartButton,
            ),
          ),
        ],
      );
}
