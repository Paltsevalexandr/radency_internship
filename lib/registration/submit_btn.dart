import 'package:flutter/material.dart';

class SubmitBtn extends StatelessWidget {
  final _formKey;

  SubmitBtn(this._formKey);

  Widget build (BuildContext context) {
    
    return (
      Container(
        width: 60,
        height: 30,
        margin: EdgeInsets.only(right: 5),
        child: ElevatedButton(
          onPressed: () => {
            if(_formKey.currentState.validate()) {
              print('good')
            }
          },
          child:  Text(
            'Create account',
            style: TextStyle(color: Colors.black)
          )
        ),
      )
    );
  }
}