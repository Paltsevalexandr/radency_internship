import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/repositories/firebase_auth_repository/firebase_auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  String verificationId;
  int forceCodeResend;

  Future<void> credentialsSubmitted({
    @required String phoneNumber,
  }) async {
    emit(state.copyWith(areDetailsProcessing: true));

    try {
      await _authenticationRepository.startPhoneNumberAuthentication(
          phoneNumber: phoneNumber,
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print('PhoneAuthBloc: verificationCompleted');
            signInWithPhoneCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exception) {
            emit(state.copyWith(areDetailsProcessing: false, errorMessage: exception.message));
          },
          codeSent: (String verId, [int forceCodeResend]) {
            print('PhoneAuthBloc: codeSent');
            this.forceCodeResend = forceCodeResend;
            verificationId = verId;
            emit(state.copyWith(areDetailsProcessing: false, loginPageMode: LoginPageMode.OTP));
          },
          forceResendingToken: forceCodeResend,
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on PlatformException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }

  Future<void> otpSubmitted({@required String oneTimePassword}) async {
    emit(state.copyWith(isOTPProcessing: true));

    final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: oneTimePassword,
    );

    await signInWithPhoneCredential(phoneAuthCredential);
  }

  Future<void> wrongNumberPressed() async {
    emit(state.copyWith(loginPageMode: LoginPageMode.Credentials));
  }

  Future<void> signInWithPhoneCredential(AuthCredential authCredential) async {
    try {
      await _authenticationRepository.signInWithPhoneCredential(authCredential: authCredential);
      emit(state.copyWith(errorMessage: 'Welcome'));
    } on PlatformException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }
}
