import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/authentication/authentication_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/transactions_slider/transactions_slider_bloc.dart';
import 'package:radency_internship_project_2/ui/widgets/transactions_view/transactions_view.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import 'widgets/bottom_nav_bar.dart';

class HomePageView extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePageView());
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
        appBar: AppBar(
          title: Text(S.current.home),
          actions: <Widget>[
            IconButton(
              key: const Key('homePage_logout_iconButton'),
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested()),
            )
          ],
        ),
        floatingActionButton: floatingAddButton(context),
        body: BlocProvider<TransactionsSliderBloc>(
        create: (context) =>
          TransactionsSliderBloc()
            ..add(TransactionsSliderInitialize()),
        child: TransactionsView(),
      ),
        bottomNavigationBar: BottomNavBar()
      );
  }

  Widget floatingAddButton(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      Navigator.of(context).pushNamed(Routes.addTransactionPage);
    }, child: Icon(
      Icons.add,
      size: pixelsToDP(context, 90),
    ));
  }
}