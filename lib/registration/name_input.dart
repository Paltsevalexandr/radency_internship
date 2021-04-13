import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  final edit;

  NameInput(this.edit);

  Widget build (BuildContext context) {
    return (
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: TextFormField(
          onChanged: edit,
          decoration: InputDecoration(
            labelText: 'name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            RegExp regExp = RegExp(r"^[\wА-Яа-я]+$");

            if (regExp.hasMatch(value) && value.length <= 70) {
              return null;

            }
            return 'Print name. Only letters, digits, symbol "_"\nand max 70 symbols';
          }
        )
      )
    );
  }
}