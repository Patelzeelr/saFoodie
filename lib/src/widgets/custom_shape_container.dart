import 'package:flutter/material.dart';

import 'custom_shape_clipper.dart';

Widget customShapeContainer(BuildContext context) => ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
        ),
      ),
    );
