import 'package:flutter/material.dart';

import 'package:radency_internship_project_2/ui/settings_components/settings_subpages/style_setting_page.dart';
import 'package:radency_internship_project_2/blocs/settings/styles/styles_bloc.dart';

import 'package:radency_internship_project_2/blocs/transactions/add_transaction/transaction_location_map/transaction_location_map_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_summary/transactions_summary_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/add_transaction_view_template.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/transaction_location_select_view.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/settings/settings_bloc.dart';

import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';

import 'ui/add_transaction_page.dart';
import 'ui/login_page.dart';
import 'ui/sign_up_page.dart';
import 'ui/splash.dart';
import 'ui/settings_page_template.dart';
import 'ui/spending_page_template.dart';
import 'ui/settings_components/settings_subpages/currency_setting_page.dart';
import 'utils/routes.dart';
import 'blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import 'blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import 'blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import 'blocs/user_profile/user_profile_bloc.dart';
import 'ui/home_page.dart';
import 'generated/l10n.dart';
import 'utils/styles.dart';

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
            create: (BuildContext context) => SettingsBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => StylesBloc(),
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
          BlocProvider(
            create: (_) => TransactionsSummaryBloc()..add(TransactionsSummaryInitialize()),
          ),
          BlocProvider(
            create: (_) => TransactionLocationMapBloc(),
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
    return BlocBuilder<StylesBloc, StylesState>(
        builder: (BuildContext context, state) {
          return MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('ru', ''),
            ],
            themeMode: getThemeMode(state.theme),
            theme: Styles.themeData(context, false, state.lightPrimaryColor),
            darkTheme: Styles.themeData(context, true, state.lightPrimaryColor),
            navigatorKey: _navigatorKey,
            routes: {
              Routes.loginPage: (context) => LoginPage(),
              Routes.homePage: (context) => HomePage(),
              Routes.signUpPage: (context) => SignUpPage(),
              Routes.splashScreen: (context) => SplashPage(),
              Routes.spendingPage: (context) => SpendingPage(),
              Routes.settingsPage: (context) => SettingsPage(),
              Routes.currencySettingPage: (context) => CurrencySettingPage(),
              Routes.addTransactionPage: (context) => AddTransactionPage(),
              Routes.styleSettingPage: (context) => StyleSettingPage(),
              Routes.transactionLocationSelectView: (context) => TransactionLocationSelectView(),
            },
            builder: (context, child) {
              return BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AuthenticationStatus.authenticated:
                      _navigator.pushNamedAndRemoveUntil(
                          Routes.homePage, (route) => false);
                      break;
                    case AuthenticationStatus.unauthenticated:
                      _navigator.pushNamedAndRemoveUntil(
                          Routes.loginPage, (route) => false);
                      break;
                    default:
                      _navigator.pushNamedAndRemoveUntil(
                          Routes.splashScreen, (route) => false);
                      break;
                  }
                },
                child: child,
              );
            },
          );
        });
  }
}
