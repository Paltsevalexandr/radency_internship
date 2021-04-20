import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/user_profile/user_profile_cubit.dart';
import 'repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'ui/home_page_template.dart';
import 'ui/login_page_template.dart';
import 'ui/sign_up_page.dart';
import 'ui/splash.dart';
import 'utils/routes.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/settings/settings_bloc.dart';

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
            create: (_) => UserProfileCubit(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (BuildContext context) => SettingsBloc()
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
