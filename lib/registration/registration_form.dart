import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/registration/name_input.dart';
import 'package:flutter_app/registration/confirm_password_input.dart';
import 'package:flutter_app/registration/email_input.dart';
import 'package:flutter_app/registration/password_input.dart';
import 'package:flutter_app/registration/phone_input.dart';
import 'package:flutter_app/registration/submit_btn.dart';

class RegistrationForm extends StatelessWidget {
  final _registrationBloc = CounterBloc({});
  
  Widget build(BuildContext context) {
    final _formKey = GlobalKey();

    return Container(
      margin: EdgeInsets.all(20),
      child: 
          StreamBuilder(
            stream: _registrationBloc.pressedCount,
            initialData: _registrationBloc.getData(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              return Form(
                key: _formKey,
                child:ListView(
                  children: [
                    NameInput(_registrationBloc._handleData('name')),
                    EmailInput(_registrationBloc._handleData('email')),
                    PhoneInput(_registrationBloc._handleData('phone')),
                    PasswordInput(_registrationBloc._handleData('password')),
                    ConfirmPasswordInput(data['password'], _registrationBloc._handleData('confirm_password')),
                    SubmitBtn(_formKey)
                  ]
                )
            );
          }
      )
    );
  }
}

class CounterBloc {
  Map _counter;

  CounterBloc(this._counter);

  final _counterStream = StreamController();

  Stream get pressedCount => _counterStream.stream;
  Sink get _addValue => _counterStream.sink;

  Function _handleData(dataType) {
    return (data) {
      _counter[dataType] = data;
      _addValue.add(_counter);
    };
  }
  
  Map getData() {
    return _counter;
  }

  void dispose() {
    _counterStream.close();
  }
}