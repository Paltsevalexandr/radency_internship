import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/login/login_cubit.dart';
import 'package:radency_internship_project_2/repositories/firebase_auth_repository/firebase_auth_repository.dart';
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
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
      }
    }, builder: (context, state) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              state.isOTPProcessing || state.areDetailsProcessing
                  ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      child: () {
                        switch (state.loginPageMode) {
                          case LoginPageMode.Credentials:
                            return Text('Test Login');
                            break;
                          case LoginPageMode.OTP:
                            return Text('Test Submit OTP');
                            break;
                        }
                      }(),
                      onPressed: () {
                        if (state.isOTPProcessing || state.areDetailsProcessing) return null;

                        switch (state.loginPageMode) {
                          case LoginPageMode.Credentials:
                            return context.read<LoginCubit>().credentialsSubmitted(phoneNumber: '+12345678901');
                            break;
                          case LoginPageMode.OTP:
                            return context.read<LoginCubit>().otpSubmitted(oneTimePassword: '111111');
                            break;
                        }
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
    });
  }
}
