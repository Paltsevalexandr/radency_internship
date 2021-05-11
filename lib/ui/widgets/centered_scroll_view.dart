import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class CenteredScrollView extends StatelessWidget {
  const CenteredScrollView({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: pixelsToDP(context, 15.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: min(400, MediaQuery.of(context).size.width * 0.8)),
          child: this.child,
        ),
      ),
    );
  }
}
