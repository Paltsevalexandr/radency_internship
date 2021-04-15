import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../models/user.dart';

class SignUpFailure implements Exception {}

class LogInWithPhoneNumberFailure implements Exception {}

class SignUpWithPhoneNumberFailure implements Exception {
  final String message;

  SignUpWithPhoneNumberFailure({@required this.message});
}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  Stream<UserEntity> get userFromAuthState {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      print("AuthenticationRepository.user: user changed ${firebaseUser?.uid ?? null}");
      return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
    });
  }

  Stream<UserEntity> get userFromAnyChanges {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      print("AuthenticationRepository.user: user changed ${firebaseUser?.uid ?? null}");
      return firebaseUser == null ? UserEntity.empty : firebaseUser.toUserEntity;
    });
  }

  Future<void> signInWithPhoneCredential({@required AuthCredential authCredential, String email, String username}) async {
    User firebaseUser;
    await _firebaseAuth.signInWithCredential(authCredential).then((value) async {
      firebaseUser = value.user;
      if (firebaseUser.email == null || firebaseUser.displayName == null) {
        // Logging out if user haven't completed registration flow
        await logOut();
        throw SignUpWithPhoneNumberFailure(message: 'This account is not yet registered!');
      }
    });

    await _firebaseAuth.currentUser.reload();

    print("AuthenticationRepository.signInWithPhoneCredentialAndUpdateProfile: ${firebaseUser.uid} ${firebaseUser.displayName}");
  }

  Future<void> signUpWithPhoneCredentialAndUpdateProfile({@required AuthCredential authCredential, String email, String username}) async {
    User firebaseUser;
    await _firebaseAuth.signInWithCredential(authCredential).then((value) {
      firebaseUser = value.user;
    });

    if (firebaseUser.email != null || firebaseUser.displayName != null) {
      throw SignUpWithPhoneNumberFailure(message: 'This account is already registered!');
    }

    await firebaseUser.updateEmail(email);
    await firebaseUser.updateProfile(displayName: username);
    await _firebaseAuth.currentUser.reload();
  }

  Future<void> startPhoneNumberAuthentication({
    @required
        String phoneNumber,
    @required
        codeAutoRetrievalTimeout(String verificationId),
    @required
        verificationFailed(FirebaseAuthException error),
    @required
        codeSent(String verificationId, int forceResendingToken),
    @required
        verificationCompleted(
      PhoneAuthCredential phoneAuthCredential,
    ),
    int forceResendingToken,
  }) async {
    assert(phoneNumber != null && codeAutoRetrievalTimeout != null && verificationFailed != null && codeSent != null && verificationCompleted != null);
    try {
      await _firebaseAuth.verifyPhoneNumber(
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          verificationFailed: verificationFailed,
          phoneNumber: phoneNumber,
          codeSent: codeSent,
          forceResendingToken: forceResendingToken,
          verificationCompleted: verificationCompleted);
    } on Exception {
      throw LogInWithPhoneNumberFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  UserEntity get toUserEntity {
    return UserEntity(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
