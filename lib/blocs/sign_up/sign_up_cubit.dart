import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import '../../repositories/firebase_auth_repository/firebase_auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  String email;
  String username;
  String verificationId;
  int forceCodeResend;

  Future<void> credentialsSubmitted({@required String phoneNumber, @required String email, @required String username}) async {
    emit(state.copyWith(areDetailsProcessing: true));
    this.email = email;
    this.username = username;
    try {
      await _authenticationRepository.startPhoneNumberAuthentication(
          phoneNumber: phoneNumber,
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print('PhoneAuthBloc: verificationCompleted');
            signInWithPhoneCredentialAndUpdateProfile(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exception) {
            emit(state.copyWith(areDetailsProcessing: false, errorMessage: exception.message));
          },
          codeSent: (String verId, [int forceCodeResend]) {
            print('PhoneAuthBloc: codeSent');
            this.forceCodeResend = forceCodeResend;
            verificationId = verId;
            emit(state.copyWith(areDetailsProcessing: false, signUpPageMode: SignUpPageMode.OTP));
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

    signInWithPhoneCredentialAndUpdateProfile(phoneAuthCredential);
  }

  Future<void> wrongNumberPressed() async {
    emit(state.copyWith(signUpPageMode: SignUpPageMode.Credentials));
  }

  Future<void> signInWithPhoneCredentialAndUpdateProfile(AuthCredential authCredential) async {
    try {
      await _authenticationRepository.signUpWithPhoneCredentialAndUpdateProfile(authCredential: authCredential, email: email, username: username);
      emit(state.copyWith(errorMessage: 'Successful'));
    } on PlatformException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }
}
