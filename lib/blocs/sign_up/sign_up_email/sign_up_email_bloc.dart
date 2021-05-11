import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';

part 'sign_up_email_event.dart';

part 'sign_up_email_state.dart';

class SignUpEmailBloc extends Bloc<SignUpEmailEvent, SignUpEmailState> {
  SignUpEmailBloc(this._authenticationService)
      : assert(_authenticationService != null),
        super(SignUpEmailState());

  final FirebaseAuthenticationService _authenticationService;

  @override
  Stream<SignUpEmailState> mapEventToState(SignUpEmailEvent event) async* {
    if (event is SignUpEmailSubmitted) {
      yield* _mapSignUpEmailSubmittedToState(email: event.email, password: event.password, username: event.username);
    }
  }

  Stream<SignUpEmailState> _mapSignUpEmailSubmittedToState({
    @required String email,
    @required String password,
    @required String username,
  }) async* {
    yield state.setDetailsProcessing();

    try {
      await _authenticationService.signUpWithEmailAndPassword(email: email, password: password, username: username);
    } on FirebaseAuthException catch (exception) {
      // TODO: localize FB-related errors
      yield state.showError(errorMessage: exception.message);
    } catch (e) {
      yield state.showError(errorMessage: e.toString());
    }
  }
}
