import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/routes.dart';

class FloatingButtonsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        Navigator.of(context).pushNamed(Routes.addTransactionPage);
      },
      child: Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}