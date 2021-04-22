import 'package:bloc/bloc.dart';
import 'package:radency_internship_project_2/shared_preferences/settings_shared_preferences.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final SettingsSharedPreferences settingsSharedPreferences;
  
  SettingsBloc(this.settingsSharedPreferences)
  : assert(settingsSharedPreferences != null),
  super(InitialSettingsState());

  SettingsState changeCurrency(value) {
    return LoadedSettingsState(currency: value, language: state.language);
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if(event is InitialSettingsEvent) {
      yield InitialSettingsState();
      try {
        final Map settings = await settingsSharedPreferences.getSettings();
        yield LoadedSettingsState(currency: settings['currency'], language: settings['language']);

      }catch(_) {
        print('bad');
      }

    } else if(event is ChangeCurrency) {
      yield changeCurrency(event.newSettingValue);
      await settingsSharedPreferences.setSetting('currency', event.newSettingValue);
    }
  }
}
