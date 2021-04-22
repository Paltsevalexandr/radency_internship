import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(S.current.loginToolbarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return new LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validate = false;

  bool _otpError = false;
  String _codeText = "";
  String _phoneNumber = "";

  StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    super.initState();
    if (errorController == null || !errorController.hasListener)
      errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Text(S.current.appTitle,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold))),
              Container(
                margin: const EdgeInsets.all(16.0),
                color: Colors.blue,
                width: 80.0,
                height: 80.0,
                child: Center(
                    child: Text('Logo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold))),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                constraints: const BoxConstraints(maxWidth: 500),
                child: _validate ? otpPassInput() : phoneNumberInput(),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneNumberInput() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
              initialValue: _phoneNumber?.replaceAll('+', '') ?? '',
              validator: (val) {
                print(val);
                if (val.trim().isEmpty)
                  return S.current.enterPhoneNumber;

                if (val.length != 12) {
                  return S.current.incorrectPhoneNumber;
                }

                _phoneNumber = val;

                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: InputDecoration(
                  focusedErrorBorder: getColoredBorder(Colors.red),
                  errorBorder: getColoredBorder(Colors.redAccent),
                  focusedBorder: getColoredBorder(Colors.grey),
                  enabledBorder: getColoredBorder(Colors.grey[300]),
                  prefixText: '+',
                  labelText: S.current.yourPhoneNumber,
                  icon: Icon(Icons.phone_iphone))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    if (!errorController.isClosed) errorController.close();
                    errorController = StreamController<ErrorAnimationType>();

                    _validate = true;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Center(
                  child: Text(S.current.loginButton,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white)),
                ),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                text: S.current.noAccount,
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${S.current.createNewAccount}',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(S.current
                                  .createNewAccount)));
                        })
                ]),
          ),
        ]);
  }

  Widget otpPassInput() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: RichText(
              text: TextSpan(
                  text: S.current.otpPassSendToNumber,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\n+$_phoneNumber',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              child: Text(
                S.current.wrongNumber,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  _validate = false;
                  _codeText = '';
                });
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: PinCodeTextField(
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
                    inactiveFillColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    inactiveColor: Theme.of(context).disabledColor,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  //autoDisposeControllers: false,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _codeText = value;
                    });
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              _otpError
                  ? S.current.otpIncorrectPassword
                  : '',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton(
              onPressed: () {
                if (_codeText?.length != 6) {
                  errorController.add(ErrorAnimationType.shake);
                  setState(() {
                    _otpError = true;
                  });
                } else {
                  final snackBar = SnackBar(
                      content:
                          Text(S.current.signInSuccessful));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    _otpError = false;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Center(
                  child: Text(S.current.confirmButton,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white)),
                ),
              ),
            ),
          ),
        ]);
  }
}

OutlineInputBorder getColoredBorder(Color color) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color,
      ));
}
