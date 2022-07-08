import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

void main() {
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

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: _routes,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.orangeAccent),
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
