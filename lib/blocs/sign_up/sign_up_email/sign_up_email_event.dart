part of 'sign_up_email_bloc.dart';

abstract class SignUpEmailEvent extends Equatable {
  const SignUpEmailEvent();
}

class SignUpEmailSubmitted extends SignUpEmailEvent {
  final String email;
  final String password;
  final String username;

  SignUpEmailSubmitted({@required this.email, @required this.password, @required this.username});

  @override
  List<Object> get props => [email, password, username];
}
