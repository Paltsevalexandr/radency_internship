import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../blocs/settings/settings_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'settings_subpages/currency_setting_page.dart';
import 'settings_subpages/language_setting_page.dart';


class AppSettingsList extends StatelessWidget {
  Widget build(BuildContext context) {
    final settingsBloc = SettingsBlocProvider.of<SettingsBloc>(context);

    return 
      StreamBuilder(
        stream: settingsBloc.settingsStream,
        initialData: settingsBloc.settings,
        builder: (context, snapshot) {
          Map settings = snapshot.data;
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
                    subtitle: settings['currency'],
                    leading: Icon(FontAwesome5Solid.money_bill),
                    onPressed: (BuildContext context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return 
                            CurrencySettingPage(
                              currency: settings['currency'], 
                              changeCurrency: settingsBloc.changeCurrency
                            );
                          }
                        )
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Language Setting',
                    subtitle: settings['language'],
                    leading: Icon(FontAwesome5Solid.language),
                    onPressed: (BuildContext context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return 
                            LanguageSettingPage(
                              language: 'English', 
                              changeLanguage: settingsBloc.changeLanguage);
                        })
                      );
                    },
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