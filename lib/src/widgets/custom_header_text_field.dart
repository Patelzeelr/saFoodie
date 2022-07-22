import 'package:flutter/material.dart';

import '../utils/constants/color_constants.dart';

class CustomHeaderTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final Function(String? value) onSubmit;

  const CustomHeaderTextField({
    Key? key,
    required this.hintText,
    required this.maxLines,
    required this.controller,
    this.validator,
    required this.focusNode,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 12.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: kOrange, width: 1.5),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        cursorColor: kOrange,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kGrey, width: 1.0)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kOrange)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: kGrey, width: 1.0)),
          hintText: hintText,
        ),
        onFieldSubmitted: onSubmit,
        maxLines: maxLines,
      ),
    );
  }
}
