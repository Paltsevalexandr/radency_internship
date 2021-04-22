part of 'sign_up_bloc.dart';

enum SignUpPageMode { Credentials, OTP }

class SignUpState extends Equatable {
  const SignUpState({this.signUpPageMode = SignUpPageMode.Credentials, this.errorMessage, this.areDetailsProcessing = false, this.isOTPProcessing = false});

  final SignUpPageMode signUpPageMode;
  final String errorMessage;
  final bool areDetailsProcessing;
  final bool isOTPProcessing;

  @override
  List<Object> get props => [signUpPageMode, errorMessage, areDetailsProcessing, isOTPProcessing];

  SignUpState onNumberProcessing() {
    return copyWith(areDetailsProcessing: true);
  }

  SignUpState onWrongNumber() {
    return copyWith(signUpPageMode: SignUpPageMode.Credentials);
  }

  SignUpState onNumberSubmitted() {
    return copyWith(areDetailsProcessing: false, signUpPageMode: SignUpPageMode.OTP);
  }

  SignUpState onOtpStartProcessing() {
    return copyWith(isOTPProcessing: true);
  }

  SignUpState showError(String message) {
    return copyWith(errorMessage: message);
  }

  SignUpState copyWith({
    SignUpPageMode signUpPageMode,
    String errorMessage,
    bool areDetailsProcessing,
    bool isOTPProcessing,
  }) {
    return SignUpState(
        signUpPageMode: signUpPageMode ?? this.signUpPageMode,
        errorMessage: errorMessage ?? null,
        areDetailsProcessing: areDetailsProcessing ?? false,
        isOTPProcessing: isOTPProcessing ?? false);
  }
}
