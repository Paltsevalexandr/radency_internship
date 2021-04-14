import 'package:flutter/material.dart';
import 'package:flutter_app/registration/registration_form.dart';
import 'package:flutter_app/registration/bloc.dart';

class RegistrationPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: BlocProvider(
        bloc: RegistrationBloc(),
        child: RegistrationForm(),
      )
    );
  }
}
