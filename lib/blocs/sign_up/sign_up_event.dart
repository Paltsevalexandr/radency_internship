part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpCredentialsSubmitted extends SignUpEvent {
  final String phoneNumber;
  final String email;
  final String username;

  SignUpCredentialsSubmitted({@required this.phoneNumber, @required this.email, @required this.username});

  @override
  List<Object> get props => [phoneNumber, email, username];
}

class SignUpOtpSubmitted extends SignUpEvent {
  final String oneTimePassword;

  SignUpOtpSubmitted({@required this.oneTimePassword});

  @override
  List<Object> get props => [oneTimePassword];
}

class SignUpWrongNumberPressed extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SignUpSignInWithPhoneCredentialCalled extends SignUpEvent {
  final AuthCredential authCredential;

  SignUpSignInWithPhoneCredentialCalled({@required this.authCredential});

  @override
  List<Object> get props => [authCredential];
}

class SignUpCodeSent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SignUpVerificationFailed extends SignUpEvent {
  final FirebaseAuthException exception;

  SignUpVerificationFailed({@required this.exception});

  @override
  List<Object> get props => [exception];
}
