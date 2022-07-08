import 'package:flutter/material.dart';

import '../utils/constants/string_constants.dart';

// ignore: non_constant_identifier_names
CustomAppBar(BuildContext context, String image) => PreferredSize(
      preferredSize: const Size.fromHeight(200.0),
      child: AppBar(
        leading: _backButton(context),
        leadingWidth: 200,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
              ),
              gradient: LinearGradient(colors: [
                Colors.black.withOpacity(.4),
                Colors.black.withOpacity(.2),
              ], begin: Alignment.topCenter),
            ),
          ),
        ),
      ),
    );

_backButton(BuildContext context) => GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.arrow_back_ios),
          ),
          Text(
            kBackButton,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
