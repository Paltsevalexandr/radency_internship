import 'package:flutter/material.dart';

class ConfirmPasswordInput extends StatelessWidget {
  final password;
  final edit;

  ConfirmPasswordInput(this.password, this.edit);

  Widget build(BuildContext context) {
    return (
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          onChanged: edit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'confirm password',
          ),
          validator: (value) {
            if (value == password) {
              return null;
              
            }
            return 'Passwords are not similar';
          }
        )
      )
    );
  }
}