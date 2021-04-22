import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import '../../utils/routes.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  BottomNavBar(this.index);
  @override
  _BottomNavBarState createState() => _BottomNavBarState(index);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentItemIndex;

  _BottomNavBarState(this.currentItemIndex);

  void selectPage(selectedItemIndex) {
    setState(() {
      currentItemIndex = selectedItemIndex;      
    });
    switch(selectedItemIndex) {
      case 0:
        Navigator.pushNamed(
          context,
          Routes.homePage,
        );
        break;
      case 1:
        Navigator.pushNamed(
          context,
          Routes.spendingPage
        );
        break;
      case 4: 
        Navigator.pushNamed(
          context,
          Routes.settingsPage
        );
        break;
    }
  }

  Widget build(BuildContext context) {
    return 
      BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: S.current.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_sharp),
          label: S.current.spending,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: S.current.card,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: S.current.contacts,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: S.current.settings,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey[50],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentItemIndex,
      onTap: selectPage,
    );
  }
}