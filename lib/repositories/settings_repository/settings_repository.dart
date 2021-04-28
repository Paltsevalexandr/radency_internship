import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';


Map defaultSettings = {'currency': 'UAH', 'language': 'en'};

class SettingsRepository {
  get() async {    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String settings = prefs.getString('settings');

      Map settingsObject =  jsonDecode(settings);

      return LoadedSettingsState(
        currency: settingsObject['currency'], 
        language: settingsObject['language']
      );

    } catch (_) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('settings', json.encode(defaultSettings));

      return InitialSettingsState();
    }
  }

  set(settingName, newSettingValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('settings');
    Map settingsObject = jsonDecode(settings);

    settingsObject[settingName] = newSettingValue;

    prefs.setString('settings', json.encode(settingsObject));
  }
}
