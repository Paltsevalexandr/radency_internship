import 'package:flutter/material.dart';
import 'package:flutter_app/registration/bloc.dart';

class RegistrationForm extends StatelessWidget {

  final Map user = {};
  final _registrationBloc = RegistrationBloc();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

 
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  RegistrationForm(){
    _focusName.addListener(() {
      if(!_focusName.hasFocus) {
        _registrationBloc.handleData('name', _nameController.text);
      }
    });

    _focusEmail.addListener(() {
      if(!_focusEmail.hasFocus) {
        _registrationBloc.handleData('email', _emailController.text);
      }
    });
    _focusPhone.addListener(() {
      if(!_focusEmail.hasFocus) {
        _registrationBloc.handleData('phone', _phoneContoller.text);
      }
    });
    _focusPassword.addListener(() {
      if(!_focusPassword.hasFocus) {
        _registrationBloc.handleData('password', _passwordController.text);
      }
    });
    _focusConfirmPassword.addListener(() {
      if(!_focusPassword.hasFocus) {
        _registrationBloc.handleData('confirm_password', _confirmPasswordController.text);
      }
    });
    
  }

  Widget createNameInput() {
    
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        focusNode: _focusName,
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          RegExp regExp = RegExp(r"^[\wА-Яа-я]+$");

          if (regExp.hasMatch(value) && value.length <= 70) {
            return null;

          }
          return 'Print name. Only letters, digits, symbol "_"\nand max 70 symbols';
        }
      )
    );
  }

  Widget createEmailInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        focusNode: _focusEmail,
        controller: _emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'email',
        ),
        validator: (value) {
          RegExp regExp = RegExp(r"^[\wА-Яа-я]+@[\wА-Яа-я]+\.[A-Za-z]{2,4}$");

          if (regExp.hasMatch(value)) {
            return null;
          }
          return 'Print email';
        },
      )
    );
  }

  Widget createPhoneInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _phoneContoller,
        focusNode: _focusPhone,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'phone',
        ),
        validator: (value) {
          RegExp regExp = RegExp(r"^(\+38)\s?\d{3}\s?\d{3}\s?\d{2}\s?\d{2}$");
          if (regExp.hasMatch(value)) {
            return null;
            
          }
          return 'Please enter a number in right format +3 xxx xxx xx xx';
        }
      )
    );
  }

  Widget createPasswordInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        focusNode: _focusPassword,
        controller: _passwordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'password',
        ),
        validator: (value) {
          if(value.length >= 5) {
            return null;
          }
          return 'password must contain at least 5 symbols';
        },
      )
    );
  }

  Widget createConfirmPassword(password) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        focusNode: _focusConfirmPassword,
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'confirm password',
        ),
        validator: (value) {
          if (value == password) {
            return null;
            
          }
          return 'Passwords are not similar';
        }
      )
    );
  }
  
  Widget createSubmitButton(_formKey) {
    return Container(
      width: 60,
      height: 30,
      margin: EdgeInsets.only(right: 5),
      child: ElevatedButton(
        onPressed: () => {
          if(_formKey.currentState.validate()) {
            print('good')
          }
        },
        child:  Text(
          'Create account',
          style: TextStyle(color: Colors.black)
        )
      ),
    );
  }
  
  Widget build(BuildContext context) {
    final _formKey = GlobalKey();
    //final _registrationBloc = BlocProvider.of<RegistrationBloc>(context);

    return Container(
      margin: EdgeInsets.all(20),
      child: StreamBuilder(
        stream: _registrationBloc.userStream,
        initialData: {},
        builder: (context, snapshot) {
          var data = snapshot.data;
          return Form(
            key: _formKey,
            child:ListView(
              children: [
                Text(data.toString()),
                createNameInput(),
                createEmailInput(),
                createPhoneInput(),
                createPasswordInput(),
                createConfirmPassword(data['password']),
                createSubmitButton(_formKey)
              ]
            )
        );
      }
      )
    );
  }
}
