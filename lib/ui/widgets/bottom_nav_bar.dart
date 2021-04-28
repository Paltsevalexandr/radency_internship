import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/navigation/navigation_bloc.dart';

class BottomNavBar extends StatelessWidget {

  Widget build(BuildContext context) {
    var navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: S.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: S.current.stats,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: S.current.accounts,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: S.of(context).settings,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey[50],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: state.selectedPageIndex,
          onTap: (currentIndex) => navigationBloc.add(SelectPage(currentIndex)),
        );
      }
    );      
  }
}