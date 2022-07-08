import 'package:flutter/material.dart';

import '../../../utils/localizations/language/languages.dart';
import '../../auth/signin/model/signin_res_model.dart';
import '../../recipe/screens/add_recipe_screen.dart';
import '../../recipe/screens/recipe_listing_screen.dart';
import '../../user/screens/user_detail_screen.dart';
import '../../user/screens/user_listing_screen.dart';

class CustomBottomNavigation extends StatefulWidget {
  final SignInResModel? res;

  const CustomBottomNavigation({Key? key, this.res}) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: <Widget>[
            RecipeListingScreen(res: widget.res),
            AddRecipeScreen(res: widget.res),
            const UserListingScreen(),
            UserDetailScreen(res: widget.res),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.orangeAccent, spreadRadius: 0, blurRadius: 5),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.fastfood_sharp),
                label: Languages.of(context)!.bottomRecipe,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_box_sharp),
                label: Languages.of(context)!.bottomAddRecipe,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.supervised_user_circle_sharp),
                label: Languages.of(context)!.bottomUsers,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: Languages.of(context)!.bottomUser,
              ),
            ],
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.orangeAccent,
            onTap: _onItemTapped,
          ),
        ),
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
