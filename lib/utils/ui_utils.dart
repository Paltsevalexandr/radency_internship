import 'package:flutter/material.dart';

double pixelsToDP(context, double pixels) {
  var pr = MediaQuery.of(context).devicePixelRatio;
  return pixels/pr;
}