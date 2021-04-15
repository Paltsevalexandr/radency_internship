import 'package:flutter/material.dart';
import 'package:flutter_app/bottom_nav_bar/bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text('Test'),
        bottomNavigationBar: BottomNavBar(),
      )
    );
  }
}
