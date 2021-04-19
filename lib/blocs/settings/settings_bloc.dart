import 'package:flutter/material.dart';
import 'dart:async';

abstract class Bloc {
  void dispose();
}

class SettingsBloc implements Bloc {

  Map settings = {'currency': 'UAH', 'language': 'Ukrainian'};

  final _settingsStreamController = StreamController();

  Stream get settingsStream => _settingsStreamController.stream;
  Sink get settingsSink => _settingsStreamController.sink;

  void changeCurrency(value) {
    settings['currency'] = value;
    settingsSink.add(settings);
  }

  void changeLanguage(value) {
    settings['language'] = value;
    settingsSink.add(settings);
  }

  void dispose() {
    _settingsStreamController.close();
  }
}

class SettingsBlocProvider<T extends Bloc> extends StatefulWidget {
  SettingsBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _SettingsBlocProviderState createState() => _SettingsBlocProviderState();

  static T of<T extends Bloc>(BuildContext context){
    SettingsBlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _SettingsBlocProviderState extends State<SettingsBlocProvider> {
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}
