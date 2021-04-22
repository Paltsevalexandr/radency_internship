import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../blocs/settings/settings_bloc.dart';

import '../../utils/routes.dart';

class AppSettingsList extends StatelessWidget {
  Widget build(BuildContext context) {
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      builder: (BuildContext context, state) {
        return Container(
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'Settings',
                titleTextStyle: TextStyle(color: Colors.grey),
                titlePadding: EdgeInsets.all(10),
                tiles: [
                  SettingsTile(
                    title: 'Main Currency Setting',
                    subtitle: state.currency,
                    leading: Icon(FontAwesome5Solid.money_bill),
                    onPressed: (BuildContext context) {
                      Navigator.pushNamed(
                        context,
                        Routes.currencySettingPage
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Language Setting',
                    subtitle: state.language,
                    leading: Icon(FontAwesome5Solid.language),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'Alarm Setting',
                    leading: Icon(FontAwesome5Solid.bell),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'Style',
                    leading: Icon(FontAwesome5Solid.palette),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'Passcode',
                    leading: Icon(FontAwesome5Solid.lock),
                    onPressed: (BuildContext context){},
                  ),
                ],
              ),
            ],
          )
        );
      }
    );
  }
}