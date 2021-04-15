import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'app.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: App(authenticationRepository: AuthenticationRepository()),
        bottomNavigationBar: BottomNavBar(),
      )
    ));
}