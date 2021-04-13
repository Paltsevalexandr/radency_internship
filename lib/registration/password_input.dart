import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final edit;

  PasswordInput(this.edit);

  Widget build(BuildContext context) {
    return (
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          onChanged: edit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'password',
          ),
          validator: (value) {
            if(value.length >= 5) {
              return null;
            }
            return 'password must contain at least 5 symbols';
          },
        )
      )
    );
  }
}