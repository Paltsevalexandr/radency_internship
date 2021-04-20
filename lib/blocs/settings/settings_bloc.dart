import 'package:bloc/bloc.dart';

class SettingsBloc extends Cubit<Map> {
  SettingsBloc() : super({'currency': 'UAH', 'language': 'Ukrainian'});

  void changeCurrency(value) => emit({...state, 'currency': value});
}
