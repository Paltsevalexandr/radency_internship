import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/providers/hive/hive_provider.dart';
import 'providers/firebase_auth_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:radency_internship_project_2/providers/biometric_credentials_service.dart';
import 'package:radency_internship_project_2/providers/hive/hive_provider.dart';

import 'package:radency_internship_project_2/repositories/budgets_repository.dart';

import 'app.dart';
import 'providers/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var directory = await path_provider.getApplicationDocumentsDirectory();
  await HiveProvider().initializeHive(directory.path);

  runApp(App(
    authenticationService: FirebaseAuthenticationService(),
    biometricCredentialsService: BiometricCredentialsService(),
    budgetsRepository: BudgetsRepository(),
  ));
}
