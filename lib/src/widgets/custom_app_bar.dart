import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
CustomAppBar(BuildContext context, String image) => PreferredSize(
      preferredSize: const Size.fromHeight(200.0),
      child: AppBar(
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
