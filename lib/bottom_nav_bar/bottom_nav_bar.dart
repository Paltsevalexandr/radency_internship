import 'package:flutter/material.dart';
import 'package:flutter_app/ui/chart_page_template.dart';
import '../ui/chart_page_template.dart';
//import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;

  void selectIndex(value) {
    setState(() {
      index = value;
      if(value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ChartPage();
          }
        ));
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