import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/providers/firebase_auth_service.dart';

part 'email_login_event.dart';

part 'email_login_state.dart';

class EmailLoginBloc extends Bloc<EmailLoginEvent, EmailLoginState> {
  EmailLoginBloc(this._authenticationService)
      : assert(_authenticationService != null),
        super(EmailLoginState());

  final FirebaseAuthenticationService _authenticationService;

  @override
  Stream<EmailLoginState> mapEventToState(
    EmailLoginEvent event,
  ) async* {
    if (event is EmailLoginSubmitted) {
      yield* _mapEmailLoginSubmittedToState(email: event.email, password: event.password);
    }
  }

  Stream<EmailLoginState> _mapEmailLoginSubmittedToState({
    @required String email,
    @required String password,
  }) async* {
    yield state.setDetailsProcessing();

    try {
      await _authenticationService.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      // TODO: localize FB-related errors
      yield state.showError(errorMessage: exception.message);
    } catch (e) {
      yield state.showError(errorMessage: e.toString());
    }
  }
}
