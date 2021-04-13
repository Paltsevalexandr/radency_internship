import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final edit;

  EmailInput(this.edit);

  Widget build(BuildContext context) {
    return(
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          onChanged: edit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email',
          ),
          validator: (value) {
            RegExp regExp = RegExp(r"^[\wА-Яа-я]+@[\wА-Яа-я]+\.[A-Za-z]{2,4}$");

            if (regExp.hasMatch(value)) {
              return null;
            }
            return 'Print email';
          },
        )
      )
    );
  }
}