import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
        child: SignUpForm(),
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

  bool isInitialScreen = true;

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
    if (isInitialScreen) return signUpDetails();
    return otpInput();
  }

  Widget signUpDetails() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
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

                                if (!RegExp(r'^(?:[+])?[0-9]{10,15}$').hasMatch(val)) return 'Enter correct phone number';

                                return null;
                              },
                              onSaved: (value) => _phoneNumber = '+$value',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: _padding),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              initialValue: _email ?? '',
                              decoration:
                                  InputDecoration(helperText: '', labelText: 'E-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                              validator: (val) {
                                if (val.trim().isEmpty) return 'Enter e-mail';

                                if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(val)) return 'Enter correct email';

                                return null;
                              },
                              onSaved: (value) => _email = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: _padding),
                            child: TextFormField(
                              initialValue: _username ?? '',
                              decoration:
                                  InputDecoration(helperText: '', labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                              validator: (val) {
                                if (val.trim().isEmpty) return 'Enter username';

                                return null;
                              },
                              onSaved: (value) => _username = value,
                            ),
                          )
                        ],
                      )),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState.save();

                      if (_formKey.currentState.validate()) {
                        setState(() {
                          if (!errorController.isClosed) {
                            print('_PhoneAuthScreenState: !errorController.isClosed');
                            errorController.close();
                          }
                          errorController = StreamController<ErrorAnimationType>();
                          isInitialScreen = false;
                        });
                      }
                    },
                    child: Text('Sign up'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget otpInput() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Please, enter a one-time password that was sent to number:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _phoneNumber,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              child: Text(
                'Wrong number?',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  isInitialScreen = true;
                  _oneTimePassword = '';
                });
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
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
              //autoDisposeControllers: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: codeController,
              //focusNode: codeFocusNode,
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
          ),
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
          SizedBox(
            height: 30,
          ),
          Container(
            //color: state.verifyOtpEnabled ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                if (_oneTimePassword?.length != 6) {
                  errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                  setState(() {
                    otpHasError = true;
                  });
                } else {
                  final snackBar = SnackBar(content: Text('Registration successful'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    otpHasError = false;
                  });
                }
              },
              child: Text(
                'Continue',
              ),
            ),
          )
        ],
      ),
    );
  }
}
