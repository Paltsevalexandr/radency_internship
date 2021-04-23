import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class DataLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(pixelsToDP(context, 8.0)),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
