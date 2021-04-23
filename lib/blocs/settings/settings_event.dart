part of 'settings_bloc.dart';

abstract class SettingsEvent {
  SettingsEvent();
}

class InitialSettingsEvent implements SettingsEvent{
  InitialSettingsEvent();
}

class ChangeCurrency implements SettingsEvent {
  ChangeCurrency({
    this.newCurrencyValue
  });

  String newCurrencyValue;
}
