import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class StylizedElevatedButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final Function onPressed;

  StylizedElevatedButton({@required this.child, @required this.backgroundColor, this.borderColor, @required this.onPressed})
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
          side: MaterialStateProperty.all<BorderSide>(
            borderColor == null ? null : BorderSide(width: pixelsToDP(context, 0.3), color: borderColor),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(pixelsToDP(context, 5.0)),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
