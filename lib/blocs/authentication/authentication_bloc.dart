import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radency_internship_project_2/models/user.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/repositories/firebase_auth_repository/firebase_auth_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userAuthStateSubscription = _authenticationRepository.userFromAnyChanges.listen((userChanged) {

      /// Listens to changes of current firebase user (log in/log out/profile details modifying)
      /// Triggers change to auth state (means global navigation between homepage and sign in/sign up pages) ONLY if one of the following requirement is met:
      /// - user logged out;
      /// - user was not authenticated and firebase emitted user with complete profile.
      ///
      /// "Complete" in context of current app means that user completed registration flow, providing their e-mail and username as well verifying their phone
      /// number.
      ///
      /// Problem lays in fact, that verifying a phone number (for firebase user account) serves as sign in AND sign up (if profile wasn't previously
      /// created) at the same time. Thus firebase don't provide ability to set profile details while verifying phone number, so we must to populate them after
      /// receiving instance of FirebaseUser.
      ///
      /// This check made to prevent opening homepage with uncompleted user profile and to return to login page in case if user logs out.

      // TODO: if this looks messy consider changing way of listening to FBUser changes

      bool userLoggedOut = userChanged == UserEntity.empty;
      bool userWasNotAuthenticated = this.user == UserEntity.empty;
      bool newUserIsRegistered = userChanged?.name != null && userChanged?.email != null;
      print("AuthenticationBloc.AuthenticationBloc: userLoggedOut $userLoggedOut ${userChanged.toString()}"
          "userWasNotAuthenticated $userWasNotAuthenticated newUserIsRegistered $newUserIsRegistered");
      if (userLoggedOut || (userWasNotAuthenticated && newUserIsRegistered)) add(AuthenticationUserChanged(userChanged));
    });
  }

  UserEntity user = UserEntity.empty;

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserEntity> _userAuthStateSubscription;

  @override
  Future<void> close() {
    _userAuthStateSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event.user);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    UserEntity userChanged,
  ) {
    if (userChanged == null || userChanged == UserEntity.empty) {
      user = UserEntity.empty;
      return const AuthenticationState.unauthenticated();
    } else {
      print("AuthenticationBloc._mapAuthenticationUserChangedToState: $userChanged");
      user = userChanged;
      return AuthenticationState.authenticated(user);
    }
  }
}
