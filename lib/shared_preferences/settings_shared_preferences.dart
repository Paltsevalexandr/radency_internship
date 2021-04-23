import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Map defaultSettings = {'currency': 'UAH', 'language': 'en'};

class SettingsSharedPreferences {
  getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('settings');

    if(settings == null) {
      prefs.setString('settings', json.encode(defaultSettings));
      return null;
    }

    return jsonDecode(settings);
  }

  setSetting(settingName, newSettingValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settings = prefs.getString('settings');

    Map settingsObject = jsonDecode(settings);

    settingsObject[settingName] = newSettingValue;

    prefs.setString('settings', json.encode(settingsObject));
  }
}
