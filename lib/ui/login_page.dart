import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/authentication/authentication_bloc.dart';
import 'package:radency_internship_project_2/models/user.dart';
import 'package:radency_internship_project_2/ui/sign_up_page.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Log in'),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationUserChanged(User(email: 'example@mail.com', id: 'qwety', name: 'John Doe', photo: null)));
              },
            ),
            ElevatedButton(
              child: Text('Sign up'),
              onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
            ),
          ],
        ),
      ),
    );
  }
}
