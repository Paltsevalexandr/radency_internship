import 'package:flutter/material.dart';
import 'package:flutter_app/registration/registration_form.dart';

class RegistrationPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: RegistrationForm());
  }
}
