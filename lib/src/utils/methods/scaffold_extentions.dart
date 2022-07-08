import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_shape_container.dart';

extension ScaffoldExtensions on Widget {
  Scaffold containerScaffold({required BuildContext context}) {
    return Scaffold(
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold appBarScaffold({required BuildContext context}) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: customShapeContainer(context),
      ),
      body: SafeArea(
        child: this,
      ),
    );
  }

  Scaffold authScaffold(
      {required BuildContext context, required String image}) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(context, image),
      body: SafeArea(
        child: this,
      ),
    );
  }
}
