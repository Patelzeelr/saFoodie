import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
