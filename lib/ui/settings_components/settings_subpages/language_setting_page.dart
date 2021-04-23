import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class LanguageSettingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var settingsBloc =  BlocProvider.of<SettingsBloc>(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      builder: (BuildContext context, state) {

        return Scaffold(
          appBar: AppBar(title: Text(S.current.language)),
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: pixelsToDP(context, 4)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: pixelsToDP(context, 2), 
                      color: Colors.grey[200])
                  )
                ),
                child: ListTile(
                  title: Text('English'),
                  hoverColor: Colors.blueGrey[800],
                )
              ),
              Container(
                margin: EdgeInsets.only(bottom: pixelsToDP(context, 4)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: pixelsToDP(context, 2), 
                      color: Colors.grey[200])
                  )
                ),
                child: ListTile(
                  title: Text('Russian'),
                  hoverColor: Colors.blueGrey[800],
                )
              ),
            ],
          )
        );
      }
    );
  }
}
