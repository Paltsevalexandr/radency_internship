import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class StylizedElevatedButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function onPressed;

  StylizedElevatedButton({@required this.child, this.backgroundColor = Colors.white, @required this.onPressed, this.foregroundColor = Colors.black})
      : assert(child != null),
        assert(backgroundColor != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 8.0)),
      child: ElevatedButton(
        child: child,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
          textStyle: MaterialStateProperty.all<TextStyle>(
            addTransactionElevatedButtonTitleStyle(context, foregroundColor)
          ),
          side: MaterialStateProperty.all<BorderSide>(
            foregroundColor == null ? null : BorderSide(width: pixelsToDP(context, 0.3), color: foregroundColor),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(pixelsToDP(context, 10.0)),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
