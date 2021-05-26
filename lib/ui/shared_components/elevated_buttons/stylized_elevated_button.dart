import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class StylizedElevatedButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function onPressed;

  StylizedElevatedButton({@required this.child, this.backgroundColor = Colors.white, @required this.onPressed, this.foregroundColor})
      : assert(child != null),
        assert(backgroundColor != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ElevatedButton(
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          foregroundColor: MaterialStateProperty.all<Color>(foregroundColor == null ? Theme.of(context).accentColor : foregroundColor),
          textStyle: MaterialStateProperty.all<TextStyle>(
            addTransactionElevatedButtonTitleStyle(context, foregroundColor == null ? Theme.of(context).accentColor : foregroundColor)
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(width: 1, color: foregroundColor == null ? Theme.of(context).accentColor : foregroundColor),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          shadowColor: MaterialStateProperty.all(Colors.transparent)
        ),
        onPressed: onPressed,
      ),
    );
  }
}
