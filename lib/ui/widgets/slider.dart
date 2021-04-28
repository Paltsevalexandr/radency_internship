import 'package:flutter/material.dart';

class DateRangeSlider extends StatelessWidget {
  final String content;
  final Function onBackPressed;
  final Function onForwardPressed;

  DateRangeSlider({@required this.content, @required this.onBackPressed, @required this.onForwardPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        Text(
          content,
          style: TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: onForwardPressed,
          icon: Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
