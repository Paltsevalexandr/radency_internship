import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'widgets/transactions_view/transactions_view.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested()),
            )
          ],
        ),
        body: BlocProvider<TransactionsSliderBloc>(
          create: (context) => TransactionsSliderBloc()..add(TransactionsSliderInitialize()),
          child: TransactionsView(),
        ),
        bottomNavigationBar: BottomNavBar(0));
  }
}
