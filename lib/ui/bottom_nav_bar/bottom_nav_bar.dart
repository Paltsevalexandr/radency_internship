import 'package:flutter/material.dart';
import '../home_page_template.dart';
import '../chart_page_template.dart';
import '../settings_page_template.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  BottomNavBar(this.index);
  @override
  _BottomNavBarState createState() => _BottomNavBarState(index);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index;

  _BottomNavBarState(this.index);

  void selectIndex(value) {
    setState(() {
      index = value;
      switch(value) {
        case 0:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) {
                return HomePage();
              }
            )
          );
          break;
        case 1:
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) {
                return ChartPage();
              }
            )
          );
          break;
        case 4: 
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) {
                return SettingsPage();
              }
            )
          );
          break;
      }
      
    });
  }

  Widget build(BuildContext context) {
    return 
      BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_sharp),
          label: 'Spending',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: 'Card',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_rounded),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey[50],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      onTap: selectIndex,
    );
  }
}