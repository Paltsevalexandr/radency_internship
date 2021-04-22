import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:radency_internship_project_2/blocs/sign_up/sign_up_bloc.dart';
import 'package:radency_internship_project_2/repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'package:radency_internship_project_2/utils/strings.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(context.read<AuthenticationRepository>()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;
  String _phoneNumber;
  String _username;
  String _oneTimePassword;

  bool otpHasError = false;

  TextEditingController codeController;

  StreamController<ErrorAnimationType> errorController;

  static const double _padding = 4.0;

  @override
  void initState() {
    super.initState();
    if (errorController == null || !errorController.hasListener) errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
        }
      },
      builder: (context, state) {
        switch (state.signUpPageMode) {
          case SignUpPageMode.Credentials:
            return _signUpDetails();
            break;
          case SignUpPageMode.OTP:
            return _otpInput();
            break;
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _signUpDetails() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'A one-time password will be sent to your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              _detailsForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsForm() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_phoneNumberField(), _emailField(), _usernameField()],
              )),
          ElevatedButton(
            onPressed: state.areDetailsProcessing
                ? null
                : () {
                    _formKey.currentState.save();

                    if (_formKey.currentState.validate()) {
                      if (!errorController.isClosed) {
                        print('_PhoneAuthScreenState: !errorController.isClosed');
                        errorController.close();
                      }
                      errorController = StreamController<ErrorAnimationType>();
                      context.read<SignUpBloc>().add(SignUpCredentialsSubmitted(phoneNumber: _phoneNumber, email: _email, username: _username));
                    }
                  },
            child: state.areDetailsProcessing
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(),
                  )
                : Text('Sign up'),
          )
        ],
      );
    });
  }

  Widget _phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        initialValue: _phoneNumber?.replaceAll('+', '') ?? '',
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefix: Text('+'),
            helperText: '',
            labelText: 'Phone number in international format',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return 'Enter phone number';

          if (!RegExp(phoneNumberRegExp).hasMatch(val)) return 'Enter correct phone number';

          return null;
        },
        onSaved: (value) => _phoneNumber = '+$value',
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        initialValue: _email ?? '',
        decoration: InputDecoration(helperText: '', labelText: 'E-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return 'Enter e-mail';

          if (!RegExp(emailRegExp).hasMatch(val)) return 'Enter correct email';

          return null;
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _padding),
      child: TextFormField(
        initialValue: _username ?? '',
        decoration: InputDecoration(helperText: '', labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return 'Enter username';

          return null;
        },
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget _otpInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 45),
              Text(
                'Please, enter a one-time password that was sent to number:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 25),
              Text(
                _phoneNumber,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 15),
              TextButton(
                child: Text(
                  'Wrong number?',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    context.read<SignUpBloc>().add(SignUpWrongNumberPressed());
                    _oneTimePassword = '';
                  });
                },
              ),
              SizedBox(height: 45),
              _pinCodeField(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  otpHasError ? 'Please, enter a correct one-time password' : "",
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              verifyOtpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: new PinCodeTextField(
        appContext: context,
        autoFocus: true,
        length: 6,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          selectedColor: Theme.of(context).accentColor,
          selectedFillColor: Colors.blueGrey,
          inactiveFillColor: Theme.of(context).scaffoldBackgroundColor,
          inactiveColor: Theme.of(context).disabledColor,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: codeController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
          setState(() {
            _oneTimePassword = value;
          });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return false;
        },
      ),
    );
  }

  Widget verifyOtpSection() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Container(
        child: TextButton(
          onPressed: state.isOTPProcessing
              ? null
              : () {
                  if (_oneTimePassword?.length != 6) {
                    errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                    setState(() {
                      otpHasError = true;
                    });
                  } else {
                    context.read<SignUpBloc>().add(SignUpOtpSubmitted(oneTimePassword: _oneTimePassword));
                  }
                },
          child: state.isOTPProcessing
              ? CircularProgressIndicator()
              : Text(
                  'Continue',
                ),
        ),
      );
    });
  }
}
