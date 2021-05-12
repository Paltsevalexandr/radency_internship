import 'dart:math';
import 'package:flutter/material.dart';

List<CustomColor> randomColors(colorsNumber) {
  List<CustomColor> colors = [];

  for(int i = 0; i < colorsNumber; i++) {
    colors.add(CustomColor(
      r: Random().nextInt(255),
      g: Random().nextInt(255),
      b: Random().nextInt(255)
    ));
  }

  return colors;
}


class CustomColor {
  CustomColor({this.r, this. g, this.b});
  int r;
  int g;
  int b;
  double o = 1;

  Color rgboColor() {
    return Color.fromRGBO(r, g, b, o);
  }
}
