import 'package:flutter/material.dart';

import '../utils/constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: const LinearGradient(
          colors: [kYellow, kOrange],
        ),
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: kWhite),
        ),
      ),
    );
  }
}
