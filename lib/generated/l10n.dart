// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Example EN Title`
  String get exampleTitle {
    return Intl.message(
      'Example EN Title',
      name: 'exampleTitle',
      desc: '',
      args: [],
    );
  }

  /// `App Title`
  String get appTitle {
    return Intl.message(
      'App Title',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your phone number`
  String get yourPhoneNumber {
    return Intl.message(
      'Your phone number',
      name: 'yourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginToolbarTitle {
    return Intl.message(
      'Login',
      name: 'loginToolbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get loginButton {
    return Intl.message(
      'LOGIN',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Don't have account?`
  String get noAccount {
    return Intl.message(
      'Don\'t have account?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create a new!`
  String get createNewAccount {
    return Intl.message(
      'Create a new!',
      name: 'createNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter the number in international format`
  String get incorrectPhoneNumber {
    return Intl.message(
      'Enter the number in international format',
      name: 'incorrectPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `One-time password was sent to the number: `
  String get otpPassSendToNumber {
    return Intl.message(
      'One-time password was sent to the number: ',
      name: 'otpPassSendToNumber',
      desc: '',
      args: [],
    );
  }

  /// `Wrong number?`
  String get wrongNumber {
    return Intl.message(
      'Wrong number?',
      name: 'wrongNumber',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM`
  String get confirmButton {
    return Intl.message(
      'CONFIRM',
      name: 'confirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect otp password!`
  String get otpIncorrectPassword {
    return Intl.message(
      'Incorrect otp password!',
      name: 'otpIncorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign In successful!`
  String get signInSuccessful {
    return Intl.message(
      'Sign In successful!',
      name: 'signInSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Spending`
  String get spending {
    return Intl.message(
      'Spending',
      name: 'spending',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get mondayShort {
    return Intl.message(
      'Mon',
      name: 'mondayShort',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get tuesdayShort {
    return Intl.message(
      'Tue',
      name: 'tuesdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get wednesdayShort {
    return Intl.message(
      'Wed',
      name: 'wednesdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get thursdayShort {
    return Intl.message(
      'Thu',
      name: 'thursdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get fridayShort {
    return Intl.message(
      'Fri',
      name: 'fridayShort',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get saturdayShort {
    return Intl.message(
      'Sat',
      name: 'saturdayShort',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get sundayShort {
    return Intl.message(
      'Sun',
      name: 'sundayShort',
      desc: '',
      args: [],
    );
  }

  /// `Jan.`
  String get januaryShort {
    return Intl.message(
      'Jan.',
      name: 'januaryShort',
      desc: '',
      args: [],
    );
  }

  /// `Feb.`
  String get februaryShort {
    return Intl.message(
      'Feb.',
      name: 'februaryShort',
      desc: '',
      args: [],
    );
  }

  /// `Mar.`
  String get marchShort {
    return Intl.message(
      'Mar.',
      name: 'marchShort',
      desc: '',
      args: [],
    );
  }

  /// `Apr.`
  String get aprilShort {
    return Intl.message(
      'Apr.',
      name: 'aprilShort',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get mayShort {
    return Intl.message(
      'May',
      name: 'mayShort',
      desc: '',
      args: [],
    );
  }

  /// `Jun.`
  String get juneShort {
    return Intl.message(
      'Jun.',
      name: 'juneShort',
      desc: '',
      args: [],
    );
  }

  /// `Jul.`
  String get julyShort {
    return Intl.message(
      'Jul.',
      name: 'julyShort',
      desc: '',
      args: [],
    );
  }

  /// `Aug.`
  String get augustShort {
    return Intl.message(
      'Aug.',
      name: 'augustShort',
      desc: '',
      args: [],
    );
  }

  /// `Sep.`
  String get septemberShort {
    return Intl.message(
      'Sep.',
      name: 'septemberShort',
      desc: '',
      args: [],
    );
  }

  /// `Oct.`
  String get octoberShort {
    return Intl.message(
      'Oct.',
      name: 'octoberShort',
      desc: '',
      args: [],
    );
  }

  /// `Nov.`
  String get novemberShort {
    return Intl.message(
      'Nov.',
      name: 'novemberShort',
      desc: '',
      args: [],
    );
  }

  /// `Dec.`
  String get decemberShort {
    return Intl.message(
      'Dec.',
      name: 'decemberShort',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get transactionsTabTitleDaily {
    return Intl.message(
      'Daily',
      name: 'transactionsTabTitleDaily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get transactionsTabTitleWeekly {
    return Intl.message(
      'Weekly',
      name: 'transactionsTabTitleWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get transactionsTabTitleMonthly {
    return Intl.message(
      'Monthly',
      name: 'transactionsTabTitleMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get transactionsTabTitleSummary {
    return Intl.message(
      'Summary',
      name: 'transactionsTabTitleSummary',
      desc: '',
      args: [],
    );
  }

  /// ` Account`
  String get transactionsTabTitleAccount {
    return Intl.message(
      ' Account',
      name: 'transactionsTabTitleAccount',
      desc: '',
      args: [],
    );
  }

  /// `Export data to Excel`
  String get transactionsTabButtonExportToExcel {
    return Intl.message(
      'Export data to Excel',
      name: 'transactionsTabButtonExportToExcel',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Expenses (Cash, Accounts)`
  String get transactionsTabButtonExpensesCashAccounts {
    return Intl.message(
      'Expenses (Cash, Accounts)',
      name: 'transactionsTabButtonExpensesCashAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Expenses (Credit Cards)`
  String get transactionsTabButtonExpensesCreditCards {
    return Intl.message(
      'Expenses (Credit Cards)',
      name: 'transactionsTabButtonExpensesCreditCards',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}