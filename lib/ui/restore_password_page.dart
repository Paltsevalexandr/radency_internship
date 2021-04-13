import 'package:flutter/material.dart';

class RestorePasswordPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RestorePasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restore password')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RestorePasswordForm(),
      ),
    );
  }
}

class RestorePasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: null,
        child: Text('Restore'),
      ),
    );
  }
}
