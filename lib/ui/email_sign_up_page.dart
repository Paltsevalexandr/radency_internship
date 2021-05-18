import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/sign_up/sign_up_email/sign_up_email_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/providers/biometric_credentials_service.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/ui/widgets/centered_scroll_view.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class EmailSignUpPage extends StatelessWidget {
  const EmailSignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpEmailBloc>(
      create: (_) => SignUpEmailBloc(
        context.read<FirebaseAuthenticationService>(),
        context.read<BiometricCredentialsService>(),
      )..add(SignUpEmailInitialize()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.signUpPageTitle),
        ),
        body: EmailSignUpForm(),
      ),
    );
  }
}

class EmailSignUpForm extends StatefulWidget {
  const EmailSignUpForm({Key key}) : super(key: key);

  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  static const double _padding = 8.0;

  String _email;
  String _username;
  String _password;
  String _passwordConfirmation;
  bool _biometricsPairingEnabled = false;

  static final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _passwordConfirmationFormKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpEmailBloc, SignUpEmailState>(
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
        if (state.signUpFlowInitializationStatus) {
          return signUpContent();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget signUpContent() {
    return CenteredScrollView(
      child: Column(
        children: [
          SizedBox(
            height: pixelsToDP(context, 15.0),
          ),
          Text(
            S.current.signUpCreateAccountHeader,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: pixelsToDP(context, 80),
          ),
          _detailsForms(),
        ],
      ),
    );
  }

  Widget _detailsForms() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailField(),
            _usernameField(),
            _passwordField(),
            _passwordConfirmationField(),
            _biometricsPairingCheckbox(),
          ],
        ),
        _submitButton(),
      ],
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: Form(
        key: _emailFormKey,
        child: TextFormField(
          autovalidateMode: autovalidateMode,
          keyboardType: TextInputType.emailAddress,
          initialValue: _email ?? '',
          decoration: InputDecoration(
              helperText: '',
              labelText: S.current.signUpEmailLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (val) {
            if (val.trim().isEmpty) {
              return S.current.signUpEmailValidatorEmpty;
            }

            if (!RegExp(emailRegExp).hasMatch(val)) {
              return S.current.signUpEmailValidatorIncorrect;
            }

            return null;
          },
          onSaved: (value) => _email = value,
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: Form(
        key: _usernameFormKey,
        child: TextFormField(
          autovalidateMode: autovalidateMode,
          initialValue: _username ?? '',
          decoration: InputDecoration(
              helperText: '',
              labelText: S.current.signUpUsernameLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (val) {
            if (val.trim().isEmpty) {
              return S.current.signUpUsernameValidatorEmpty;
            }

            return null;
          },
          onSaved: (value) => _username = value,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: Form(
        key: _passwordFormKey,
        child: TextFormField(
          autovalidateMode: autovalidateMode,
          initialValue: _password ?? '',
          obscureText: true,
          decoration: InputDecoration(
              helperText: '',
              labelText: S.current.signUpPasswordLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (val) {
            if (val.trim().isEmpty) {
              return S.current.signUpPasswordValidatorEmpty;
            }

            return null;
          },
          onSaved: (value) => _password = value,
          onChanged: (value) {
            _password = value;
            _passwordConfirmationFormKey.currentState.validate();
          },
        ),
      ),
    );
  }

  Widget _passwordConfirmationField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
      child: Form(
        key: _passwordConfirmationFormKey,
        child: TextFormField(
          autovalidateMode: autovalidateMode,
          initialValue: _passwordConfirmation ?? '',
          obscureText: true,
          decoration: InputDecoration(
              helperText: '',
              labelText: S.current.signUpPasswordConfirmationLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (val) {
            if (val != _password) {
              return S.current.signUpPasswordConfirmationValidatorNotMatch;
            }

            return null;
          },
          onSaved: (value) => _passwordConfirmation = value,
        ),
      ),
    );
  }

  Widget _biometricsPairingCheckbox() {
    return BlocBuilder<SignUpEmailBloc, SignUpEmailState>(builder: (context, state) {
      if (state.biometricsAvailable) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, _padding)),
          child: Row(
            children: [
              Checkbox(
                  value: _biometricsPairingEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricsPairingEnabled = value;
                    });
                  }),
              Text(S.current.authenticationBiometricsPairCheckbox),
            ],
          ),
        );
      }

      return SizedBox();
    });
  }

  Widget _submitButton() {
    return BlocBuilder<SignUpEmailBloc, SignUpEmailState>(
      builder: (context, state) {
        return Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.areDetailsProcessing
                ? null
                : () {
                    _saveForms();

                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });

                    if (_validateForms()) {
                      context.read<SignUpEmailBloc>().add(SignUpEmailSubmitted(
                            email: _email,
                            password: _password,
                            username: _username,
                            biometricsPairingStatus: _biometricsPairingEnabled,
                          ));
                    }
                  },
            child: state.areDetailsProcessing
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(),
                  )
                : Text(S.current.signUpApplyCredentialsButton),
          ),
        );
      },
    );
  }

  void _saveForms() {
    _emailFormKey.currentState.save();
    _usernameFormKey.currentState.save();
    _passwordFormKey.currentState.save();
    _passwordConfirmationFormKey.currentState.save();
  }

  bool _validateForms() {
    bool result = true;

    if (!_emailFormKey.currentState.validate()) {
      result = false;
    }
    if (!_usernameFormKey.currentState.validate()) {
      result = false;
    }
    if (!_passwordFormKey.currentState.validate()) {
      result = false;
    }
    if (!_passwordConfirmationFormKey.currentState.validate()) {
      result = false;
    }

    return result;
  }
}
