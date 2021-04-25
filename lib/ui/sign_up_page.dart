import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import '../blocs/sign_up/sign_up_bloc.dart';
import '../repositories/firebase_auth_repository/firebase_auth_repository.dart';
import '../utils/strings.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.signUpPageTitle)),
      body: Padding(
        padding: EdgeInsets.all(pixelsToDP(context, 8.0)),
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
      padding: EdgeInsets.all(pixelsToDP(context, 15.0)),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: pixelsToDP(context, 400)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.current.signUpCreateAccountHeader,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: pixelsToDP(context, 20),
              ),
              Text(
                S.current.signUpOTPNotice,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: pixelsToDP(context, 80),
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
                : Text(S.current.signUpApplyCredentialsButton),
          )
        ],
      );
    });
  }

  Widget _phoneNumberField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: TextFormField(
        initialValue: _phoneNumber?.replaceAll('+', '') ?? '',
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            prefix: Text('+'),
            helperText: '',
            labelText: S.current.signUpPhoneNumberLabelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return S.current.signUpPhoneNumberValidatorEmpty;

          if (!RegExp(phoneNumberRegExp).hasMatch(val)) return S.current.signUpPhoneNumberValidatorIncorrect;

          return null;
        },
        onSaved: (value) => _phoneNumber = '+$value',
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        initialValue: _email ?? '',
        decoration:
            InputDecoration(helperText: '', labelText: S.current.signUpEmailLabelText, border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return S.current.signUpEmailValidatorEmpty;

          if (!RegExp(emailRegExp).hasMatch(val)) return S.current.signUpEmailValidatorIncorrect;

          return null;
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: TextFormField(
        initialValue: _username ?? '',
        decoration:
            InputDecoration(helperText: '', labelText: S.current.signUpUsernameLabelText, border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        validator: (val) {
          if (val.trim().isEmpty) return S.current.signUpUsernameValidatorEmpty;

          return null;
        },
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget _otpInput() {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 15.0)),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: pixelsToDP(context, 400)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: pixelsToDP(context, 45)),
              Text(
                S.current.signUpOTPSentNotice,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: pixelsToDP(context, 25)),
              Text(
                _phoneNumber,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: pixelsToDP(context, 15)),
              TextButton(
                child: Text(
                  S.current.signUpWrongNumberButton,
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    context.read<SignUpBloc>().add(SignUpWrongNumberPressed());
                    _oneTimePassword = '';
                  });
                },
              ),
              SizedBox(height: pixelsToDP(context, 45)),
              _pinCodeField(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: pixelsToDP(context, 15.0)),
                child: Text(
                  otpHasError ? S.current.signUpOTPValidatorIncorrect : "",
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: pixelsToDP(context, 30)),
              verifyOtpSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pixelsToDP(context, 15.0)),
      child: new PinCodeTextField(
        appContext: context,
        autoFocus: true,
        length: 6,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: pixelsToDP(context, 50),
          fieldWidth: pixelsToDP(context, 40),
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
        onCompleted: (v) {},
        onChanged: (value) {
          print(value);
          setState(() {
            _oneTimePassword = value;
          });
        },
        beforeTextPaste: (text) {
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
                  S.current.signUpOTPContinueButton,
                ),
        ),
      );
    });
  }
}
