import 'package:flutter/cupertino.dart';

class CustomContainerList extends StatelessWidget {
  const CustomContainerList(this.list, this.width, this.height, {Key? key})
      : super(key: key);

  final Widget list;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width * width, height: size.height * height, child: list);
  }
}
