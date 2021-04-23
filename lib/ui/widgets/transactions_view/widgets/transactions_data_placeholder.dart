import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class TransactionsDataPlaceholder extends StatelessWidget {
  final String text;

  TransactionsDataPlaceholder({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(pixelsToDP(context, 8.0)),
        child: Text(text),
      ),
    );
  }
}
