part of 'settings_bloc.dart';

abstract class SettingsState {
  SettingsState({
    this.currency,
    this.language,
  });

  final String currency;
  final String language;
}

class InitialSettingsState implements SettingsState {
  final String currency = 'UAH';
  final String language = 'ru';
}

class LoadedSettingsState implements SettingsState {
  LoadedSettingsState({this.currency, this.language});

  final String currency;
  final String language;
}
