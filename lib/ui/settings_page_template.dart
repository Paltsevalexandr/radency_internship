import 'package:flutter/material.dart';

import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'settings_components/settings_list.dart';
import '../blocs/settings/settings_bloc.dart';

class SettingsPage extends StatelessWidget {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),
      body: SettingsBlocProvider(
        bloc: SettingsBloc(),
        child: AppSettingsList(),
      ),
      bottomNavigationBar: BottomNavBar(4)
    );
  }
}
