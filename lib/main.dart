import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App(authenticationRepository: AuthenticationRepository()));
}