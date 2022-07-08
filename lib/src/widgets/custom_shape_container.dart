import 'package:flutter/material.dart';

import 'custom_shape_clipper.dart';

Widget customShapeContainer() => ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 100.0,
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
        ),
      ),
    );
