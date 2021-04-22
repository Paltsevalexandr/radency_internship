import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/authentication/authentication_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import 'package:radency_internship_project_2/ui/widgets/bottom_nav_bar.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/transactions_view.dart';

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
        bottomNavigationBar: BottomNavBar());
  }
}
