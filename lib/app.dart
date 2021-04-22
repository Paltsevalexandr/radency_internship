import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import 'package:radency_internship_project_2/blocs/user_profile/user_profile_bloc.dart';
import 'package:radency_internship_project_2/repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'package:radency_internship_project_2/ui/home_page.dart';
import 'package:radency_internship_project_2/ui/login_page_template.dart';
import 'package:radency_internship_project_2/ui/sign_up_page.dart';
import 'package:radency_internship_project_2/ui/splash.dart';
import 'package:radency_internship_project_2/utils/routes.dart';

import 'blocs/authentication/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => UserProfileBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => TransactionsDailyBloc()..add(TransactionsDailyInitialize()),
          ),
          BlocProvider(
            create: (_) => TransactionsWeeklyBloc()..add(TransactionsWeeklyInitialize()),
          ),
          BlocProvider(
            create: (_) => TransactionsMonthlyBloc()..add(TransactionsMonthlyInitialize()),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      routes: {
        Routes.loginPage: (context) => LoginPage(),
        Routes.homePage: (context) => HomePage(),
        Routes.signUpPage: (context) => SignUpPage(),
        Routes.splashScreen: (context) => SplashPage(),
      },
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
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil(Routes.homePage, (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil(Routes.loginPage, (route) => false);
                break;
              default:
                _navigator.pushNamedAndRemoveUntil(Routes.splashScreen, (route) => false);
                break;
            }
          },
          child: child,
        );
      },
    );
  }
}
