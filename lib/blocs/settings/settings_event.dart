part of 'settings_bloc.dart';

abstract class SettingsEvent {
  SettingsEvent({
    this.settingName,
    this.newSettingValue
  });

  String settingName;
  String newSettingValue;
}

class ChangeCurrency implements SettingsEvent {
  ChangeCurrency({
    this.newSettingValue
  });

  String settingName = 'currency';
  String newSettingValue;
}
