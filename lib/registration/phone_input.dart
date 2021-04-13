import 'package:flutter/material.dart';

class PhoneInput extends StatelessWidget {
  final edit;

  PhoneInput(this.edit);

  Widget build(BuildContext context) {
    return (
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          onChanged: edit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'phone',
          ),
          validator: (value) {
            RegExp regExp = RegExp(r"^(\+38)\s?\d{3}\s?\d{3}\s?\d{2}\s?\d{2}$");
            if (regExp.hasMatch(value)) {
              return null;
              
            }
            return 'Please enter a number in right format +3 xxx xxx xx xx';
          }
        )
      )
    );
  }
}
