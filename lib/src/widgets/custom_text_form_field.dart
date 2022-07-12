import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String? value) onSubmit;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.focusNode,
    required this.onSubmit,
    required this.controller,
    this.validator,
    this.textInputType,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(
          0xFFf8f9fa,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF858585).withOpacity(0.2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        controller: widget.controller,
        onFieldSubmitted: widget.onSubmit,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType,
        cursorColor: Colors.orangeAccent,
        style: const TextStyle(color: Colors.black),
        obscureText: _isObscureText(),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent)),
          suffixIcon: widget.hintText.contains('Password')
              ? IconButton(
                  icon: Icon(
                    _isVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (widget.hintText.contains('Password')) {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  bool _isObscureText() {
    if (!_isVisible) {
      if (widget.hintText.contains("Password")) {
        return true;
      }
    }
    return false;
  }
}
