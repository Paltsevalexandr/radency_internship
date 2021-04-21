import 'package:flutter/material.dart';

import 'bottom_nav_bar/bottom_nav_bar.dart';
import 'settings_components/settings_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings)
      ),
      body: AppSettingsList(),
      bottomNavigationBar: BottomNavBar(4)
    );
  }
}
