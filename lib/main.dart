import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/ui/auth/signin/screens/sign_in_screen.dart';
import 'src/ui/auth/signup/screens/sign_up_screen.dart';
import 'src/ui/onboard/create_screen.dart';
import 'src/ui/onboard/welcome_screen.dart';
import 'src/ui/recipe/provider/recipe_provider.dart';
import 'src/ui/recipe/screens/add_recipe_screen.dart';
import 'src/ui/recipe/screens/recipe_listing_screen.dart';
import 'src/ui/user/provider/user_provider.dart';
import 'src/ui/user/screens/user_detail_screen.dart';
import 'src/ui/user/screens/user_listing_screen.dart';
import 'src/utils/constants/color_constants.dart';
import 'src/utils/localizations/locale_constant.dart';
import 'src/utils/localizations/localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.getString('language') == null) {
    _prefs.setString('language', 'English');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecipeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kOrange,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: _routes,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: kOrange),
        fontFamily: 'Raleway-Medium',
      ),
    );
  }
}

var _routes = {
  WelcomeScreen.id: (context) => const WelcomeScreen(),
  CreateScreen.id: (context) => const CreateScreen(),
  SignInScreen.id: (context) => const SignInScreen(),
  SignUpScreen.id: (context) => const SignUpScreen(),
  AddRecipeScreen.id: (context) => const AddRecipeScreen(),
  RecipeListingScreen.id: (context) => const RecipeListingScreen(),
  UserListingScreen.id: (context) => const UserListingScreen(),
  UserDetailScreen.id: (context) => const UserDetailScreen(),
};
