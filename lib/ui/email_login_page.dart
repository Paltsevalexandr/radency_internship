import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/login/email_login/email_login_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';
import 'package:radency_internship_project_2/ui/widgets/centered_scroll_view.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class EmailLoginPage extends StatelessWidget {
  const EmailLoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.loginToolbarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<EmailLoginBloc>(
          create: (_) => EmailLoginBloc(context.read<FirebaseAuthenticationService>()),
          child: EmailLoginForm(),
        ),
      ),
    );
  }
}

class EmailLoginForm extends StatefulWidget {
  const EmailLoginForm({Key key}) : super(key: key);

  @override
  _EmailLoginFormState createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  static const double _padding = 8.0;

  String _email;
  String _password;

  static final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailLoginBloc, EmailLoginState>(
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
        return loginContent();
      },
    );
  }

  Widget loginContent() {
    return CenteredScrollView(
      child: Column(
        children: [
          SizedBox(
            height: pixelsToDP(context, 15.0),
          ),
          Text(
            S.current.loginWelcomeText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: pixelsToDP(context, 15.0),
          ),
          Text(
            S.current.loginNoticeText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: pixelsToDP(context, 80),
          ),
          _loginForms(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [forgotButton()],
          ),
          _submitButton(),
          _newAccountSection(),
        ],
      ),
    );
  }

  Widget _loginForms() {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailField(),
            _passwordField(),
          ],
        ),
      ],
    );
  }

  Widget forgotButton() {
    return TextButton(
      child: Text(S.current.loginForgotPasswordButton),
      onPressed: () {
        // TODO: implement password restore
      },
    );
  }

  Widget _newAccountSection() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(S.current.loginNoAccountNotice),
        TextButton(
          child: Text(S.current.loginCreateAccountButton),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.signUpPage);
          },
        ),
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
              labelText: S.current.loginEmailLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              prefixIcon: Icon(Icons.email)),
          validator: (val) {
            if (val.trim().isEmpty) {
              return S.current.loginEmailValidatorEmpty;
            }

            if (!RegExp(emailRegExp).hasMatch(val)) {
              return S.current.loginEmailValidatorIncorrect;
            }

            return null;
          },
          onSaved: (value) => _email = value,
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
              labelText: S.current.loginPasswordLabelText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              prefixIcon: Icon(Icons.lock)),
          validator: (val) {
            if (val.trim().isEmpty) {
              return S.current.loginPasswordValidatorEmpty;
            }

            return null;
          },
          onSaved: (value) => _password = value,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<EmailLoginBloc, EmailLoginState>(
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
                      context.read<EmailLoginBloc>().add(EmailLoginSubmitted(
                            email: _email,
                            password: _password,
                          ));
                    }
                  },
            child: state.areDetailsProcessing
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(),
                  )
                : Text(S.current.loginSubmitButton),
          ),
        );
      },
    );
  }

  void _saveForms() {
    _emailFormKey.currentState.save();
    _passwordFormKey.currentState.save();
  }

  bool _validateForms() {
    bool result = true;

    if (!_emailFormKey.currentState.validate()) {
      result = false;
    }
    if (!_passwordFormKey.currentState.validate()) {
      result = false;
    }

    return result;
  }
}
