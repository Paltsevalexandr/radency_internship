import 'package:flutter/material.dart';

double pixelsToDP(context, double pixels) {
  var pr = MediaQuery.of(context).devicePixelRatio;
  return pixels/pr;
}

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message)),
    );
}