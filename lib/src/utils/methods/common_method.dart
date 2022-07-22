import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//focus method
void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

//toast message display method
final toast = FToast();

showMessage(String message) => toast.showToast(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.orangeAccent,
        ),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    ));

//navigation method
Route createRoute(route) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => route,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
