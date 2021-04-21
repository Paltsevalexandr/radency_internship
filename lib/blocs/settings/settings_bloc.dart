import 'package:bloc/bloc.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final String currency;
  final String language;
  
  SettingsBloc(this.currency, this.language) 
  : super(SettingsState(language: language, currency: currency));

  SettingsState changeCurrency(value) {
    return SettingsState(currency: value, language: state.language);
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if(event is ChangeCurrency) {
      yield changeCurrency(event.newSettingValue);
    }
  }
}
