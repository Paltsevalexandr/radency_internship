part of 'email_login_bloc.dart';

abstract class EmailLoginEvent extends Equatable {
  const EmailLoginEvent();
}

class EmailLoginSubmitted extends EmailLoginEvent {
  final String email;
  final String password;

  EmailLoginSubmitted({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
