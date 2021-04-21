import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_sharp),
          label: AppLocalizations.of(context).spending,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: AppLocalizations.of(context).card,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: AppLocalizations.of(context).contacts,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: AppLocalizations.of(context).settings,
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