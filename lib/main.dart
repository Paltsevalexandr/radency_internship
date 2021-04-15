import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ru', ''),
      ],
      home: Scaffold(
        body: App(authenticationRepository: AuthenticationRepository()),
        bottomNavigationBar: BottomNavBar(),
      )
    ));
}