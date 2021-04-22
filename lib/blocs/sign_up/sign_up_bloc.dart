import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../../repositories/firebase_auth_repository/firebase_auth_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  String email;
  String username;
  String verificationId;
  int forceCodeResend;

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpCredentialsSubmitted) {
      yield* _mapSignUpCredentialsSubmittedToState(phoneNumber: event.phoneNumber, email: event.email, username: event.username);
    } else if (event is SignUpOtpSubmitted) {
      yield* _mapSignUpOtpSubmittedToState(oneTimePassword: event.oneTimePassword);
    } else if (event is SignUpWrongNumberPressed) {
      yield state.onWrongNumber();
    } else if (event is SignUpSignInWithPhoneCredentialCalled) {
      yield* _mapSignUpSignInWithPhoneCredentialAndUpdateProfileCalledToState(event.authCredential);
    } else if (event is SignUpCodeSent) {
      yield state.copyWith(areDetailsProcessing: false, signUpPageMode: SignUpPageMode.OTP);
    } else if (event is SignUpVerificationFailed) {
      yield state.copyWith(areDetailsProcessing: false, errorMessage: event.exception.message);
    }
  }

  Stream<SignUpState> _mapSignUpCredentialsSubmittedToState({@required String phoneNumber, @required String email, @required String username}) async* {
    yield state.onNumberProcessing();

    this.email = email;
    this.username = username;

    try {
      await _authenticationRepository.startPhoneNumberAuthentication(
          phoneNumber: phoneNumber,
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print('PhoneAuthBloc: verificationCompleted');
            add(SignUpSignInWithPhoneCredentialCalled(authCredential: phoneAuthCredential));
          },
          verificationFailed: (FirebaseAuthException exception) {
            add(SignUpVerificationFailed(exception: exception));
          },
          codeSent: (String verId, [int forceCodeResend]) {
            print('PhoneAuthBloc: codeSent');
            this.forceCodeResend = forceCodeResend;
            verificationId = verId;
            add(SignUpCodeSent());
          },
          forceResendingToken: forceCodeResend,
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on PlatformException catch (e) {
      yield state.copyWith(errorMessage: e.message);
    }
  }

  Stream<SignUpState> _mapSignUpOtpSubmittedToState({@required String oneTimePassword}) async* {
    yield state.onOtpStartProcessing();

    final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: oneTimePassword,
    );

    add(SignUpSignInWithPhoneCredentialCalled(authCredential: phoneAuthCredential));
  }

  Stream<SignUpState> _mapSignUpSignInWithPhoneCredentialAndUpdateProfileCalledToState(AuthCredential authCredential) async* {
    try {
      await _authenticationRepository.signUpWithPhoneCredentialAndUpdateProfile(authCredential: authCredential, email: email, username: username);
    } on PlatformException catch (e) {
      yield state.showError(e.message);
    } catch (e) {
      yield state.showError(e.message);
    }
  }
}
