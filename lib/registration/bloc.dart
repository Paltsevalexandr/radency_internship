import 'package:flutter/material.dart';
import 'dart:async';

abstract class Bloc {
  void dispose();
}
class RegistrationBloc implements Bloc {

  Map _user = {};

  final _registrationStream = StreamController();

  Stream get userStream => _registrationStream.stream;
  Sink get userSink => _registrationStream.sink;

  void dispose() {
    _registrationStream.close();
  }

  void handleData(dataType, data) {
    _user[dataType] = data;
    userSink.add(_user);
  }
}

class BlocProvider<T extends Bloc> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState createState() => _BlocProviderState();

  static T of<T extends Bloc>(BuildContext context){
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }
}

class _BlocProviderState extends State<BlocProvider> {
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