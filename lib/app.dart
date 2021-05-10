import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:radency_internship_project_2/blocs/image_picker/image_picker_bloc.dart';
import 'package:radency_internship_project_2/blocs/navigation/navigation_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/styles/styles_bloc.dart';
import 'package:radency_internship_project_2/blocs/stats/stats_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/transaction_location_map/transaction_location_map_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_summary/transactions_summary_bloc.dart';
import 'package:radency_internship_project_2/repositories/settings_repository/settings_repository.dart';
import 'package:radency_internship_project_2/ui/category_page/category_page_add.dart';
import 'package:radency_internship_project_2/ui/category_page/expenses_catedory_list.dart';
import 'package:radency_internship_project_2/ui/category_page/income_catedory_list.dart';
import 'package:radency_internship_project_2/ui/login_page.dart';
import 'package:radency_internship_project_2/ui/settings_components/settings_subpages/language_setting_page.dart';
import 'package:radency_internship_project_2/ui/settings_components/settings_subpages/style_setting_page.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/add_transaction_view_template.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/transaction_location_select_view.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/stats_view.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/budget_overview/budget_settings_page.dart';
import 'package:radency_internship_project_2/ui/widgets/stats_view/tabs/budget_overview/category_budget_setup_view.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/settings/category/category_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'blocs/stats/budget_overview/budget_overview_bloc.dart';
import 'blocs/transactions/transactions_daily/transactions_daily_bloc.dart';
import 'blocs/transactions/transactions_monthly/transactions_monthly_bloc.dart';
import 'blocs/transactions/transactions_weekly/transactions_weekly_bloc.dart';
import 'blocs/user_profile/user_profile_bloc.dart';
import 'generated/l10n.dart';
import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'ui/home_page.dart';
import 'ui/settings_components/settings_subpages/currency_setting_page.dart';
import 'ui/settings_page_template.dart';
import 'ui/sign_up_page.dart';
import 'ui/splash.dart';
import 'utils/routes.dart';
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
            create: (context) => SettingsBloc(SettingsRepository())..add(InitialSettingsEvent()),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => UserProfileBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => StylesBloc(),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(),
          ),
          BlocProvider(
            create: (context) => TransactionsDailyBloc(settingsBloc: BlocProvider.of<SettingsBloc>(context))
              ..add(
                TransactionsDailyInitialize(),
              ),
          ),
          BlocProvider(
            create: (context) => TransactionsWeeklyBloc()..add(TransactionsWeeklyInitialize()),
          ),
          BlocProvider(
            create: (context) => TransactionsMonthlyBloc()..add(TransactionsMonthlyInitialize()),
          ),
          BlocProvider(
            create: (context) => TransactionsSummaryBloc(settingsBloc: BlocProvider.of<SettingsBloc>(context))
              ..add(
                TransactionsSummaryInitialize(),
              ),
          ),
          BlocProvider(
            create: (_) => ImagePickerBloc(),
          ),
          BlocProvider(
            create: (_) => NavigationBloc()..add(SelectPage(0)),
          ),
          BlocProvider(
            create: (context) => StatsBloc(),
          ),
          BlocProvider(
            create: (context) => BudgetOverviewBloc(settingsBloc: BlocProvider.of<SettingsBloc>(context))
              ..add(
                BudgetOverviewInitialize(),
              ),
          ),
          BlocProvider(
            create: (context) => TransactionLocationMapBloc(),
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
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      String language = state.language;
      return BlocBuilder<StylesBloc, StylesState>(builder: (BuildContext context, state) {
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
          locale: Locale(language),
          navigatorKey: _navigatorKey,
          themeMode: getThemeMode(state.theme),
          theme: Styles.themeData(context, false, state.lightPrimaryColor),
          darkTheme: Styles.themeData(context, true, state.lightPrimaryColor),
          routes: {
            Routes.loginPage: (context) => LoginPage(),
            Routes.homePage: (context) => HomePage(),
            Routes.signUpPage: (context) => SignUpPage(),
            Routes.splashScreen: (context) => SplashPage(),
            Routes.statsPage: (context) => StatsView(),
            Routes.budgetSettings: (context) => BudgetSettingsPage(),
            Routes.settingsPage: (context) => SettingsPage(),
            Routes.currencySettingPage: (context) => CurrencySettingPage(),
            Routes.addTransactionPage: (context) => AddTransactionPage(),
            Routes.categoryBudgetSetupView: (context) => CategoryBudgetSetupView(),
            Routes.languageSettingPage: (context) => LanguageSettingPage(),
            Routes.styleSettingPage: (context) => StyleSettingPage(),
            Routes.transactionLocationSelectView: (context) => TransactionLocationSelectView(),
            Routes.incomeCategoriesPage: (context) => IncomeCategoriesPage(),
            Routes.expensesCategoriesPage: (context) => ExpensesCategoriesPage(),
            Routes.newCategoryPage: (context) => NewCategoryPage(),
          },
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
      });
    });
  }
}
