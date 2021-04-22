import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Smthh {

  String value;
  Smthh({this.value});
}
class SettingsSharedPreferences {
  Map defaultSettings = {'currency': 'UAH', 'language': 'English'};

  getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('settings');

    if(settings == null) {
      prefs.setString('settings', json.encode(defaultSettings));
      return defaultSettings;
    }

    Map currentSettings = jsonDecode(settings);
    return currentSettings;
  }

  setSetting(settingName, newSettingValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('settings');

    Map settingsObject = jsonDecode(settings);

    settingsObject[settingName] = newSettingValue;

    prefs.setString('settings', json.encode(settingsObject));
  }
}
