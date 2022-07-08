import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa_foodie/src/widgets/custom_shape_container.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';

class UserListingScreen extends StatefulWidget {
  static const String id = "user_listing_screen";
  const UserListingScreen({Key? key}) : super(key: key);

  @override
  State<UserListingScreen> createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  late UserProvider userData;

  _loadAllUsers() async {
    await Provider.of<UserProvider>(context, listen: false)
        .getUserData(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserProvider>(context);
    _loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: ListView.builder(
        itemCount: userData.user?.data.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final data = userData.user!.data[index];
          return Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: _userCardView(data),
          );
        },
      ),
    );
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

  _customAppBar() => PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: customShapeContainer(),
      );

  _userProfileImage(User data) => CircleAvatar(
        backgroundColor: Colors.orangeAccent,
        child: Text(
          data.firstname[0].toUpperCase() + data.lastname[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
              thickness: 5,
              color: Colors.black,
            ),
            Text(
              data.email,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ],
        ),
      );
}
