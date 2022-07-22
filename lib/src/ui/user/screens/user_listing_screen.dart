import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/style_constants.dart';
import '../../../utils/methods/scaffold_extentions.dart';
import '../model/user.dart';
import '../provider/user_provider.dart';

class UserListingScreen extends StatefulWidget {
  static const String id = "user_listing_screen";
  const UserListingScreen({Key? key}) : super(key: key);

  @override
  State<UserListingScreen> createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  late UserProvider _userData;

  _loadAllUsers() async {
    await Provider.of<UserProvider>(context, listen: false)
        .getUserData(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userData = Provider.of<UserProvider>(context);
    _loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _userData.user?.data.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final data = _userData.user!.data[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: _userCardView(data),
        );
      },
    ).appBarScaffold(context: context);
  }

  _userCardView(User data) => Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          child: Row(
            children: [
              _userProfileImage(data),
              _userDetail(data),
            ],
          ),
        ),
      );

  _userProfileImage(User data) => CircleAvatar(
        backgroundColor: Colors.orangeAccent,
        child: Text(
          data.firstname[0].toUpperCase() + data.lastname[0].toUpperCase(),
          style: kRecipeNameTextStyle.copyWith(color: Colors.white),
        ),
        radius: 30,
      );

  _userDetail(User data) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.firstname + data.lastname,
              style: kMediumBoldTextTextStyle,
            ),
            const Divider(
              height: 20,
              thickness: 5,
              color: Colors.black,
            ),
            Text(
              data.email,
              style: kEmailTextStyle,
              maxLines: 2,
            ),
          ],
        ),
      );
}
